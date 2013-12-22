require 'delegate'

class Shoes
  module Swt
    class UnlessDisposedDelegator < SimpleDelegator
      def __getobj__
        if @delegate_sd_obj.disposed?
          @delegate_sd_null_obj ||= NullObject.new
        else
          @delegate_sd_obj
        end
      end

      class NullObject
        def respond_to?(method)
          true
        end

        def method_missing(method)
        end
      end
    end
  end
end

describe Shoes::Swt::UnlessDisposedDelegator do
  let(:width) { 234 }
  subject(:delegator) { Shoes::Swt::UnlessDisposedDelegator.new delegation_object }

  context "when delegation object is NOT disposed" do
    let(:delegation_object) { double("delegation object", width: width, disposed?: false) }

    it "delegates method" do
      delegator.width
      expect(delegation_object).to have_received(:width)
    end

    it "returns the same result as the delegation object" do
      expect(delegator.width).to eq(width)
    end
  end

  context "when delegation object IS disposed" do
    let(:delegation_object) { double("delegation object", width: width, disposed?: true) }

    it "does not delegate method" do
      delegator.width
      expect(delegation_object).not_to have_received(:width)
    end

    it "returns nil" do
      expect(delegator.width).to eq(nil)
    end
  end
end

