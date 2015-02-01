# This is a helper to let `rspec test-file` run directly from the root dir by
# pulling in the right spec helpers from the subdirectories

dirs = ARGV.map do |path|
  path.gsub(/^\.\//, '')
end

dirs.select! do |path|
  path.match /^shoes-.*\//
end

dirs.map! do |path|
  File.expand_path(path.split("/").first)
end

dirs.uniq!
dirs.each do |dir|
  require File.join(dir, "spec", "spec_helper")
end
