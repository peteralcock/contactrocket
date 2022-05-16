require 'objspace'
class SpiderWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  include Sidekiq::Benchmark::Worker


  sidekiq_options :queue => 'crawler', :retry => false, :backtrace => true, expires_in: 1.hour #, throttle: { threshold: 10, period: 1.minute, key: ->(user_id){ user_id } }


  def perform(url, user_id, job_id)
    benchmark.spider_metric do

      @max_pages = 1000
      total @max_pages
      @profiles = []
      @addresses = []
      @numbers = []
      @original_url = url
      @pages = 0
      @current_user = User.find(user_id)
      @end_time = Time.now + 15.minutes

      if @current_user
        #if @current_user.websites.count > @current_user.max_targets
        #  return "[ERROR]  Max reached for user #{user_id}"
        #else
        @current_user.active_engines.incr
        @current_user.job_ids << job_id
        #end
      else
        return "[ERROR] User #{user_id} does not exist"
      end

      url.gsub!(" ", "")
      uri = URI.parse(url)
      @original_domain = uri.host || url.rpartition("://")[2].rpartition("/")[0]
      @website = Website.find_or_initialize_by(:domain => @original_domain, :user_id => user_id)
      @website.url = url
      @website.save
      @logger = Logger.new(STDOUT)

      @client = Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL'], logger: @logger)
      @client.transport.logger.level = Logger::WARN
      if @current_user and @current_user.admin == true
        @storage = Polipus::Storage::ElasticSearchStore.new(
            @client,
            refresh: true
        )
        @storage.include_query_string_in_uuid = true
      else
        @storage = nil
      end



      @options = {
          :redis_options => {
              :host => 'localhost',
              :driver => 'hiredis',
              :db => 11},
          :depth_limit => 4,
          :discard_page_bodies => false,
          # HTTP read timeout in seconds
          :read_timeout => 10,
          # HTTP open connection timeout in seconds
          :open_timeout => 10,
          :obey_robots_txt => false,
          :logger => @logger,
          :skip_query_strings => false,
          :user_agent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9) AppleWebKit/537.71 (KHTML, like Gecko) Version/7.0 Safari/537.71",
          :enable_signal_handler => false,
          :workers => 4,
          :redirect_limit => 4,
          # :ttl => 900,
          :storage => @storage
      }




      Polipus.crawler(job_id, url, @options) do |crawler|

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
          @current_user.mileage.increment
          @current_user.pages_crawled.add crawled_page.url

          @pages += 1
          at @pages, "#{crawled_page.url}"
          if crawled_page.success?
            # @current_user.bandwidth_used.incr(ObjectSpace.memsize_of(crawled_page.body))
            if crawled_page.doc and crawled_page.doc.at('body')
              body_text = crawled_page.doc.at('html').text
            else
              body_text = crawled_page.body.to_s.force_encoding('UTF-8') || crawled_page.body.to_s
            end
            if body_text


              # Phone
              body_text.scan(/\(?([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{4})/).each do |phone_number|
                if phone_number
                  phone_number = phone_number.to_s.scan(/\d/).join
                  @numbers << [phone_number, crawled_page.url]
                  # @current_user.notifications.add ["Phone: #{phone_number}", @original_domain]
                end
              end

              # Email
              body_text.scan(/[\w\d]+[\w\d.-]@[\w\d.-]+\.\w{2,6}/).each do |address|
                if address
                  @addresses << [address.to_s.downcase, crawled_page.url]
                  # @current_user.notifications.add ["Email: #{address.to_s.downcase}", @original_domain]
                end
              end

              # Twitter
              body_text.scan(/twitter\.com(?:\/\#!)?\/(\w+)/i).each do |twitter|
                if twitter and !twitter.join.match(".php")
                  @profiles << ["http://twitter.com/#{twitter.join.downcase}", crawled_page.url]
                  # @current_user.notifications.add ["Twitter: #{twitter.join.downcase}", @original_domain]
                end
              end

              # Facebook
              body_text.scan(/(?:https?:\/\/)?(?:www\.)?facebook\.com\/(?:(?:\w)*#!\/)?(?:pages\/)?(?:[\w\-]*\/)*([\w\-\.]*)/).each do |facebook|
                if facebook and !facebook.to_s.match(".php")
                  @profiles << ["http://facebook.com/#{facebook.join.downcase}", crawled_page.url]
                  # @current_user.notifications.add ["Facebook: #{facebook.join.downcase}", @original_domain]
                end
              end

              # LinkedIn
              [body_text.scan(/(?<=linkedin.com\/in\/)[a-z0-9_-]{3,16}/), body_text.scan(/(?<=www.linkedin.com\/in\/)[a-z0-9_-]{3,16}/), body_text.scan(/(?<=www.linkedin.com\/pub\/)[a-z0-9_-]{3,16}/), body_text.scan(/(?<=linkedin.com\/pub\/)[a-z0-9_-]{3,16}/), body_text.scan(/(?<=linkedin.com\/in\/)[a-z0-9_-]{3,16}/)].flatten.each do |linkedin|
                if linkedin
                  @profiles << ["http://linkedin.com/in/#{linkedin.downcase}", crawled_page.url]
                  # @current_user.notifications.add ["LinkedIn: #{linkedin.downcase}", @original_domain]
                end
              end

              # Google+
              body_text.scan(/(?<=plus.google.com\/)[a-z0-9_-]{3,16}/).each do |googleplus|
                if googleplus
                  @profiles << ["http://plus.google.com/+#{googleplus.downcase}", crawled_page.url]
                  #  @current_user.notifications.add ["Google+: #{googleplus.downcase}", @original_domain]
                end
              end

              # Instagram
              body_text.scan(/(?<=instagram.com\/)[a-z0-9_-]{3,16}/).each do |instagram|
                if instagram
                  @profiles << ["http://instagram.com/#{instagram.downcase}", crawled_page.url]
                  # @current_user.notifications.add ["Instagram: #{instagram.downcase}", @original_domain]
                end
              end

              # Pinterest
              body_text.scan(/(?<=pinterest.com\/)[a-z0-9_-]{3,16}/).each do |pinterest|
                if pinterest
                  @profiles << ["http://pinterest.com/#{pinterest.downcase}", crawled_page.url]
                  #  @current_user.notifications.add ["Pinterest: #{pinterest.downcase}", @original_domain]
                end
              end

              # Github
              [body_text.scan(/(?<=github.com\/user\/)[a-z0-9_-]{3,16}/), body_text.scan(/(?<=www.github.com\/user\/)[a-z0-9_-]{3,16}/)].flatten.each do |username|
                if username
                  @profiles << ["http://github.com/#{username.downcase}", crawled_page.url]
                  # @current_user.notifications.add ["GitHub: #{username.downcase}", @original_domain]
                end
              end


              # Vimeo
              body_text.scan(/vimeo\.com(?:\/\#!)?\/(\w+)/i).each do |vimeo|
                if vimeo
                  @profiles << ["http://vimeo.com/#{vimeo.join.downcase}", crawled_page.url]
                  # @current_user.notifications.add ["Vimeo: #{vimeo.join.downcase}", @original_domain]
                end
              end


              # # lastfm
              # [body_text.scan(/(?<=lastfm.com\/user\/)[a-z0-9_-]{3,16}/), body_text.scan(/(?<=www.lastfm.com\/user\/)[a-z0-9_-]{3,16}/)].flatten.each do |username|
              #   if username
              #     @profiles << ["http://lastfm.com/user/#{username.downcase}", crawled_page.url]
              #     @current_user.notifications.add ["LastFM: #{username.downcase}", @original_domain]
              #   end
              # end

              # Stumbleupon
              #   body_text.scan(/stumbleupon\.com(?:\/\#!)?\/(\w+)/i).each do |stumbleupon|
              #     if stumbleupon
              #       @profiles << ["http://stumbleupon.com/#{stumbleupon.join.downcase}", crawled_page.url]
              #       @current_user.notifications.add ["StumbleUpon: #{stumbleupon.join.downcase}", @original_domain]
              #     end
              #   end

              # Flickr
              #    body_text.scan(/flickr\.com(?:\/\#!)?\/(\w+)/i).each do |username|
              #      if username
              #        @profiles << ["http://flickr.com/#{username.join.downcase}", crawled_page.url]
              #        @current_user.notifications.add ["Flicker: #{username.downcase}", @original_domain]
              #      end
              #    end

              # Foursquare
              #    [body_text.scan(/(?<=foursquare.com\/user\/)[a-z0-9_-]{3,16}/), body_text.scan(/(?<=www.foursquare.com\/user\/)[a-z0-9_-]{3,16}/)].flatten.each do |username|
              #      if username
              #        @profiles << ["http://foursquare.com/user/#{username.downcase}", crawled_page.url]
              #        @current_user.notifications.add ["Foursquare: #{username.downcase}", @original_domain]
              #      end
              #    end

              # SoundCloud
              #      body_text.scan(/soundcloud\.com(?:\/\#!)?\/(\w+)/i).each do |soundcloud|
              #        if soundcloud
              #          @profiles << ["http://soundcloud.com/#{soundcloud.join.downcase}", crawled_page.url]
              #          @current_user.notifications.add ["SoundCloud: #{soundcloud.join.downcase}", @original_domain]
              #        end
              #      end

              # Meetup
              #       [body_text.scan(/(?<=meetup.com\/members\/)[a-z0-9_-]{3,16}/), body_text.scan(/(?<=www.meetup.com\/members\/)[a-z0-9_-]{3,16}/)].flatten.each do |meetup|
              #         if meetup
              #           @profiles << ["http://meetup.com/members/#{meetup.downcase}", crawled_page.url]
              #           @current_user.notifications.add ["Meetup: #{meetup.downcase}", @original_domain]
              #         end
              #       end

              # Reddit
              #   [body_text.scan(/(?<=reddit.com\/user\/)[a-z0-9_-]{3,16}/), body_text.scan(/(?<=www.reddit.com\/user\/)[a-z0-9_-]{3,16}/)].flatten.each do |reddit|
              #     if reddit
              #       @profiles << ["http://reddit.com/user/#{reddit.downcase}", crawled_page.url]
              #       @current_user.notifications.add ["Reddit: #{reddit.downcase}", @original_domain]
              #     end
              #   end


            end
          end
        end

        crawler.on_crawl_end do
          unless @addresses.empty? and @profiles.empty? and @numbers.empty?
            @addresses.uniq! { |a| a.first }
            @profiles.uniq! { |p| p.first }
            @numbers.uniq! { |n| n.first }
            LeadWorker.perform_async(@addresses, @numbers, @profiles, @current_user.id, @website.id, @original_domain)
          end
          @current_user.job_ids.delete job_id
          @current_user.active_engines.decr
        end
      end
    end

    benchmark.finish
  end
end






