require 'shoes/spec_helper'

describe Shoes::Span do
  let(:app) { Shoes::App.new }
  let(:style) { {} }
  let(:text) { ['test'] }
  subject(:span) { Shoes::Span.new(text, style) }

  describe 'span' do
    include InspectHelpers

    it 'sets style to Span block' do
      expect(app.style[:strikethrough]).not_to be_truthy

      style = { strikethrough: true }
      result = app.span('test', style)
      expect(result.style[:strikethrough]).to be_truthy

      expect(app.style[:strikethrough]).not_to be_truthy
    end

    it 'displays text for #to_s' do
      expect(span.to_s).to eq(text.join)
    end

    it 'displays (Shoes::Span:0x01234567 "text") for #inspect' do
      expect(span.inspect).to match(/[(]Shoes::Span:#{shoes_object_id_pattern} "#{text.join}"[)]/)
    end
  end

  describe 'Looking up styles of the parent text' do
    let(:white) {Shoes::COLORS[:white]}
    let(:red) {Shoes::COLORS[:red]}
    it 'does not try to merge with parent style when there are none' do
      parent = double 'parent'
      span.parent = parent
      expect {span.style}.to_not raise_error()
    end

    it 'merges with the styles of the parent text' do
      parent = double 'parent', style: {stroke: white}
      span.parent = parent
      expect(span.style[:stroke]).to eq(white)
    end

    describe 'with own style' do
      let(:style) {{stroke: red}}
      it 'prefers own values over parent text values' do
        parent = double 'parent', style: {stroke: white}
        span.parent = parent
        expect(span.style[:stroke]).to eq(red)
      end
    end
  end

  describe 'setting the text block a span belongs to' do
    it 'can set it' do
      text_block = double 'text block'
      subject.text_block = text_block
      expect(subject.text_block).to eq text_block
    end
  end

  describe 'code' do
    it 'sets font to Lucida Console' do
      result = app.code 'test'
      expect(result.style[:font]).to eq(('Lucida Console'))
    end
  end

  describe 'del' do
    it 'sets strikethrough to true' do
      result = app.del 'test'
      expect(result.style[:strikethrough]).to be_truthy
    end
  end

  describe 'em' do
    it 'sets emphasis to true' do
      result = app.em 'test'
      expect(result.style[:emphasis]).to be_truthy
    end
  end

  describe 'ins' do
    it 'sets underline to true' do
      result = app.ins 'test'
      expect(result.style[:underline]).to be_truthy
    end
  end

  describe 'sub' do
    it 'sets rise to -10 and multiplies font size by 0.8' do
      result = app.sub 'test'
      expect(result.style[:rise]).to eq(-10)
    end
  end

  describe 'sup' do
    it 'sets rise to 10 and multiplies font size by 0.8' do
      result = app.sup 'test'
      expect(result.style[:rise]).to eq(10)
    end
  end

  describe 'strong' do
    it 'sets weight to true' do
      result = app.strong 'test'
      expect(result.style[:weight]).to be_truthy
    end
  end
end
