Before do
  FileUtils.rm_rf(TEST_DIR)
  FileUtils.mkdir(TEST_DIR)
  Dir.chdir(TEST_DIR)
end

After do
  Dir.chdir(TEST_DIR)
  FileUtils.rm_rf(TEST_DIR)
end
 
# Like "I have a foo file" but gives a yaml front matter so jekyll actually processes it
Given /^I have an? "(.*)" page(?: with (.*) "(.*)")? that contains "(.*)"$/ do |file, key, value, text|
  File.open(file, 'w') do |f|
    f.write <<EOF
---
#{key || 'layout'}: #{value || 'nil'}
---
#{text}
EOF
    f.close
  end
end

Given /^I have an? "(.*)" file that contains "(.*)"$/ do |file, text|
  File.open(file, 'w') do |f|
    f.write(text)
    f.close
  end
end

Given /^I have a configuration file with "(.*)" set to "(.*)"$/ do |key, value|
  File.open('_config.yml', 'w') do |f|
    f.write("#{key}: #{value}\n")
    f.close
  end
end

Given /^I have a configuration file with:$/ do |table|
  File.open('_config.yml', 'w') do |f|
    table.hashes.each do |row|
      f.write("#{row["key"]}: #{row["value"]}\n")
    end
    f.close
  end
end

Given /^I have a configuration file with "([^\"]*)" set to:$/ do |key, table|
  File.open('_config.yml', 'w') do |f|
    f.write("#{key}:\n")
    table.hashes.each do |row|
      f.write("- #{row["value"]}\n")
    end
    f.close
  end
end

When /^I run jekyll$/ do
  run_jekyll
end

Then /^the (.*) directory should exist$/ do |dir|
  assert File.directory?(dir)
end

Then /^I should see "(.*)" in "(.*)"$/ do |text, file|
  assert_match Regexp.new(text), File.open(file).readlines.join
end

Then /^the "(.*)" file should exist$/ do |file|
  assert File.file?(file)
end

Then /^the "(.*)" file should not exist$/ do |file|
  assert !File.exists?(file)
end
