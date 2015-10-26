module Api
  module V1
    class TermsController < ApplicationController
      respond_to :json

      def index
        render json: find_terms, only: [:id, :name]
      end

      private

      def find_terms
        return Term.all if params[:source].nil? && params[:mapped_term].nil?

        if log_new_mapped_term?
          mapped_term = MappedTerm.create(name: params[:mapped_term])
          source = Source.find_or_create_by(name: params[:source])
          source.mapped_terms << mapped_term
        end

        source = Source.find_by(name: params[:source]) if params[:source].present?

        return Term.none if params[:source].present? && source.nil?

        filters = {}
        filters[:source_id] = source.id if source.present?
        filters[:name] = params[:mapped_term] if params[:mapped_term].present?
        Term.joins(:mapped_terms).where(mapped_terms: filters)
      end

      def log_new_mapped_term?
        params[:source] &&
          params[:mapped_term] &&
          params[:log_failed] &&
          MappedTerm.find_by(name: params[:mapped_term]).blank?
      end
    end
  end
end
