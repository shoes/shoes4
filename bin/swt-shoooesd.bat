call jruby --1.9 --debug -e "$:<< 'lib'; require 'shoes'; require 'shoes/configuration'; Shoes.configuration.framework = 'swt_shoes'; require '%1' "
