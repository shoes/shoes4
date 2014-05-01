require 'shoes/spec_helper'

describe Shoes::Link do
  let(:gui) { double("gui").as_null_object }
  let(:app) { double("app", gui: gui) }
  let(:internal_app) { double("internal app", app: app, gui: gui) }

  context "initialize" do
    let(:texts) { ["text", "goes", "first"] }

    subject { Shoes::Link.new(app, app, texts, {color: :blue}) }

    it "should set up text" do
      subject.texts.should eql(texts)
      subject.to_s.should  eql("textgoesfirst")
    end

    it "should set color" do
      subject.color.should eql(:blue)
    end

    it "should default opts" do
      subject.opts.should eql({
        :underline=>true,
        :stroke=>Shoes::COLORS[:blue]
      })
    end

    context "overriding options" do
      subject { Shoes::Link.new(app, app, texts,
                                underline: false, bg: Shoes::COLORS[:green]) }

      it "should include defaults" do
        subject.opts.should include(:stroke => Shoes::COLORS[:blue])
      end

      it "should override defaults" do
        subject.opts.should include(:underline => false)
      end

      it "should include other options" do
        subject.opts.should include(:bg => Shoes::COLORS[:green])
      end
    end

    context "with a block" do
      let(:callable) { double("callable") }
      subject { Shoes::Link.new(internal_app, nil, texts) { callable.call } }

      it "sets up for the click" do
        expect(callable).to receive(:call)
        subject.execute_link
      end
    end

    context "with click option as text" do
      subject { Shoes::Link.new(internal_app, nil, texts, click: "/url") }

      it "should visit the url" do
        expect(app).to receive(:visit).with("/url")
        subject.execute_link
      end
    end

    context "with click option as Proc" do
      let(:block) { double("block", call: nil) }
      subject { Shoes::Link.new(internal_app, nil, texts, click: block) }

      it "calls the block" do
        expect(block).to receive(:call)
        subject.execute_link
      end
    end

    context "calling click explicitly" do
      let(:original_block)    { double("original") }
      let(:replacement_block) { double("replacement") }
      subject { Shoes::Link.new(internal_app, nil, texts) { original_block.call } }

      it "replaces original block" do
        expect(original_block).to_not receive(:call)
        expect(replacement_block).to receive(:call)

        subject.click { replacement_block.call }
        subject.execute_link
      end
    end
  end
end
