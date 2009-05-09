require 'templated_form_builder'

module ActionView::Helpers::FormHelper
  %w(form_for remote_form_for fields_for).each do |helper|
    src = <<-end_src
      def tpl_#{helper}(object_name, *args, &proc)
        options = args.last.is_a?(Hash) ? args.pop : {}
        options.merge! :builder => TemplatedFormBuilder, :type => :tabular
				concat(render(:partial => "forms/\#{options[:type]}/form_head"), proc.binding)
				#{helper}(object_name, *(args << options), &proc)
				concat(render(:partial => "forms/\#{options[:type]}/form_foot"), proc.binding)
      end
    end_src
    
    class_eval src, __FILE__, __LINE__
  end
end