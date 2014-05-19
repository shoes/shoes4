class Changelog
  def generate(categories = nil)
    categories ||= [
      { pattern: 'Changelog: feature', heading: 'New features'},
      { pattern: 'Changelog: improvement', heading: 'Improvements'},
      { pattern: 'Changelog: bugfix', heading: 'Bug Fixes'}
    ]

    last_sha = `git rev-list --tags --max-count=1`.chomp
    last_release = `git describe #{last_sha}`.chomp
    commit_range = "#{last_release}..master"
    categorized_commits = []

    changes = categories.inject([]) do |list, category|
      commits = commits_matching(category[:pattern], commit_range)
      categorized_commits.concat Array(commits)
      list << changes_under_heading(category[:heading], commits)
    end

    # TODO: Add anything marked 'Changelog' without a parameter
    all_change_commits = commits_matching('Changelog', commit_range)
    misc_change_commits = all_change_commits.reject {|commit| categorized_commits.include? commit }
    changes << changes_under_heading('Miscellaneous', misc_change_commits)


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

  def commits_matching(pattern, commit_range)
    grep_placeholder = '{TOKEN}'
    log_command_template = "git log --regexp-ignore-case --grep '#{grep_placeholder}' --format='* %s [%h]' #{commit_range}"
    log_command = log_command_template.gsub(grep_placeholder, pattern)

    commits =`#{log_command}`.split("\n").tap do
      raise "Bad \`git log\` command. Using <#{log_command}>" unless $?.success?
    end
  end

  def changes_under_heading(title, commits)
    if commits.any?
      heading = heading(title, commits.length)
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
