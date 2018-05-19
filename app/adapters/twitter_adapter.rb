class TwitterAdapter
  TWEETS_COUNT = 10
  private_constant :TWEETS_COUNT

  def initialize
    @client = Twitter::REST::Client.new(**Rails.application.credentials.twitter)
  end

  def search(q)
    client.search(q).take(TWEETS_COUNT)
  end

  private

  attr_reader :client
end
