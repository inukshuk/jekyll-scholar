Before do
  FileUtils.mkdir_p(TEST_DIR) unless File.exist?(TEST_DIR)
  Dir.chdir(TEST_DIR)
end

After do
  FileUtils.rm_rf(TEST_DIR) if File.exist?(TEST_DIR)
end

