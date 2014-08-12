shared_examples_for "text element DSL methods" do
  it "should set banner font size to 48" do
    text_block = dsl.banner("hello!")
    expect(text_block.size).to eql 48
  end

  it "should set title font size to 34" do
    text_block = dsl.title("hello!")
    expect(text_block.size).to eql 34
  end

  it "should set subtitle font size to 26" do
    text_block = dsl.subtitle("hello!")
    expect(text_block.size).to eql 26
  end

  it "should set tagline font size to 18" do
    text_block = dsl.tagline("hello!")
    expect(text_block.size).to eql 18
  end

  it "should set caption font size to 14" do
    text_block = dsl.caption("hello!")
    expect(text_block.size).to eql 14
  end

  it "should set para font size to 12" do
    text_block = dsl.para("hello!")
    expect(text_block.size).to eql 12
  end

  it "should set inscription font size to 10" do
    text_block = dsl.inscription("hello!")
    expect(text_block.size).to eql 10
  end

  describe 'span' do
    it 'should parse the color' do
      span = dsl.span 'Hello', stroke: '#ccc'
      expect(span.style[:stroke]).to eq Shoes::Color.new 204, 204, 204
    end

    it 'should handle a splatted array of links' do
      expect{dsl.span *[dsl.link('foo'), dsl.link('foo')]}.not_to raise_error
    end

    it 'should handle a splatted array of links and parse the color' do
      span = dsl.span *[dsl.link('foo'), dsl.link('foo')], stroke: '#ccc'
      expect(span.style[:stroke]).to eq Shoes::Color.new 204, 204, 204
    end

    it 'should handle a splatted array of links with a block' do
      link = dsl.link('foo') { "Bar" }
      expect{dsl.span *[link, link]}.not_to raise_error
    end
  end

  describe 'link' do
    it 'handles multiple texts' do
      link = dsl.link('one', 'two')
      expect(link.to_s).to eql('onetwo')
    end

    it 'handles trailing options' do
      link = dsl.link('one', 'two', stroke: '#ccc')
      expect(link.to_s).to eql('onetwo')
      expect(link.style[:stroke]).to eq Shoes::Color.new 204, 204, 204
    end
  end

  describe 'para' do
    context "with nested text fragments with parameters" do
      Shoes::DSL::TEXT_STYLES.keys.each do |style|
        it "handles opts properly for #{style}" do
          para = dsl.para(dsl.send(style, style, stroke: '#ccc'))
          expect(para.text).to eq(style.to_s)
        end
      end
    end
  end
end
