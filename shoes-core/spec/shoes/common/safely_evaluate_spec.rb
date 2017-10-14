# frozen_string_literal: true

require "spec_helper"

describe Shoes::Common::SafelyEvaluate do
  let(:test_class) do
    Class.new do
      attr_accessor :args
      include Shoes::Common::SafelyEvaluate
    end
  end

  subject { test_class.new }

  before do
    @prior_fail_fast = Shoes.configuration.fail_fast
  end

  after do
    Shoes.configuration.fail_fast = @prior_fail_fast
  end

  it "calls through with args" do
    subject.safely_evaluate(1, 2, 3) do |*args|
      subject.args = args
    end

    expect(subject.args).to eq([1, 2, 3])
  end

  it "allows without block" do
    expect(Shoes.logger).to_not receive(:error)
    subject.safely_evaluate
  end

  it "doesn't raise during block evaluation by default" do
    expect(Shoes.logger).to receive(:error).with("heck")
    subject.safely_evaluate do
      raise "heck"
    end
  end

  it "doesn't raise during block evaluation if marked not failing fast" do
    Shoes.configuration.fail_fast = false
    expect(Shoes.logger).to receive(:error).with("heck")

    subject.safely_evaluate do
      raise "heck"
    end
  end

  it "raises during block evaluation if failing fast" do
    Shoes.configuration.fail_fast = true
    expect(Shoes.logger).to receive(:error).with("heck")

    expect do
      subject.safely_evaluate do
        raise "heck"
      end
    end.to raise_error(RuntimeError)
  end
end
