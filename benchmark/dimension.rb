# frozen_string_literal: true

require 'benchmark/ips'

Benchmark.ips do |benchmark|
  dimension = Shoes::Dimension.new
  dimension.start  = 0
  dimension.extent = 10
  dimension.margin_start = 2

  benchmark.report 'margin_start' do
    dimension.margin_start
  end

  benchmark.report 'element_extent' do
    dimension.element_extent
  end
end
