module Jekyll
  class Scholar
    @defaults = {
      'style'                  => 'apa',
      'locale'                 => 'en',

      'sort_by'                => 'none',
      'order'                  => 'ascending',
      'group_by'               => 'none',
      'group_order'            => 'ascending',
      'bibliography_group_tag' => 'h2,h3,h4,h5',
      'bibliography_list_tag'  => 'ol',
      'bibliography_item_tag'  => 'li',
      'bibliography_list_attributes' => {},
      'bibliography_item_attributes' => {},

      'source'                 => './_bibliography',
      'bibliography'           => 'references.bib',
      'repository'             => nil,

      'bibtex_options'         => { :strip => false, :parse_months => true },
      'bibtex_filters'         => [ :superscript, :latex ],
      'bibtex_skip_fields'     => [ :abstract, :month_numeric ],

      'replace_strings'        => true,
      'join_strings'           => true,

      'details_dir'            => 'bibliography',
      'details_layout'         => 'bibtex.html',
      'details_link'           => 'Details',
      'use_raw_bibtex_entry'   => false,

      'bibliography_class'     => 'bibliography',
      'bibliography_template'  => '{{reference}}',

      'reference_tagname'      => 'span',
      'missing_reference'      => '(missing reference)',

      'details_link_class'     => 'details',

      'query'                  => '@*',

      'type_names' => {
        'article' => 'Journal Articles',
        'book' => 'Books',
        'incollection' => 'Book Chapters',
        'inproceedings' => 'Conference Articles',
        'thesis' => 'Theses',
        'mastersthesis' => 'Master\'s Theses',
        'phdthesis' => 'PhD Theses',
        'manual' => 'Manuals',
        'techreport' => 'Technical Reports',
        'misc' => 'Miscellaneous',
        'unpublished' => 'Unpublished',
      },
      'type_aliases' => {
        'phdthesis' => 'thesis',
        'mastersthesis' => 'thesis',
      },
      'type_order' => [],

      'month_names' => nil,
    }.freeze

    class << self
      attr_reader :defaults
    end
  end
end
