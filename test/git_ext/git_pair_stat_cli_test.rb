require_relative '../test_helper'
require 'tmpdir'

class GitPairStatCliTest < MiniTest::Test
  def test_commits_for_cosette
    in_git_repo do |repo|
      create_git_history
      commits = GitExt::PairStat::CLI.new(repo: repo, initials: 'co').commits
      assert_equal 3, commits.count
    end
  end

  def test_commits_for_non_author
    in_git_repo do |repo|
      create_git_history
      commits = GitExt::PairStat::CLI.new(repo: repo, initials: 'ga').commits
      assert_equal 0, commits.count
    end
  end

  def test_collaborators_for_cosette
    in_git_repo do |repo|
      create_git_history
      commits = GitExt::PairStat::CLI.new(repo: repo, initials: 'co').commits_by_collaborators
      assert_equal 1, commits.count
      assert_equal 3, commits['Marius'].count
    end
  end

  def test_days_worked_with
    in_git_repo do |repo|
      create_git_history
      days = GitExt::PairStat::CLI.new(repo: repo, initials: 'co').days_worked_with('Marius')
      assert_equal 1, days
    end
  end

  def test_percentage_worked_with
    in_git_repo do |repo|
      create_git_history
      percent = GitExt::PairStat::CLI.new(repo: repo, initials: 'ma').percentage_worked_with('Cosette')
      assert_equal 50.0, percent
    end
  end

  def test_report_for
    in_git_repo do |repo|
      create_git_history
      report = GitExt::PairStat::CLI.new(repo: repo, initials: 'ma').report_on('Cosette')
      assert_equal 'Cosette              1        3        50%', report
    end
  end

  def test_solo_report
    in_git_repo do |repo|
      create_git_history
      configure_pair('Marius')
      File.write('README', "Han solo-ing")
      add_and_commit_at('README', '2013-12-12 22:55:32 -0700')
      sleep 0.1
      commits = GitExt::PairStat::CLI.new(repo: repo, initials: 'ma').commits_by_collaborators
      assert_equal 1, commits['Solo'].count
    end
  end
end