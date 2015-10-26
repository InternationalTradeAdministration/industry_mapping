ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel 'Failed Lookups' do
          link_to MappedTerm.includes(:terms).where('terms.id' => nil).count, admin_failed_lookups_path
        end
      end
    end

    columns do
      column do
        panel 'Terms' do
          link_to Term.count, admin_terms_path
        end
      end

      column do
        panel 'Taxonomies' do
          link_to Taxonomy.count, admin_taxonomies_path
        end
      end

      column do
        panel 'Mapped Terms' do
          link_to MappedTerm.count, admin_mapped_terms_path
        end
      end

      column do
        panel 'Sources' do
          link_to Source.count, admin_sources_path
        end
      end
    end
  end # content
end
