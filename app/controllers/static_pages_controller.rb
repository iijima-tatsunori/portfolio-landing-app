class StaticPagesController < ApplicationController
  
  def top
    @days = %w[今日 明日 明後日]
    @times =  %w[00-06 06-12 12-18 18-24]
    
    landing_url
  end
end
