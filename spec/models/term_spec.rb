require 'spec_helper'

describe Term do
  it { is_expected.to have_and_belong_to_many(:parents) }
  it { is_expected.to have_and_belong_to_many(:children) }
  it { is_expected.to have_and_belong_to_many(:mapped_terms) }
  it { is_expected.to have_and_belong_to_many(:taxonomies) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }

  it { is_expected.to validate_presence_of(:protege_id) }
  it { is_expected.to validate_uniqueness_of(:protege_id) }
end
