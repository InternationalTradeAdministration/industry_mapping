ActiveAdmin.register Taxonomy do
  actions :index, :show

  index do
    column :name
    column :updated_at
    column :terms do |taxonomy|
      links = taxonomy.terms.order(:name).first(10).collect do |term|
        link_to term.name, admin_term_path(term)
      end.join(', ')
      links.concat(', ...') if taxonomy.terms.count > 10
      links.html_safe
    end
    actions
  end

  show do |taxonomy|
    attributes_table do
      row :id
      row :name
      row :updated_at
      row :created_at
    end
    panel 'Terms' do
      table_for taxonomy.terms do
        column 'term name' do |term|
          link_to term.name, admin_term_path(term)
        end
      end
    end
  end
end
