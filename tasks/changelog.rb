class Changelog
  def generate(categories = nil)
    categories ||= [
      { token: 'feature', heading: 'New features'},
      { token: 'improvement', heading: 'Improvements'},
      { token: 'bugfix', heading: 'Bug Fixes'}
    ]

    last_release = `git describe #{`git rev-list --tags --max-count=1`}`
    grep_placeholder = '{TOKEN}'
    log_command_template = "git log --grep '#{grep_placeholder}' --format='* %s (%an) [%h]' --since #{last_release}"

    changes = categories.inject('') do |list, category|
      grep_pattern = "[Cc]hangelog: #{category[:token]}"
      log_command = log_command_template.gsub(grep_placeholder, grep_pattern)
      heading = heading(category[:heading])
      commits =`#{log_command}`
      raise "Error scanning git log. Using <#{log_command}" unless $?.success?

      if commits.strip != ''
        list << heading << commits
      end

      list
    end

    # TODO: Anything marked 'Changelog' without a parameter
    # changes << log_command.gsub(grep_placeholder, "[Cc]hangelog")

    changes
  end

  def heading(title, underline_char = '-')
    underline = underline_char * title.length
    "#{title}\n#{underline}\n\n"
  end
end

desc "Generate changelog entries since last release"
task :changelog do
  puts Changelog.new.generate
end
