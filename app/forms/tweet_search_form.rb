class TweetSearchForm
  include ActiveModel::Model

  attr_accessor :q, :count

  validate :format_of_search_term
  validates :count, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_blank: true

  def self.model_name
    ActiveModel::Name.new(self, nil, 'TweetSearch')
  end

  def call(adapter: TwitterAdapter.new)
    return [] if q.blank?
    return [] unless valid?
    adapter.search(q, count: count)
  end

  private

  def format_of_search_term
    errors.add(:q) if q.present? && q.match(/\A(_|\W)+\z/)
  end
end
