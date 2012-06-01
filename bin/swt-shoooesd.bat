call jruby --1.9 --debug -e "$:<< 'lib'; require 'shoes'; require 'shoes/configuration'; Shoes.configuration.framework = 'shoes/swt'; Shoes.configuration.backend = :swt; require '%1' "
