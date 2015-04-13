require 'benchmark/ips'

Shoes.app do
  button "Go" do
    Benchmark.ips do |benchmark|
      benchmark.report 'toggle paragraph' do
        @subject.toggle
      end
    end
  end

  @subject = para "I'm going to get hidden and shown a lot"
end
