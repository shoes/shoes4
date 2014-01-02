require 'shoes/spec_helper'
require 'shoes/helpers/sample17_helper'

describe Shoes::TextBlock do
  include_context "dsl app"

  let(:text_link) { Shoes::Link.new(['Hello']) }
  subject(:text_block) { Shoes::TextBlock.new(app, parent, ["#{text_link}, world!"], 99, {app: app}) }

  describe "initialize" do
    it "creates gui object" do
      expect(text_block.gui).not_to be_nil
    end
  end

  describe "text" do
    it "sets text when the object is created" do
      expect(text_block.text).to eq "Hello, world!"
    end

    it "allows us to change the text" do
      text_block.text = "Goodbye Cruel World"
      expect(text_block.text).to eq "Goodbye Cruel World"
    end
  end

  describe "#to_s" do
    it "is the same as #text" do
      text = text_block.text
      expect(text_block.to_s).to eq(text)
    end
  end

  describe "#replace" do
    it "replaces text" do
      text_block.replace "Goodbye Cruel World"
      expect(text_block.text).to eq("Goodbye Cruel World")
    end

    it "allows two arguments" do
      text_block.replace "Goodbye Cruel World, ", text_link
      expect(text_block.text).to eq("Goodbye Cruel World, Hello")
    end
  end

  describe "font" do
    it "sets the default font to Arial" do
      expect(text_block.font).to eql "Arial"
    end

    it "should allow setting the font with :family" do
      s = Shoes::TextBlock.new(app, parent, ["Hello, world!"], 99, { font: "Helvetica", app: app })
      expect(s.font).to eql "Helvetica"
    end

    it "should allow setting the font size with :family" do
      s = Shoes::TextBlock.new(app, parent, ["Hello, world!"], 99, { font: "Helvetica 33px", app: app })
      expect(s.font).to eql "Helvetica"
      expect(s.font_size).to eql 33
    end

    it "should accept fonts surrounded with questionmarks when using :family" do
      s = Shoes::TextBlock.new(app, parent, ["Hello, world!"], 99, { font: '"Comic Sans" 13px', app: app })
      expect(s.font).to eql "Comic Sans"
      expect(s.font_size).to eql 13
    end

  end

  describe "stroke" do
    it "should accept a hex code" do
      s = Shoes::TextBlock.new(app, parent, ["Hello, world!"], 99, { stroke: "#fda", app: app })
      color = s.opts[:stroke]
      expect(color.red).to eql 255
      expect(color.green).to eql 221
      expect(color.blue).to eql 170
    end
  end

  # Emulates samples/sample17.rb
  #
  #   Shoes.app width: 240, height: 95 do
  #     para 'Testing, test, test. ',
  #       strong('Breadsticks. '),
  #       em('Breadsticks. '),
  #       code('Breadsticks. '),
  #       bg(fg(strong(ins('EVEN BETTER.')), white), rgb(255, 0, 192)),
  #       sub('fine!')
  #   end
  #
  context "with nested text fragments" do
    let(:helper) {Sample17Helper.new(app)}
    let!(:para) { helper.create_para }

    it "has full text of fragments" do
      expect(para.text).to eq("Testing, test, test. Breadsticks. Breadsticks. Breadsticks. EVEN BETTER.fine!")
    end

    it "has fragment styles" do
      text_styles = {
                     21..33 => [helper.strong_breadsticks],
                     34..46 => [helper.em],
                     47..59 => [helper.code],
                     60..71 => [helper.bg, helper.fg, helper.strong, helper.ins],
                     72..76 => [helper.sub]
                    }
      expect(para.text_styles).to eq(text_styles)
    end

    it 'sets the parent of the non nested texts to the para' do
      expect(helper.strong_breadsticks.parent).to eq para
    end

    it 'sets the parent of nested fragments correctly' do
      expect(helper.ins.parent).to eq helper.strong
    end
  end
end
