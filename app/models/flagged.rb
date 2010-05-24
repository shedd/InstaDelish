require 'rss/2.0'
require 'open-uri'
require 'www/delicious'

class Flagged < ActiveRecord::Base
  #has_and_belongs_to_many :users
  #has_and_belongs_to_many :usergroups
  #has_many :articles

  #validates_presence_of :name, :url
  #validates_uniqueness_of :url
  
  def post_new_items(username,password,flagged_feed)
    # create a new instance with given username and password
    d = WWW::Delicious.new(username,password)

    #flagged_feed = "http://www.instapaper.com/starred/rss/541434/gEAFiajKd9U0GSKv0fyKpSNoOA"

    begin
      new_items = self.posts_for(flagged_feed)#parse the instapaper feed
    rescue
      raise Exception.new("Invalid URL: must be an XML feed.")
    end
    
    #loop for new items
    new_items.items.each do |new_i|

      is_new = true   #allow each article to start off as a new article unless otherwise detected
      #unless self.articles.nil? #make sure there are articles to check against
      #  #check articles already in db
      #  self.articles.each do |a|
      #    if new_a.title == a.title
      #      is_new = false
      #    end
      #  end
      #end
      #if the item is new, add it
      if is_new
        # post the item to delicious
        d.posts_add(:url => new_i.title, :title => new_i.link)
      end #end of new item scope
    end #end new_items.each
  end

  def posts_for(feed_url)

    content = "" # raw content of rss feed will be loaded here

    open(feed_url) do |f|
      content = f.read 
    end
    
    posts = RSS::Parser.parse(content, false)

    return posts
  end

end