module Jekyll
  class Scholar
    @defaults = Hash[*%w{

      style        apa
      locale       en

      sort_by      none
      order        ascending

      source       ./_bibliography
      bibliography references.bib

      details_dir    bibliography
      details_layout bibtex.html
      details_link   Details
      
    	query  @*
	
    }].freeze

    class << self
      attr_reader :defaults
    end
  end
end