shared_examples_for "editable element" do
  subject { super.public_send(dsl_method, *args) }

  describe "with no arguments" do
    let(:args) { [] }
    its(:initial_text) { should == '' }
    its(:width) { should == klazz::DEFAULT_STYLE[:width] }
    its(:height) { should == klazz::DEFAULT_STYLE[:height] }
  end

  describe "with a single text argument" do
    let(:args) { ['Hello text here'] }

    its(:initial_text) { should == 'Hello text here' }
  end

  describe "with a style hash" do
    let(:args) { [{width: 100, height: 50}] }

    its(:initial_text) { should == '' }
  end

  describe "with a text argument and a style hash" do
    let(:args) { ['Hello text here', {width: 100, height: 50}] }
    its(:initial_text) { should == 'Hello text here' }
    its(:width) { should == 100 }
    its(:height) { should == 50 }
  end
end
