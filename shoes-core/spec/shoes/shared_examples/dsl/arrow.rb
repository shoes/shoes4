shared_examples_for "arrow DSL method" do
  it "takes no arguments" do
    arrow = dsl.arrow
    expect(arrow).to have_attributes(left: 0,
                                     top: 0,
                                     width: 0)
  end

  it "takes 1 argument" do
    arrow = dsl.arrow 40
    expect(arrow).to have_attributes(left: 40,
                                     top: 0,
                                     width: 0)
  end

  it "takes 1 argument with options" do
    arrow = dsl.arrow 40, top: 50
    expect(arrow).to have_attributes(left: 40,
                                     top: 50,
                                     width: 0)
  end

  it "takes 2 arguments" do
    arrow = dsl.arrow 40, 50
    expect(arrow).to have_attributes(left: 40,
                                     top: 50,
                                     width: 0)
  end

  it "takes 2 arguments with options" do
    arrow = dsl.arrow 40, 50, width: 100
    expect(arrow).to have_attributes(left: 40,
                                     top: 50,
                                     width: 100)
  end

  it "takes 3 arguments" do
    arrow = dsl.arrow 40, 50, 100
    expect(arrow).to have_attributes(left: 40,
                                     top: 50,
                                     width: 100)
  end

  it "takes 3 arguments with options" do
    arrow = dsl.arrow 40, 50, 100, left: -1, top: -2, width: -3
    expect(arrow).to have_attributes(left: 40,
                                     top: 50,
                                     width: 100)
  end

  it "takes styles hash" do
    arrow = dsl.arrow left: 40, top: 50, width: 100
    expect(arrow).to have_attributes(left: 40,
                                     top: 50,
                                     width: 100)
  end

  it "doesn't like too many arguments" do
    expect { dsl.arrow 40, 50, 100, 666 }.to raise_error(ArgumentError)
  end

  it "doesn't like too many arguments and options too!" do
    expect { dsl.arrow 40, 50, 100, 666, left: -1 }.to raise_error(ArgumentError)
  end
end
