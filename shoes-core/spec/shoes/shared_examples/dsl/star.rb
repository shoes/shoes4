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

    describe '4 arguments' do
      subject {dsl.star left, top, points, outer}
      its(:left) {should eq left}
      its(:top) {should eq top}
      its(:points) {should eq points}
      its(:outer) {should eq outer}
      its(:inner) {should eq DEFAULT_INNER}
    end

    describe '5 arguments' do
      subject {dsl.star left, top, points, outer, inner}
      its(:left) {should eq left}
      its(:top) {should eq top}
      its(:points) {should eq points}
      its(:outer) {should eq outer}
      its(:inner) {should eq inner}
    end

  end
end
