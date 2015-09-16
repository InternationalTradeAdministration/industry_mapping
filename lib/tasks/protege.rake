namespace :protege do
  desc 'Import Industries and Sectors from Protege'
  task import: :environment do
    ProtegeImporter.new.import
  end
end
