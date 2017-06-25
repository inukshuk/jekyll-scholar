module Jekyll
  class Scholar

    class BibliographyTag < Liquid::Tag
      include Scholar::Utilities

      def initialize(tag_name, arguments, tokens)
        super

        @config = Scholar.defaults.dup

        optparse(arguments)
      end

      def render(context)
        set_context_to context

        # Add bibtex files to dependency tree
        if context.registers[:page] and context.registers[:page].key? "path"
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
        else
          items = items[offset..max] if limit_entries?
          bibliography = render_items(items)
        end

        bibliography
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
                bibhead = content_tag(tags.first || group_tags.last,
                                      group_name(keys.first, e[0]),
                                      :class => config['bibliography_class'])
                bibentries = group_renderer(e[1], keys.drop(1), order.drop(1), tags.drop(1))
                bibhead + "\n" + bibentries
              end
              .join("\n")
          end
        end
        group_renderer(groups,group_keys,group_order,group_tags)
      end

      def render_items(items)
        bibliography = items.each_with_index.map { |entry, index|
          reference = bibliography_tag(entry, index + 1)

          if generate_details?
            reference << link_to(details_link_for(entry),
              config['details_link'], :class => config['details_link_class'])
          end

          content_tag config['bibliography_item_tag'], reference, config['bibliography_item_attributes']
        }.join("\n")

        content_tag config['bibliography_list_tag'], bibliography,
          { :class => config['bibliography_class'] }.merge(config['bibliography_list_attributes'])

      end

    end

  end
end

Liquid::Template.register_tag('bibliography', Jekyll::Scholar::BibliographyTag)
