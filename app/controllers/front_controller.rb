class FrontController < ApplicationController
  before_filter :load_public_sidebar
  
  layout 'public'
  
  def index
    @posts = Post.published.paginate(:page => params[:page], :per_page => 3, :order => 'created_at DESC')
  end
end
