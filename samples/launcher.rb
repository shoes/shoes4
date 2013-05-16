require 'yaml'

Shoes.app margin: 10, :title => "App Samples Status" do
  button "app flow 1"
  button "app flow 2"
  button "app flow 3"
  button "app flow 4"
 # button "app flow 5"
  #button "app flow 6"

  samples_dir = "samples"
  samples_all = Dir.entries("#{samples_dir}").sort
  samples=[]
  samples_all.each_index do |i|
    samples << {name: samples_all[i],desc: "", ok: false} if !(samples_all[i] =~ /\.rb$/).nil?
  end

  stack do
    samples.each do |s|
      stack do
          button(s[:name]) do
            load "#{samples_dir}/#{s[:name]}"
          end
     end
    end

  end
end
