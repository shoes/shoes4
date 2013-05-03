shared_examples_for "background DSL method" do
  context "with hex string" do
    let(:color) { "ffffff" }

    it "sets color" do
      border = subject.background(color)
      border.fill.should eq(Shoes::COLORS[:white])
    end
  end
end
