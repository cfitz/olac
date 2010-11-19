require 'vendor/plugins/blacklight/app/helpers/application_helper.rb'
include Blacklight::SolrHelper
module ApplicationHelper


    def application_name
      'OLAC'
    end
  
  
  
  
  def render_item_facet_value(facet_solr_field, item, options ={})    
     link_to_unless(options[:suppress_link], item.value, add_facet_params_and_redirect(facet_solr_field, item.value), :class=>"facet_select") 
   end
   
   
   
   # used in the catalog/_facets partial
   def manifestation_facet_field_labels
     Blacklight.config[:facet_manifestations][:labels]
   end

   # used in the catalog/_facets partial
   def manifestation_facet_field_names
     Blacklight.config[:facet_manifestations][:field_names]
   end
   
   
   # used in the catalog/_index_partials/_default view
   def manifestation_index_field_names
     Blacklight.config[:manifestation_index_fields][:field_names]
   end

   # used in the _index_partials/_default view
   def manifestation_index_field_labels
     Blacklight.config[:manifestation_index_fields][:labels]
   end
   
   # used to generate a dummy link for the manifestation id
   def link_to_manifestaion(id)
       link = "http://www.worldcat.org/search?qt=worldcat_org_all&q=#{id.chomp}"
       "<a href=#{link}>#{h(id.gsub('manifestation_', ''))}</a>"
   end

   def get_manifestation_dl(color)
     "<dl class='defList_manifestation' id='#{color}' >"
   end
   
   
   # given a doc number and action_name, gets a document list of manifestations and renders a partial with
   # the list
   # if this value is blank (nil/empty) the "default" is used
   # if the partial is not found, the "default" partial is rendered instead  
   def render_manifestation_partial(doc, i, action_name)
      if( i%2 == 0) 
        color = "even"
      else 
       color = "odd"
      end
      
      
      format = document_partial_name(doc)
      begin
        render :partial=>"catalog/_#{action_name}_partials/#{format}", :locals=>{:mandoc=>doc, :color=>color}
      rescue ActionView::MissingTemplate

        render :partial=>"catalog/_#{action_name}_partials/manifestation.html.erb", :locals=>{:mandoc=>doc, :color=>color}
      end
    end
   
   
   
end