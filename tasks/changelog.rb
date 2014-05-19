class Changelog
  def generate(categories = nil)
    categories ||= [
      { token: 'feature', heading: 'New features'},
      { token: 'improvement', heading: 'Improvements'},
      { token: 'bugfix', heading: 'Bug Fixes'}
    ]

    last_release = `git describe #{`git rev-list --tags --max-count=1`}`
    grep_placeholder = '{TOKEN}'
    log_command_template = "git log --grep '#{grep_placeholder}' --format='* %s [%h]' --since #{last_release}"

    changes = categories.inject('') do |list, category|
      grep_pattern = "[Cc]hangelog: #{category[:token]}"
      log_command = log_command_template.gsub(grep_placeholder, grep_pattern)
      commits =`#{log_command}`.split("\n")
      raise "Error scanning git log. Using <#{log_command}" unless $?.success?

      if commits.any?
        heading = heading(category[:heading], commits.length)
        list << heading << commits.join("\n")
      end

      list
    end

    if changes.length > 0
      contributors = `git shortlog --numbered --summary --since #{last_release}`.split("\n")
      changes << "\n\n" << heading("Contributors", contributors.length)
      changes << contributors.map {|line| line.sub(/^.*\t/, '')}.join(", ")
    end

    # TODO: Anything marked 'Changelog' without a parameter
    # changes << log_command.gsub(grep_placeholder, "[Cc]hangelog")

    changes
  end

  def heading(title, count, underline_char = '-')
    title_with_count = "#{title} (#{count})"
    underline = underline_char * title_with_count.length
    "#{title_with_count}\n#{underline}\n\n"
  end
end

desc "Generate changelog entries since last release"
task :changelog do
  puts Changelog.new.generate
end
