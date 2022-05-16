class ScoreWorker
  include Sidekiq::Worker
  sidekiq_options   :queue => 'score', :retry => false, :backtrace => true, expires_in: 1.hour

def perform(email)
  {
      twitter_followers_weight:   0.05,
      angellist_followers_weight: 0.05,
      klout_score_weight:         0.05,
      company_twitter_followers_weight: 0.05,
      company_alexa_rank_weight:  0.000005,
      company_google_rank_weight: 0.05,
      company_employees_weight:   0.5,
      company_raised_weight:      0.0000005,
      company_score:              10,
      total_score:                1415
  }
end

end
