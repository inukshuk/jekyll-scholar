module Jekyll
  class Scholar

    # Load styles into static memory.
    # They should be thread safe as long as they are
    # treated as being read-only.
    STYLES = Hash.new do |h, k|
      h[k.to_s] = CSL::Style.load k
    end


    # Utility methods used by several Scholar plugins. The methods in this
    # module may depend on the presence of #config, #bibtex_files, and
    # #site readers
    module Utilities

      attr_reader :config, :site, :query,
        :context, :prefix, :keys, :text

      def split_arguments(arguments)

        tokens = arguments.strip.split(/\s+/)

        args = tokens.take_while { |a| !a.start_with?('-') }
        opts = (tokens - args).join(' ')

        [args, opts]
      end

      def optparse(arguments)
        return if arguments.nil? || arguments.empty?

        parser = OptionParser.new do |opts|
          opts.on('-c', '--cited') do |cited|
            @cited = true
          end

          opts.on('-f', '--file FILE') do |file|
            @bibtex_files ||= []
            @bibtex_files << file
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

          opts.on('-l', '--locator LOCATOR') do |locator|
            locators << locator
          end

          opts.on('-s', '--style STYLE') do |style|
            @style = style
          end

          opts.on('-T', '--template TEMPLATE') do |template|
            @bibliography_template = template
          end
        end

        argv = arguments.split(/(\B-[cfqptTsl]|\B--(?:cited|file|query|prefix|text|style|template|locator|))/)

        parser.parse argv.map(&:strip).reject(&:empty?)
      end

      def locators
        @locators ||= []
      end

      def bibtex_files
        @bibtex_files ||= [config['bibliography']]
      end

      # :nodoc: backwards compatibility
      def bibtex_file
        bibtex_files[0]
      end

      def bibtex_options
        config['bibtex_options'] ||= {}
      end

      def bibtex_filters
        config['bibtex_filters'] ||= []
      end

      def bibtex_paths
        @bibtex_paths ||= bibtex_files.map { |file|
          extend_path file
        }
      end

      # :nodoc: backwards compatibility
      def bibtex_path
        bibtex_paths[0]
      end

      def bibliography
        unless @bibliography
          @bibliography = BibTeX.parse(
            bibtex_paths.reduce('') { |s, p| s << IO.read(p) },
            bibtex_options
          )
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

      def repository?
        !config['repository'].nil? && !config['repository'].empty?
      end

      def repository
        @repository ||= load_repository
      end

      def load_repository
        return {} unless repository?

        Hash[Dir[File.join(repository_path, '**/*.{pdf,ps}')].map { |path|
          [File.basename(path).sub(/\.(pdf|ps)$/, ''), path]
        }]
      end

      def repository_path
        config['repository']
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

      def reference_tag(entry, index = nil)
        return missing_reference unless entry

        entry = entry.convert(*bibtex_filters) unless bibtex_filters.empty?
        reference = render_bibliography entry, index

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
        @bibliography_template || config['bibliography_template']
      end

      def liquid_template
        return @liquid_template if @liquid_template

        tmp = bibliography_template

        case
        when tmp.nil?, tmp.empty?
          tmp = '{{reference}}'
        when site.layouts.key?(tmp)
          tmp = site.layouts[tmp].content
        end

        @liquid_template = Liquid::Template.parse(tmp)
      end

      def bibliography_tag(entry, index)
        return missing_reference unless entry

        liquid_template.render({
          'entry' => liquidify(entry),
          'reference' => reference_tag(entry, index),
          'key' => entry.key,
          'type' => entry.type,
          'link' => repository_link_for(entry),
          'index' => index
        })
      end

      def liquidify(entry)
        e = {}

        e['key'] = entry.key
        e['type'] = entry.type

        if entry.field?(:abstract)
          tmp = entry.dup
          tmp.delete :abstract
          e['bibtex'] = tmp.to_s
        else
          e['bibtex'] = entry.to_s
        end

        entry.fields.each do |key, value|
          value = value.convert(*bibtex_filters) unless bibtex_filters.empty?
          e[key.to_s] = value.to_s
        end

        e
      end

      def generate_details?
        site.layouts.key?(File.basename(config['details_layout'], '.html'))
      end

      def details_file_for(entry)
        name = entry.key.to_s.dup

        name.gsub!(/[:\s]+/, '_')

        [name, 'html'].join('.')
      end

      def repository_link_for(entry, base = base_url)
        url = repository[entry.key]
        return unless url

        File.join(base, url)
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

      def renderer
        @renderer ||= CiteProc::Ruby::Renderer.new :format => 'html',
          :style => style, :locale => config['locale']
      end

      def render_citation(items)
        renderer.render items.zip(locators).map { |entry, locator|
          cited_keys << entry.key

          item = citation_item_for entry, citation_number
          item.locator = locator

          item
        }, STYLES[style].citation
      end

      def render_bibliography(entry, index = nil)
        renderer.render citation_item_for(entry, index),
          STYLES[style].bibliography
      end

      def citation_item_for(entry, citation_number = nil)
        CiteProc::CitationItem.new id: entry.id do |c|
          c.data = CiteProc::Item.new entry.to_citeproc
          c.data[:'citation-number'] = citation_number
        end
      end

      def cited_keys
        context['cited'] ||= []
      end

      def citation_number
        number = context['citation_number'] || 1
        context['citation_number'] = number.succ
        number
      end

      def cite(keys)
        items = keys.map do |key|
          if bibliography.key?(key)
            entry = bibliography[key]
            entry = entry.convert(*bibtex_filters) unless bibtex_filters.empty?
          else
            return missing_reference
          end
        end

        link_to "##{[prefix, keys[0]].compact.join('-')}", render_citation(items)
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
