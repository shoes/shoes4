shared_examples_for "arrow dimensions" do
  it "makes a Shoes::Arrow" do
    expect(arrow).to be_an_instance_of(Shoes::Arrow)
  end

  it "sets proper dimensions" do
    expect(arrow.left).to eq(left)
    expect(arrow.top).to eq(top)
    expect(arrow.width).to eq(width)
  end
end

shared_examples_for "arrow DSL method" do
  let(:left)   { 40 }
  let(:top)    { 30 }
  let(:width)  { 12 }

  context "no arguments" do
    subject(:arrow) { dsl.arrow }

    let(:left)  { 0 }
    let(:top)   { 0 }
    let(:width) { 0 }

    include_examples "arrow dimensions"
  end

  context "from 1 argument" do
    subject(:arrow) { dsl.arrow left }

    let(:top)   { 0 }
    let(:width) { 0 }

    include_examples "arrow dimensions"
  end

  context "from 1 argument with options" do
    subject(:arrow) { dsl.arrow left, top: top }

    let(:width) { 0 }

    include_examples "arrow dimensions"
  end

  context "from 2 argument" do
    subject(:arrow) { dsl.arrow left, top }

    let(:width) { 0 }

    include_examples "arrow dimensions"
  end

  context "from 2 argument with options" do
    subject(:arrow) { dsl.arrow left, top, width: width }

    include_examples "arrow dimensions"
  end

  context "from 3 arguments" do
    subject(:arrow) { dsl.arrow left, top, width }

    include_examples "arrow dimensions"
  end

  context "from 3 arguments with options" do
    subject(:arrow) { dsl.arrow left, top, width, left: -1, top: -2, width: -3 }

    include_examples "arrow dimensions"
  end

  context "from style hash" do
    subject(:arrow) { dsl.arrow left: left, top: top, width: width }

    include_examples "arrow dimensions"
  end

  context "too many arguments" do
    subject(:arrow) { dsl.arrow left, top, width, oops }

    let(:oops) { 42 }

    it "won't accept that" do
      expect { subject }.to raise_error(ArgumentError)
    end
  end

  context "too many arguments and options too!" do
    subject(:arrow) { dsl.arrow left, top, width, oops, left: -1 }

    let(:oops) { 42 }

    it "won't accept that" do
      expect { subject }.to raise_error(ArgumentError)
    end
  end
end
