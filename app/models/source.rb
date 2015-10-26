class Source < ActiveRecord::Base
  has_many :mapped_terms
  validates :name, presence: true, uniqueness: true
end
