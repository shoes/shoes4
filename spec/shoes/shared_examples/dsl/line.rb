shared_examples_for "line DSL method" do
  it "creates a Shoes::Line" do
    dsl.line(10, 15, 20, 30).should be_an_instance_of(Shoes::Line)
  end

  it "raises an ArgumentError" do
    lambda { dsl.line(30) }.should raise_error(ArgumentError)
  end
end
