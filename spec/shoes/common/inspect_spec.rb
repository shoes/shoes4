require "spec_helper"

describe "Shoes::Common::Inspect" do
  let (:test_class) {
    Class.new {
      include Shoes::Common::Inspect
      def self.name
        "Shoes::InspectableObject"
      end
    }
  }

  describe "when included" do
    subject(:object) { test_class.new }

    it "gives a #to_s like (Shoes::Klass)" do
      expect(object.to_s).to eq("(Shoes::InspectableObject)")
    end

    it "gives an #inspect like (Shoes::Klass <0x000049e8>)" do
      expect(object.inspect).to match(/^\(Shoes::InspectableObject <0x[0-9a-f]{8}>\)$/)
    end
  end
end
