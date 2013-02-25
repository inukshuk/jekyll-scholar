module Jekyll
  class Scholar

    class CiteTag < Liquid::Tag
      include Scholar::Utilities

      attr_reader :key, :pages

      def initialize(tag_name, arguments, tokens)
        super

        @config = Scholar.defaults.dup
        @key = arguments.strip.split(/\s+/)[0]
      end

      def render(context)
        set_context_to context

        context['cited'] ||= []
        context['cited'] << key

        cite key
      end

    end

  end
end

Liquid::Template.register_tag('cite', Jekyll::Scholar::CiteTag)