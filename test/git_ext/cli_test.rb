require_relative '../test_helper'
require 'tmpdir'

class CLITest < Minitest::Test
  def setup
    ENV['PATH'] = "#{File.expand_path('../../../bin', __FILE__)}:#{ENV['PATH']}"
  end

  def test_git_pair
    in_git_repo do
      system 'git pair co'

      name = `git config user.name`.chomp
      email = `git config user.email`.chomp

      assert_equal 'Cosette', name
      assert_equal 'pair+cosette@lesmis.com', email
    end
  end

  def test_git_about
    in_git_repo do
      system 'git config user.name "Jean Valjean"'
      system 'git config user.email "jean@valjean.com"'

      assert_equal <<-ABOUT.gsub(/^ {8}/, ''), `git about`
        git user:  Jean Valjean
        git email: jean@valjean.com
      ABOUT
    end
  end

  def test_git_pair_stats
    in_git_repo do
      create_git_history

      assert_equal <<-STAT.gsub(/^ {8}/, ''), `git pair-stat ma`
        Pairing stats for Marius

        Developer            Days     Commits  %
        ---------------      ----     -------  ----
        Cosette              1        3        50%
        Jean Valjean         1        1        50%
      STAT
    end
  end
end