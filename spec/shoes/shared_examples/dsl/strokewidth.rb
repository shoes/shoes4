shared_examples_for "strokewidth DSL method" do
  it "returns a number" do
    dsl.strokewidth = 4
    dsl.strokewidth.should eq(4)
  end

  it "sets on receiver" do
    dsl.strokewidth = 4
    dsl.style[:strokewidth].should eq(4)
  end

  it "applies to subsequently created objects" do
    dsl.strokewidth = 6
    Shoes::Oval.should_receive(:new).with do |*args|
      style = args.pop
      style[:strokewidth].should eq(6)
    end
    dsl.oval(10, 10, 100, 100)
  end
end
