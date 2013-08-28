require 'shoes/spec_helper'

describe Shoes::TextBlock do
  let(:app) { Shoes::App.new }
  let(:parent) { Shoes::Flow.new app, app }
  let(:text_link) { Shoes::Link.new(:link, ['Hello']) }
  subject { Shoes::TextBlock.new(app, parent, "#{text_link}, world!", 99, {app: app}) }

  describe "initialize" do
    it "creates gui object" do
      subject.gui.should_not be_nil
    end
  end

  describe "text" do
    it "sets text when the object is created" do
      subject.text.should eql "Hello, world!"
    end

    it "allows us to change the text" do
      s = subject
      s.text = "Goodbye Cruel World"
      s.text.should eql "Goodbye Cruel World"
    end
  end

  describe "#to_s" do
    it "is the same as #text" do
      text = subject.text
      subject.to_s.should eq(text)
    end
  end

  describe "#replace" do
    it "replaces text" do
      subject.replace "Goodbye Cruel World"
      subject.text.should eq("Goodbye Cruel World")
    end

    it "allows two arguments" do
      subject.replace "Goodbye Cruel World, ", text_link
      subject.text.should eq("Goodbye Cruel World, Hello")
    end
  end

  describe "font" do
    it "sets the default font to Arial" do
      subject.font.should eql "Arial"
    end

    it "should allow setting the font with :family" do
      s = Shoes::TextBlock.new(app, parent, "Hello, world!", 99, { font: "Helvetica", app: app })
      s.font.should eql "Helvetica"
    end

    it "should allow setting the font size with :family" do
      s = Shoes::TextBlock.new(app, parent, "Hello, world!", 99, { font: "Helvetica 33px", app: app })
      s.font.should eql "Helvetica"
      s.font_size.should eql 33
    end

    it "should accept fonts surrounded with questionmarks when using :family" do
      s = Shoes::TextBlock.new(app, parent, "Hello, world!", 99, { font: '"Comic Sans" 13px', app: app })
      s.font.should eql "Comic Sans"
      s.font_size.should eql 13
    end

  end

  describe "stroke" do
    it "should accept a hex code" do
      s = Shoes::TextBlock.new(app, parent, "Hello, world!", 99, { stroke: "#fda", app: app })
      color = s.gui.instance_variable_get('@opts')[:stroke]
      color.red.should eql 255
      color.green.should eql 221
      color.blue.should eql 170
    end
  end

  context "with nested text fragments" do
    # Emulates samples/sample17.Rb
    #
    #   Shoes.app width: 240, height: 95 do
    #     para 'Testing, test, test. ',
    #       strong('Breadsticks. '),
    #       em('Breadsticks. '),
    #       code('Breadsticks. '),
    #       bg(fg(strong(ins('EVEN BETTER.')), white), rgb(255, 0, 192)),
    #       sub('fine!')
    #   end

    let(:breadsticks) { "Breadsticks. "}
    let(:even_better) { "EVEN BETTER."}
    let(:fine) { "fine!"}
    let(:strong_breadsticks) { app.strong breadsticks }
    let(:em) { app.em breadsticks }
    let(:code) { app.code breadsticks }
    let(:ins) { app.ins even_better }
    let(:fg) { app.fg strong, app.white }
    let(:strong) { app.strong ins }
    let(:bg) { app.bg fg, app.rgb(255, 0, 192) }
    let(:sub) { app.sub fine }
    let(:para) { app.para("Testing, test, test. ", strong_breadsticks, em, code, bg, sub) }

    it "has full text of fragments" do
      para.text.should eq("Testing, test, test. Breadsticks. Breadsticks. Breadsticks. EVEN BETTER.fine!")
    end

    it "has fragment styles" do
      text_styles = [
                     [strong_breadsticks, 21..33],
                     [em, 34..46],
                     [code, 47..59],
                     [bg, 60..71],
                     [fg, 60..71],
                     [strong, 60..71],
                     [ins, 60..71],
                     [sub, 72..76]
                    ]
      para.text_styles.should eq(text_styles)
    end
  end
end
