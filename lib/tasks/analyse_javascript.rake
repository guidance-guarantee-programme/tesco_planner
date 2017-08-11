desc 'Lint JavaScript'
task :analyse_javascript do
  puts 'Running Javascript code analysis...'
  system('yarn run js') || raise('Javascript analysis failed')
end
