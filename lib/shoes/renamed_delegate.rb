module RenamedDelegate
  include Forwardable

  def renamed_delegate_to(getter, methods, renamings)
    words_to_substitute = renamings.keys
    methods.each do |method_name|
      sub = words_to_substitute.detect {|word| method_name.to_s.include? word}
      if sub
        renamed_method_name = method_name.to_s.gsub(sub, renamings[sub])
        def_delegator getter, method_name, renamed_method_name
      end
    end
  end
end