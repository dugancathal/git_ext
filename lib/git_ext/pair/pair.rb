module GitExt
  module Pair
    class Pair < Struct.new(:initials, :name)
      def first_name
        name.split.first
      end
    end
  end
end