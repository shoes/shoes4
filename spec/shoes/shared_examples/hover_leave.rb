shared_examples "hover and leave events" do
  let(:proc) {Proc.new do end}

  it 'can execute hover without raising an error' do
    expect{subject.hover proc}.not_to raise_error
  end

  it 'can execute leave without raising an error' do
    expect{subject.leave proc}.not_to raise_error
  end
end
