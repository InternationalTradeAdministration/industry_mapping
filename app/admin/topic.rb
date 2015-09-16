ActiveAdmin.register Topic do
  menu priority: 100
  permit_params :name, :source_id, industry_ids: [], sector_ids: []
  remove_filter :industry_sector_topics

  index do
    column :name
    column :updated_at
    column :sectors do |topic|
      sectors = Sector.includes(:topics).where('topics.id' => topic.id)
      links = sectors.collect do |sector|
        link_to sector.name, admin_sector_path(sector)
      end
      links.join(', ').html_safe
    end
    column :industries do |topic|
      industries = Industry.includes(:topics).where('topics.id' => topic.id)
      links = industries.collect do |sector|
        link_to sector.name, admin_sector_path(sector)
      end
      links.join(', ').html_safe
    end

    actions
  end

  controller do
    def scoped_collection
      Topic.includes(:industries, :sectors)
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :source
    end
    f.inputs "Industries" do
      selectable_industries = Industry.all.map { |i| [i.name, i.id] }
      selected_industries = resource.id? ? Industry.includes(:topics).where('topics.id' => resource.id).map{ |i| i.id } : []
      f.input :industries,
          :as => :select2_multiple,
          :collection => options_for_select(selectable_industries, selected_industries),
          :input_html => { :class => "multiple-select" }
    end

    f.inputs "Sectors" do
      selectable_sectors = Sector.all.map { |i| [i.name, i.id] }
      selected_sectors = resource.id? ? Sector.includes(:topics).where('topics.id' => resource.id).map{ |i| i.id } : []
      f.input :sectors,
          :as => :select2_multiple,
          :collection => options_for_select(selectable_sectors, selected_sectors),
          :input_html => { :class => 'multiple-select' } 
    end    
    actions
  end
end
