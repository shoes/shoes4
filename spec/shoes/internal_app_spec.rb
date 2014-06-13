require 'shoes/spec_helper'

describe Shoes::InternalApp do
  include_context "dsl app"

  subject { app }

  describe "#initialize" do
    context "with defaults" do
      let(:defaults) { Shoes::InternalApp::DEFAULT_OPTIONS }

      it "sets title", :qt do
        expect(subject.app_title).to eq defaults[:title]
      end

      it "is resizable", :qt do
        expect(subject.resizable).to be_truthy
      end

      it "sets width" do
        expect(subject.width).to eq(defaults[:width])
      end

      it "sets height" do
        expect(subject.height).to eq(defaults[:height])
      end

      it "does not start as fullscreen" do
        expect(subject.start_as_fullscreen?).to be_falsey
      end
    end

    context "with custom opts" do
      let(:input_opts) { {:width => 150, :height => 2, :title => "Shoes::App Spec", :resizable => false} }

      it "sets title", :qt do
        expect(subject.app_title).to eq input_opts[:title]
      end

      it "sets resizable", :qt do
        expect(subject.resizable).to be_falsey
      end

      it "sets width" do
        expect(subject.width).to eq(input_opts[:width])
      end

      it "sets height" do
        expect(subject.height).to eq(input_opts[:height])
      end
    end
  end

  describe 'fullscreen' do
    let(:input_opts) { {:fullscreen => true} }

    it "sets fullscreen" do
      expect(subject.start_as_fullscreen?).to be_truthy
    end
  end

  describe '#contents' do
    it 'delegates to top_slot' do
      expect(subject.contents).to be(subject.top_slot.contents)
    end
  end

  describe '#clear' do
    context 'when called after the initial input block' do
      let(:input_block) {
        Proc.new do
          para "CONTENT"
          para "JUST FOR TESTING"
        end
      }

      before :each do
        expect(subject.contents.size).to eq(2)
      end

      it 'clears top_slot' do
        subject.clear
        expect(subject.contents).to be_empty
      end
    end

    context 'when called in the initial input_block' do
      let(:input_block) {
        Proc.new do
          para 'Hello there'
          clear do
            para 'see you'
          end
        end
      }

      it 'does not raise an error' do
        expect {subject}.not_to raise_error
      end

      context 'when called inside a slot' do
        let(:input_block) {
          Proc.new do
            button 'I am here'
            stack do
              button 'Hi there'
              button 'Another one'
              clear
            end
          end
        }

        it 'does not delete the slot, or an element outside the slot' do
          expect(subject.contents.size).to eq 2
        end
      end
    end

    context 'when called before a button in an initial input block' do
      let(:input_block) {
        Proc.new do
          clear
          button 'My Button'
        end
      }

      it 'allows a button to be created' do
        expect(subject.contents.size).to eq(1)
      end

      describe 'the button' do
        let(:button) { subject.contents.first }

        it 'has the top_slot as its parent' do
          expect(button.parent).to eq subject.top_slot
        end
      end
    end

  end
end
