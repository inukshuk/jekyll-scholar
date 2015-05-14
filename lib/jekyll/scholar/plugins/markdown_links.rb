# Contriubted by @mfenner
# See https://github.com/inukshuk/jekyll-scholar/issues/30

require 'uri'

module Jekyll
  class Scholar
    class Markdown < BibTeX::Filter
      def apply(value)
        value.to_s.gsub(URI.regexp(['http','https','ftp'])) { |c| "[#{$&}](#{$&})" }
      end
    end
  end
end
