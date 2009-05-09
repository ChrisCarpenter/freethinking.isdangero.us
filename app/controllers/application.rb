# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  
  protected
  
  def load_public_sidebar
    @tags = Post.tag_counts
    @recent_posts = Post.find(:all, :limit => 10, :order => 'created_at DESC')
  end
  
  def ensure_logged_in_as_admin
    authenticate_or_request_with_http_basic do |username, password|
      username == 'carp' && password == 'enter'
    end
  end
end
