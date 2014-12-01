shared_examples_for 'check DSL method' do
  let(:checkbox) { dsl.check }

  it 'should be a checkbox' do
    expect(checkbox).to be_instance_of Shoes::Check
  end

  it 'should be unchecked by default' do
    expect(checkbox.checked?).to be_falsey
  end
end
