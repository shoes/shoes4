shared_examples_for "shape DSL method" do
  let(:shape) {
    dsl.shape {
      move_to 400, 300
      line_to 400, 200
      line_to 100, 100
      line_to 400, 300
      curve_to 100, 100, 20, 200, 120, 240
    }
  }

  it "creates a Shoes::Shape" do
    expect(shape).to be_an_instance_of(Shoes::Shape)
  end

  it "receives style from app" do
    green = Shoes::COLORS.fetch :green
    dsl.style[:stroke] = green
    expect(shape.stroke).to eq(green)
  end
end
