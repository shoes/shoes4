require 'shoes/context'

describe Shoes::Context do
  let(:app) { double("app") }
  let(:privates) { :@__privates__ }
  subject(:context) { Shoes::Context.new app }

  it "has DSL methods" do
    expect(context).to respond_to(:background)
  end

  it "sets privates" do
    expect(context.instance_variable_defined? privates).to eq(true)
  end

  it "doesn't brag about :@__privates__" do
    expect(context.instance_variables).not_to include(privates)
  end

  it "allows setting instance variables" do
    code = proc do
      @fruit = "orange"
    end
    expect(context.instance_variable_defined?(:@fruit)).to be_false
    context.execute &code
    expect(context.instance_variable_get(:@fruit)).to eq("orange")
  end

end
