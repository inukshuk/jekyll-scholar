Feature: BibTeX
  As a scholar who likes to blog
  I want to publish my BibTeX bibliography on my blog
  And I want Jekyll to generate detail pages for all the entries in my bibliography
  
  @generators
	Scenario: A bibliography with a single entry
    Given I have a scholar configuration with:
  	  | key            | value             |
  	  | source         | ./_bibliography   |
  	  | details_layout | details.html      |
		And I have a "_bibliography" directory
	  And I have a file "_bibliography/references.bib":
			"""
			@book{ruby,
			  title     = {The Ruby Programming Language},
			  author    = {Flanagan, David and Matsumoto, Yukihiro},
			  year      = {2008},
			  publisher = {O'Reilly Media}
			}
			"""
		And I have a "_layouts" directory
		And I have a file "_layouts/details.html":
			"""
			---
			---
			<html>
			<head></head>
			<body>
			{{ page.entry.title }}
			</body>
			</html>
			"""
	  When I run jekyll
	  Then the _site directory should exist
		And the "_site/bibliography/ruby.html" file should exist
	  And I should see "The Ruby Programming Language" in "_site/bibliography/ruby.html"
