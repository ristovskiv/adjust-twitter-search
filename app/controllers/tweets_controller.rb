class TweetsController < ApplicationController
  def index
    @tweet_search_form = TweetSearchForm.new(tweet_search_form_params)
    @tweets = @tweet_search_form.call
  end

  private

  def tweet_search_form_params
    params.fetch(:tweet_search, {}).permit(:q, :count)
  end
end
