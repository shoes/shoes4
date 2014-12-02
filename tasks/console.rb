desc 'Start a pry console with Shoes loaded'
task :console do
  require 'pry'
  require 'shoes'
  ARGV.clear
  Pry.start
end
