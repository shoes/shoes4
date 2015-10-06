namespace :guard do
  [:core, :swt, :package].each do |gem|
    desc "Run Guard for shoes-#{gem}"
    task gem do
      run_guard_in("shoes-#{gem}")
    end
  end
end

def run_guard_in(directory)
  if RbConfig::CONFIG["host_os"] =~ /darwin/
    jruby_opts = "-J-XstartOnFirstThread"
  end

  sh "cd #{directory} && JRUBY_OPTS=#{jruby_opts} bundle exec guard -i"
end
