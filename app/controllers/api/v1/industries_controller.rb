module Api
  module V1
    class IndustriesController < ApplicationController
      respond_to :json

      def index
        render json: find_industries, only: [:id, :name]
      end

      private

      def find_industries
        return Industry.all if params[:source].nil? && params[:topic].nil?

        if log_new_topic?
          topic = Topic.create(name: params[:topic])
          source = Source.find_or_create_by(name: params[:source])
          source.topics << topic
        end

        source = Source.find_by(name: params[:source]) if params[:source].present?

        return Industry.none if params[:source].present? && source.nil?

        filters = {}
        filters[:source_id] = source.id if source.present?
        filters[:name] = params[:topic] if params[:topic].present?
        Industry.joins(:topics).where(topics: filters)
      end

      def log_new_topic?
        params[:source] &&
          params[:topic] &&
          params[:log_failed] &&
          Topic.find_by(name: params[:topic]).blank?
      end
    end
  end
end
