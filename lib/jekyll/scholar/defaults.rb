module Jekyll
  class Scholar
    @defaults = {
      'style'                 => 'apa',
      'locale'                => 'en',

      'sort_by'               => 'none',
      'order'                 => 'ascending',
      'bibliography_list_tag' => 'ol',
      'bibliography_item_tag' => 'li',

      'source'                => './_bibliography',
      'bibliography'          => 'references.bib',
      'repository'            => nil,

      'bibtex_options'        => { :strip => false, :parse_months => true },
      'bibtex_filters'        => [ :latex ],

      'replace_strings'       => true,
      'join_strings'          => true,

      'details_dir'           => 'bibliography',
      'details_layout'        => 'bibtex.html',
      'details_link'          => 'Details',

      'bibliography_class'    => 'bibliography',
      'bibliography_template' => '{{reference}}',

      'reference_tagname'     => 'span',
      'missing_reference'     => '(missing reference)',

      'details_link_class'    => 'details',

      'query'                 => '@*'

    }.freeze

    class << self
      attr_reader :defaults
    end
  end
end
