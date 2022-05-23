#require 'sidekiq/testing'
#require 'sidekiq/testing/inline'
#require 'sidekiq-status/testing/inline'

#Sidekiq::Testing.inline!

# or use block mode to avoid switching global state
# Sidekiq::Testing.inline! do
#   SpiderWorker.perform_async
#   assert_worked_hard
# end