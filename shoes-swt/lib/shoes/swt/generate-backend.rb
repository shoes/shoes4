require 'rbconfig'

def generate_backend(path)
  if RbConfig::CONFIG["host_os"] =~ /darwin/
    options = "-J-XstartOnFirstThread"
  end

  "jruby #{options} #{path}/shoes-swt"
end
