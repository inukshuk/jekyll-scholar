module Jekyll
  class Scholar

    class CiteTag < Liquid::Tag
  
      attr_reader :key, :pages, :config
    
      def initialize(tag_name, arguments, tokens)
        super
        
        @config = Scholar.defaults.dup
        @key = arguments.strip.split(/\s+/)[0]
      end

      def render(context)
        config.merge!(context.registers[:site].config['scholar'] || {})

        puts key
        e = bibliography[key]
        puts e
        if e
          CiteProc.process e.to_citeproc, :style => config['style'],
            :locale => config['locale'], :format => 'html', :mode => :citation
        else
          "(missing reference)"
        end
      end
      
      private
      
      def bibliography
        @bibliography ||= BibTeX.open(extend_path(config['bibliography']), :filter => :latex)
      end          
      
      def extend_path(name)
        p = File.join(config['source'], name)
        p << '.bib' unless File.exists?(p)
        p
      end
    end
    
  end
end

Liquid::Template.register_tag('cite', Jekyll::Scholar::CiteTag)