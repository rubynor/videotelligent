class Video < ActiveRecord::Base
  def rating
    (likes.to_f / (likes + dislikes)) * 100
  end
end
