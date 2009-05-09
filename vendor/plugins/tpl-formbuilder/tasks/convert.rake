class File
  def self.glob(pattern, mode, &block)
    Dir.glob(pattern) do |file|
      File.open(file, mode) do |f|
        yield f
      end
    end
  end
  
  def clear
    self.truncate(0)
    self.rewind
  end
  
  def to_pathname 
    @pathname ||= Pathname.new(self.path)
  end
  
  def relative_path_from_rails_root
    self.to_pathname.relative_path_from(Pathname.new(RAILS_ROOT))
  end
end

namespace :tfb do
  
  desc 'Convert freshly generated form scaffolds to use TemplatedFormBuilder'
  task :convert do
    require 'hpricot'
    
    puts 'Converting form helpers to use TemplatedFormBuilder' + if ENV['VIEWS'] 
      ' for ' + ENV['VIEWS'] + ' views:'
    else ':' end
    
    base_path = RAILS_ROOT + '/app/views' + (ENV['VIEWS'] ? '/' + ENV['VIEWS'] : '')
    
    File.glob(base_path + '/**/{_form}.rhtml', 'r+') do |file|
      puts " * #{file.relative_path_from_rails_root}"
      doc = Hpricot.parse(file.read)
      (doc/:p).each do |p|
        text = []
        p.traverse_text do |t|
          next if t.content.strip.blank?
          text << t.content
        end
        
        matches = text.last.strip.match(/<%= (\w+) [^ ]+ ([^%]+) %>/)
        next unless matches
        
        (p/:label).remove
        (p/:br).remove
        
        p.innerHTML = "<%= form.#{matches[1]} #{matches[2].strip}, :label => '#{text.first}' %>"
      end
      
      file.clear
      file.write(doc.to_html)
    end
    
    File.glob(base_path + '/**/{new,edit}.rhtml', 'r+') do |file|
      puts " * #{file.relative_path_from_rails_root}"
      doc = Hpricot.parse(file.read)
      model_name = file.to_pathname.parent.to_s.split('/').last.singularize
      doc.innerHTML = doc.innerHTML.gsub('form_tag', "tpl_form_for :#{model_name}, @#{model_name},")
      doc.innerHTML = doc.innerHTML.gsub('do %>', 'do |form| %>')
      doc.innerHTML = doc.innerHTML.gsub(":partial => 'form'", ":partial => 'form', :locals => { :form => form }")
      file.clear
      file.write(doc.to_html)
    end
  end
end