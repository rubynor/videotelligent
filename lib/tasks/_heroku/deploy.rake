Rake::Task['assets:clean'].enhance do
  if Rails.env.staging?
    puts 'Migrating the database'
    Rake::Task['db:migrate'].invoke
  end
end
