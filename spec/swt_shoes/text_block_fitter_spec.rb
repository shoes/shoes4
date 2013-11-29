require 'swt_shoes/spec_helper'
require 'shoes/swt/text_block_fitter'

describe Shoes::Swt::TextBlockFitter do
  let(:parent_dsl) { double(width: 100, height: 200) }

  let(:dsl)        { double(parent: parent_dsl) }
  let(:text_block) { double(dsl: dsl) }

  subject { Shoes::Swt::TextBlockFitter.new(text_block) }

  before(:each) do
    parent_dsl.stub(:contents) { [dsl] }
  end

  describe "determining space from siblings" do
    describe "when all alone" do
      it "should be the parent's width" do
        subject.available_space.should == [100, 200]
      end
    end

    describe "when second sibling" do
      let(:prior_sibling_dsl) { double(width: 50, height: 20) }

      it "should be width from end of sibling" do
        parent_dsl.stub(:contents) { [prior_sibling_dsl, dsl] }
        subject.available_space.should == [50, 20]
      end
    end

    pending "when siblings are on different lines" do
      describe "should handle that correctly" do
        # TODO
      end
    end
  end

  describe "fit it in completely" do
    it "should run without failing" do
      subject.fit_it_in
    end
  end
end
