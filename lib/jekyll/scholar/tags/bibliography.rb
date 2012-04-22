module Jekyll
  class Scholar

    class BibliographyTag < Liquid::Tag
  
      attr_reader :file, :config
    
      def initialize(tag_name, arguments, tokens)
        super
        
        @config = Scholar.defaults.dup
        @file = arguments.strip
      end

      def render(context)
        config.merge!(context.registers[:site].config['scholar'] || {})

        entries.map { |e|
          CiteProc.process e.to_citeproc, :style => config['style'],
            :locale => config['locale'], :format => 'html'
        }.join("\n")
      end
      
      private
      
      def bibliography
        @bibliography ||= BibTeX.open(extend_path(file), :filter => :latex)
      end          
      
      def entries
        b = bibliography['@*']

        unless config['sort_by'] == 'none'
          b.sort_by! { |e| e[config['sort_by']] }
          b.reverse! if config['order'] =~ /^(desc|reverse)/i
        end
        
        b
      end
      
      def extend_path(name)
        if name.nil? || name.empty?
          name = config['bibliography']
        end
        
        p = File.join(config['source'], name)
        p << '.bib' unless File.exists?(p)
        p
      end
    end
    
  end
end

Liquid::Template.register_tag('bibliography', Jekyll::Scholar::BibliographyTag)