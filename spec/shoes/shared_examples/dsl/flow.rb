shared_examples_for "flow DSL method" do
  it "creates a Shoes::Flow" do
    blk = Proc.new {}
    opts = Hash.new
    flow = dsl.flow opts, &blk
    flow.should be_an_instance_of(Shoes::Flow)
  end
end
