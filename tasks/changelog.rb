class Changelog
  def generate(categories = nil)
    categories ||= [
      { token: 'feature', heading: 'New features'},
      { token: 'improvement', heading: 'Improvements'},
      { token: 'bugfix', heading: 'Bug Fixes'}
    ]

    last_sha = `git rev-list --tags --max-count=1`.chomp
    last_release = `git describe #{last_sha}`.chomp
    commit_range = "#{last_release}..master"

    changes = categories.inject([]) do |list, category|
      list << changes_for_category(category, commit_range)
    end

    # TODO: Add anything marked 'Changelog' without a parameter

    if changes.any?
      changes << contributors(commit_range)
    end

    changes.compact.join("\n\n")
  end

  def heading(title, count, underline_char = '-')
    title_with_count = "#{title} (#{count})"
    underline = underline_char * title_with_count.length
    "#{title_with_count}\n#{underline}\n\n"
  end

  def changes_for_category(category, commit_range)
    grep_placeholder = '{TOKEN}'
    log_command_template = "git log --grep '#{grep_placeholder}' --format='* %s [%h]' #{commit_range}"
    grep_pattern = "[Cc]hangelog: #{category[:token]}"
    log_command = log_command_template.gsub(grep_placeholder, grep_pattern)

    commits =`#{log_command}`.split("\n")
    raise "Bad \`git log\` command. Using <#{log_command}>" unless $?.success?

    if commits.any?
      heading = heading(category[:heading], commits.length)
      heading << commits.join("\n")
    end
  end

  def contributors(commit_range)
    contributors = `git shortlog --numbered --summary #{commit_range}`.split("\n")
    heading = heading("Contributors", contributors.length)
    names = contributors.map {|line| line.sub(/^.*\t/, '')}.join(", ")
    heading << names
  end
end

desc "Generate changelog entries since last release"
task :changelog do
  puts Changelog.new.generate
end
