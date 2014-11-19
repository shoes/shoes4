require 'shoes/swt/spec_helper'

describe Shoes::Swt::ColorFactory do
  let(:blue)     { Shoes::COLORS[:blue] }
  let(:gradient) { Shoes::Gradient.new(blue, blue) }

  subject(:factory) { Shoes::Swt::ColorFactory.new }

  it "turns Shoes::Color's into Shoes::Swt::Color's" do
    expect(factory.create(blue)).to_not be_nil
  end

  it "hands back nil for nil" do
    expect(factory.create(nil)).to be_nil
  end

  it "caches colors" do
    first  = factory.create(blue)
    second = factory.create(blue)

    expect(first).to eql(second)
  end

  it "disposes of colors" do
    color = factory.create(blue)
    expect(color).to receive(:dispose)

    factory.dispose
  end

  it "doesn't cache colors across dispose" do
    color = factory.create(blue)
    factory.dispose

    new_color = factory.create(blue)
    expect(color).to_not eql(new_color)
  end

  it "allows gradients through" do
    expect(factory.create(gradient)).to_not be_nil
  end

  it "safely disposes of non-disposable elements" do
    factory.create(gradient)
    expect(gradient).to receive(:dispose).never

    factory.dispose
  end
end
