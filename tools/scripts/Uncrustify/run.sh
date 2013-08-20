#!/usr/bin/ruby
base_path = ENV['XcodeProjectPath'] + "/.."

puts "running uncrustify for xcode project path: #{base_path}"

if base_path != nil
  paths = `find "#{base_path}" -name "*.m" -o -name "*.h" -o -name "*.mm" -o -name "*.c"`
  paths = paths.collect do |path|
    path.gsub(/(^[^\n]+?)(\n)/, '"\\1"')
  end
  paths = paths.join(" ")
  result = `/usr/local/bin/uncrustify/uncrustify -c /usr/local/bin/uncrustify/uncrustify.cfg --no-backup #{paths}`;
  puts result
else
  puts "Invalid base path..."
end
