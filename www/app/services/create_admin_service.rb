class CreateAdminService

  def call
    user = User.new(email: "admin@your-server.net")
    @token = "p00pface"
    user.password = @token
    user.password_confirmation = @token
    user.authentication_token = @token
    user.admin = true
    user.approved = true
    user.name = "admin"
    user.username = "admin"
    user.role = "admin"
      if user.save
        puts "-- ADMIN CREATED --"
      end
    end
  end


