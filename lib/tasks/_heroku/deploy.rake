Rake::Task['assets:clean'].enhance do
  if Rails.env.staging?
    begin
      puts 'Migrating the database'
      Rake::Task['db:migrate'].invoke
    rescue ActiveRecord::NoDatabaseError, PG::ConnectionBad => e
      puts e
    end
  end
end
