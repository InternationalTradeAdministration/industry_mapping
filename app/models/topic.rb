class Topic < ActiveRecord::Base
  belongs_to :source
  has_many :industry_sector_topics
  has_many :sectors, through: :industry_sector_topics
  has_many :industries, through: :industry_sector_topics

  validates :source, presence: true
  validates :name, presence: true, uniqueness: { scope: :source }
end
