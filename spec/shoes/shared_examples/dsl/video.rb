shared_examples_for 'video DSL method' do
  it 'throws a Shoes::NotImplementedError' do
    expect{dsl.video}.to raise_error Shoes::NotImplementedError
  end
end