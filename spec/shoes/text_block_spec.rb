require 'shoes/spec_helper'
require 'shoes/helpers/sample17_helper'

describe Shoes::TextBlock do
  include_context "dsl app"
  
  let(:text_link) { Shoes::Link.new(app, parent, ['Hello']) }
  let(:text) { [text_link, ", world!"] }
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

    it "updates contents" do
      text_block.replace("Later Gator")
      expect(text_block.contents).to eq(["Later Gator"])
    end

    it "updates text styles" do
      text_block.replace "Later Gator"
      expect(text_block.text_styles).to be_empty
    end
  end

  describe "#contents" do
    it "returns text elements" do
      expect(text_block.contents).to eql([text_link, ", world!"])
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

  describe "width" do
    before(:each) do
      allow(parent).to receive(:element_width) { 300 }
      allow(parent).to receive(:absolute_left) { 0 }
    end

    context "when not explicitly set" do
      subject(:text_block) { Shoes::TextBlock.new(app, parent, ["text"], 42) }

      it "delegates to calculated width" do
        subject.calculated_width = 240
        expect(subject.width).to eql 240
      end

      it "delegates to calculated height" do
        subject.calculated_height = 240
        expect(subject.height).to eql 240
      end

      it "bases desired width off parent" do
        subject.absolute_left = 20
        expect(subject.desired_width).to eql 280
      end

      it "can base desired off explicit containing width" do
        subject.absolute_left = 20
        expect(subject.desired_width(1000)).to eql(980)
      end
    end

    context "when explicitly set" do
      subject(:text_block) { Shoes::TextBlock.new(app, parent, ["text"], 42, { width: 120 }) }

      it "gets returned" do
        expect(subject.width).to eql 120
      end

      it "is used for desired width" do
        subject.absolute_left = 20
        expect(subject.desired_width).to eql 100
      end
    end

  end

  context "cursor management" do
    let(:textcursor) { double("textcursor") }

    before(:each) do
      allow(app).to receive(:textcursor) { textcursor }
    end

    it "creates a textcursor" do
      expect(subject.textcursor).to eq(textcursor)
      expect(app).to have_received(:textcursor)
    end

    it "only creates textcursor" do
      original = subject.textcursor
      allow(app).to receive(:textcursor) { double("new cursor") }

      expect(subject.textcursor).to eq(original)
      expect(app).to have_received(:textcursor).once
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
