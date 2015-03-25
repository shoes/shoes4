require 'benchmark'

Shoes.app do
  button "Go" do
    Benchmark.bm do |benchmark|
      benchmark.report '100' do
        100.times do
          @subject.toggle
        end
      end

      benchmark.report '1000' do
        1000.times do
          @subject.toggle
        end
      end

      benchmark.report '10000' do
        10000.times do
          @subject.toggle
        end
      end
    end
  end

  @subject = para "I'm going to get hidden and shown a lot"
end
