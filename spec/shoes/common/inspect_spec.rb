require "spec_helper"

describe "Shoes::Common::Inspect" do
  include_context "dsl app"
  describe "when included" do
    subject(:rect) { Shoes::Rect.new(app, parent, 0, 0, 100, 200) }

    it "gives a #to_s like (Shoes:Rect)" do
      expect(rect.to_s).to eq("(Shoes:Rect)")
    end

    it "gives an #inspect like (Shoes:Rect <0x000049e8>)" do
      expect(rect.inspect).to match(/^\(Shoes:Rect <0x[0-9a-f]{8}>\)$/)
    end
  end
end
