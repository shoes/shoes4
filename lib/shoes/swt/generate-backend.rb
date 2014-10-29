require 'rbconfig'

def generate_backend(path)
  if RbConfig::CONFIG["host_os"] =~ /darwin/
    options = "-J-XstartOnFirstThread"
  end

  "jruby --1.9 #{options} #{path}/shoes-swt"
end
