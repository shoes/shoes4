call jruby --1.9 -e "$LOAD_PATH.unshift File.expand_path('../lib', __FILE__); require 'shoes/cli'; Shoes::CLI.new.run('%3'.empty? ? ['%2', '%1', '%2'] : ['%3', '%1', '%2', '%3'])"
