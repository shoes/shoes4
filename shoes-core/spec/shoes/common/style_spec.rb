require 'spec_helper'

describe Shoes::Common::Style do
  include_context "dsl app"
  let(:blue) { Shoes::COLORS[:blue] }

  class StyleTester
    include Shoes::Common::Visibility
    include Shoes::Common::Style

    attr_accessor :left
    style_with :key, :left, :click, :strokewidth, :fill

    STYLES = {fill: Shoes::COLORS[:blue]}

    def initialize(app, styles = {})
      @app = app #needed for style init
      style_init(styles, key: 'value')
      @left = 15
    end

    def click(&arg)
      @click = arg
    end

    def click_blk
      @click
    end

    def update_visibility
    end
  end

  subject {StyleTester.new(app)}

  its(:style) { should eq (initial_style) }
  let(:initial_style) { {key: 'value', left: 15, click: nil, strokewidth: 1, fill: blue} }

  describe 'reading and writing through #style(hash)' do
    let(:input_proc) { Proc.new {} }
    let(:changed_style) { {key: 'changed value'} }


    before :each do
      subject.style changed_style
    end

    it 'returns the changed style' do
      expect(subject.style).to eq initial_style.merge changed_style
    end

    it 'does update values for new values' do
      subject.style new_key: 'new value'
      expect(subject.style[:new_key]).to eq 'new value'
    end

    it 'reads new dimensions' do
      subject.left = 20
      expect(subject.style[:left]).to eq 20
    end

    it 'writes new dimensions' do
      subject.style(left: 200)
      expect(subject.left).to eq 200
    end

    it 'reads visibility' do
      subject.hide
      expect(subject.style[:hidden]).to be true
    end

    it 'writes visibility' do
      subject.style(hidden: true)
      expect(subject.hidden?).to be true
    end

    it 'sets click' do
      subject.style(click: input_proc)
      expect(subject.click_blk).to eq input_proc
    end

    it 'sets non dimension non click style via setter' do
      subject.key = 'silver'
      expect(subject.style[:key]).to eq 'silver'
    end

    it 'gets non dimension non click style via getter' do
      expect(subject.key).to eq 'changed value'
    end

    # these specs are rather extensive as they are performance critical for
    # redrawing
    describe 'calling or not calling #update_style' do
      it 'does not call #update_style if no key value pairs changed' do
        expect(subject).not_to receive(:update_style)
        subject.style changed_style
      end

      it 'does not call #update_style if called without arg' do
        expect(subject).not_to receive(:update_style)
        subject.style
      end

      it 'does call #update_style if the values change' do
        expect(subject).to receive(:update_style)
        subject.style key: 'new value'
      end

      it 'does call #update_style if there is a new key-value' do
        expect(subject).to receive(:update_style)
        subject.style new_key: 'value'
      end
    end
  end

  describe "app-default" do
    it "reads app-default styles with reader" do
      expect(subject.strokewidth).to eq 1
    end

    it "writes app-default styles with writer" do
      subject.strokewidth = 5
      expect(subject.strokewidth).to eq 5
    end

    it "does not read 'default' styles that it doesn't support" do
      expect(subject).not_to respond_to :stroke
    end

    it "does not write 'default' styles that it doesn't support" do
      expect(subject).not_to respond_to :stroke=
    end
  end

  describe "style priorities" do
    subject {StyleTester.new(app, key: 'pumpkin')}

    it 'uses arguments-styles over element-styles' do
      expect(subject.key).to eq 'pumpkin'
    end

    it "uses element-defaults over app-defaults" do
      expect(subject.fill).to eq blue
    end

    #related priority specs are tested individually in spec/shared_examples/style
  end

  describe 'StyleWith' do
    it 'ensures that readers exist for each supported style' do
      subject.supported_styles.each do |style|
        expect(subject).to respond_to style
      end
    end

    it 'ensures that writers exist for each supported style' do
      subject.supported_styles.each do |style|
        expect(subject).to respond_to "#{style}="
      end
    end

  end

end
