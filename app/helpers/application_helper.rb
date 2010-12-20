require 'vendor/plugins/blacklight/app/helpers/application_helper.rb'
include Blacklight::SolrHelper
module ApplicationHelper


    def application_name
      'OLAC Work-Centric Moving Image Discovery Interface Prototype'
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
   def link_to_manifestaion(mandoc)
       link = "/page/search"
       if mandoc["libname_display"].length > 1
         libs = "<div class='manLib'><label>Libraries:</label>"
         mandoc["libname_display"].each do |l|
           libs << "<a href=#{link}>#{l}</a> , "
         end
         libs.chop!
         libs << "</div>"
        else
          libs = "<div class='manLib'><label>Library:</label><a href=#{link}>#{mandoc["libname_display"].first}</a></div>"
        end 
        "<div class='manFormat'>#{h(mandoc.get "format_display")} (#{h(mandoc.get "date_display")})</div>#{libs}"
   end

   def get_manifestation_dl(color)
     "<div id='#{color}' >"
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
   
   
   
    # link_to_document(doc, :label=>'VIEW', :counter => 3)
    # Use the catalog_path RESTful route to create a link to the show page for a specific item. 
    # catalog_path accepts a HashWithIndifferentAccess object. The solr query params are stored in the session,
    # so we only need the +counter+ param here.
    def link_to_document(doc, opts={:label=>"show all items", :counter => nil})
      label = case opts[:label]
      when Symbol
        doc.get(opts[:label])
      when String
        opts[:label]
      else
        raise 'Invalid label argument'
      end
      #link_to_with_data(label, catalog_path(doc[:id]), {:method => :put, :data => {:counter => opts[:counter]}})
      return ""
    end
    
    
    
    
    # :suppress_link => true # do not make it a link, used for an already selected value for instance
     def link_to_document_query(doc, options={:label=>Blacklight.config[:index][:show_link].to_sym})
        label = case options[:label]
         when Symbol
           doc.get(options[:label])
         when String
           options[:label]
         else
           raise 'Invalid label argument'
         end   
       if params[:f].nil? or params[:f]['worknum_s'].nil? 
         link_to_unless(options[:suppress_link], label, add_facet_params_and_redirect("worknum_s", doc["id"])) 
       else
          doc["worktitle_display"]
       end
     end
   
     # link_back_to_catalog(:label=>'Back to Search')
     # Create a link back to the index screen, keeping the user's facet, query and paging choices intact by using session.
     def link_back_to_catalog(opts={:label=>'Back to Search'})
       if session[:search].nil?
         query_params = {}
       else
         query_params = session[:search].dup || {}
       end
       query_params.delete :counter
       query_params.delete :total
       link_url = catalog_index_path(query_params)
       link_to opts[:label], link_url
     end
   
end