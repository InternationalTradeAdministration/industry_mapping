ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc { I18n.t("active_admin.dashboard") }

  content :title => proc { I18n.t("active_admin.dashboard") } do

    columns do
      column do
        panel "Failed Lookups" do
          link_to Topic.includes(:sectors, :industries).where('sectors.id' => nil, 'industries.id' => nil).count, admin_failed_lookups_path
        end
      end
    end

    columns do
      column do
        panel "Industries" do
          link_to Industry.count, admin_industries_path
        end
      end

      column do
        panel "Sectors" do
          link_to Sector.count, admin_sectors_path
        end
      end

      column do
        panel "Topics" do
          link_to Topic.count, admin_topics_path
        end
      end

      column do
        panel "Sources" do
          link_to Source.count, admin_sources_path
        end
      end

    end
  end # content
end
