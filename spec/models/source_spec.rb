require 'spec_helper'

describe Source do
  it { is_expected.to have_many(:topics) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
end
