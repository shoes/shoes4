require "shoes/spec_helper"
require "shoes/element_methods/shared_contexts"

describe Shoes::ElementMethods, "edit_box" do
  include_context "with a mock dsl object"

  subject { dsl.edit_box *args }

  describe "edit_box()" do
    let(:args) { [] }
    it { should be_instance_of Shoes::EditBox }
    its(:text)  { should == nil }
    its(:opts) { should == {}  }
  end

  describe "edit_box(text)" do
    let(:args) { ['Hello text here'] }

    it { should be_instance_of Shoes::EditBox }
    its(:text)  { should == 'Hello text here' }
    its(:opts) { should == {}  }
  end

  describe "edit_box(style: options)" do
    let(:args) { [{width: 100, height: 50}] }

    it { should be_instance_of Shoes::EditBox }
    its(:text)  { should == nil }
    its(:opts) { should == {width: 100, height: 50} }
  end

  describe "edit_box(text, style: options)" do
    let(:args) { ['Hello text here', {width: 100, height: 50}] }
    it { should be_instance_of Shoes::EditBox }
    its(:text)  { should == 'Hello text here' }
    its(:opts) { should == {width: 100, height: 50} }
  end
end
