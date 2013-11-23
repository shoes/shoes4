shared_examples_for "star DSL method" do
  it "creates a Shoes::Star" do
    dsl.star(30, 20).should be_an_instance_of(Shoes::Star)
  end

  it "raises an ArgumentError" do
    lambda { dsl.star(30) }.should raise_error(ArgumentError)
  end
end
