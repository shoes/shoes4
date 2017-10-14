# frozen_string_literal: true

require 'benchmark'
require File.dirname(__FILE__) + '/para_creator'

# doesn't use benchmark/ips as one of the main purposes here is seeing how the
# app deals with a lot of content (in this case paras/stacks/flows) which is
# good to measure with explicit numbers. It doesn't get cleared inbetween so
# per iteration times seems irrelevant.
Shoes.app do
  extend ParaCreator

  def benchmark_paras
    Benchmark.bm do |benchmark|
      benchmark.report '100' do
        create_paras 100
      end

      # this already hangs on shoes 3
      benchmark.report '1000' do
        create_paras 1000
      end
    end
  end

  def benchmark_paras_stacks_flows
    Benchmark.bm do |benchmark|
      benchmark.report '100' do
        create_stack_flows 100
      end

      benchmark.report '500' do
        create_stack_flows 500
      end
    end
  end

  def create_stack_flows(count)
    count.times do
      stack do
        flow do
          para ParaCreator::LOREM_IPSUM
        end
        flow do
          para ParaCreator::LOREM_IPSUM
        end
      end
    end
  end

  button 'benchmark paras' do
    benchmark_paras
  end

  button 'benchmark paras with some stacks and flows' do
    benchmark_paras_stacks_flows
  end
end
