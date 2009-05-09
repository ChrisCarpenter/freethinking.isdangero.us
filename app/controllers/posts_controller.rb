class PostsController < ApplicationController
  before_filter :load_public_sidebar
  
  layout 'public'
  exempt_from_layout 'atom.builder'
  
  make_resourceful do
    actions :index, :show
    response_for(:index) { |f| f.html; f.atom }
  end
  
  def tag
    @posts = Post.published.paginate_tagged_with(params[:id], :page => params[:page], :per_page => 10, :order => 'created_at DESC')
    render :action => :index
  end
  
  protected
  
  def current_object
    @current_object ||= Post.published.find(:first, :conditions => {:slug => params[:id]})
    raise ActiveRecord::RecordNotFound if @current_object.nil? else return @current_object
  end
  
  def current_objects
    @current_objects ||= Post.published.paginate(:page => params[:page], :per_page => 10, :order => 'created_at DESC')
  end
end
