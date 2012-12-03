module Jekyll
  class Scholar

    class ReferenceTag < Liquid::Tag
      include Scholar::Utilities

      attr_reader :key, :file

      def initialize(tag_name, arguments, tokens)
        super

        @config = Scholar.defaults.dup
        @key, @file = arguments.strip.split(/\s*,\s*/, 2)
      end

      def render(context)
        set_context_to context
        bib = unless file.nil?
                BibTeX.open(file, { :filter => :latex })
              else
                set_context_to context
                bibliography
              end

        entry = bib[key]

        if bib.key?(key)
          CiteProc.process entry.to_citeproc,
                           :style => config['style'],
                           :locale => config['locale'],
                           :format => 'html'
        else
          "(missing reference)"
        end
      rescue
        "(#{key})"
      end
    end

  end
end

Liquid::Template.register_tag('reference', Jekyll::Scholar::ReferenceTag)
