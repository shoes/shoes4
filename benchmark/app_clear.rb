require 'benchmark'

Shoes.app do
  background green

  button 'start repeated app clear benchmark' do
    Benchmark.bm do |benchmark|
      benchmark.report do
        200.times do
          clear do
            background green
            rect 200, 300, 50, 60
            rect 100, 200, 100, 200
            oval left: 22, top: 40, radius: 50
            oval left: 350, top: 250, radius: 100
          end
        end
      end
    end
  end
end