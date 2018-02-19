# frozen_string_literal: true

shared_examples "object with hover" do
  let(:teal) { Shoes::COLORS[:teal] }
  let(:gold) { Shoes::COLORS[:gold] }

  let(:hover_class) { subject.hover_class }

  it "registers hover" do
    expect(subject).to receive(:add_mouse_hover_control)
    subject.hover {}
  end

  it "returns element from hover" do
    returned = subject.hover {}
    expect(returned).to eq(subject)
  end

  it "registers with leave" do
    expect(subject).to receive(:add_mouse_hover_control)
    subject.leave {}
  end

  it "returns element from leave" do
    returned = subject.leave {}
    expect(returned).to eq(subject)
  end

  it "marks itself as hovered" do
    subject.mouse_hovered
    expect(subject.hovered?).to eq(true)
  end

  it "marks itself not hovered after leaving" do
    subject.mouse_hovered
    expect(subject.hovered?).to eq(true)

    subject.mouse_left
    expect(subject.hovered?).to eq(false)
  end

  it "only calls hover block once" do
    count = 0
    subject.hover do
      count += 1
    end

    subject.mouse_hovered
    subject.mouse_hovered

    expect(count).to eq(1)
  end

  it "only calls leave block once after we're hovering" do
    count = 0
    subject.leave do
      count += 1
    end

    subject.mouse_hovered
    subject.mouse_left
    subject.mouse_left

    expect(count).to eq(1)
  end

  it "doesn't update styles on hover by default" do
    original_style = subject.style.dup
    subject.mouse_hovered

    expect(subject.style).to eq(original_style)
  end

  it "updates styles on hover" do
    user_facing_app.style(hover_class, stroke: teal)

    subject.mouse_hovered
    expect(subject.style[:stroke]).to eq(teal)
  end

  it "restores style after hover's done" do
    user_facing_app.style(hover_class, stroke: teal)

    subject.style[:stroke] = gold
    subject.mouse_hovered
    subject.mouse_left

    expect(subject.style[:stroke]).to eq(gold)
  end
end
