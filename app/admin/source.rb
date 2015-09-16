ActiveAdmin.register Source do
  permit_params :name

  index do
    column :name
    column :updated_at
    column :topics do |source|
      links = source.topics.order(:name).first(10).collect { |topic|
        link_to topic.name, admin_topic_path(topic)
      }.join(', ')
      links.concat(', ...') if source.topics.count > 10
      links.html_safe
    end
    actions
  end

  controller do
    def scoped_collection
      Source.includes(:topics)
    end
  end

  show do |source|
    attributes_table do
      row :id
      row :name
      row :updated_at
      row :created_at
    end
    panel "Topics" do
      table_for source.topics do
        column "topic name" do |topic|
          link_to topic.name, admin_topic_path(topic)
        end
      end
    end
  end
end
