require "rails_helper"

RSpec.feature "Tweets index" do
  background do
    visit tweets_path
  end

  scenario "when visiting the page" do
    expect(page).to have_content('Tweets')

    expect(find('ul#tweets')).to_not have_selector('li')
  end

  scenario 'when searching with no term' do
    fill_in id: 'tweet_search_q', with: ''
    click_button 'Search'

    expect(find('ul#tweets')).to_not have_selector('li')
  end

  scenario 'when searching with invalid term' do
    fill_in id: 'tweet_search_q', with: %w(_ + = & # ! ?).sample * [*1..9].sample
    click_button 'Search'

    expect(find('ul#tweets')).to_not have_selector('li')

    expect(find('#tweet_search_q + span.error')).to have_text('is invalid')
  end

  scenario 'when searching with valid term' do
    VCR.use_cassette('twitter_search/q_adjust_count_10') do
      fill_in id: 'tweet_search_q', with: 'adjust'
      click_button 'Search'

      expect(find('ul#tweets')).to have_selector('li', count: 10)
    end
  end

  scenario 'when searching with setting count' do
    VCR.use_cassette('twitter_search/q_adjust_count_5') do
      fill_in id: 'tweet_search_q', with: 'adjust'
      fill_in id: 'tweet_search_count', with: '5'
      click_button 'Search'

      expect(find('ul#tweets')).to have_selector('li', count: 5)
    end
  end
end
