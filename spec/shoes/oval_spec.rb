require 'shoes/spec_helper'

describe Shoes::Oval do
  let(:app) { Shoes::App.new }

  describe "basic" do
    subject { Shoes::Oval.new(app, 20, 30, 100, 200) }
    it_behaves_like "object with stroke"
    it_behaves_like "object with fill"
    it_behaves_like "movable object"
    it_behaves_like "left, top as center"
  end

end
