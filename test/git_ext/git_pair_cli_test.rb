require_relative '../test_helper'
require 'tmpdir'

class GitPairCliTest < MiniTest::Test
  def test_get_pair_for_initials
    in_git_repo do |repo|
      pairs = GitExt::Pair::CLI.new(repo: repo, initials: %w(co)).pairs
      assert_equal 1, pairs.count
      assert_equal 'Cosette', pairs.first.name
    end
  end

  def test_pair_names
    in_git_repo do |repo|
      pair_names = GitExt::Pair::CLI.new(repo: repo, initials: %w(co ma)).pair_names
      assert_equal 'Cosette and Marius', pair_names
    end
  end

  def test_generate_email
    in_git_repo do |repo|
      email = GitExt::Pair::CLI.new(repo: repo, initials: %w(co)).pair_email
      assert_equal 'pair+cosette@lesmis.com', email
    end
  end

  def test_set_user_options
    in_git_repo do |repo|
      GitExt::Pair::CLI.new(repo: repo, initials: %w(co)).set_user_options!
      assert_equal 'Cosette', `git config user.name`.chomp
      assert_equal 'pair+cosette@lesmis.com', `git config user.email`.chomp
    end
  end
end