require 'spec_helper'

describe Shoes::SystemColor do
  describe "new" do
    let(:color) { Shoes::SystemColor.new(:system_background) }

    it "has a backend" do
      expect(color).to respond_to(:gui)
    end
  end
end
