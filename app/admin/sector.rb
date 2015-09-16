ActiveAdmin.register Sector do
  permit_params :name, :protege_id, industry_ids: []
  remove_filter :industry_sectors
  remove_filter :industry_sector_topics

  index do
    column :name
    column :updated_at
    column :industries do |sector|
      industries = Industry.includes(:sectors).where('sectors.id' => sector.id)
      links = industries.collect do |industry|
        link_to industry.name, admin_industry_path(industry)
      end
      links.join(', ').html_safe
    end
    column :topics do |sector|
      topics = Topic.includes(:sectors).where('sectors.id' => sector.id)
      links = topics.collect do |topic|
        link_to topic.name, admin_topic_path(topic)
      end
      links.join(', ').html_safe
    end
    actions
  end

  controller do
    def scoped_collection
      Sector.includes(:industries)
    end
  end

  show do |sector|
    attributes_table do
      row :id
      row :name
      row :updated_at
      row :created_at
    end
    panel "Industries" do
      industries = Industry.includes(:sectors).where('sectors.id' => sector.id)
      table_for industries do
        column "industry name" do |industry|
          link_to industry.name, admin_industry_path(industry)
        end
      end
    end
    panel "Topics" do
      topics = Topic.includes(:sectors).where('sectors.id' => sector.id)
      table_for topics do
        column "topic name" do |topic|
          link_to topic.name, admin_topic_path(topic)
        end
      end
    end
  end

  form do |f|
    f.inputs "Sector" do
      f.input :name
      f.input :protege_id, label: "Protege ID"
    end
    f.inputs "Industries" do
      selectable_industries = Industry.all.map { |i| [i.name, i.id] }
      selected_industries = resource.id? ? Industry.includes(:sectors).where('sectors.id' => resource.id).map{ |i| i.id } : []
      f.input :industries,
          :as => :select2_multiple,
          :collection => options_for_select(selectable_industries, selected_industries),
          :input_html => { :class => "multiple-select" }
    end
    f.actions
  end
end
