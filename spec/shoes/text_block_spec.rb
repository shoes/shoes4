require 'shoes/spec_helper'
require 'shoes/helpers/sample17_helper'

describe Shoes::TextBlock do
  include_context "dsl app"

  let(:text_link) { Shoes::Link.new(['Hello']) }
  let(:text) { ["#{text_link}, world!"] }
  subject(:text_block) { Shoes::TextBlock.new(app, parent, text, 99, {app: app}) }

  describe "initialize" do
    it "creates gui object" do
      expect(text_block.gui).not_to be_nil
    end
  end

  describe "text" do
    context "with an array of [Shoes::Link, String]" do
      it "sets text" do
        expect(text_block.text).to eq "Hello, world!"
      end

      it "changes the text" do
        text_block.text = "Goodbye Cruel World"
        expect(text_block.text).to eq "Goodbye Cruel World"
      end
    end

    context "with a single string" do
      let(:text) { "Hello, world!" }

      it "sets text" do
        expect(text_block.text).to eq "Hello, world!"
      end

      it "changes the text" do
        text_block.text = "Goodbye Cruel World"
        expect(text_block.text).to eq "Goodbye Cruel World"
      end
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
    let(:size) { 99 }
    let(:text_block) { Shoes::TextBlock.new(app, parent, ["Hello, world!"], size, opts) }

    context "with defaults" do
      let(:opts) { Hash.new }

      it "sets the default font to Arial" do
        expect(text_block.font).to eq "Arial"
      end

      it "sets the size from explicit argument" do
        expect(text_block.font_size).to eq size
      end
    end

    context "with a font family string" do
      let(:opts) { { font: "Helvetica" } }

      it "sets the font family" do
        expect(text_block.font).to eq "Helvetica"
      end

      it "sets the size from explicit argument" do
        expect(text_block.font_size).to eq size
      end
    end

    context "with a font family string and size with 'px'" do
      let(:opts) { { font: "Helvetica 33px" } }

      it "sets the font family" do
        expect(text_block.font).to eq "Helvetica"
      end

      it "sets the font size" do
        expect(text_block.font_size).to eq 33
      end
    end

    context "with a font family string and size with ' px'" do
      let(:opts) { { font: "Helvetica 33 px" } }

      it "sets the font family" do
        expect(text_block.font).to eq "Helvetica"
      end

      it "sets the font size" do
        expect(text_block.font_size).to eq 33
      end
    end

    context "with a quoted font family string and size with 'px'" do
      let(:opts) { { font: '"Comic Sans" 13px' } }

      it "sets the font family" do
        expect(text_block.font).to eq "Comic Sans"
      end

      it "sets the size" do
        expect(text_block.font_size).to eq 13
      end
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
