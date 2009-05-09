class Post < ActiveRecord::Base
  acts_as_taggable
  
  DRAFT = 0
  PUBLISHED = 1
  
  has_finder :published, :conditions => {:status => PUBLISHED}
  has_finder :drafts, :conditions => {:status => DRAFT}
  
  has_many :discussions, :order => 'created_at'
  
  def to_param
    slug
  end
end
