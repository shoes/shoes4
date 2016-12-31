require 'spec_helper'

# This isn't typically required except when the picker is running
require 'shoes/swt/generate_backend'

describe "generate_backend" do
  after do
    reset_ruby_engine("jruby")
  end

  it "validates we're on JRuby" do
    expect(Shoes::SelectedBackend).to_not receive(:exit)

    Shoes::SelectedBackend.validate
  end

  it "throws a fit if we're not on JRuby" do
    reset_ruby_engine("ruby")

    expect(Shoes::SelectedBackend).to receive(:puts)
    expect(Shoes::SelectedBackend).to receive(:exit).with(1)

    Shoes::SelectedBackend.validate
  end

  def reset_ruby_engine(engine)
    Object.instance_eval do
      remove_const(:RUBY_ENGINE)
      const_set(:RUBY_ENGINE, engine)
    end
  end
end
