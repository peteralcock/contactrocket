Capybara.default_wait_time = 5

Capybara.javascript_driver = :webkit
Capybara.default_driver = :selenium

Capybara.app_host = "http://#{ENV['APP_HOST']}"
Capybara.run_server = false

Capybara.register_driver :selenium_firefox do |app|
  Capybara::Selenium::Driver.new(app, :browser => :firefox)
end

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end


Capybara.current_driver = :selenium_chrome
#Capybara.current_driver = :selenium_firefox





