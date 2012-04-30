module Jekyll
  class Scholar

    class CiteTag < Liquid::Tag
      include Scholar::Utilities
      
      attr_reader :key, :pages, :config
    
      def initialize(tag_name, arguments, tokens)
        super
        
        @config = Scholar.defaults.dup
        @key = arguments.strip.split(/\s+/)[0]
      end

      def render(context)
        set_context_to context
                
        entry = bibliography[key]

        if entry
          citation = CiteProc.process entry.to_citeproc, :style => config['style'],
            :locale => config['locale'], :format => 'html', :mode => :citation
          
          link_to "##{entry.key}", citation
        else
          "(missing reference)"
        end
      end
      
    end
    
  end
end

Liquid::Template.register_tag('cite', Jekyll::Scholar::CiteTag)