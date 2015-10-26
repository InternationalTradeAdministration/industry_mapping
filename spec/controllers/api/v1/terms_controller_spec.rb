require 'spec_helper'

describe Api::V1::TermsController, type: :controller do
  render_views

  let(:query) { {} }
  let(:get_index) { get :index, query }
  let(:json_response) { JSON.parse(response.body) }

  before do
    Source.delete_all
    Term.delete_all
    MappedTerm.delete_all
    @source = Source.create(name: 'Source Name')
    @mapped_term = MappedTerm.create(name: 'First Mappable Term', source: @source)
    @term = Term.create(name: 'Term Name', protege_id: 1337)
    @mapped_term.terms << @term
  end

  context 'mapped_term only' do
    context 'when query matches' do
      let(:query) { { mapped_term: @mapped_term.name } }

      it 'responds as expected' do
        get_index
        expect(json_response.count).to eq(1)
        expect(json_response.first['name']).to eq(@mapped_term.terms.first.name)
      end
    end

    context "when query doesn't match" do
      let(:query) { { mapped_term: @mapped_term.name.concat("won't match") } }

      it 'responds as expected' do
        get_index
        expect(json_response.count).to eq(0)
      end
    end
  end

  context 'source only' do
    let(:json_response) { JSON.parse(response.body) }

    context 'when query matches' do
      let(:query) { { source: @mapped_term.source.name } }

      context 'with one mapped_term matching the source' do
        it 'contains the term of the mapped_term' do
          get_index
          expect(json_response.count).to eq(1)
          expect(json_response.first['name']).to eq(@mapped_term.terms.first.name)
        end
      end

      context 'with multiple mapped_terms matching the source' do
        it 'contains the terms of both mapped_terms' do
          @mapped_term2 = MappedTerm.create(name: 'Second Mapped Term', source: @source)
          @mapped_term2.terms << @term
          get_index
          expect(json_response.count).to eq(2)
          expect(json_response).to match_array(
            [@mapped_term, @mapped_term2].map { |t| { 'id' => t.terms.first.id, 'name' => t.terms.first.name } },
          )
        end
      end
    end

    context "when query doesn't match" do
      let(:query) { { source: @mapped_term.source.name.concat("won't match") } }

      it 'responds as expected' do
        get_index
        expect(json_response.count).to eq(0)
      end
    end
  end

  context 'when requesting to log failed lookups' do
    context 'with source and mapped_term' do
      context "when source doesn't exist" do
        let(:mapped_term_name) { 'Foo Bar' }
        let(:source_name) { 'Foo::Bar' }
        let(:query) { { source: source_name, mapped_term: mapped_term_name, log_failed: 'true' } }

        it 'creates the new Mapped Term and Source' do
          get_index
          expect(json_response.count).to eq(0)

          source = Source.find_by(name: source_name)
          expect(source).to be

          mapped_term = MappedTerm.find_by(name: mapped_term_name, source: source)
          expect(mapped_term).to be
          expect(mapped_term.terms).to be_empty
        end
      end

      context 'when source already exists' do
        before { @mapped_term.terms.delete_all }
        let(:query) { { source: @mapped_term.source.name, mapped_term: @mapped_term.name, log_failed: 'true' } }
        before { get_index }
        it { expect(json_response.count).to eq(0) }
        subject { Source.find_by(name: @mapped_term.source.name) }
        it { expect(subject).to be }
        subject { MappedTerm.find_by(name: @mapped_term.name, source: @mapped_term.source) }
        it { expect(subject).to be }
        it { expect(subject.terms).to be_empty }
      end
    end
  end
end
