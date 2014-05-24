shared_examples_for "line DSL method" do
  it "creates a Shoes::Line" do
    expect(dsl.line(10, 15, 20, 30)).to be_an_instance_of(Shoes::Line)
  end

  it "raises an ArgumentError" do
    expect { dsl.line(30) }.to raise_error(ArgumentError)
  end
end
