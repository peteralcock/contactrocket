
class TextWorker
  @@wl = WhatLanguage.new(:all)
  @@tgr = EngTagger.new


  def self.post(url, path, body={})
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(path)
    request.add_field('Content-Type', 'application/json')
    request.body =  body.to_json
    response = http.request(request)
    response.body
  end



  def self.analyze_text(text)
  if text
    hash = {}
    tagged = @@tgr.add_tags(text)
    hash[:word_list] =  @@tgr.get_words(text)
    hash[:nouns] = @@tgr.get_nouns(tagged)
    hash[:proper_nouns] = @@tgr.get_proper_nouns(tagged)
    hash[:past_tense_verbs] = @@tgr.get_past_tense_verbs(tagged)
    hash[:adjectives] =  @@tgr.get_adjectives(tagged)
    hash[:noun_phrases] = @@tgr.get_noun_phrases(tagged)
    hash[:language] = @@wl.language(text)
    hash[:languages_ranked] = @@wl.process_text(text)
    hash[:profanity] = SadPanda.polarity (text)
    hash[:emotion] = SadPanda.emotion (text)
    hash[:reading_level] = Odyssey.coleman_liau (text)
    return hash
  else 
    return false
  end
end


def self.analyze_entities(text)
  if text
    entities = @@ner.perform(text)
    if entities
      return entities
    else
      return false
    end
  end
end



def self.analyze_name(first_name, last_name)
  if first_name and last_name
    hash = {}
    hash[:gender] = Guess.gender(first_name.to_s.humanize)
    hash[:ethnicity] = $races[last_name.to_s.upcase]
    hash[:name] = [first_name, last_name].join(" ")
    return hash
  else
    return false
  end
end



end
