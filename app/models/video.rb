class Video < ActiveRecord::Base

  serialize :tags

  def rating
    (likes.to_f / (likes + dislikes)) * 100
  end
end
