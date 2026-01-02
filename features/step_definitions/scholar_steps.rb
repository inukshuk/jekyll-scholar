
Given(/^I have a "([^"]*)" directory/) do |dir|
  FileUtils.mkdir(dir)
end

Given(/^I have a (?:page|file) "([^"]*)":$/) do |file, string|
  File.open(file, 'w') do |f|
    f.write(string)
  end
end

Given(/^I have a scholar configuration with:$/) do |table|
  File.open('_config.yml', 'a') do |f|
    f.write("scholar:\n")
    table.hashes.each do |row|
      f.write("  #{row["key"]}: #{row["value"]}\n")
    end
  end
end

Given(/^I have the following BibTeX options:$/) do |table|
  File.open('_config.yml', 'a') do |f|
    f.write("  bibtex_options:\n")
    table.hashes.each do |row|
      f.write("    #{row["key"]}: #{row["value"]}\n")
    end
  end
end

Given(/^I have the following BibTeX filters:$/) do |table|
  File.open('_config.yml', 'a') do |f|
    f.write("  bibtex_filters:\n")
    table.raw.flatten.each do |row|
      f.write("    - #{row}\n")
    end
  end
end

Given(/^I have the following raw BibTeX filters:$/) do |table|
  File.open('_config.yml', 'a') do |f|
    f.write("  raw_bibtex_filters:\n")
    table.raw.flatten.each do |row|
      f.write("    - #{row}\n")
    end
  end
end

Then(/^"(.*)" should come before "(.*)" in "(.*)"$/) do |p1, p2, file|
  data = File.open(file).readlines.join('')

  m1 = data.match(p1)
  m2 = data.match(p2)

  assert m1.offset(0)[0] < m2.offset(0)[0]
end

Then(/^I should have a (bibliography|cite) cache entry for (.*)$/) do |cache_type, key|
  require "digest"
  case cache_type
  when "bibliography"
    raise NotImplementedError "Can't load temporary files for some reason"
    # paths = key.split(", ")
    # bib_mtimes = paths.reduce('') { |s, p| s << File.mtime(p).inspect }
    # bib_hash = Digest::SHA256.hexdigest bib_mtimes
    # assert Jekyll::Scholar::Utilities.bib_cache.key?(bib_hash)
  when "cite"
    assert Jekyll::Scholar::Utilities.class_variable_get(:@@cite_cache).key?(key)
  else
    raise "Unknown cache type"
  end
end

Then(/^I should have (\d*) (bibliography|cite) cache entr(?:ies|y)$/) do |n_entries, cache_type|
  case cache_type
  when "bibliography"
    assert Jekyll::Scholar::Utilities.class_variable_get(:@@bib_cache).instance_variable_get(:@cache).length == n_entries.to_i
  when "cite"
    assert Jekyll::Scholar::Utilities.class_variable_get(:@@cite_cache).instance_variable_get(:@cache).length == n_entries.to_i
  else
    raise "Unknown cache type"
  end
end

