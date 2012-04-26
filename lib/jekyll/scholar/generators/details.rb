module Jekyll
  class Scholar

    class Details < Page
      
      attr_reader :config
      
      def initialize(site, base, dir, entry)
        @site, @base, @dir = site, base, dir
        
        @config = Scholar.defaults.merge(site.config['scholar'] || {})
        
        @name = [entry.key, 'html'].join('.')

        process(@name)
        read_yaml(File.join(base, '_layouts'), config['details_layout'])
        
        data['entry'] = entry
      end
    end

    class DetailsGenerator < Generator
      safe true

      attr_reader :config
      
      def generate(site)
        if site.config['scholar'] && site.layouts.key?(site.config['scholar']['details_layout'])
          
          @config = Scholar.defaults.merge(site.config['scholar'] || {})
          
          bibliography['@*'].each do |entry|
            details = Detauls.new(site, site.source, config['details_dir'], entry)
            details.render(site.layouts, site.site_payload)
            details.write(site.dest)
            
            site.pages << details
          end
          
        end
      end

      private
      
      def bibliography
        @bibliography ||= BibTeX.open(extend_path(file), :filter => :latex)
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