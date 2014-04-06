require 'spec_helper'
require 'shoes/cli'

describe Shoes::CLI do
  subject {Shoes::CLI.new}

  before :each do
    subject.stub :package
  end

  it 'does not raise an error for a normal packaging command #624' do
    expect do
      subject.run ['-p', 'swt:app', 'test/simple-sound.rb']
    end.not_to raise_error
  end
end