require 'spec_helper'

describe Shoes::CLI do
  subject {Shoes::CLI.new}

  before :each do
    allow(subject.packager).to receive :run
  end

  it 'does not raise an error for a normal packaging command #624' do
    expect do
      subject.run ['-p', 'swt:app', 'samples/simple-sound.rb']
    end.not_to raise_error
  end
end
