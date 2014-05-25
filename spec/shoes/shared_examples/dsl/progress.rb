shared_examples_for "progress DSL method" do
  let(:progress) { dsl.progress }

  it 'should be a progress bar' do
    progress.should be_instance_of Shoes::Progress
  end
end
