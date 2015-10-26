ActiveAdmin.register MappedTerm do
  menu priority: 100
  permit_params :name, :source_id, term_ids: []

  index do
    column :name
    column :source
    column :updated_at
    column :terms do |mapped_term|
      terms = mapped_term.terms
      links = terms.collect do |term|
        link_to term.name, admin_term_path(term)
      end
      links.join(', ').html_safe
    end

    actions
  end

  show do |mapped_term|
    attributes_table do
      row :id
      row :name
      row :source
      row :updated_at
      row :created_at
    end
    panel 'Terms' do
      table_for mapped_term.terms do
        column 'term name' do |term|
          link_to term.name, admin_term_path(term)
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :source
    end

    f.inputs 'Terms' do
      selectable_terms = Term.all.map { |i| [i.name, i.id] }
      selected_terms = resource.terms.map(&:id)
      f.input :terms,
              as:         :select2_multiple,
              collection: options_for_select(selectable_terms, selected_terms),
              input_html: { class: 'multiple-select' }
    end
    actions
  end
end
