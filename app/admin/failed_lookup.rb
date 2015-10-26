ActiveAdmin.register MappedTerm, as: 'FailedLookup' do
  menu label: proc { "Failed Lookups [#{ MappedTerm.includes(:terms).where('terms.id' => nil).count }]" }, priority: 1337

  actions :index

  index do
    column :name
    column :source
    column :updated_at
    actions defaults: false do |mapped_term|
      link_to 'Fix', edit_admin_mapped_term_path(mapped_term)
    end
  end

  controller do
    def scoped_collection
      MappedTerm.includes(:terms).where('terms.id' => nil)
    end
  end
end
