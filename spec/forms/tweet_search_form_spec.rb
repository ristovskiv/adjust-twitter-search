require 'rails_helper'

RSpec.describe TweetSearchForm do

  it { is_expected.to respond_to(:q) }
  it { is_expected.to respond_to(:q=) }
  it { is_expected.to respond_to(:call) }

  context 'validations' do
    describe '#q' do
      it 'can be blank' do
        tweet_search_form = described_class.new(q: [nil, ''].sample)
        tweet_search_form.valid?

        expect(tweet_search_form.errors[:q]).to be_blank
      end

      it 'can be any string' do
        tweet_search_form = described_class.new(q: [*'a'..'z'].sample * [*1..9].sample)
        tweet_search_form.valid?

        expect(tweet_search_form.errors[:q]).to be_blank
      end

      it 'must be meaningful' do
        unmeaningful_term = %w(_ + = & # ! ?).sample * [*1..9].sample
        tweet_search_form = described_class.new(q: unmeaningful_term)
        tweet_search_form.valid?

        expect(tweet_search_form.errors[:q]).to include(match(/is invalid/))
      end
    end
  end

  context '#call' do
    describe 'when term is blank' do
      it 'returns an empty collection' do
        tweet_search_form = described_class.new(q: '')

        expect(tweet_search_form.call).to be_empty
      end
    end

    describe 'when form is not valid' do
      it 'returns and empty collection' do
        tweet_search_form = described_class.new(q: 'adjust')
        allow(tweet_search_form).to receive(:valid?).and_return(false)

        expect(tweet_search_form.call).to be_empty
      end
    end

    describe 'when form is valid' do
      it 'can get collection of tweets' do
        adapter = instance_double(TwitterAdapter)
        expect(adapter).to receive(:search).with('adjust')

        tweet_search_form = described_class.new(q: 'adjust')
        allow(tweet_search_form).to receive(:valid?).and_return(true)

        tweet_search_form.call(adapter: adapter)
      end
    end
  end

end
