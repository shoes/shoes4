shared_context "style context" do
  let(:fill_color) { Shoes::COLORS.fetch(:tomato) }
  let(:stroke_color) { Shoes::COLORS.fetch(:chartreuse) }

  before :each do
    subject.fill fill_color
    subject.stroke stroke_color
  end
end

shared_examples_for "persistent stroke" do
  include_context "style context"

  it "passes to element" do
    element.stroke.should eq(stroke_color)
  end
end

shared_examples_for "persistent fill" do
  include_context "style context"

  it "passes to element" do
    element.fill.should eq(fill_color)
  end
end

shared_examples_for "arc DSL method" do
  let(:arc) { dsl.arc(13, 44, 200, 300, 0, Shoes::TWO_PI) }

  it "creates a Shoes::Arc" do
    arc.should be_an_instance_of(Shoes::Arc)
  end

  it "raises an ArgumentError" do
    lambda { dsl.arc(30) }.should raise_exception(ArgumentError)
  end

  it_behaves_like "persistent fill" do
    let(:element) { arc }
  end

  it_behaves_like "persistent stroke" do
    let(:element) { arc }
  end
end
