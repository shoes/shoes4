require 'shoes/spec_helper'

describe Shoes::Stack do
  let(:app) { Shoes::App.new }
  subject { Shoes::Stack.new(app, {:app => app}) }

  it_behaves_like "Slot"
end
