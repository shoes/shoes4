describe Shoes::Swt::Arc do
  let(:app_real) { double("app real") }
  let(:app) { double("app", real: app_real) }
  let(:left) { 100 }
  let(:top) { 200 }
  let(:width) { 300 }
  let(:height) { 400 }
  let(:opts) { { app: app, left: left, top: top, width: width, height: height} }
  let(:dsl) { double("dsl object").as_null_object }

  subject {
    Shoes::Swt::Arc.new(dsl, opts)
  }

  describe "paint callback" do
    include_context "paintable context"

    it_behaves_like "paintable"

    specify "fills arc" do
      pending "swt arc implementation"
    end

    specify "draws arc" do
      pending "swt arc implementation"
    end
  end
end
