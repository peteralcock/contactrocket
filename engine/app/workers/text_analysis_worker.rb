require 'sad_panda'
require 'odyssey'
require 'engtagger'
require 'whatlanguage'
require 'json'

class TextAnalysisWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  include Sidekiq::Benchmark::Worker

  sidekiq_options :queue => 'default', :retry => false, :backtrace => true, expires_in: 1.hour


  @@wl = WhatLanguage.new(:all)
  @@tgr = EngTagger.new

  
  def perform(record_id, klass)

    benchmark.text_analysis_metric do

      record = nil
      if klass == "EmailLead"
        record = EmailLead.find(record_id)
      elsif klass == "PhoneLead"
        record = PhoneLead.find(record_id)
      elsif klass == "SocialLead"
        record = SocialLead.find(record_id)
      end


    if record and record.page_text
      
        hash = {}
        tagged = @@tgr.add_tags record.page_text
        hash[:word_list] =  @@tgr.get_words record.page_text
        hash[:nouns] = @@tgr.get_nouns(tagged)
        hash[:proper_nouns] = @@tgr.get_proper_nouns(tagged)
        hash[:past_tense_verbs] = @@tgr.get_past_tense_verbs(tagged)
        hash[:adjectives] =  @@tgr.get_adjectives(tagged)
        hash[:noun_phrases] = @@tgr.get_noun_phrases(tagged)
        hash[:language] = @@wl.language record.page_text
        hash[:languages_ranked] = @@wl.process_text record.page_text
        hash[:profanity] = SadPanda.polarity record.page_text
        hash[:emotion] = SadPanda.emotion record.page_text
        hash[:reading_level] = Odyssey.coleman_liau record.page_text
        names = text.scan(/([A-Z][a-z]+(?=\s[A-Z])(?:\s[A-Z][a-z]+)+)/)
        hash[:names] = names.to_s

        if names
          begin
          names.flatten!
          names.uniq!
          names.each do |name|
            first_name = name.split(" ").first
            last_name = name.split(" ").last
            gender = Guess.gender(first_name.to_s.humanize)
            ethnicity = $races[last_name.to_s.upcase]
            if gender or ethnicity
              person = Person.find_or_initialize_by(:first_name => first_name.humanize, :last_name => last_name.humanize)
              unless person.gender or person.ethnicity
                person.gender = gender.to_s
                person.ethnicity = ethnicity.to_s
                person.save
              end
            end
          end
          rescue
            #ignore
          end

        end

        record.update(:page_json => hash.to_json)

    end
    end
    benchmark.finish

  end
end




