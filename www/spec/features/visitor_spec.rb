=begin

require 'rails_helper'
target_domain = "contactrocket.local"
target_link = "http://contactrocket.local/test.html"
random_email = FFaker::Internet.safe_email
crm_url = ["http://", ENV['CRM_HOST']].join
Sidekiq::Queue.new.clear
Sidekiq::RetrySet.new.clear
Sidekiq::ScheduledSet.new.clear
session = Capybara::Session.new(:selenium_chrome)

feature 'Visitor' do

    describe "without a subscription" do

      it 'can register' , :js => true do
        session.visit('/register')
        expect(session).to have_button('GET STARTED')
        session.fill_in("user_email", :with => random_email)
        session.click_button('GET STARTED')
        sleep 5
      end

      it 'can confirm account', :js => true do
        @user = User.find_by(:email => random_email)
        if @user
          session.visit("http://#{ENV['APP_HOST']}/users/confirmation?confirmation_token=#{@user.confirmation_token}")
        end
      end

      it "can target websites" , :js => true do
        session.visit('/dashboard')
        expect(session).to have_content('confirmed')
        expect(session).to have_button('OK')
        session.click_button("OK")
        session.fill_in("Paste any URL to download...", :with => "#{target_link}\n")
        session.find("button#target_submit_large").click
        expect(session).not_to have_content("LIMIT REACHED")
        puts ">> WAITING..."
        timer = 45
        timer.times do |x|
          sleep 1
          puts [(timer - x), "seconds..."]
        end
      end

      it 'has Cloud CRM', :js => true do
        session.visit([crm_url, "/"].join)
        expect(session).to have_content("Dashboard")
        expect(session).to have_content(random_email)
        session.visit([crm_url, "/leads"].join)
        expect(session).to have_content("Leads")
        session.visit("/phone_leads")
        expect(session).to have_content("Phone")
        expect(session).to have_content("NY")
        session.first("a.add_to_crm_link").click
        expect(session).to have_content("SUBSCRIBERS ONLY")
        session.visit("/social_leads")
        expect(session).to have_content("Social")
        expect(session).to have_content("contactrocket")
        session.first("a.add_to_crm_link").click
        expect(session).to have_content("SUBSCRIBERS ONLY")
        session.visit("/email_leads")
        expect(session).to have_content("Email")
        expect(session).to have_content("sales@your-server.net")
        session.first("a.add_to_crm_link").click
        expect(session).to have_content("SUBSCRIBERS ONLY")
      end

       it 'can upgrade plan', :js => true do
          plan = Plan.first
          session.visit("https://your-server.net/pricing")
          expect(session).to have_content(plan.name)
          session.visit("/koudoku/subscriptions/new?plan=#{plan.id}")
          expect(session).to have_button("Upgrade Your Account")
          session.execute_script "window.scrollBy(0,10000)"
          session.fill_in("cc_number", :with => "4242424242424242")
          session.fill_in("cc_month", :with => "04")
          session.fill_in("cc_year", :with => "2020")
          session.fill_in("cc_cvc", :with => "4242")
          session.click_button("Upgrade Your Account")
          expect(session).to have_content("upgraded")
       end

      it 'can logout', :js => true do
        session.visit("/logout")
        expect(session).to have_content("Login")
      end

    end


  describe "with a subscription" do

    it 'can login again', :js => true do
      @user = User.find_by(email: random_email)
      expect(@user).not_to eq(nil)
      expect(@user.subscription.plan).not_to eq(nil)
      session.visit("/login")
      expect(session).to have_button("Sign in")
      session.fill_in("user_email", :with => @user.email)
      session.fill_in("user_password", :with => @user.authentication_token)
      session.click_button("Sign in")
      sleep 3
    end

    it "can see lead counts" , :js => true do
      session.visit('/dashboard')
      email_count = session.find("#email_count")
      phone_count = session.find("#phone_count")
      social_count = session.find("#social_count")
      expect(phone_count).not_to have_content("0")
      expect(email_count).not_to have_content("0")
      expect(social_count).not_to have_content("0")
    end


    it 'can qualify leads', :js => true do
        session.visit("/phone_leads")
        expect(session).to have_content("Phone")
        expect(session).to have_content("NY")
        session.first("a.add_to_crm_link").click
        expect(session).to have_content("added")
        session.visit("/social_leads")
        expect(session).to have_content("Social")
        expect(session).to have_content("contactrocket")
        session.first("a.add_to_crm_link").click
        expect(session).to have_content("added")
        session.visit("/email_leads")
        expect(session).to have_content("Email")
        expect(session).to have_content("sales@your-server.net")
        session.first("a.add_to_crm_link").click
        expect(session).to have_content("added")
        session.visit([crm_url, "/"].join)
        expect(session).to have_content("Leads")
        session.visit([crm_url, "/leads"].join)
        expect(session).to have_content(target_domain)
    end

    it 'can search leads', :js => true do
      session.visit("/phone_leads?q=917")
      expect(session).to have_content("Phone")
      expect(session).to have_content("(917)")
      session.visit("/email_leads/?q=contactrocket.local")
      expect(session).to have_content("Email")
      expect(session).to have_content("bingo@your-server.net")
      session.visit("/social_leads/?q=contactrocket")
      expect(session).to have_content("Social")
      expect(session).to have_content("contactrocket")
      expect(session).to have_content("contactrocket.local")
    end

    it 'can logout', :js => true do
      session.visit("/logout")
      expect(session).to have_content("Login")
    end

  end
end



=end
