ActiveAdmin.register Term do
  actions :index, :show

  index do
    column :name
    column :updated_at
    column :children do |term|
      children = term.children
      links = children.collect do |child|
        link_to child.name, admin_term_path(child)
      end
      links.join(', ').html_safe
    end

    column :parents do |term|
      parents = term.parents
      links = parents.collect do |parent|
        link_to parent.name, admin_term_path(parent)
      end
      links.join(', ').html_safe
    end

    column :taxonomies do |term|
      taxonomies = term.taxonomies
      links = taxonomies.collect do |taxonomy|
        link_to taxonomy.name, admin_taxonomy_path(taxonomy)
      end
      links.join(', ').html_safe
    end

    column :mapped_terms do |term|
      mapped_terms = term.mapped_terms
      links = mapped_terms.collect do |mapped_term|
        link_to mapped_term.name, admin_mapped_term_path(mapped_term)
      end
      links.join(', ').html_safe
    end
    actions
  end

  show do |term|
    attributes_table do
      row :id
      row :name
      row :updated_at
      row :created_at
    end

    panel 'Children' do
      children = term.children
      table_for children do
        column 'child name' do |child|
          link_to child.name, admin_term_path(child)
        end
      end
    end

    panel 'Parents' do
      parents = term.parents
      table_for parents do
        column 'paret name' do |parent|
          link_to parent.name, admin_term_path(parent)
        end
      end
    end

    panel 'Taxonomies' do
      taxonomies = term.taxonomies
      table_for taxonomies do
        column 'taxonomy name' do |taxonomy|
          link_to taxonomy.name, admin_term_path(taxonomy)
        end
      end
    end

    panel 'Mapped Terms' do
      mapped_terms = term.mapped_terms
      table_for mapped_terms do
        column 'mapped term name' do |mapped_term|
          link_to mapped_term.name, admin_mapped_term_path(mapped_term)
        end
      end
    end
  end
end
