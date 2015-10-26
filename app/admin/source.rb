ActiveAdmin.register Source do
  permit_params :name

  index do
    column :name
    column :updated_at
    column :mapped_terms do |source|
      links = source.mapped_terms.order(:name).first(10).collect do |mapped_term|
        link_to mapped_term.name, admin_mapped_term_path(mapped_term)
      end.join(', ')
      links.concat(', ...') if source.mapped_terms.count > 10
      links.html_safe
    end
    actions
  end

  controller do
    def scoped_collection
      Source.includes(:mapped_terms)
    end
  end

  show do |source|
    attributes_table do
      row :id
      row :name
      row :updated_at
      row :created_at
    end
    panel 'Mapped Terms' do
      table_for source.mapped_terms do
        column 'mapped term name' do |mapped_term|
          link_to mapped_term.name, admin_mapped_term_path(mapped_term)
        end
      end
    end
  end
end
