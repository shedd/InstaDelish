require 'rss/2.0'
require 'open-uri'
require 'www/delicious'

class FlaggedController < ApplicationController

  def index
    #make sure form data provided
    unless params[:username].nil? or params[:password].nil? or params[:flagged_feed].nil?
      #trigger the delicious import
      @items = self.post_new_items(params[:username],params[:password],params[:flagged_feed])
    else
      #load the default form
    end

  end
  
  def post_new_items(username,password,flagged_feed)
    # create a new instance with given username and password
    d = WWW::Delicious.new(username,password)

    begin
      logger.info 'now parsing: ' + flagged_feed
      new_items = self.posts_for(flagged_feed)#parse the instapaper feed
    rescue
      raise Exception.new("Invalid URL: must be an XML feed.")
    end

    logger.info 'loading # items: ' + new_items.items.length.to_s
    #counter for links added
    added = new_items.items.length

    #loop for new items
    new_items.items.each do |new_i|
      logger.info 'loading ' + new_i.link
      
      #get delicious bookmark with current url - is there one?
      ex_bmark = d.posts_get(:url => new_i.link)
      
      logger.info 'account has this many links with that url: ' + ex_bmark.length.to_s
      
      unless ex_bmark.length > 0 #make sure there isn't already an existing bookmark
        # post the item to delicious
        d.posts_add(:url => new_i.link, :title => new_i.title)
        logger.info new_i.link + ' loaded'
      else
        logger.info new_i.link + ' EXISTS!'
        added = added - 1
      end
    end #end new_items.each
    
    #return the number of items parsed
    return added
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