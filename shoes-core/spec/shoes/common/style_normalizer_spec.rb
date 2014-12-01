require 'spec_helper'

describe Shoes::Common::StyleNormalizer do
  subject {Shoes::Common::StyleNormalizer.new}

  it 'does not modify a simple hash' do
    input = {left: 100, width: 233}
    expect(subject.normalize input).to eq input
  end

  it 'turns hexcodes for fill into colors' do
    input = {fill: 'ffffff'}
    expected = {fill: Shoes::Color.new(255, 255, 255)}
    expect(subject.normalize input).to eq expected
  end
  
  it 'turns hexcodes for stroke into colors' do
    input = {stroke: 'ffffff'}
    expected = {stroke: Shoes::Color.new(255, 255, 255)}
    expect(subject.normalize input).to eq expected
  end

  it 'does not modify the original hash' do
    input = {stroke: '333333'}
    subject.normalize input
    expect(input).to eq({stroke: '333333'})
  end
end