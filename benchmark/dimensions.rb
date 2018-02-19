# frozen_string_literal: true

require 'benchmark/ips'

# Mimics the old RenamedDelegate
class RenamedDimensions < Shoes::Dimensions
  extend Forwardable

  def self.renamed_delegate_to(getter, methods, renamings)
    methods.each do |method|
      method_name = method.to_s
      renamed_method_name = renamings.inject(method_name) do |name, (word, sub)|
        name.gsub word, sub
      end
      if renamed_method_name != method_name
        def_delegator getter, method_name, renamed_method_name
      end
    end
  end

  def self.setup_delegations
    methods_to_rename = Shoes::Dimension.public_instance_methods false
    renamed_delegate_to :x_dimension, methods_to_rename, 'start'  => 'left',
                                                         'end'    => 'right',
                                                         'extent' => 'width'
    renamed_delegate_to :y_dimension, methods_to_rename, 'start'  => 'top',
                                                         'end'    => 'bottom',
                                                         'extent' => 'height'
  end

  setup_delegations
end

Benchmark.ips do |benchmark|
  direct = Shoes::Dimensions.new(nil, 0, 0, 100, 100, margin: 10)
  delegating = RenamedDimensions.new(nil, 0, 0, 100, 100, margin: 10)

  benchmark.report 'direct' do
    direct.absolute_left
    direct.element_left
    direct.margin_left
  end

  benchmark.report 'delegating' do
    delegating.absolute_left
    delegating.element_left
    delegating.margin_left
  end

  benchmark.compare!
end
