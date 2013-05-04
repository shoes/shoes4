shared_examples_for "editable element" do
  subject { super.public_send(dsl_method, *args) }

  describe "with no arguments" do
    let(:args) { [] }
    it { should be_instance_of klazz }
    its(:text) { should == '' }
    its(:opts) { should == klazz::DEFAULT_STYLE  }
  end

  describe "with a single text argument" do
    let(:args) { ['Hello text here'] }

    it { should be_instance_of klazz }
    its(:text) { should == 'Hello text here' }
    its(:opts) { should == klazz::DEFAULT_STYLE }
  end

  describe "with a style hash" do
    let(:args) { [{width: 100, height: 50}] }

    it { should be_instance_of klazz }
    its(:text) { should == '' }
    its(:opts) { should == {width: 100, height: 50} }
  end

  describe "with a text argument and a style hash" do
    let(:args) { ['Hello text here', {width: 100, height: 50}] }
    it { should be_instance_of klazz }
    its(:text) { should == 'Hello text here' }
    its(:opts) { should == {width: 100, height: 50} }
  end
end
