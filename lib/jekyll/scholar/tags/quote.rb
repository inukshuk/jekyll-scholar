module Jekyll
  class Scholar

    class QuoteTag < Liquid::Block
      include Scholar::Utilities
      
      attr_reader :pages
    
      def initialize(tag_name, arguments, tokens)
        super
        
        @config = Scholar.defaults.dup
        @key, arguments = arguments.strip.split(/\s+/, 2)
      end

      def render(context)
        set_context_to context
        
        quote = super.strip.gsub(/\n\n/, '</p><p>').gsub(/\n/, '<br/>')
        quote = content_tag :p, quote
        
        citation = cite key
        
        quote << content_tag(:cite, citation)
        
        content_tag :blockquote, quote
      end
      
    end
    
  end
end

Liquid::Template.register_tag('quote', Jekyll::Scholar::QuoteTag)