# frozen_string_literal: true

require 'spec_helper'

require 'shoes/package'
require 'shoes/package/configuration'

describe Shoes::Swt::Packager do
  subject { Shoes::Swt::Packager.new(dsl) }

  let(:dsl)      { double("dsl") }
  let(:config)   { double("config", gems: []) }
  let(:packager) { double("packager") }
  let(:gems)     { [] }

  before do
    allow(subject).to receive(:puts)
    allow(Shoes::Package::Configuration).to receive(:load).and_return(config)
    allow(Shoes::Package).to receive(:create_packager).and_return(packager)
  end

  it "balks at empty packages" do
    expect(subject).to receive(:puts).with(/You must select/)
    subject.run("somewhere.rb")
  end

  it "runs when given packaging formats" do
    expect(packager).to receive(:package)
    subject.options.parse("--jar")
    subject.run("somewhere")
  end
end
