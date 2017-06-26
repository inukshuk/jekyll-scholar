module Jekyll
  class Scholar
    @defaults = {
      # Style used for citations and bibliographies
      'style'                  => 'apa',
      # Sets languages used in bibliography
      'locale'                 => 'en',

      # Keys used to sort bibliography
      'sort_by'                => 'none',
      # Order used to sort biobliography
      'order'                  => 'ascending',
      'group_by'               => 'none',
      'group_order'            => 'ascending',
      # HTML tags used for bibliography group names
      'bibliography_group_tag' => 'h2,h3,h4,h5',
      # HTML tag used for list of bibliography entries
      'bibliography_list_tag'  => 'ol',
      # HTML tag used for individual bibliography entries
      'bibliography_item_tag'  => 'li',
      # Attributes applied to HTML tag for list of bibliography entries
      'bibliography_list_attributes' => {},
      # Attributes applied to HTML tag for bibliography entries
      'bibliography_item_attributes' => {},

      # Name of folder references files are stored in
      'source'                 => './_bibliography',
      # Name of default references file
      'bibliography'           => 'references.bib',

      # The repository folder with your entries' attachemnts, slides, etc.
      'repository'             => nil,

      # Delimiter for files in repositories;
      # this character may not be part of your entry keys!
      'repository_file_delimiter' => '.',

      'bibtex_options'         => { :strip => false, :parse_months => true },
      'bibtex_filters'         => [ :smallcaps, :superscript, :latex ],
      'bibtex_skip_fields'     => [ :abstract, :month_numeric ],

      'replace_strings'        => true,
      'join_strings'           => true,

      'details_dir'            => 'bibliography',
      'details_layout'         => 'bibtex.html',
      'details_link'           => 'Details',
      'use_raw_bibtex_entry'   => true,

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

      'month_names' => nil

    }.freeze

    class << self
      attr_reader :defaults
    end
  end
end
