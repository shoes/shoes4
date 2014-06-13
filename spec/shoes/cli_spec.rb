require 'spec_helper'

describe Shoes::CLI do
  subject {Shoes::CLI.new}

  before :each do
    allow(subject).to receive :package
  end

  it 'does not raise an error for a normal packaging command #624' do
    expect do
      subject.run ['-p', 'swt:app', 'test/simple-sound.rb']
    end.not_to raise_error
  end
end
