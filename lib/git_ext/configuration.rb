module GitExt
  class Configuration
    attr_reader :repo
    def initialize(repo)
      @repo = Pathname.new(repo)
    end

    def pair_file
      repo + '.pairs'
    end

    def all_pairs
      @pair_list ||= config['pairs']
    end

    def email_prefix
      config['email']['prefix']
    end

    def email_domain
      config['email']['domain']
    end

    private

    def config
      @config ||= if pair_file.exist?
        YAML.load_file(pair_file)
      else
        {
          'pairs' => [],
          'email' => {
            'prefix' => 'pair',
            'domain' => 'example.com'
          }
        }
      end
    end
  end
end