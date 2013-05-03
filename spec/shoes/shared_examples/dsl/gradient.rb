shared_examples_for "creating gradient" do
  it "returns correct gradient" do
    gradient.to_s.should eq("<Shoes::Gradient #ff0000->#0000ff>")
  end
end

shared_examples_for "gradient DSL method" do
  context "with colors" do
    let(:red) { Shoes::Color.new(255, 0, 0) }
    let(:blue) { Shoes::Color.new(0, 0, 255) }

    context "two separate" do
      it_behaves_like "creating gradient" do
        let(:gradient) { dsl.gradient(red, blue) }
      end
    end

    context "as range" do
      it_behaves_like "creating gradient" do
        let(:gradient) { dsl.gradient(red..blue) }
      end
    end
  end

  context "with strings" do
    let(:red) { "#f00" }
    let(:blue) { "#00f" }

    context "two separate" do
      it_behaves_like "creating gradient" do
        let(:gradient) { dsl.gradient(red, blue) }
      end
    end

    context "as range" do
      it_behaves_like "creating gradient" do
        let(:gradient) { dsl.gradient(red..blue) }
      end
    end
  end

  context "with gradient" do
    it_behaves_like "creating gradient" do
      let(:gradient_arg) { dsl.gradient("#f00", "#00f") }
      let(:gradient) { dsl.gradient(gradient_arg) }
    end
  end

  it "fails on bad input" do
    lambda { dsl.gradient(100) }.should raise_error(ArgumentError)
  end
end
