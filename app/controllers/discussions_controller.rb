class DiscussionsController < ApplicationController
  before_filter :load_public_sidebar

  layout 'public'
  
  make_resourceful do
    actions :new, :create
  end
end
