require 'benchmark'

LOREM_IPSUM = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur. Donec ut libero sed arcu vehicula ultricies a non tortor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean ut gravida lorem. Ut turpis felis, pulvinar a semper sed, adipiscing id dolor. Pellentesque auctor nisi id magna consequat sagittis. Curabitur dapibus enim sit amet elit pharetra tincidunt feugiat nisl imperdiet. Ut convallis libero in urna ultrices accumsan. Donec sed odio eros. Donec viverra mi quis quam pulvinar at malesuada arcu rhoncus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In rutrum accumsan ultricies. Mauris vitae nisi at sem facilisis semper ac in est"

Shoes.app do

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
          para LOREM_IPSUM
        end
        flow do
          para LOREM_IPSUM
        end
      end
    end
    flush_gui
  end

  def create_paras(count)
    count.times do para LOREM_IPSUM end
    flush_gui
  end

  def flush_gui
    gui.flush if respond_to? :gui
  end

  button 'benchmark paras' do
    benchmark_paras
  end

  button 'benchmark paras with some stacks and flows' do
    benchmark_paras_stacks_flows
  end
end