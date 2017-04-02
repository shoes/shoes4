# frozen_string_literal: true
require 'spec_helper'

describe Shoes::UI::CLI do
  subject { Shoes::UI::CLI.new("swt") }

  before :each do
    allow_any_instance_of(Shoes::Packager).to receive(:run)
  end

  it 'does not raise an error for a normal packaging command #624' do
    expect do
      subject.run ['package', '--jar', 'samples/simple_sound.rb']
    end.not_to raise_error
  end
end
