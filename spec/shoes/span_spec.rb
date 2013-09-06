require 'shoes/spec_helper'

describe Shoes::Span do
  let(:app) { Shoes::App.new }

  describe 'span' do
    it 'sets style to Span block' do
      app.opts[:strikethrough].should_not be_true

      opts = { strikethrough: true }
      result = app.span('test', opts)
      result.opts[:strikethrough].should be_true

      app.opts[:strikethrough].should_not be_true
    end
  end

  describe 'code' do
    it 'sets font to Lucida Console' do
      result = app.code 'test'
      result.opts[:font].should eq('Lucida Console')
    end
  end

  describe 'del' do
    it 'sets strikethrough to true' do
      result = app.del 'test'
      result.opts[:strikethrough].should be_true
    end
  end

  describe 'em' do
    it 'sets emphasis to true' do
      result = app.em 'test'
      result.opts[:emphasis].should be_true
    end
  end

  describe 'ins' do
    it 'sets underline to true' do
      result = app.ins 'test'
      result.opts[:underline].should be_true
    end
  end

  describe 'sub' do
    it 'sets rise to -10 and multiplies font size by 0.8' do
    #  initial_size = app.dsl.font_sizee
      result = app.sub 'test'
      result.opts[:rise].should eq(-10)
    #  result.opts[:size].should eq(initial_size * 0.8)
    end
  end

  describe 'sup' do
    it 'sets rise to 10 and multiplies font size by 0.8' do
    #  initial_size = app.dsl.font_sizee
      result = app.sup 'test'
      result.opts[:rise].should eq(10)
    #  result.opts[:size].should eq(initial_size * 0.8)
    end
  end

  describe 'strong' do
    it 'sets weight to true' do
      result = app.strong 'test'
      result.opts[:weight].should be_true
    end
  end
end
