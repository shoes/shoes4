shared_examples_for "nostroke DSL method" do
  it "sets nil" do
    dsl.nostroke
    dsl.style[:stroke].should eq(nil)
  end
end
