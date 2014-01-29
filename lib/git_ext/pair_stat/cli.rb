module GitExt
  module PairStat
    class CLI
      def self.run(options={})
        new(options).report
      end

      attr_reader :initials

      def initialize(options={})
        @config = Configuration.new(options.fetch(:repo))
        @initials = options.fetch(:initials)
      end

      def commits
        @commits ||= `git log --format='%ci|%an' | grep "#{querant}"`.split("\n")
      end

      def commits_by_collaborators
        memo = Hash.new {|h, k| h[k] = [] }
        commits.each_with_object(memo) do |commit, h|
          date, committers = commit.split('|')
          committers = committers.split(/,? (?:and|&) |, /)
          committers = committers == [querant] ? ['Solo'] : committers
          committers.each do |committer|
            next if committer == querant
            h[committer] << date
          end
        end
      end

      def days_worked_with(collaborator)
        commits_by_collaborators[collaborator].group_by do |commit|
          commit.split.first
        end.count
      end

      def percentage_worked_with(collaborator)
        days_worked_with_each = {}
        commits_by_collaborators.keys.each do |collab|
          days_worked_with_each[collab] = days_worked_with(collab)
        end
        days_worked_with_each[collaborator] / days_worked_with_each.values.reduce(0, :+).to_f * 100
      end

      def report_on(collaborator)
        "%-15s\t\t\t%-4d\t\t%-7d\t%-d%%" % [
          collaborator,
          days_worked_with(collaborator),
          commits_by_collaborators[collaborator].count,
          percentage_worked_with(collaborator)
        ]
      end

      def report
        <<-REPORT.gsub(/^ {10}/, '')
          Pairing stats for #{querant}

          Developer\t\t\tDays\t\tCommits\t%
          ---------------\t\t\t----\t\t-------\t----
          #{commits_by_collaborators.keys.map {|collab| report_on(collab)}.sort.join("\n")}
        REPORT
      end

      def querant
        config.all_pairs[initials] || 'ANONYMOUS'
      end

      private

      attr_reader :config
    end
  end
end
