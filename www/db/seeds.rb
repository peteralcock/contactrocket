ActiveMedian.create_function

begin
if Plan.count < 1
  ActiveMedian.create_function
  CreatePlanService.new.call
  CreateSearchService.new.call
  CreateAdminService.new.call
end
rescue
  # ignore seeding errors
end

if GlobalSettings.count < 1
  GlobalSettings.create(
      command_apache_restart: 'sudo /etc/init.d/apache2 reload',
      command_apache_status: '/etc/init.d/apache2 status'
  )
end

# create admin account with default password if it does not exist
admin = User.find_by(username: "admin")
unless admin.present?
  User.create(
      username: "admin",
      name: "admin",
      password: "password",
      password_confirmation: "password",
      email: "admin@your-server.net",
      approved: true
  )
end

