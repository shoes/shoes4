# frozen_string_literal: true
require 'spec_helper'

describe Shoes::Packager do
  subject { Shoes::Packager.new }

  it "creates packages" do
    expect(subject.backend).to receive(:create_package).and_call_original
    subject.create_package("program", "swt:app")
  end

  if defined?(::Bundler)
    it "detects Bundler and includes gems" do
      expect(subject.backend.gems).to_not be_empty
      expect(subject.backend.gems).to include("shoes-core")
    end

    it "works fine when missing Gemfile" do
      allow(::Bundler).to receive(:environment).and_raise(::Bundler::GemfileNotFound)
      expect(subject.backend.gems).to be_empty
    end
  else
    puts
    puts "Skipping part of shoes-core/spec/shoes/packager_spec.rb because missing Bundler"
  end

  it "delegates run" do
    expect(subject.backend).to receive(:run)
    subject.run("path/to/shoes/app.rb")
  end

  it "delegates help" do
    expect(subject.backend).to receive(:help)
    subject.help("program")
  end
end
