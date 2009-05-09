namespace :tfb do
  desc 'Copies default form templates to app/views/forms'
  task :install do
    target_dir = File.join(RAILS_ROOT, 'app', 'views', 'forms')
    mkdir_p target_dir
    FileUtils.cp Dir.glob(File.join(File.dirname(__FILE__), '..', 'assets', 'views', '*.rhtml')), target_dir
  end
end
