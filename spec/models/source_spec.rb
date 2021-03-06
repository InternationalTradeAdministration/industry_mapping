require 'spec_helper'

describe Source do
  it { is_expected.to have_many(:mapped_terms) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
end
