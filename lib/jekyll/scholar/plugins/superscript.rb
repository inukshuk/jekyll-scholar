module Jekyll
  class Scholar
    class Superscript < BibTeX::Filter
      def apply(value)
        # Use of \g<1> pattern back-reference to allow for capturing nested {} groups
        value.to_s.gsub(/\\textsuperscript(\{((?:.|\g<1>)*)\})/) {
          "<sup>#{$2}</sup>"
        }
      end
    end
  end
end
