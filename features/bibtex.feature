Feature: BibTeX
  As a scholar who likes to blog
  I want to publish my BibTeX bibliography on my blog
  In order to share my awesome references with my peers

	Scenario: Simple Bibliography
		Given I have a configuration file with "citation_style" set to "apa"
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
			"""
	  When I run jekyll
	  Then the _site directory should exist
		And the "_site/references.html" file should exist
	  And I should see "<i>The Ruby Programming Language</i>" in "_site/references.html"
