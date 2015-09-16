require 'spec_helper'

describe Api::V1::IndustriesController, type: :controller do
  render_views

  let(:query) { {} }
  let(:get_index) { get :index, query }
  let(:json_response) { JSON.parse(response.body) }

  before do
    Source.delete_all
    Topic.delete_all
    Industry.delete_all
    @source = Source.create(name: "Source Name")
    @topic = Topic.create(name: "First Topic", source: @source)
    @industry = Industry.create(name: "Industry Name", protege_id: 1337)
    @topic.industries << @industry
  end

  context 'topic only' do
    context 'when query matches' do
      let(:query) { {topic: @topic.name} }

      it 'responds as expected' do
        get_index
        expect(json_response.count).to eq(1)
        expect(json_response.first['name']).to eq(@topic.industries.first.name)
      end
    end

    context "when query doesn't match" do
      let(:query) { {topic: @topic.name.concat("won't match")} }

      it 'responds as expected' do
        get_index
        expect(json_response.count).to eq(0)
      end
    end
  end

  context 'source only' do
    let(:json_response) { JSON.parse(response.body) }

    context 'when query matches' do
      let(:query) { {source: @topic.source.name} }

      context 'with one topic matching the source' do
        it 'contains the industry of the topic' do
          get_index
          expect(json_response.count).to eq(1)
          expect(json_response.first['name']).to eq(@topic.industries.first.name)
        end
      end

      context 'with multiple topics matching the source' do
        it 'contains the industries of both topics' do
          @topic2 = Topic.create(name: "Second Topic", source: @source)
          @topic2.industries << @industry
          get_index
          expect(json_response.count).to eq(2)
          expect(json_response).to match_array(
            [@topic, @topic2].map { |t| {'id' => t.industries.first.id, 'name' => t.industries.first.name } }
          )
        end
      end
    end

    context "when query doesn't match" do
      let(:query) { {source: @topic.source.name.concat("won't match")} }

      it 'responds as expected' do
        get_index
        expect(json_response.count).to eq(0)
      end
    end
  end

  context 'when requesting to log failed lookups' do
    context 'with source and topic' do
      context "when source doesn't exist" do
        let(:topic_name) { 'Foo Bar' }
        let(:source_name) { 'Foo::Bar' }
        let(:query) { {source: source_name, topic: topic_name, log_failed: 'true'} }

        it 'creates the new Topic and source' do
          get_index
          expect(json_response.count).to eq(0)

          source = Source.find_by(name: source_name)
          expect(source).to be

          topic = Topic.find_by(name: topic_name, source: source)
          expect(topic).to be
          expect(topic.sectors).to be_empty
          expect(topic.industries).to be_empty
        end
      end

      context 'when source already exists' do
        before { @topic.industries.delete_all }
        let(:query){ { source: @topic.source.name, topic: @topic.name, log_failed: 'true' } }
        before{ get_index }
        it { expect(json_response.count).to eq(0) }
        subject { Source.find_by(name: @topic.source.name) }
        it { expect(subject).to be }
        subject { Topic.find_by(name: @topic.name, source: @topic.source) }
        it { expect(subject).to be }
        it { expect(subject.sectors).to be_empty }
        it { expect(subject.industries).to be_empty }
      end
    end
  end
end
