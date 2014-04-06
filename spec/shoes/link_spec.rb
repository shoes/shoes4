require 'shoes/spec_helper'

describe Shoes::Link do
  let(:app) { double("app", gui: double("gui").as_null_object) }

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
        :fg=>Shoes::COLORS[:blue]
      })
    end

    context "overriding options" do
      subject { Shoes::Link.new(app, app, texts,
                                underline: false, bg: Shoes::COLORS[:green]) }

      it "should include defaults" do
        subject.opts.should include(:fg => Shoes::COLORS[:blue])
      end

      it "should override defaults" do
        subject.opts.should include(:underline => false)
      end

      it "should include other options" do
        subject.opts.should include(:bg => Shoes::COLORS[:green])
      end
    end
  end
end
