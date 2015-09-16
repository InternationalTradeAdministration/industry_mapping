require 'spec_helper'

describe Topic do
  it { is_expected.to have_many(:sectors) }
  it { is_expected.to have_many(:industries) }
  it { is_expected.to belong_to(:source) }

  it { is_expected.to validate_presence_of(:source) }
  it { is_expected.to validate_presence_of(:name) }

  describe 'uniqueness validation' do
    let(:source1) { Source.create(name: 'Source 1') }
    let(:source2) { Source.create(name: 'Source 2') }
    let!(:topic) { Topic.create(name: 'Foo', source: source1) }

    it 'enforces uniqueness scoped to source' do
      expect(Topic.create(name: 'Bar', source: source1)).to be_valid
      expect(Topic.create(name: 'Foo', source: source2)).to be_valid
      expect(Topic.create(name: 'Foo', source: source1)).to_not be_valid
    end
  end
end
