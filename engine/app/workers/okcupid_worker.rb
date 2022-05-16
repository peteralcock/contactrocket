class OkcupidWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  include Sidekiq::Benchmark::Worker

  sidekiq_options :queue => 'okcupid', :retry => false, :backtrace => true


  def perform(usernames=[])
      urls = []
      @profiles = []
      @addresses = []
      @numbers = []

      @current_user = User.find(10)
      usernames.each do |username|
        urls << "https://2-instant.okcupid.com/profile/#{username}"
      end

      @logger = Logger.new(STDOUT)
      @storage = nil
      @options = {
          :redis_options => {
              :host => 'localhost',
              :driver => 'hiredis',
              :db => 11},
          :depth_limit => 2,
          :discard_page_bodies => false,
          # HTTP read timeout in seconds
          :read_timeout => 30,
          # HTTP open connection timeout in seconds
          :open_timeout => 10,
          :obey_robots_txt => false,
          :logger => @logger,
          :skip_query_strings => false,
          :user_agent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9) AppleWebKit/537.71 (KHTML, like Gecko) Version/7.0 Safari/537.71",
          :enable_signal_handler => false,
          :workers => 5,
          :redirect_limit => 2,
          :storage => @storage
      }
 
       Polipus.crawler(job_id, urls, @options) do |crawler|

        crawler.skip_links_like(/\/versions\//)
        crawler.skip_links_like(/\.pdf$/)
        crawler.skip_links_like(/\.zip$/)
        crawler.skip_links_like(/\.jpg$/)
        crawler.skip_links_like(/\.png$/)
        crawler.skip_links_like(/\.PDF$/)
        crawler.skip_links_like(/\.JPG$/)
        crawler.skip_links_like(/\.PNG$/)
        crawler.skip_links_like(/\.GIF$/)
        crawler.skip_links_like(/\.EXE$/)
        crawler.skip_links_like(/\.gif$/)
        crawler.skip_links_like(/\.exe$/)
        crawler.skip_links_like(/\.mpg$/)
        crawler.skip_links_like(/\.avi$/)
        crawler.skip_links_like(/\.mp4$/)
        crawler.skip_links_like(/\.mpeg$/)
        crawler.skip_links_like(/\/images\//)

        crawler.on_page_downloaded do |crawled_page|
          if crawled_page.success? and crawled_page.body

            profile = SocialLead.new(:user_id => 10, :social_network => "okcupid",
                                     :username=> crawled_page.url.split("/profile/").last)
            profile.save
            body_text = crawled_page.body.force_encoding('UTF-8') || crawled_page.body

            if body_text

              # Phone Numbers
              body_text.scan(/\(?([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{4})/).each do |phone_number|
                if phone_number
                  phone_number = phone_number.to_s.scan(/\d/).join
                  @numbers << [phone_number, crawled_page.url]
                end
              end

              # Email Addresses
              body_text.scan(/[\w\d]+[\w\d.-]@[\w\d.-]+\.\w{2,6}/).each do |address|
                if address
                  @addresses << [address.to_s.downcase, crawled_page.url]
                end
              end

              # LinkedIn Profiles
              [body_text.scan(/(?<=linkedin.com\/in\/)[a-z0-9_-]{3,16}/), body_text.scan(/(?<=www.linkedin.com\/in\/)[a-z0-9_-]{3,16}/), body_text.scan(/(?<=www.linkedin.com\/pub\/)[a-z0-9_-]{3,16}/), body_text.scan(/(?<=linkedin.com\/pub\/)[a-z0-9_-]{3,16}/), body_text.scan(/(?<=linkedin.com\/in\/)[a-z0-9_-]{3,16}/)].flatten.each do |linkedin|
                if linkedin
                  @profiles << ["http://linkedin.com/in/#{linkedin.downcase}", crawled_page.url]
                end
              end

              # Google+ Profiles
              body_text.scan(/(?<=plus.google.com\/)[a-z0-9_-]{3,16}/).each do |googleplus|
                if googleplus
                  @profiles << ["http://plus.google.com/+#{googleplus.downcase}", crawled_page.url]
                end
              end

              # Instagram Profiles
              body_text.scan(/(?<=instagram.com\/)[a-z0-9_-]{3,16}/).each do |instagram|
                if instagram
                  @profiles << ["http://instagram.com/#{instagram.downcase}", crawled_page.url]
                end
              end

              # Pinterest Profiles
              body_text.scan(/(?<=pinterest.com\/)[a-z0-9_-]{3,16}/).each do |pinterest|
                if pinterest
                  @profiles << ["http://pinterest.com/#{pinterest.downcase}", crawled_page.url]
                end
              end

              # Github Profiles
              body_text.scan(/github\.com(?:\/\#!)?\/(\w+)/i).each do |github|
                if github
                  @profiles << ["http://github.com/#{github.join.downcase}", crawled_page.url]
                end
              end

              # Twitter Profiles
              body_text.scan(/twitter\.com(?:\/\#!)?\/(\w+)/i).each do |twitter|
                if twitter and !twitter.join.match(".php")
                  @profiles << ["http://twitter.com/#{twitter.join.downcase}", crawled_page.url]
                end
              end

              # Facebook Profiles
              body_text.scan(/(?:https?:\/\/)?(?:www\.)?facebook\.com\/(?:(?:\w)*#!\/)?(?:pages\/)?(?:[\w\-]*\/)*([\w\-\.]*)/).each do |facebook|
                if facebook and !facebook.to_s.match(".php")
                  @profiles << ["http://facebook.com/#{facebook.join.downcase}", crawled_page.url]
                end
              end
          end
          end
        end

        crawler.on_crawl_end do
          unless @addresses.empty? and @profiles.empty? and @numbers.empty?
            @addresses.uniq! { |a| a.first }
            @profiles.uniq! { |p| p.first }
            @numbers.uniq! { |n| n.first }
            LeadWorker.perform_async(@addresses, @numbers, @profiles, @current_user.id, 1, "okcupid.com")
          end
        end
      end
    end
  end






