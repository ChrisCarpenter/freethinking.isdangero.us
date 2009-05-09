class Admin::PostsController < ApplicationController
  before_filter :ensure_logged_in_as_admin
  layout 'admin'
  
  make_resourceful do
    actions :all, :except => [:show]
  end
  
  protected
  
  def current_object
    @current_object ||= Post.find :first, :conditions => {:slug => params[:id]}
  end
  
  def current_objects
    @current_objects ||= Post.paginate :page => params[:page], :per_page => 20, :order => 'created_at DESC'
  end
end
