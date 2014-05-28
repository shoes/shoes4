require 'shoes/spec_helper'

describe Shoes::Oval do
  include_context "dsl app"

  let(:left) { 20 }
  let(:top) { 30 }
  let(:width) { 100 }
  let(:height) { 200 }

  describe "basic" do
    subject { Shoes::Oval.new(app, parent, left, top, width, height) }
    it_behaves_like "object with style"
    it_behaves_like "object with dimensions"
    it_behaves_like "movable object"
    it_behaves_like "left, top as center"
    it_behaves_like "object with parent"
    
    #unpack styles. In the future we'd like to do something clever to avoid this duplication.
    supported_styles = []
    %w[art_styles center dimensions radius].map(&:to_sym).each do |style|
      if Shoes::Common::Style::STYLE_GROUPS[style]
        Shoes::Common::Style::STYLE_GROUPS[style].each{|style| supported_styles << style}
      else
        supported_styles << style
      end
    end
    
    supported_styles.each do |style|
      it_behaves_like "object that styles with #{style}"
    end

  end
end
