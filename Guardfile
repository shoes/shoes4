# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})            { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/shoes/mock/(.+)\.rb$}) { |m| "spec/shoes/#{m[1]}_spec.rb" }
  watch(%r{^lib/shoes/swt/(.+)\.rb$})  { |m| "spec/swt_shoes/#{m[1]}_spec.rb" }
  watch('lib/shoes/dsl.rb')            { |m| "spec/swt_shoes/dsl_spec.rb" }
end

