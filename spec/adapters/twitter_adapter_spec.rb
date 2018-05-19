require 'rails_helper'

RSpec.describe TwitterAdapter do
  let(:adapter) { described_class.new }

  context '#search' do
    it 'returns a collection of tweets' do
      VCR.use_cassette('twitter_search/q_adjust_count_10') do
        tweets = adapter.search('adjust')
        expect(tweets).to all(be_a(Twitter::Tweet))
      end
    end

    it 'returns a collection of 10 by default' do
      VCR.use_cassette('twitter_search/q_adjust_count_10') do
        tweets = adapter.search('adjust')
        expect(tweets.count).to eq 10
      end
    end

    it 'returns a collection of as much as count' do
      VCR.use_cassette('twitter_search/q_adjust_count_5') do
        tweets = adapter.search('adjust', count: 5)
        expect(tweets.count).to eq 5
      end
    end
  end
end
