class MappedTerm < ActiveRecord::Base
  belongs_to :source
  has_and_belongs_to_many(:terms, join_table: 'terms_joined_mapped_terms')

  validates :source, presence: true
  validates :name, presence: true, uniqueness: { scope: :source }
end
