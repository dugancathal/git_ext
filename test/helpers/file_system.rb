module FileSystemHelpers
  def in_git_repo
    Dir.mktmpdir('git') do |repo|
      Dir.chdir(repo) do
        File.write(repo + '/.pairs', config)
        `git init`
        yield repo
      end
    end
  end

  def config
    <<-YAML.gsub(/ {6}/, '')
      pairs:
        co: Cosette
        ma: Marius
        jv: Jean Valjean
        ep: Eponine
        ja: Javert
        mt: Madame Thenardier
      email:
        prefix: pair
        domain: lesmis.com
    YAML
  end

  def configure_pair(*names)
    email = "pair+#{names.map {|name| name.downcase.split.first }.join('+')}@example.com"
    `git config user.name "#{names.join(' and ')}"`
    `git config user.email "#{email}"`
  end

  def add_and_commit_at(filename, date=Time.now)
    `git add #{filename}`
    `env GIT_COMMITTER_DATE="#{date}" git commit -m "#{filename}"`
  end

  def create_git_history
    configure_pair('Cosette and Marius')

    File.write('README', 'My awesome project')
    add_and_commit_at('README', '2013-12-12 22:49:29 -0700')

    File.write('README', 'My awesome project got better')
    add_and_commit_at('README', '2013-12-12 22:49:50 -0700')

    File.write('README', 'My awesome project is now deceased')
    add_and_commit_at('README', '2013-12-12 22:50:13 -0700')

    configure_pair('Jean Valjean and Marius')
    File.write('README', "We're bringin' back the party")
    add_and_commit_at('README', '2013-12-12 22:50:47 -0700')
    sleep 0.01
  end
end

class Minitest::Test
  include FileSystemHelpers
end