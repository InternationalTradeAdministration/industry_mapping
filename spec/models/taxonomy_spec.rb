require 'spec_helper'

describe Taxonomy do
  it { is_expected.to have_and_belong_to_many(:terms) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
end
