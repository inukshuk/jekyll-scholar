module Jekyll
  class Scholar
    require 'date'

    # Load styles into static memory.
    # They should be thread safe as long as they are
    # treated as being read-only.
    STYLES = Hash.new do |h, k|
      style = CSL::Style.load k
      style = style.independent_parent unless style.independent?
      h[k.to_s] = style
    end


    # Utility methods used by several Scholar plugins. The methods in this
    # module may depend on the presence of #config, #bibtex_files, and
    # #site readers
    module Utilities


      attr_reader :config, :site, :context, :prefix, :text, :offset, :max


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

          opts.on('-C', '--cited_in_order') do |cited|
            @cited, @skip_sort = true, true
          end

          opts.on('-A', '--suppress_author') do |cited|
            @suppress_author = true
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

          opts.on('-L', '--label LABEL') do |label|
            labels << label
          end

          opts.on('-o', '--offset OFFSET') do |offset|
            @offset = offset.to_i
          end

          opts.on('-m', '--max MAX') do |max|
            @max = max.to_i
          end

          opts.on('-s', '--style STYLE') do |style|
            @style = style
          end

          opts.on('-g', '--group_by GROUP') do |group_by|
            @group_by = group_by
          end

          opts.on('-G', '--group_order ORDER') do |group_order|
            self.group_order = group_order
          end

          opts.on('-O', '--type_order ORDER') do |type_order|
            @group_by = type_order
          end

          opts.on('-T', '--template TEMPLATE') do |template|
            @bibliography_template = template
          end
        end

        argv = arguments.split(/(\B-[cCfqptTsgGOlLomA]|\B--(?:cited(_in_order)?|file|query|prefix|text|style|group_(?:by|order)|type_order|template|locator|label|offset|max|suppress_author|))/)

        parser.parse argv.map(&:strip).reject(&:empty?)
      end

      def locators
        @locators ||= []
      end

      def labels
        @labels ||= []
      end

      def bibtex_files
        @bibtex_files ||= [config['bibliography']]
      end

      # :nodoc: backwards compatibility
      def bibtex_file
        bibtex_files[0]
      end

      def bibtex_options
        @bibtex_options ||=
          (config['bibtex_options'] || {}).symbolize_keys
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
          @bibliography = BibTeX::Bibliography.parse(
            bibtex_paths.reduce('') { |s, p| s << IO.read(p) },
            bibtex_options
          )
          @bibliography.replace_strings if replace_strings?
          @bibliography.join if join_strings? && replace_strings?
        end

        @bibliography
      end

      def query
        interpolate @query
      end

      def entries
        sort bibliography[query || config['query']].select { |x| x.instance_of? BibTeX::Entry}
      end

      def offset
        @offset ||= 0
      end

      def max
        @max.nil? ? -1 : @max + offset - 1
      end

      def limit_entries?
        !offset.nil? || !max.nil?
      end

      def sort(unsorted)
        return unsorted if skip_sort?

        sorted = unsorted.sort do |e1, e2|
          sort_keys
            .map.with_index do |key, idx|
              v1 = e1[key].nil? ? BibTeX::Value.new : e1[key]
              v2 = e2[key].nil? ? BibTeX::Value.new : e2[key]
              if (sort_order[idx] || sort_order.last) =~ /^(desc|reverse)/i
                v2 <=> v1
              else
                v1 <=> v2
              end
            end
            .find { |c| c != 0 } || 0
        end

        sorted
      end

      def sort_keys
        return @sort_keys unless @sort_keys.nil?

        @sort_keys = Array(config['sort_by'])
          .map { |key| key.to_s.split(/\s*,\s*/) }
          .flatten
          .map { |key| key == 'month' ? 'month_numeric' : key }
      end

      def sort_order
        return @sort_order unless @sort_order.nil?

        @sort_order = Array(config['order'])
          .map { |key| key.to_s.split(/\s*,\s*/) }
          .flatten
      end

      def group_by
        @group_by ||= config['group_by']
      end

      def group?
        group_by != 'none'
      end

      def group(ungrouped)
        def grouper(items, keys, order)
          groups = items.group_by do |item|
            group_value(keys.first, item)
          end

          if keys.count == 1
            groups
          else
            groups.merge(groups) do |key, items|
              grouper(items, keys.drop(1), order.drop(1))
            end
          end
        end

        grouper(ungrouped, group_keys, group_order)
      end

      def group_keys
        return @group_keys unless @group_keys.nil?

        @group_keys = Array(group_by)
          .map { |key| key.to_s.split(/\s*,\s*/) }
          .flatten
          .map { |key| key == 'month' ? 'month_numeric' : key }
      end

      def group_order
        self.group_order = config['group_order'] if @group_order.nil?
        @group_order
      end

      def group_order=(value)
        @group_order = Array(value)
          .map { |key| key.to_s.split(/\s*,\s*/) }
          .flatten
      end

      def group_compare(key,v1,v2)
        case key
        when 'type'
          o1 = type_order.find_index(v1)
          o2 = type_order.find_index(v2)
          if o1.nil? && o2.nil?
            0
          elsif o1.nil?
            1
          elsif o2.nil?
            -1
          else
            o1 <=> o2
          end
        else
          v1 <=> v2
        end
      end

      def group_value(key,item)
        case key
        when 'type'
          type_aliases[item.type.to_s] || item.type.to_s
        else
          value = item[key]
          if value.numeric?
            value.to_i
          elsif value.date?
            value.to_date
          else
            value.to_s
          end
        end
      end

      def group_tags
        return @group_tags unless @group_tags.nil?

        @group_tags = Array(config['bibliography_group_tag'])
          .map { |key| key.to_s.split(/\s*,\s*/) }
          .flatten
      end

      def group_name(key,value)
        case key
        when 'type'
          type_names[value] || value.to_s
        when 'month_numeric'
          month_names[value] || "(unknown)"
        else
          value.to_s
        end
      end

      def type_order
        @type_order ||= config['type_order']
      end

      def type_aliases
        @type_aliases ||= Scholar.defaults['type_aliases'].merge(config['type_aliases'])
      end

      def type_names
        @type_names ||= Scholar.defaults['type_names'].merge(config['type_names'])
      end

      def month_names
        return @month_names unless @month_names.nil?

        @month_names = config['month_names'].nil? ? Date::MONTHNAMES : config['month_names'].unshift(nil)
      end

      def suppress_author?
        !!@suppress_author
      end

      def raw_bibtex?
        config['use_raw_bibtex_entry']
      end

      def repository?
        !config['repository'].nil? && !config['repository'].empty?
      end

      def repository
        @repository ||= load_repository
      end

      def load_repository
        repo = Hash.new { |h,k| h[k] = {} }

        return repo unless repository?
        
        # ensure that the base directory format is literally 
        # the same as the entries that are in the directory
        base = Dir[site.source][0] 
        
        Dir[File.join(site.source, repository_path, '**/*')].each do |path|
          extname = File.extname(path)
          repo[File.basename(path, extname)][extname[1..-1]] = Pathname(path).relative_path_from(Pathname(base))
        end

        repo
      end

      def repository_path
        config['repository']
      end

      def replace_strings?
        config['replace_strings']
      end

      def join_strings?
        config['join_strings']
      end

      def cited_only?
        !!@cited
      end

      def skip_sort?
        @skip_sort || config['sort_by'] == 'none'
      end

      def extend_path(name)
        if name.nil? || name.empty?
          name = config['bibliography']
        end

        # Return as is if it is an absolute path
        # Improve by using Pathname from stdlib?
        return name if name.start_with?('/') && File.exists?(name)

        name = File.join scholar_source, name
        name << '.bib' if File.extname(name).empty? && !File.exists?(name)
        name
      end

      def scholar_source
        source = config['source']
        
        # Improve by using Pathname from stdlib?
        return source if source.start_with?('/') && File.exists?(source)

        File.join site.source, source
      end

      def relative
        config['relative']
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
        Liquid::Template.register_filter(Jekyll::Filters)

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
        
        tmp = liquid_template.render(
          reference_data(entry,index)
            .merge(site.site_payload)
            .merge({
              'index' => index,
              'details' => details_link_for(entry)
            }),
          {
            :registers => { :site => site },
            :filters => [Jekyll::Filters]
          }
        )
        # process the generated reference with Liquid, to get the same behaviour as 
        # when it is used on a page
        Liquid::Template.parse(tmp).render(
          site.site_payload, 
          {
            :registers => { :site => site },
            :filters => [Jekyll::Filters]
          }
        )
      end

      def reference_data(entry, index = nil)
        {
          'entry' => liquidify(entry),
          'reference' => reference_tag(entry, index),
          'key' => entry.key,
          'type' => entry.type.to_s,
          'link' => repository_link_for(entry),
          'links' => repository_links_for(entry)
        }
      end

      def liquidify(entry)
        e = {}

        e['key'] = entry.key
        e['type'] = entry.type.to_s

        if entry.field_names(config['bibtex_skip_fields']).empty?
          e['bibtex'] = entry.to_s
        else
          tmp = entry.dup

          config['bibtex_skip_fields'].each do |name|
            tmp.delete name if tmp.field?(name)
          end

          e['bibtex'] = tmp.to_s
        end

        if raw_bibtex?
          e['bibtex'] = "{%raw%}#{e['bibtex']}{%endraw%}"
        end

        entry.fields.each do |key, value|
          value = value.convert(*bibtex_filters) unless bibtex_filters.empty?
          e[key.to_s] = value.to_s

          if value.is_a?(BibTeX::Names)
            e["#{key}_array"] = arr = []
            value.each.with_index do |name, idx|
              parts = {}
              name.each_pair do |k, v|
                e["#{key}_#{idx}_#{k}"] = v.to_s
                parts[k.to_s] = v.to_s
              end
              arr << parts
            end
          end
        end

        e
      end

      def generate_details?
        site.layouts.key?(File.basename(config['details_layout'], '.html'))
      end

      def details_file_for(entry)
        name = entry.key.to_s.dup

        name.gsub!(/[:\s]+/, '_')

        if site.config['permalink'] == 'pretty'
          name << '/'
        else
          name << '.html'
        end
      end

      def repository_link_for(entry, base = base_url)
        links = repository[entry.key]
        url   = links['pdf'] || links['ps']

        return unless url

        File.join(base, url)
      end

      def repository_links_for(entry, base = base_url)
        Hash[repository[entry.key].map { |ext, url|
          [ext, File.join(base, url)]
        }]
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

      def renderer(force = false)
        return @renderer if @renderer && !force

        @renderer = CiteProc::Ruby::Renderer.new :format => 'html',
          :style => style, :locale => config['locale']
      end

      def render_citation(items)
        renderer.render items.zip(locators.zip(labels)).map { |entry, (locator, label)|
          cited_keys << entry.key
          cited_keys.uniq!

          item = citation_item_for entry, citation_number(entry.key)
          item.locator = locator
          item.label = label unless label.nil?

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
          c.data.suppress! 'author' if suppress_author?
        end
      end

      def cited_keys
        context['cited'] ||= []
      end

      def citation_number(key)
        (context['citation_numbers'] ||= {})[key] ||= cited_keys.length
      end

      def link_target_for(key)
        "#{relative}##{[prefix, key].compact.join('-')}"
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

        link_to link_target_for(keys[0]), render_citation(items)
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

      def keys
        # De-reference keys (in case they are variables)
        # We need to do this every time, to support for loops,
        # where the context can change for each invocation.
        Array(@keys).map do |key|
          context[key] || key
        end
      end

      def interpolate(string)
        return unless string

        string.gsub(/{{\s*([\w\.]+)\s*}}/) do |match|
          context[$1] || match
        end
      end

      def set_context_to(context)
        @context, @site, = context, context.registers[:site]
        config.merge!(site.config['scholar'] || {})
        self
      end
    end

  end
end
