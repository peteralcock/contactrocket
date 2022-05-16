
require 'rubydns'
require 'rubydns/system'
class DnsWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false, :backtrace => true

  def perform(domains=[])

    return false if domains.blank?

    resolver = RubyDNS::Resolver.new(RubyDNS::System::nameservers)
    dead = []
    alive = []

    EventMachine::run do

      domains.each do |domain|
        resolver.query(domain) do |response|
          if response.answer.blank?
            dead << domain
          else
            alive << domain
          end
        end
      end

      EventMachine::stop

    end

    results = {}
    results[:dead] = dead
    results[:alive] = alive
    results

  end
end

