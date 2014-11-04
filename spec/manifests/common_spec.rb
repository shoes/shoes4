require 'spec_helper'

# These will be moved out when we address #934
ALLOWED_EXCLUSIONS = Dir["lib/ext/**/*.rb"]

Dir["manifests/**/*.rb"].each do |manifest_file|
  require manifest_file
end

describe "Gem manifests" do
  it "can't have unused declarations" do
    all_manifest_files = ShoesManifestReport.manifest_classes.map do |manifest|
      manifest.files + manifest.test_files
    end.flatten

    if all_manifest_files.empty?
      fail "Didn't get any manifest files listed. Did ShoesManifestReport change?"
    end

    all_manifest_files.concat(ALLOWED_EXCLUSIONS)

    incorrectly_excluded_files = Dir["**/*.rb"].reject do |file|
      all_manifest_files.include?(file)
    end

    expect(incorrectly_excluded_files).to be_empty
  end
end
