module RenamedDelegate
  include Forwardable

  def renamed_delegate_to(getter, methods, renamings)
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
end
