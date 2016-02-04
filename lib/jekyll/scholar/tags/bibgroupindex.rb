module Jekyll
  class Scholar

    class BibliographyGroupIndexTag < Liquid::Tag
      include Scholar::Utilities

      def initialize(tag_name, arguments, tokens)
        super

        @config = Scholar.defaults.dup

        optparse(arguments)
      end

      def render(context)
        set_context_to context

        # Add bibtex files to dependency tree
        if context.registers[:page] and context.registers[:page].has_key? "path"
          bibtex_paths.each do |bibtex_path|
            site.regenerator.add_dependency(
              site.in_source_dir(context.registers[:page]["path"]),
              bibtex_path
            )
          end
        end

        items = entries

        if cited_only?
          items = if skip_sort?
            cited_references.uniq.map do |key|
              items.detect { |e| e.key == key }
            end
          else
            entries.select do |e|
              cited_references.include? e.key
            end
          end

          # See #90
          cited_keys.clear
        end

        if group?
          groups = group(items)
          bibliography = render_groups(groups)
        end
      end

      def render_groups(groups)
        def group_renderer(groupsOrItems,keys,order,tags)
          if keys.count == 0
            renderer(force = true)
            render_items(groupsOrItems)
          else
            groupsOrItems
              .sort do |e1,e2|
                if (order.first || group_order.last) =~ /^(desc|reverse)/i
                  group_compare(keys.first,e2[0],e1[0])
                else
                  group_compare(keys.first,e1[0],e2[0])
                end
              end
              .map do |e|
                title = group_name(keys.first, e[0])
                anchor = '#' + title.delete(' ')
                group = content_tag(config['bibgroupindex_item_tag'],
                                    link_to(anchor, title))
                group + "\n"
              end
              .join("\n")
          end
        end
        content_tag config['bibgroupindex_list_tag'], group_renderer(groups,group_keys,group_order,group_tags), :class => config['bibliography_group_index_class']
      end

    end

  end
end

Liquid::Template.register_tag('bibgroupindex', Jekyll::Scholar::BibliographyGroupIndexTag)
