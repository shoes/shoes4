# requires you to provide a let(:parent)
shared_examples_for 'object with parent' do
  it 'has a getter for the parent' do
    expect(subject.parent).to eq parent
  end
end