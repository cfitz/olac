require 'vendor/plugins/blacklight/app/helpers/application_helper.rb'
module ApplicationHelper


    def application_name
      'OLAC'
    end
  end
  
  
  
  def render_item_facet_value(facet_solr_field, item, options ={})    
     link_to_unless(options[:suppress_link], item.value, add_facet_params_and_redirect(facet_solr_field, item.value), :class=>"facet_select") 
   end