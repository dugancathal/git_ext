require 'pathname'
require 'yaml'

module GitExt
  module Pair
    class CLI
      def self.run(options={})
        runner = self.new(options)
        runner.set_user_options!
      end

      attr_reader :initials

      def initialize(options={})
        @config = Configuration.new(options.fetch(:repo))
        @initials = options.fetch(:initials, [])
      end

      def pairs
        initials.map { |pair| Pair.new pair, config.all_pairs[pair] }
      end

      def pair_names
        pairs.map(&:name).join(' and ')
      end

      def pair_email
        downcased_pair_names = pairs.map { |pair| pair.first_name.downcase }
        pair_list = [config.email_prefix, *downcased_pair_names].join('+')
        [pair_list, config.email_domain].join('@')
      end

      def set_user_options!
        `git config user.name "#{pair_names}"`
        `git config user.email "#{pair_email}"`
      end

      private

      attr_reader :config
    end
  end
end