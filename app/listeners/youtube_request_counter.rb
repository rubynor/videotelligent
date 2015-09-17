class YoutubeRequestCounter

  @number_of_requests = 0

  def self.increment
    @number_of_requests = @number_of_requests + 1
  end

  def self.number_of_requests
    @number_of_requests
  end

  def self.reset!
    @number_of_requests = 0
  end

end