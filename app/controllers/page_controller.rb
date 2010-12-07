class PageController < ApplicationController

 include Blacklight::SolrHelper

  def show
   
   puts params.inspect
   
  end
  
end