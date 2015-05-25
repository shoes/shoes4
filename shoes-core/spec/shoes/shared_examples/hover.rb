shared_examples "object with hover" do
  it "registers hover" do
    expect(subject.app).to receive(:add_mouse_hover_control).with(subject)
    subject.hover { }
  end

  it "registers with leave" do
    expect(subject.app).to receive(:add_mouse_hover_control).with(subject)
    subject.leave { }
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
end
