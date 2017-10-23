# frozen_string_literal: true
shared_examples_for "scrollable slot" do
  its(:scroll) { should be_truthy }
  it "initializes scroll_top to 0" do
    expect(subject.scroll_top).to eq(0)
  end

  before do
    subject.scroll_height = 200
    subject.height = 100
  end

  describe '#scroll_top' do
    describe "when scrolling" do
      before do
        subject.scroll = true
      end

      it "allows setting scroll position" do
        subject.scroll_top = 42
        expect(subject.scroll_top).to eq(42)
      end

      it "can't scroll past maximum" do
        subject.scroll_top = subject.scroll_max + 10
        expect(subject.scroll_top).to eq(subject.scroll_max)
      end
    end

    describe "when not scrolling" do
      before do
        subject.scroll = false
        allow(Shoes.logger).to receive(:warn)
      end

      it "can't set scroll position" do
        subject.scroll_top = 42
        expect(subject.scroll_top).to eq(0)
      end

      it "logs a warning" do
        subject.scroll_top = 42
        expect(Shoes.logger).to have_received(:warn)
      end
    end
  end

  describe '#scroll_max' do
    it 'allows some scrolling' do
      expect(subject.scroll_max).to eq(100)
    end

    it 'caps scrolling' do
      subject.scroll_height = 80
      expect(subject.scroll_max).to eq(0)
    end
  end

  describe '#snapshot_current_position' do
    before do
      subject.absolute_left = 100
      subject.absolute_top = 100
    end

    it "offsets when scrollable" do
      subject.scroll = true
      subject.scroll_top = 10

      position = subject.snapshot_current_position
      expect(position.y).to eq(90)
      expect(position.next_line_start).to eq(90)
    end

    it "doesn't offset when not scrollable" do
      subject.scroll = false

      position = subject.snapshot_current_position
      expect(position.y).to eq(100)
      expect(position.next_line_start).to eq(100)
    end
  end
end

shared_examples_for "scrollable slot with overflowing content" do
  it "retains the same height" do
    expect(subject.height).to eq(height)
  end

  it "has scroll_height larger than height" do
    expect(subject.scroll_height).to be > height
  end

  it "has scroll_max = (scroll_height - height)" do
    expect(subject.scroll_max).to eq(subject.scroll_height - subject.height)
  end

  it 'adjusts scroll_top' do
    expect(subject.scroll_top).to eq(new_position)
  end
end

shared_context "scroll" do
  let(:height) { 200 }
  let(:input_opts) { {left: 40, top: 20, width: 400, height: height} }
  let(:opts) { input_opts.merge(scroll: scroll) }
end

shared_context "overflowing content" do
  let(:new_position) { 300 }

  before :each do
    200.times do
      Shoes::TextBlock.new(app, subject, "Fourteen fat chimichangas", size: 18)
    end
    subject.scroll_top = new_position
  end
end
