module Jekyll
  class Scholar

    class NoCiteTag < Liquid::Tag
      include Scholar::Utilities

      attr_reader :pages

      def initialize(tag_name, arguments, tokens)
        super

        @config = Scholar.defaults.dup
        @keys, arguments = split_arguments(arguments)

        optparse(arguments)
      end

      def render(context)
        set_context_to context
        nocite keys
      end

    end

  end
end

Liquid::Template.register_tag('nocite', Jekyll::Scholar::NoCiteTag)
