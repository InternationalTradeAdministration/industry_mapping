class IndustrySectorTopic < ActiveRecord::Base
  belongs_to :industry
  belongs_to :sector
  belongs_to :topic
end