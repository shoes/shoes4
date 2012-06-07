require 'shoes/color'

shared_examples_for "object with stroke" do
  let(:color) { Shoes::COLORS.fetch :tomato }

  specify "returns a color" do
    c = subject.stroke = color
    c.class.should eq(Shoes::Color)
  end

  specify "sets on receiver" do
    subject.stroke = color
    subject.stroke.should eq(color)
    subject.style[:stroke].should eq(color)
  end

  # Be sure the subject does *not* have the stroke set previously
  specify "defaults to black" do
    subject.stroke.should eq(Shoes::COLORS.fetch :black)
  end

  describe "strokewidth" do
    specify "defaults to 1" do
      subject.strokewidth.should eq(1)
    end

    specify "sets" do
      subject.strokewidth = 2
      subject.strokewidth.should eq(2)
    end
  end
end

shared_examples_for "object with fill" do
  let(:color) { Shoes::COLORS.fetch :honeydew }

  specify "returns a color" do
    c = subject.fill = color
    c.class.should eq(Shoes::Color)
  end

  specify "sets on receiver" do
    subject.fill = color
    subject.fill.should eq(color)
    subject.style[:fill].should eq(color)
  end

  # Be sure the subject does *not* have the stroke set previously
  specify "defaults to black" do
    subject.fill.should eq(Shoes::COLORS.fetch :black)
  end
end
