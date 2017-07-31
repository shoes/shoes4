# frozen_string_literal: true
require 'spec_helper'
require 'shoes/helpers/sample17_helper'

describe Shoes::TextBlock do
  include_context "dsl app"

  let(:text_link) { Shoes::Link.new(app, ['Hello']) }
  let(:text) { [text_link, ", world!"] }
  subject(:text_block) { Shoes::Para.new(app, parent, text, app: app) }

  it_behaves_like "object with style" do
    let(:subject_without_style) { Shoes::Para.new(app, parent, text) }
    let(:subject_with_style) { Shoes::Para.new(app, parent, text, arg_styles) }
  end

  it_behaves_like "object with hover"
  it_behaves_like "clickable object"

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

  describe "#takes_up_space?" do
    it "does with default alignment" do
      expect(text_block.takes_up_space?).to eq(true)
    end

    it "does when left aligned" do
      text_block.align = "left"
      expect(text_block.takes_up_space?).to eq(true)
    end

    it "doesn't when right aligned" do
      text_block.align = "right"
      expect(text_block.takes_up_space?).to eq(false)
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

    it "updates styles from options hash" do
      text_block.replace "Later Gator", stroke: Shoes::COLORS[:aquamarine]
      expect(text_block.stroke).to eq(Shoes::COLORS[:aquamarine])
    end

    it "updates font from options hash" do
      text_block.replace "Later Gator", font: 'Monospace 18px'
      expect(text_block.font).to eq('Monospace')
      expect(text_block.size).to eq(18)
    end
  end

  describe "#contents" do
    it "returns text elements" do
      expect(text_block.contents).to eql([text_link, ", world!"])
    end
  end

  describe "font" do
    let(:text_block) { Shoes::Para.new(app, parent, ["Hello, world!"], style) }

    context "with defaults" do
      let(:style) { {} }

      it "sets the default font to Arial" do
        expect(text_block.font).to eq "Arial"
      end
    end

    context "with a font family string" do
      let(:style) { { font: "Helvetica" } }

      it "sets the font family" do
        expect(text_block.font).to eq "Helvetica"
      end
    end

    context "with a font family string and size with 'px'" do
      let(:style) { { font: "Helvetica 33px" } }

      it "sets the font family" do
        expect(text_block.font).to eq "Helvetica"
      end

      it "sets the font size" do
        expect(text_block.size).to eq 33
      end
    end

    context "with a font family string and size with ' px'" do
      let(:style) { { font: "Helvetica 33 px" } }

      it "sets the font family" do
        expect(text_block.font).to eq "Helvetica"
      end

      it "sets the font size" do
        expect(text_block.size).to eq 33
      end
    end

    context "with a quoted font family string and size with 'px'" do
      let(:style) { { font: '"Comic Sans" 13px' } }

      it "sets the font family" do
        expect(text_block.font).to eq "Comic Sans"
      end

      it "sets the size" do
        expect(text_block.size).to eq 13
      end
    end
  end

  describe "stroke" do
    it "should accept a hex code" do
      s = Shoes::Para.new(app, parent, ["Hello, world!"], stroke: "#fda", app: app)
      color = s.style[:stroke]
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
      subject(:text_block) { Shoes::Para.new(app, parent, ["text"]) }

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

      it "factors margins into desired width" do
        subject.absolute_left = 0
        subject.margin = 10
        expect(subject.desired_width(1000)).to eql(980)
      end
    end

    context "when explicitly set" do
      subject(:text_block) { Shoes::Para.new(app, parent, ["text"], width: 120) }

      it "gets returned" do
        expect(subject.width).to eql 120
      end

      it "is used for desired width" do
        expect(subject.desired_width).to eql 120
      end

      it "factors in if parent space is too small" do
        subject.absolute_left = parent.element_width - 100
        expect(subject.desired_width).to eql(100)
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

  context "with empty subelements" do
    let!(:link) { actual_app.link('') }
    let!(:span) { actual_app.span('') }
    let!(:para) { actual_app.para(link, span) }
    let(:actual_app) { app.app }

    it "properly ignores empty element lengths in text_styles" do
      text_styles = { 0...0 => [link, span] }

      expect(para.text_styles).to eq(text_styles)
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
    let(:helper) { Sample17Helper.new(app) }
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

    it 'sets the parent_text of the non nested texts to the para' do
      expect(helper.strong_breadsticks.parent).to eq para
    end

    it 'sets the parent_text of nested fragments correctly' do
      expect(helper.ins.parent).to eq helper.strong
    end

    it 'lets the nested text fragements know what their text block is' do
      expect(helper.ins.text_block).to eq para
    end
  end

  describe "links" do
    it "finds em" do
      expect(text_block.links).to eq([text_link])
    end
  end
end
