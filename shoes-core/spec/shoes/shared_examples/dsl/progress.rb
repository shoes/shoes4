shared_examples_for "progress DSL method" do
  let(:progress) { dsl.progress }

  it 'should be a progress bar' do
    expect(progress).to be_instance_of Shoes::Progress
  end
end
