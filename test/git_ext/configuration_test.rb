require_relative '../test_helper'
require 'tmpdir'

class ConfigurationTest < MiniTest::Test
  def test_can_find_pair_file_from_root
    in_git_repo do |repo|
      file = GitExt::Configuration.new(repo).pair_file
      assert_equal repo + "/.pairs", file.to_s
    end
  end

  def test_get_pairs_from_file
    in_git_repo do |repo|
      pairs = GitExt::Configuration.new(repo).all_pairs
      assert_equal(
        {
          "co" => "Cosette",
          "ma" => "Marius",
          "jv" => "Jean Valjean",
          "ep" => "Eponine",
          "ja" => "Javert",
          "mt" => "Madame Thenardier"
        },
        pairs
      )
    end
  end

  def test_default_email_prefix
    assert_equal 'pair', GitExt::Configuration.new('/tmp').email_prefix
  end

  def test_configured_email_prefix
    in_git_repo do |repo|
      assert_equal 'pair', GitExt::Configuration.new(repo).email_prefix
    end
  end

  def test_email_domain
    assert_equal 'example.com', GitExt::Configuration.new('/tmp').email_domain
  end

  def test_email_domain
    in_git_repo do |repo|
      assert_equal 'lesmis.com', GitExt::Configuration.new(repo).email_domain
    end
  end
end