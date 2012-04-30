module Jekyll
  class Scholar
    
    # Utility methods used by several Scholar plugins. The methods in this
    # module may depend on the presence of #config, #bibtex_file, and
    # #site readers
    module Utilities
      
      attr_reader :bibtex_file, :config, :site
      
      def bibtex_options
        @bibtex_options ||= { :filter => :latex }
      end
      
      def bibtex_path
        @bibtex_path ||= extend_path(bibtex_file)
      end
      
      def bibliography
        @bibliography ||= BibTeX.open(bibtex_path, bibtex_options)
      end          
      
      def entries
        b = bibliography[config['query']]

        unless config['sort_by'] == 'none'
          b.sort_by! { |e| e[config['sort_by']].to_s }
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
      
      def generate_details?
        site.layouts.key?(File.basename(config['details_layout'], '.html'))
      end
      
      def details_file_for(entry)
        name = entry.key.to_s.dup
        
        name.gsub!(/[:\s]+/, '_')
        
        [name, 'html'].join('.')
      end
      
      def details_link_for(entry)
        [site.source, details_path, details_file_for(entry)].join('/')
      end
      
      def details_path
        config['details_dir']
      end
      
    end
    
  end
end