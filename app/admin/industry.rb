ActiveAdmin.register Industry do
  permit_params :name, :protege_id
  remove_filter :industry_sectors
  remove_filter :industry_sector_topics

  index do
    column :name
    column :updated_at
    column :sectors do |industry|
      sectors = Sector.includes(:industries).where('industries.id' => industry.id)
      links = sectors.collect do |sector|
        link_to sector.name, admin_sector_path(sector)
      end
      links.join(', ').html_safe
    end
    actions
  end

  controller do
    def scoped_collection
      Industry.includes(:sectors)
    end
  end

  show do |industry|
    attributes_table do
      row :id
      row :name
      row :updated_at
      row :created_at
    end
    panel "Sectors" do
      sectors = Sector.includes(:industries).where('industries.id' => industry.id)
      table_for sectors do
        column "sector name" do |sector|
          link_to sector.name, admin_sector_path(sector)
        end
      end
    end
  end

  form do |f|
    f.inputs "Industry" do
      f.input :name
      f.input :protege_id, label: "Protege ID"
    end
    f.actions
  end
end
