shared_examples_for "editable element" do
  subject { super.public_send(dsl_method, *args) }

  describe "with no arguments" do
    let(:args) { [] }
    its(:text) { should == '' }
    its(:width) { should == klazz::STYLES[:width] }
    its(:height) { should == klazz::STYLES[:height] }
  end

  describe "with a single text argument" do
    let(:args) { ['Hello text here'] }

    its(:text) { should == 'Hello text here' }
  end

  describe "with a style hash" do
    let(:args) { [{width: 100, height: 50}] }

    its(:text) { should == '' }
  end

  describe "with a text argument and a style hash" do
    let(:args) { ['Hello text here', {width: 100, height: 50}] }
    its(:text) { should == 'Hello text here' }
    its(:width) { should == 100 }
    its(:height) { should == 50 }
  end
end
