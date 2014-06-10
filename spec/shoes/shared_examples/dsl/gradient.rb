shared_examples_for "creating gradient" do
  it "returns correct gradient according to #to_s" do
    expect(gradient.to_s).to eq("(Shoes::Gradient)")
  end

  it "returns correct gradient according to #inspect" do
    expect(gradient.inspect).to match("[(]Shoes::Gradient:#{shoes_object_id_pattern} rgb[(]255, 0, 0[)]->rgb[(]0, 0, 255[)][)]")
  end
end

shared_examples_for "gradient DSL method" do
  context "with colors" do
    include InspectHelpers

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
    include InspectHelpers

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
    include InspectHelpers

    it_behaves_like "creating gradient" do
      let(:gradient_arg) { dsl.gradient("#f00", "#00f") }
      let(:gradient) { dsl.gradient(gradient_arg) }
    end
  end

  it "fails on bad input" do
    expect { dsl.gradient(100) }.to raise_error(ArgumentError)
  end
end
