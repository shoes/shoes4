shared_examples_for "border DSL method" do
  context "with hex string" do
    let(:color) { "#ffffff" }

    it "sets color" do
      border = dsl.border(color)
      expect(border.stroke).to eq(Shoes::COLORS[:white])
    end
  end
end
