#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require "open3"
require "optparse"
require "pathname"
require "time"

REPOSITORY = "emotionscientific/cooldis-kernel"
TARGETS = {
  "aarch64-apple-darwin" => ["macos", "arm"],
  "x86_64-apple-darwin" => ["macos", "intel"],
  "aarch64-unknown-linux-gnu" => ["linux", "arm"],
  "x86_64-unknown-linux-gnu" => ["linux", "intel"],
}.freeze
TAG_PATTERN = /\Av\d+\.\d+\.\d+(?:-[0-9A-Za-z]+(?:[.-][0-9A-Za-z]+)*)?\z/

options = {
  output: Pathname(__dir__).join("..", "Formula", "cooldis.rb").expand_path,
}

OptionParser.new do |parser|
  parser.banner = "Usage: scripts/update-cooldis.rb [--tag TAG] [--release-json PATH --asset-dir DIR]"
  parser.on("--tag TAG", "Update to an explicit release tag") { |tag| options[:tag] = tag }
  parser.on("--release-json PATH", "Read release metadata from a local fixture") { |path| options[:release_json] = path }
  parser.on("--asset-dir DIR", "Read checksum assets from a local fixture directory") { |dir| options[:asset_dir] = dir }
  parser.on("--output PATH", "Write the formula to PATH") { |path| options[:output] = Pathname(path).expand_path }
end.parse!

def fail!(message)
  warn "update-cooldis: #{message}"
  exit 1
end

def gh_json(endpoint, paginate: false)
  command = ["gh", "api"]
  command.concat(["--paginate", "--slurp"]) if paginate
  stdout, stderr, status = Open3.capture3(*command, endpoint)
  fail!("GitHub API request failed: #{stderr.strip}") unless status.success?

  JSON.parse(stdout)
rescue JSON::ParserError => e
  fail!("GitHub API returned malformed JSON: #{e.message}")
end

def releases_from(payload)
  case payload
  when Hash
    [payload]
  when Array
    return payload if payload.all? { |release| release.is_a?(Hash) }
    return payload.flatten(1) if payload.all? { |page| page.is_a?(Array) && page.all? { |release| release.is_a?(Hash) } }

    fail!("release metadata has an unexpected shape")
  else
    fail!("release metadata has an unexpected shape")
  end
end

def select_release(payload, requested_tag)
  releases = releases_from(payload)
  # Drafts are never installable. Prereleases remain eligible by design.
  releases = releases.select { |release| !release["draft"] && release["published_at"] }
  published_at = releases.to_h do |release|
    [release, Time.iso8601(release["published_at"])]
  rescue ArgumentError
    fail!("release #{release['tag_name'].inspect} has a malformed publication time")
  end
  release = if requested_tag
    releases.find { |candidate| candidate["tag_name"] == requested_tag }
  else
    releases.max_by { |candidate| published_at.fetch(candidate) }
  end
  fail!(requested_tag ? "published release #{requested_tag} was not found" : "no published release was found") unless release

  tag = release["tag_name"]
  fail!("unexpected release tag #{tag.inspect}") unless tag.is_a?(String) && TAG_PATTERN.match?(tag)
  fail!("release tag #{tag.inspect} does not match requested tag #{requested_tag.inspect}") if requested_tag && tag != requested_tag

  release
end

def validate_remote_asset!(asset, tag)
  name = asset.fetch("name")
  expected_url = "https://github.com/#{REPOSITORY}/releases/download/#{tag}/#{name}"
  fail!("asset #{name} is not fully uploaded") unless asset["state"] == "uploaded"
  fail!("asset #{name} has an unexpected download URL") unless asset["browser_download_url"] == expected_url
end

def checksum_text(asset, tag, asset_dir)
  if asset_dir
    path = Pathname(asset_dir).join(asset.fetch("name"))
    fail!("missing checksum fixture #{path}") unless path.file?

    return path.read
  end

  url = asset.fetch("browser_download_url")
  stdout, stderr, status = Open3.capture3("curl", "-fsSL", "--retry", "3", url)
  fail!("could not download #{asset['name']}: #{stderr.strip}") unless status.success?

  stdout
end

def release_data(release, asset_dir)
  tag = release.fetch("tag_name")
  version = tag.delete_prefix("v")
  prerelease = version.include?("-")
  fail!("release #{tag} has an unexpected prerelease flag") unless release["prerelease"] == prerelease
  assets = release.fetch("assets")
  fail!("release assets must be an array") unless assets.is_a?(Array)

  checksums = TARGETS.keys.to_h do |target|
    archive = "cooldis-#{version}-#{target}.tar.gz"
    archive_assets = assets.select { |asset| asset["name"] == archive }
    checksum_assets = assets.select { |asset| asset["name"] == "#{archive}.sha256" }
    # Require one archive and one sidecar for every target before changing the formula.
    fail!("release #{tag} is incomplete for #{target}") unless archive_assets.one? && checksum_assets.one?
    unless asset_dir
      validate_remote_asset!(archive_assets.first, tag)
      validate_remote_asset!(checksum_assets.first, tag)
    end

    text = checksum_text(checksum_assets.first, tag, asset_dir)
    match = /\A([0-9a-f]{64})[ \t]+\*?#{Regexp.escape(archive)}\n?\z/.match(text)
    fail!("malformed checksum for #{archive}") unless match

    [target, match[1]]
  end

  [tag, version, checksums]
rescue KeyError => e
  fail!("malformed release metadata: #{e.message}")
end

def render_formula(tag, version, checksums)
  url = "https://github.com/#{REPOSITORY}/releases/download/#{tag}"
  target_block = lambda do |os, arch|
    target = TARGETS.find { |_target, selector| selector == [os, arch] }.first
    archive = "cooldis-#{version}-#{target}.tar.gz"
    "      url \"#{url}/#{archive}\"\n" \
      "      sha256 \"#{checksums.fetch(target)}\""
  end

  formula = +<<~RUBY
    class Cooldis < Formula
      desc "Local-first runtime for autonomous AI agents"
      homepage "https://github.com/emotionscientific/cooldis-kernel"
  RUBY
  formula << "  version \"#{version}\"\n" if version.include?("-")
  formula << "  license \"Apache-2.0\"\n\n"

  formula + <<~RUBY
      on_macos do
        if Hardware::CPU.arm?
    #{target_block.call("macos", "arm")}
        else
    #{target_block.call("macos", "intel")}
        end
      end

      on_linux do
        if Hardware::CPU.arm?
    #{target_block.call("linux", "arm")}
        else
    #{target_block.call("linux", "intel")}
        end
      end

      def install
        bin.install "cooldis", "cooldis-acp-agent", "cooldis-mcp-server"
        pkgshare.install "share/cooldis/console"
      end

      test do
        assert_match "cooldis ", shell_output("\#{bin}/cooldis --version")
        assert_match "cooldis-acp-agent ", shell_output("\#{bin}/cooldis-acp-agent --version")
        assert_match "Usage", shell_output("\#{bin}/cooldis-mcp-server --help")
        assert_match "Usage", shell_output("\#{bin}/cooldis console --help")
        assert_path_exists pkgshare/"console/index.html"
      end
    end
  RUBY
end

fail!("unexpected requested tag #{options[:tag].inspect}") if options[:tag] && !TAG_PATTERN.match?(options[:tag])

if options[:release_json]
  fail!("--asset-dir is required with --release-json") unless options[:asset_dir]
  begin
    payload = JSON.parse(Pathname(options[:release_json]).read)
  rescue Errno::ENOENT, JSON::ParserError => e
    fail!("could not read release metadata: #{e.message}")
  end
else
  endpoint = options[:tag] ? "repos/#{REPOSITORY}/releases/tags/#{options[:tag]}" : "repos/#{REPOSITORY}/releases?per_page=100"
  payload = gh_json(endpoint, paginate: !options[:tag])
end

release = select_release(payload, options[:tag])
tag, version, checksums = release_data(release, options[:asset_dir])
formula = render_formula(tag, version, checksums)
options[:output].dirname.mkpath
options[:output].write(formula)
puts "Updated #{options[:output]} to #{tag}"
