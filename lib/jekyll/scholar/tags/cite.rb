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
        config.merge!(context.registers[:site].config['scholar'] || {})

        entry = bibliography[key]

        if entry
          c = CiteProc.process entry.to_citeproc, :style => config['style'],
            :locale => config['locale'], :format => 'html', :mode => :citation
          
          "<a href='##{entry.key}'>#{c}</a>"
        else
          "(missing reference)"
        end
      end
      
    end
    
  end
end

Liquid::Template.register_tag('cite', Jekyll::Scholar::CiteTag)