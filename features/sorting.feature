Feature: Sorting BibTeX Bibliographies
  As a scholar who likes to blog
  I want to sort my bibliographies according to configurable parameters

	Scenario: Sort Bibliography by Year
		Given I have a configuration file with "citation_sort_order" set to "year"
	  And I have a page "references.bib":
			"""
			---
			---
			@book{ruby,
			  title     = {The Ruby Programming Language},
			  author    = {Flanagan, David and Matsumoto, Yukihiro},
			  year      = {2008},
			  publisher = {O'Reilly Media}
			}
			@book{ruby,
			  title     = {The Ruby Programming Language},
			  author    = {Flanagan, David and Matsumoto, Yukihiro},
			  year      = {2007},
			  publisher = {O'Reilly Media}
			}
			"""
	  When I run jekyll
	  And I should see "\(2007\)\.+\(2008\)" in "_site/references.html"
