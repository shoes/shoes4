class Changelog
  CATEGORY_MAPPING = [
    {pattern: 'Changelog: feature', heading: 'New features'},
    {pattern: 'Changelog: improvement', heading: 'Improvements'},
    {pattern: 'Changelog: bugfix', heading: 'Bug Fixes'},
    {pattern: 'Changelog: breaking', heading: 'Breaking Changes'}
  ]

  COMMIT_SEPARATOR     = '<--COMMIT-->'
  BODY_START_SEPARATOR = '<--BODY-START-->'
  BODY_END_SEPARATOR   = '<--BODY-END-->'

  def generate(categories = CATEGORY_MAPPING)
    commit_range = commits_on_master_since_last_release
    changes = changelog_header(commit_range)
    changes << categorize_commits(categories, commit_range)
    changes << contributors(commit_range) if changes.any?
    changes.flatten.compact.join("\n\n").gsub("\r",'')
  end

  private

  def changelog_header(commit_range)
    heading = "SINCE #{last_release} (#{commit_count(commit_range)} commits)\n"
    heading += "-" * (heading.length - 1)

    [heading]
  end

  def categorize_commits(categories, commit_range)
    categorized_commits = []

    changes = categories.inject([]) do |list, category|
      commits = commits_matching(category[:pattern], commit_range)
      categorized_commits.concat commits
      list << changes_under_heading(category[:heading], commits)
    end

    changes << misc_changes(commit_range, categorized_commits)
    changes
  end

  def heading(title, count, underline_char = '-')
    title_with_count = "#{title} (#{count})"
    underline = underline_char * title_with_count.length
    "#{title_with_count}\n#{underline}\n\n"
  end

  def commits_matching(pattern, commit_range)
    grep_placeholder = '{TOKEN}'
    log_command_template = "git log --regexp-ignore-case --grep '#{grep_placeholder}' --format='%s#{BODY_START_SEPARATOR}%b#{BODY_END_SEPARATOR} [%h]#{COMMIT_SEPARATOR}' #{commit_range}"
    log_command = log_command_template.gsub(grep_placeholder, pattern)

    commits =`#{log_command}`
    raise "Bad \`git log\` command. Using <#{log_command}>" unless $?.success?

    commits.split(COMMIT_SEPARATOR + "\n").map{|commit| uniform_change_log(commit)}
  end

  def uniform_change_log(commit)
    '* ' + extract_changelog_message(commit)
  end

  def extract_changelog_message commit
    if commit =~ /Merge pull request/i
      message = commit.sub(/Merge pull request.*#{BODY_START_SEPARATOR}/i, '')
      message.sub(/((\n.*#{BODY_END_SEPARATOR})|#{BODY_END_SEPARATOR})/m, '')
    else
      commit.sub(/#{BODY_START_SEPARATOR}.*#{BODY_END_SEPARATOR}/m, '')
    end
  end

  def misc_changes(commit_range, categorized_commits)
    misc_change_commits = commits_matching('Changelog', commit_range).reject {|commit| categorized_commits.include? commit }
    changes_under_heading('Miscellaneous', misc_change_commits)
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

  def commits_on_master_since_last_release
    "#{last_release}..master"
  end

  def commit_count(commit_range)
    `git log --no-merges --format=oneline #{commit_range} | wc -l`.chomp.strip
  end

  def last_release
    last_sha = `git rev-list --tags --max-count=1`.chomp
    `git describe #{last_sha}`.chomp
  end
end

desc "Generate changelog entries since last release"
task :changelog do
  puts Changelog.new.generate
end
