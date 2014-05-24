shared_examples_for 'check DSL method' do
  let(:checkbox) { dsl.check }

  it 'should be a checkbox' do
    checkbox.should be_instance_of Shoes::Check
  end

  it 'should be unchecked by default' do
    checkbox.checked?.should be_falsey
  end
end
