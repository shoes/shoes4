require "spec_helper"

class Shoes
  class InspectableObject
    include Shoes::Common::Inspect
  end
end

describe "Shoes::Common::Inspect" do
  describe "when included" do
    subject(:object) { Shoes::InspectableObject.new }

    it "gives a #to_s like (Shoes::Klass)" do
      expect(object.to_s).to eq("(Shoes::InspectableObject)")
    end

    it "gives an #inspect like (Shoes::Klass <0x000049e8>)" do
      expect(object.inspect).to match(/^\(Shoes::InspectableObject <0x[0-9a-f]{8}>\)$/)
    end
  end
end
