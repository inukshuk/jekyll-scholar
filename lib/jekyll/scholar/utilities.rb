module Jekyll
  class Scholar

    # Utility methods used by several Scholar plugins. The methods in this
    # module may depend on the presence of #config, #bibtex_file, and
    # #site readers
    module Utilities

      attr_reader :bibtex_file, :config, :site, :query,
        :context, :prefix, :key, :text

      def optparse(arguments)
        return if arguments.nil? || arguments.empty?

        parser = OptionParser.new do |opts|
          opts.on('-c', '--cited') do |cited|
            @cited = true
          end

          opts.on('-f', '--file FILE') do |file|
            @bibtex_file = file
          end

          opts.on('-q', '--query QUERY') do |query|
            @query = query
          end

          opts.on('-p', '--prefix PREFIX') do |prefix|
            @prefix = prefix
          end

          opts.on('-t', '--text TEXT') do |text|
            @text = text
          end

          opts.on('-s', '--style STYLE') do |style|
            @style = style
          end 
        end

        argv = arguments.split(/(\B-[cfqpts]|\B--(?:cited|file|query|prefix|text|style|))/)

        parser.parse argv.map(&:strip).reject(&:empty?)
      end

      def bibtex_options
        config['bibtex_options'] ||= {}
      end

      def bibtex_filters
        config['bibtex_filters'] ||= []
      end

      def bibtex_path
        @bibtex_path ||= extend_path(bibtex_file)
      end

      def bibliography
        unless @bibliography
          @bibliography = BibTeX.open(bibtex_path, bibtex_options)
          @bibliography.replace_strings if replace_strings?
        end

        @bibliography
      end

      def entries
        b = bibliography[query || config['query']]

        unless config['sort_by'] == 'none'
          b = b.sort_by { |e| e[config['sort_by']].to_s }
          b.reverse! if config['order'] =~ /^(desc|reverse)/i
        end

        b
      end

      def replace_strings?
        config['replace_strings']
      end

      def cited_only?
        !!@cited
      end

      def extend_path(name)
        if name.nil? || name.empty?
          name = config['bibliography']
        end

        # return as is if it is an absolute path
        return name if name.start_with?('/') && File.exists?(name)

        p = File.join(config['source'], name)
        p << '.bib' unless File.exists?(p)
        p
      end

      def reference_tag(entry)
        return missing_reference unless entry

        entry = entry.convert(*bibtex_filters) unless bibtex_filters.empty?
        reference = CiteProc.process entry.to_citeproc,
          :style => style, :locale => config['locale'], :format => 'html'

        content_tag reference_tagname, reference,
          :id => [prefix, entry.key].compact.join('-')
      end

      def style
        @style || config['style']
      end

      def missing_reference
        config['missing_reference']
      end

      def reference_tagname
        config['reference_tagname'] || :span
      end

      def bibliography_template
        config['bibliography_template'] || '%{reference}'
      end

      def bibliography_tag(entry, index)
        return missing_reference unless entry

        bibliography_template % {
          :reference => reference_tag(entry),
          :key => entry.key,
          :type => entry.type,
          :index => index
        }
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
        File.join(base, details_path, details_file_for(entry))
      end

      def base_url
        @base_url ||= site.config['baseurl'] || site.config['base_url'] || ''
      end

      def details_path
        config['details_dir']
      end

      def cite(key)
        context['cited'] ||= []
        context['cited'] << key

        if bibliography.key?(key)
          entry = bibliography[key]
          entry = entry.convert(*bibtex_filters) unless bibtex_filters.empty?

          citation = CiteProc.process entry.to_citeproc, :style => style,
            :locale => config['locale'], :format => 'html', :mode => :citation

          link_to "##{[prefix, entry.key].compact.join('-')}", citation.join
        else
          missing_reference
        end
      rescue
        "(#{key})"
      end

      def cite_details(key, text)
        if bibliography.key?(key)
          link_to details_link_for(bibliography[key]), text || config['details_link']
        else
          missing_reference
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

      def cited_references
        context && context['cited'] || []
      end

      def set_context_to(context)
        @context, @site, = context, context.registers[:site]
        config.merge!(site.config['scholar'] || {})
      end
    end

  end
end
