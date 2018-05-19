require "rails_helper"

RSpec.feature "Tweets index" do
  scenario "when visiting the page" do
    visit tweets_path
    expect(page).to have_content('Tweets')
  end
end
