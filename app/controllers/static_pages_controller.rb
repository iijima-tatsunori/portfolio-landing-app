class StaticPagesController < ApplicationController
  require 'net/http'
  require 'open-uri'
  
  def top
    landing_url
  end
end
