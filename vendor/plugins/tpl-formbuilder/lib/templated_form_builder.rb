class TemplatedFormBuilder < ActionView::Helpers::FormBuilder
	def initialize(object_name, object, template, options, proc)
		@object_name, @object, @template, @options, @proc = object_name, object, template, options, proc
		@type = (@options[:type] or :tabular)
	end
	
  (field_helpers + %w[date_select datetime_select collection_select select time_zone_select submit] - %w[label check_box fields_for]).each do |helper|
    define_method(helper) do |*args|
      options = args.extract_options!
			options[:class] = helper
      method  = args.first.to_sym
      label_text = extract_label(method, options)
      args << options
      render_form_element helper, method, label_text, options, super(*args)
    end
  end

  def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
    render_form_element :check_box, method.to_sym, extract_label(method, options), options, super(method, options, checked_value, unchecked_value)
  end

  def section(label='Section', options = {}, &block)
    partial = options.delete(:partial) || "section"
    locals = {
      :section_label => label,
      :section_contents => block_given? ? @template.capture(&block) : nil
    }
    @template.concat(@template.render(:partial => "forms/#{partial}", :locals => locals), block.binding)
  end

  def button(content, options = { })
    @template.content_tag 'button', content, options
  end

  private
		def method_missing(*args)
			options = args.extract_options!
      helper  = args.first.to_sym
			method = args[1].to_sym
      label_text = extract_label(method, options)
      args << options
      render_form_element helper, method, label_text, options, ''
		end
		
    def render_form_element(helper, method, label_text, options, element)
      locals = {
        :label => label_text.blank? ? '' : label(method, label_text),
        :element => element,
				:method => method,
				:object => @object,
				:object_name => @object_name,
				:options => options
      }
      
      locals[:description] = options[:description] unless options[:description].nil?
      options[:description] = nil unless options[:description].nil?
      locals[:errors] = @object.nil? ? [] : Array(@object.errors.on(method))
			locals[:type] = @type

      begin
        @template.render :partial => "forms/#{helper}", :locals => locals
      rescue ActionView::ActionViewError
        @template.render :partial => 'forms/element', :locals => locals
      end
    end

    def extract_label(method, options)
			options[:label] = "#{options[:label]}:" unless options[:label].nil?
      options.delete(:label) do
        method.to_s.humanize
      end
    end
end
