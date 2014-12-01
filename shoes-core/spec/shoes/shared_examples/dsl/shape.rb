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

  describe "constructing" do
    it "doesn't need any arguments" do
      shape = dsl.shape
      expect(shape.left).to eq(nil)
      expect(shape.top).to eq(nil)
    end

    it "can accept some styles" do
      white = Shoes::COLORS.fetch :white
      shape = dsl.shape stroke: white
      expect(shape.stroke).to eq(white)
    end

    it "can accept a left and top" do
      left, top = 10, 20
      shape = dsl.shape left, top
      expect(shape.left).to eq(left)
      expect(shape.top).to eq(top)
    end

    it "accepts left and top in styles" do
      left, top = 10, 20
      shape = dsl.shape left: left, top: top
      expect(shape.left).to eq(left)
      expect(shape.top).to eq(top)
    end

    it "can accept a left, top, and some styles" do
      left, top, white = 10, 20, Shoes::COLORS.fetch(:white)
      shape = dsl.shape left, top, stroke: white
      expect(shape.left).to eq(left)
      expect(shape.top).to eq(top)
      expect(shape.stroke).to eq(white)
    end
  end
end
