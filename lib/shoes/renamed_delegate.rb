module RenamedDelegate
  def renamed_delegate_to(getter, methods, renamings)
    words_to_substitute = renamings.keys
    methods.each do |method_name|
      sub = words_to_substitute.detect {|word| method_name.to_s.include? word}
      if sub
        renamed_method_name = method_name.to_s.gsub(sub, renamings[sub])
        define_method renamed_method_name do |*args|
          send(getter).public_send(method_name, *args)
        end
      end
    end
  end
end