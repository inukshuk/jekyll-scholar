
Given /^I have a page "([^"]*)":$/ do |file, string|
  File.open(file, 'w') do |f|
    f.write(string)
  end
end

Then /^"(.*)" should come before "(.*)" in "(.*)"$/ do |p1, p2, file|
  data = File.open(file).readlines.join('')
    
  m1 = data.match(p1)
  m2 = data.match(p2)

  assert m1.offset(0)[0] < m2.offset(0)[0]
end

