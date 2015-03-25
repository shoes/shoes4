require 'benchmark'

Benchmark.bm do |benchmark|
  dimension = Shoes::Dimension.new
  dimension.start  = 0
  dimension.extent = 10
  dimension.margin_start = 2

  benchmark.report '1_000_000x margin_start' do
    1_000_000.times do
      dimension.margin_start
    end
  end

  benchmark.report '1_000_000x element_extent' do
    1_000_000.times do
      dimension.element_extent
    end
  end
end

