class Industry < ActiveRecord::Base
  has_many :industry_sectors
  has_many :sectors, through: :industry_sectors
  has_many :industry_sector_topics
  has_many :topics, through: :industry_sector_topics
  validates :name, presence: true, uniqueness: true
  validates :protege_id, presence: true, uniqueness: true
end
