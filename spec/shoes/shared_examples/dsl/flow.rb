shared_examples_for "flow DSL method" do
  let(:flow) {dsl.flow}

  it "creates a Shoes::Flow" do
    expect(flow).to be_an_instance_of(Shoes::Flow)
  end

  it 'reports an instance of Shoes::App when asked for its app' do
    expect(flow.app.class).to eq Shoes::App
  end

  it 'reports an object that responds to stack when asked for its app' do
    expect(flow.app).to respond_to :stack
  end
end
