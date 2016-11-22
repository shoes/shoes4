require 'rbconfig'

def generate_backend(path)
  options = "-J-XstartOnFirstThread" if RbConfig::CONFIG["host_os"] =~ /darwin/

  "jruby #{options} #{path}/shoes-swt"
end
