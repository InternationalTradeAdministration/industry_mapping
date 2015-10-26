require 'spec_helper'

describe MappedTerm do
  it { is_expected.to have_and_belong_to_many(:terms) }
  it { is_expected.to belong_to(:source) }

  it { is_expected.to validate_presence_of(:source) }
  it { is_expected.to validate_presence_of(:name) }

  describe 'uniqueness validation' do
    let(:source1) { Source.create(name: 'Source 1') }
    let(:source2) { Source.create(name: 'Source 2') }
    let!(:mapped_term) { MappedTerm.create(name: 'Foo', source: source1) }

    it 'enforces uniqueness scoped to source' do
      expect(MappedTerm.create(name: 'Bar', source: source1)).to be_valid
      expect(MappedTerm.create(name: 'Foo', source: source2)).to be_valid
      expect(MappedTerm.create(name: 'Foo', source: source1)).to_not be_valid
    end
  end
end
