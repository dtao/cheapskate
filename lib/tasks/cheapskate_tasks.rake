namespace :cheapskate do
  desc 'Check if everything is set up properly for Cheapskate to work'
  task :check => :environment do
    puts "Checking Cheapskate..."
    puts "#{SingleUseLogin.table_name} doesn't exist!" if !SingleUseLogin.table_exists?
    puts "#{SingleUseNotice.table_name} doesn't exist!" if !SingleUseNotice.table_exists?
  end
end
