class TweetSearchForm
  include ActiveModel::Model

  attr_accessor :q

  validate :format_of_search_term

  def self.model_name
    ActiveModel::Name.new(self, nil, 'TweetSearch')
  end

  def call(adapter: TwitterAdapter.new)
    return [] if q.blank?
    return [] unless valid?
    adapter.search(q)
  end

  private

  def format_of_search_term
    errors.add(:q) if q.present? && q.match(/\A(_|\W)+\z/)
  end
end
