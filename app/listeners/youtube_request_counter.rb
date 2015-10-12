class YoutubeRequestCounter

  @number_of_requests = 0
  @total_number_of_requests = 0
  @total_number_of_videos = 0

  attr_reader :number_of_requests, :total_number_of_requests, :total_number_of_videos

  def self.increment
    @number_of_requests = @number_of_requests + 1
    @total_number_of_requests = @total_number_of_requests + 1
  end

  def self.number_of_requests
    @number_of_requests
  end

  def self.total_number_of_requests
    @total_number_of_requests
  end

  def self.total_number_of_videos
    @total_number_of_videos
  end

  def self.average_number_of_requests_per_video
    @total_number_of_requests / @total_number_of_videos
  end

  def self.start_new_video!
    @number_of_requests = 0
    @total_number_of_videos = @total_number_of_videos + 1
  end

end