# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TagsHelper
  
  def require_javascript(name)
    @required_javascripts ||= []
    @required_javascripts << name unless @required_javascripts.include?(name)
  end
  
  def require_stylesheet(name)
    @required_stylesheets ||= []
    @required_stylesheets << name unless @required_stylesheets.include?(name)
  end
  
  def navigation_item(name, path, opts = {}, &block)
    if proc = opts.delete(:selected_if)
      selected = proc.call
    else
      logger.debug request.path
      selected = request.path == path
    end
    
    if selected
      if opts[:class]
        opts[:class] += ' selected'
      else
        opts[:class] = 'selected'
      end
    end
    
    html = Builder::XmlMarkup.new
    
    if block_given?
      html.li(opts) {
        html.h2 {
          html << link_to(name, path, opts)
        }
        html.ul {
          html << capture(&block)
        }
      }
      concat(html.text!(''), block.binding)
    else
      html.li(opts) {
        html.h3 {
          html << link_to(name, path, opts)
        }
      }
    end
  end
  
  def link_to_with_selected(name, url, opts = {})
    if proc = opts.delete(:selected_if)
      selected = proc.call
    else
      logger.debug request.path
      selected = request.path == url
    end
    
    if selected
      if opts[:class]
        opts[:class] += ' selected'
      else
        opts[:class] = 'selected'
      end
    end
    
    link_to(name, url, opts)
  end
end
