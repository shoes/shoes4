require 'shoes/spec_helper'

describe Shoes::Link do
  let(:gui) { double("gui").as_null_object }
  let(:app) { double("app", gui: gui, style: {}, element_styles: {}, warn: true) }
  let(:internal_app) { double("internal app", app: app, gui: gui, style: {}, element_styles: {}) }
  let(:texts) { ["text", "goes", "first"] }

  subject { Shoes::Link.new(app, texts, {color: :blue}) }

  context "initialize" do
    it "should set up text" do
      expect(subject.texts).to eql(texts)
      expect(subject.to_s).to  eql("textgoesfirst")
    end

    it "should set color" do
      expect(subject.color).to eql(:blue)
    end

    it "should default styles" do
      expect(subject.style[:underline]).to eql(true)
      expect(subject.style[:fill]).to eql(nil)
      expect(subject.style[:stroke]).to eql(Shoes::COLORS[:blue])
    end

    context "overriding styles" do
      subject { Shoes::Link.new(app, texts,
                                underline: false, bg: Shoes::COLORS[:green]) }

      it "should include defaults" do
        expect(subject.style).to include(:stroke => Shoes::COLORS[:blue])
      end

      it "should override defaults" do
        expect(subject.style).to include(:underline => false)
      end

      it "should include other options" do
        expect(subject.style).to include(:bg => Shoes::COLORS[:green])
      end
    end

    context "with a block" do
      let(:callable) { double("callable") }
      subject { Shoes::Link.new(internal_app, texts, {}, Proc.new { callable.call }) }

      it "sets up for the click" do
        expect(callable).to receive(:call)
        subject.blk.call
      end
    end

    context "with click option as text" do
      subject { Shoes::Link.new(internal_app, texts, click: "/url") }

      it "should visit the url" do
        expect(app).to receive(:visit).with("/url")
        subject.blk.call
      end
    end

    context "with click option as Proc" do
      let(:callable) { double("callable", call: nil) }
      subject { Shoes::Link.new(internal_app, texts, click: Proc.new { callable.call }) }

      it "calls the block" do
        expect(callable).to receive(:call)
        subject.blk.call
      end
    end

    context "calling click explicitly" do
      let(:original_block)    { double("original") }
      let(:replacement_block) { double("replacement") }
      subject { Shoes::Link.new(internal_app, texts) { original_block.call } }

      it "replaces original block" do
        expect(original_block).to_not receive(:call)
        expect(replacement_block).to receive(:call)

        subject.click { replacement_block.call }
        subject.blk.call
      end
    end
  end

  describe 'visibility' do
    let(:text_block) {double 'text block', visible?: true, hidden?: false}

    describe 'with a containing text block' do
      before :each do
        subject.text_block = text_block
      end

      it 'forwards #visible? calls' do
        subject.visible?
        expect(text_block).to have_received :visible?
      end

      it 'forwards #hidden? calls' do
        subject.hidden?
        expect(text_block).to have_received :hidden?
      end
    end

    describe 'without a containing text block' do
      it 'does not crash on #visibie?' do
        expect {subject.visible?}.not_to raise_error
      end

      it 'does not crash on #hidden?' do
        expect {subject.hidden?}.not_to raise_error
      end
    end
  end

  # #979
  describe 'containing text block' do
    let(:text_block) {double 'text block'}

    before :each do
      subject.parent = text_block
    end

    it 'has the correct parent, namingly he text block' do
      expect(subject.parent).to eq text_block
    end
  end
end
