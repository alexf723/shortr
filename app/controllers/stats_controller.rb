class StatsController < ApplicationController
  
  def stats
    
    if !params[:short].nil?
      
      @clicks = Click.load_clicks( params[:short] ) 
      
      @os_stats = {}
      @date_stats = {}
      @browser_stats = {}
      @country_stats = {}
    
      @clicks.each{ |click|
        add_count_to_hash( @os_stats, click.platform )
        add_count_to_hash( @browser_stats, click.browser )
        add_count_to_hash( @country_stats, click.country )
        puts click.time.to_s
        date = DateTime.strptime(click.time.to_s,'%s').strftime "%b-%d-%Y"
        add_count_to_hash( @date_stats, date )
      }
      
    end
    
  end
  
  def add_count_to_hash( hash, key )
    if hash.has_key? key
      hash[key] = hash[key] + 1
    else
      hash[key] = 1
    end
  end
  
end
