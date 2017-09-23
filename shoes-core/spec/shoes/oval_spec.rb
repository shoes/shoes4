# frozen_string_literal: true
require 'spec_helper'

describe Shoes::Oval do
  include_context "dsl app"

  let(:left) { 20 }
  let(:top) { 30 }
  let(:width) { 100 }
  let(:height) { 200 }

  describe "basic" do
    subject { Shoes::Oval.new(app, parent, left, top, width, height) }

    it_behaves_like "an art element" do
      let(:subject_without_style) { Shoes::Oval.new(app, parent, left, top, width, height) }
      let(:subject_with_style) { Shoes::Oval.new(app, parent, left, top, width, height, arg_styles) }
    end
    it_behaves_like "left, top as center"
  end

  describe "dsl" do
    it "takes no arguments" do
      oval = dsl.oval
      expect(oval).to have_attributes(left: 0,
                                      top: 0,
                                      width: 0,
                                      height: 0)
    end

    it "takes 1 argument" do
      oval = dsl.oval 10
      expect(oval).to have_attributes(left: 10,
                                      top: 0,
                                      width: 0,
                                      height: 0)
    end

    it "takes 1 argument with hash" do
      oval = dsl.oval 10, top: 20, width: 30, height: 40
      expect(oval).to have_attributes(left: 10,
                                      top: 20,
                                      width: 30,
                                      height: 40)
    end

    it "takes 2 arguments" do
      oval = dsl.oval 10, 20
      expect(oval).to have_attributes(left: 10,
                                      top: 20,
                                      width: 0,
                                      height: 0)
    end

    it "takes 2 arguments with hash" do
      oval = dsl.oval 10, 20, width: 30, height: 40
      expect(oval).to have_attributes(left: 10,
                                      top: 20,
                                      width: 30,
                                      height: 40)
    end

    it "takes 2 arguments with hash side" do
      oval = dsl.oval 10, 20, width: 30
      expect(oval).to have_attributes(left: 10,
                                      top: 20,
                                      width: 30,
                                      height: 30)
    end

    it "takes 3 arguments" do
      oval = dsl.oval 10, 20, 30
      expect(oval).to have_attributes(left: 10,
                                      top: 20,
                                      width: 30,
                                      height: 30)
    end

    it "takes 3 arguments with hash" do
      oval = dsl.oval 10, 20, 30, height: 40
      expect(oval).to have_attributes(left: 10,
                                      top: 20,
                                      width: 30,
                                      height: 40)
    end

    it "takes 4 arguments" do
      oval = dsl.oval 10, 20, 30, 40
      expect(oval).to have_attributes(left: 10,
                                      top: 20,
                                      width: 30,
                                      height: 40)
    end

    it "takes 4 arguments with hash" do
      oval = dsl.oval 10, 20, 30, 40, left: -1, top: -2, width: -3, height: -4
      expect(oval).to have_attributes(left: 10,
                                      top: 20,
                                      width: 30,
                                      height: 40)
    end

    it "takes styles hash" do
      oval = dsl.oval left: 10, top: 20, width: 30, height: 40
      expect(oval).to have_attributes(left: 10,
                                      top: 20,
                                      width: 30,
                                      height: 40)
    end

    it "favors width over radius" do
      oval = dsl.oval 10, 20, width: 30, radius: 40
      expect(oval.width).to eq(30)
    end

    it "favors width over diameter" do
      oval = dsl.oval 10, 20, width: 30, diameter: 40
      expect(oval.width).to eq(30)
    end

    it "supports radius" do
      oval = dsl.oval 10, 20, radius: 40
      expect(oval.width).to eq(80)
    end

    it "supports diameter" do
      oval = dsl.oval 10, 20, diameter: 40
      expect(oval.width).to eq(40)
    end

    it "doesn't like too many arguments" do
      expect { dsl.oval 10, 20, 30, 40, 666 }.to raise_error(ArgumentError)
    end

    it "doesn't like too many arguments and options too!" do
      expect { dsl.oval 10, 20, 30, 40, 666, left: -1 }.to raise_error(ArgumentError)
    end
  end
end
