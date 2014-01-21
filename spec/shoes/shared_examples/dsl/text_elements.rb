shared_examples_for "text element DSL methods" do
  it "should set banner font size to 48" do
    text_block = dsl.banner("hello!")
    text_block.font_size.should eql 48
  end

  it "should set title font size to 34" do
    text_block = dsl.title("hello!")
    text_block.font_size.should eql 34
  end

  it "should set subtitle font size to 26" do
    text_block = dsl.subtitle("hello!")
    text_block.font_size.should eql 26
  end

  it "should set tagline font size to 18" do
    text_block = dsl.tagline("hello!")
    text_block.font_size.should eql 18
  end

  it "should set caption font size to 14" do
    text_block = dsl.caption("hello!")
    text_block.font_size.should eql 14
  end

  it "should set para font size to 12" do
    text_block = dsl.para("hello!")
    text_block.font_size.should eql 12
  end

  it "should set inscription font size to 10" do
    text_block = dsl.inscription("hello!")
    text_block.font_size.should eql 10
  end

  describe 'span' do
    it 'should parse the color' do
      span = dsl.span 'Hello', stroke: '#ccc'
      expect(span.opts[:stroke]).to eq Shoes::Color.new 204, 204, 204
    end
  end
end
