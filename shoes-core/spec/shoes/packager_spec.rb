require 'shoes/spec_helper'

describe Shoes::Packager do
  subject { Shoes::Packager.new }

  it "creates packages" do
    expect(subject.backend).to receive(:create_package).and_call_original
    subject.create_package("program", "swt:app")
  end

  it "knows to run packaging if it created one" do
    subject.create_package("program", "swt:app")
    expect(subject.should_package?).to eq(true)
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
