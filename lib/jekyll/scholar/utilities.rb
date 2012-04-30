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
      
      def details_link_for(entry, base = base_url)
        [base, details_path, details_file_for(entry)].join('/')
      end
      
      def base_url
        @base_url ||= site.config['baseurl'] || nil
      end
      
      def details_path
        config['details_dir']
      end
      
      def cite(key)
        entry = bibliography[key]

        if bibliography.key?(key)
          citation = CiteProc.process entry.to_citeproc, :style => config['style'],
            :locale => config['locale'], :format => 'html', :mode => :citation
          
          link_to "##{entry.key}", citation.join
        else
          "(missing reference)"
        end
      end
      
      def content_tag(name, content_or_attributes, attributes = {})
        if content_or_attributes.is_a?(Hash)
          content, attributes = nil, content_or_attributes
        else
          content = content_or_attributes
        end
        
        attributes = attributes.map { |k,v| %Q(#{k}="#{v}") }
        
        if content.nil?
          "<#{[name, attributes].flatten.compact.join(' ')}/>"
        else
          "<#{[name, attributes].flatten.compact.join(' ')}>#{content}</#{name}>"
        end
      end
      
      def link_to(href, content, attributes = {})
        content_tag :a, content || href, attributes.merge(:href => href)
      end
      
      def set_context_to(context)
        @site = context.registers[:site]
        config.merge!(site.config['scholar'] || {})
      end
      
    end
    
  end
end