module Shoes
  module Swt
    module Common
      module Resource
        def gcs_reset gc
          @gcs ||= []
          @gcs.each{|g| g.dispose if g}
          @gcs.clear
          @gcs << gc
        end
      end
    end
  end
end
