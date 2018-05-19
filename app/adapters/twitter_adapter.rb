class TwitterAdapter
  TWEETS_COUNT = 10
  private_constant :TWEETS_COUNT

  def initialize
    @client = Twitter::REST::Client.new(**Rails.application.credentials.twitter)
  end

  def search(q, count: nil)
    count = count.presence || TWEETS_COUNT
    client.search(q).take(count.to_i)
  end

  private

  attr_reader :client
end
