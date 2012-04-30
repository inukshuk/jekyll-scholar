module Jekyll
  class Scholar

    class Details < Page
      
      attr_reader :config
      
      def initialize(site, base, dir, entry)
        @site, @base, @dir = site, base, dir

        @config = Scholar.defaults.merge(site.config['scholar'] || {})

        @name = filename_for(entry)

        process(@name)
        read_yaml(File.join(base, '_layouts'), config['details_layout'])

				liquidify(entry)
      end

			private
			
			def filename_for(entry)
				n = entry.key.dup
				
				n.gsub!(/[:\s]+/, '_')
				
				[n, 'html'].join('.')
			end
			
			def liquidify(entry)
				data['entry'] = {}

				data['entry']['key'] = entry.key
				data['entry']['type'] = entry.type
				
				entry.fields.each do |key, value|
					data['entry'][key.to_s] = value.to_s
        end
			end
			
    end

    class DetailsGenerator < Generator
      safe true

      attr_reader :config
      
      def generate(site)
        @config = Scholar.defaults.merge(site.config['scholar'] || {})

        if site.layouts.key?(File.basename(config['details_layout'], '.html'))
          bibliography[config['query']].each do |entry|
            details = Details.new(site, site.source, config['details_dir'], entry)
            details.render(site.layouts, site.site_payload)
            details.write(site.dest)
            
            site.pages << details
          end
          
        end
      end
			
      private
      
      def bibliography
        @bibliography ||= BibTeX.open(bibliography_path, :filter => :latex)
      end          
      
      def bibliography_path
        p = File.join(config['source'], config['bibliography'])
        p << '.bib' unless File.exists?(p)
        p
      end      
    end


  end
end