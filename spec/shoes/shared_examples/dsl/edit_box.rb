shared_examples_for "edit_box DSL method" do
  context "edit_box" do
    subject { super.edit_box *args }

    describe "edit_box()" do
      let(:args) { [] }
      it { should be_instance_of Shoes::EditBox }
      its(:text) { should == '' }
      its(:opts) { should == {}  }
    end

    describe "edit_box(text)" do
      let(:args) { ['Hello text here'] }

      it { should be_instance_of Shoes::EditBox }
      its(:text) { should == 'Hello text here' }
      its(:opts) { should == {}  }
    end

    describe "edit_box(style: options)" do
      let(:args) { [{width: 100, height: 50}] }

      it { should be_instance_of Shoes::EditBox }
      its(:text) { should == '' }
      its(:opts) { should == {width: 100, height: 50} }
    end

    describe "edit_box(text, style: options)" do
      let(:args) { ['Hello text here', {width: 100, height: 50}] }
      it { should be_instance_of Shoes::EditBox }
      its(:text) { should == 'Hello text here' }
      its(:opts) { should == {width: 100, height: 50} }
    end
  end
end
