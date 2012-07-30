module Jekyll
  class Scholar

    class CiteDetailsTag < Liquid::Tag
      include Scholar::Utilities
      
      attr_reader :key, :text
    
      def initialize(tag_name, arguments, tokens)
        super
        
        @config = Scholar.defaults.dup
        @key = arguments.strip.split(/\s+/,2)[0]
        @text = arguments.strip.split(/\s+/,2)[1]
      end

      def render(context)
        set_context_to context
        cite_details key, text
      end
      
    end
    
  end
end

Liquid::Template.register_tag('cite_details', Jekyll::Scholar::CiteDetailsTag)
