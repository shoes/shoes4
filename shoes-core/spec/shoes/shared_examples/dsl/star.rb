shared_examples_for "star DSL method" do
  it "creates a Shoes::Star" do
    expect(dsl.star(30, 20)).to be_an_instance_of(Shoes::Star)
  end

  it "raises an ArgumentError with just one argument" do
    expect { dsl.star(30) }.to raise_error(ArgumentError)
  end

  describe 'instantiation' do
    let(:left) {10}
    let(:top) {20}
    let(:points) {15}
    let(:outer) {27}
    let(:inner) {33}
    let(:clickable) { proc { } }

    DEFAULT_POINTS = 10
    DEFAULT_OUTER = 100.0
    DEFAULT_INNER = 50.0

    describe '2 arguments' do
      subject {dsl.star left, top}
      its(:left) {should eq left}
      its(:top) {should eq top}
      its(:points) {should eq DEFAULT_POINTS}
      its(:outer) {should eq DEFAULT_OUTER}
      its(:inner) {should eq DEFAULT_INNER}
    end

    describe '2 arguments with hash' do
      subject { dsl.star left, top, click: clickable }
      its(:left)   {should eq left}
      its(:top)    {should eq top}
      its(:points) {should eq DEFAULT_POINTS}
      its(:outer)  {should eq DEFAULT_OUTER}
      its(:inner)  {should eq DEFAULT_INNER}

      it "gets the click" do
        expect(subject.style[:click]).to eq(clickable)
      end
    end

    describe '3 arguments with hash' do
      subject { dsl.star left, top, points, click: clickable }
      its(:left)   {should eq left}
      its(:top)    {should eq top}
      its(:points) {should eq points}
      its(:outer)  {should eq DEFAULT_OUTER}
      its(:inner)  {should eq DEFAULT_INNER}

      it "gets the click" do
        expect(subject.style[:click]).to eq(clickable)
      end
    end

    describe '4 arguments' do
      subject {dsl.star left, top, points, outer}
      its(:left) {should eq left}
      its(:top) {should eq top}
      its(:points) {should eq points}
      its(:outer) {should eq outer}
      its(:inner) {should eq DEFAULT_INNER}
    end

    describe '4 arguments with hash' do
      subject { dsl.star left, top, points, outer, click: clickable }
      its(:left)   {should eq left}
      its(:top)    {should eq top}
      its(:points) {should eq points}
      its(:outer)  {should eq outer}
      its(:inner)  {should eq DEFAULT_INNER}

      it "gets the click" do
        expect(subject.style[:click]).to eq(clickable)
      end
    end

    describe '5 arguments' do
      subject {dsl.star left, top, points, outer, inner}
      its(:left) {should eq left}
      its(:top) {should eq top}
      its(:points) {should eq points}
      its(:outer) {should eq outer}
      its(:inner) {should eq inner}
    end

    describe '5 arguments with hash' do
      subject { dsl.star left, top, points, outer, inner, click: clickable }
      its(:left)   {should eq left}
      its(:top)    {should eq top}
      its(:points) {should eq points}
      its(:outer)  {should eq outer}
      its(:inner)  {should eq inner}

      it "gets the click" do
        expect(subject.style[:click]).to eq(clickable)
      end
    end

    describe 'too many arguments' do
      oops = 1000
      subject { dsl.star left, top, points, outer, inner, oops }

      it "raises on construction" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

  end
end
