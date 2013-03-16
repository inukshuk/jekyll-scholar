module Jekyll
  class Scholar

    class CiteTag < Liquid::Tag
      include Scholar::Utilities

      attr_reader :pages

      def initialize(tag_name, arguments, tokens)
        super

        @config = Scholar.defaults.dup
        @key, arguments = arguments.strip.split(/\s+/, 2)

        optparse(arguments)
      end

      def render(context)
        set_context_to context
        cite key
      end

    end

  end
end

Liquid::Template.register_tag('cite', Jekyll::Scholar::CiteTag)