require 'spec_helper'

describe Shoes::Rect do
  include_context "dsl app"

  let(:parent) { app }
  let(:left) { 44 }
  let(:top) { 66 }
  let(:width) { 111 }
  let(:height) { 333 }
  subject(:rect) { Shoes::Rect.new(app, parent, left, top, width, height) }

  describe '#style' do
    it 'restyles handed in fill colors (even the weird ones)' do
      subject.style fill: 'fff'
      expect(subject.style[:fill]).to eq Shoes::Color.new 255, 255, 255
    end
  end

  it "retains app" do
    expect(rect.app).to eq(app)
  end

  it "creates gui object" do
    expect(rect.gui).not_to be_nil
  end

  it_behaves_like "an art element" do
    let(:subject_without_style) { Shoes::Rect.new(app, parent, left, top, width, height) }
    let(:subject_with_style) { Shoes::Rect.new(app, parent, left, top, width, height, arg_styles) }
  end
  it_behaves_like "left, top as center"

  describe "dsl" do
    it "takes no arguments" do
      rect = dsl.rect
      expect(rect).to have_attributes(left: 0,
                                      top: 0,
                                      width: 0,
                                      height: 0,
                                      curve: 0)
    end

    it "takes 1 argument" do
      rect = dsl.rect 10
      expect(rect).to have_attributes(left: 10,
                                      top: 0,
                                      width: 0,
                                      height: 0,
                                      curve: 0)
    end

    it "takes 1 argument with hash" do
      rect = dsl.rect 10, top: 20, width: 30, height: 40
      expect(rect).to have_attributes(left: 10,
                                      top: 20,
                                      width: 30,
                                      height: 40,
                                      curve: 0)
    end

    it "takes 2 arguments" do
      rect = dsl.rect 10, 20
      expect(rect).to have_attributes(left: 10,
                                      top: 20,
                                      width: 0,
                                      height: 0,
                                      curve: 0)
    end

    it "takes 2 arguments with hash" do
      rect = dsl.rect 10, 20, width: 30, height: 40
      expect(rect).to have_attributes(left: 10,
                                      top: 20,
                                      width: 30,
                                      height: 40,
                                      curve: 0)
    end

    it "takes 2 arguments with hash side" do
      rect = dsl.rect 10, 20, width: 30
      expect(rect).to have_attributes(left: 10,
                                      top: 20,
                                      width: 30,
                                      height: 30,
                                      curve: 0)
    end

    it "takes 3 arguments" do
      rect = dsl.rect 10, 20, 30
      expect(rect).to have_attributes(left: 10,
                                      top: 20,
                                      width: 30,
                                      height: 30,
                                      curve: 0)
    end

    it "takes 3 arguments with hash" do
      rect = dsl.rect 10, 20, 30, height: 40
      expect(rect).to have_attributes(left: 10,
                                      top: 20,
                                      width: 30,
                                      height: 40,
                                      curve: 0)
    end

    it "takes 4 arguments" do
      rect = dsl.rect 10, 20, 30, 40
      expect(rect).to have_attributes(left: 10,
                                      top: 20,
                                      width: 30,
                                      height: 40,
                                      curve: 0)
    end

    it "takes 4 arguments with hash" do
      rect = dsl.rect 10, 20, 30, 40, left: -1, top: -2, width: -3, height: -4
      expect(rect).to have_attributes(left: 10,
                                      top: 20,
                                      width: 30,
                                      height: 40,
                                      curve: 0)
    end

    it "takes 5 arguments" do
      rect = dsl.rect 10, 20, 30, 40, 5
      expect(rect).to have_attributes(left: 10,
                                      top: 20,
                                      width: 30,
                                      height: 40,
                                      curve: 5)
    end

    it "takes 5 arguments with hash" do
      rect = dsl.rect 10, 20, 30, 40, 5,
                      left: -1, top: -2, width: -3, height: -4, curve: -5
      expect(rect).to have_attributes(left: 10,
                                      top: 20,
                                      width: 30,
                                      height: 40,
                                      curve: 5)
    end

    it "takes styles hash" do
      rect = dsl.rect left: 10, top: 20, width: 30, height: 40, curve: 5
      expect(rect).to have_attributes(left: 10,
                                      top: 20,
                                      width: 30,
                                      height: 40,
                                      curve: 5)
    end

    it "doesn't like too many arguments" do
      expect { dsl.rect 10, 20, 30, 40, 5, 666 }.to raise_error(ArgumentError)
    end

    it "doesn't like too many arguments and options too!" do
      expect { dsl.rect 10, 20, 30, 40, 5, 666, left: -1 }.to raise_error(ArgumentError)
    end
  end
end
