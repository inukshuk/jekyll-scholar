module Jekyll
  class Scholar
    class Tiny < BibTeX::Filter
      def apply(value)
        # Use of \g<1> pattern back-reference to allow for capturing nested {} groups.
        # The first (outermost) capture of $1 is used.
        value.to_s.gsub(/\\tiny(\{(?:[^{}]|\g<1>)*\})/) {
          "<p style=\"font-size:10px\">#{$1[1..-2]}</p>"
        }
      end
    end
  end
end
