# frozen_string_literal: true

shared_context "quiet logging" do
  before do
    allow(Shoes.logger).to receive(:debug)
    allow(Shoes.logger).to receive(:info)
    allow(Shoes.logger).to receive(:warn)
    allow(Shoes.logger).to receive(:error)
  end
end
