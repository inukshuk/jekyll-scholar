module Jekyll
  class Scholar

    class ReferenceTag < Liquid::Tag
      include Scholar::Utilities

      def initialize(tag_name, arguments, tokens)
        super

        @config = Scholar.defaults.dup
        @key, arguments = arguments.strip.split(/\s+/, 2)

        optparse(arguments)
      end

      def render(context)
        set_context_to context
        reference_tag bibliography[key]
      rescue
        "(#{key})"
      end
    end

  end
end

Liquid::Template.register_tag('reference', Jekyll::Scholar::ReferenceTag)
