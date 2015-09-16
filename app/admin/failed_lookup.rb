ActiveAdmin.register Topic, as: 'FailedLookup' do
  menu label: proc { "Failed Lookups [#{ Topic.includes(:sectors, :industries).where('sectors.id' => nil, 'industries.id' => nil).count }]" }, priority: 1337

  actions :index
  remove_filter :industry_sector_topics

  index do
    column :name
    column :updated_at
    actions defaults: false do |topic|
      link_to 'Fix', edit_admin_topic_path(topic)
    end
  end

  controller do
    def scoped_collection
      Topic.includes(:sectors, :industries).where('sectors.id' => nil, 'industries.id' => nil)
    end
  end
end
