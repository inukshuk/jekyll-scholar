
Given /^I have a page "([^"]*)":$/ do |file, string|
  File.open(file, 'w') do |f|
   f.write(string)
  end
end
