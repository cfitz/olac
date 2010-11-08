# You can configure Blacklight from here. 
#   
#   Blacklight.configure(:environment) do |config| end
#   
# :shared (or leave it blank) is used by all environments. 
# You can override a shared key by using that key in a particular
# environment's configuration.
# 
# If you have no configuration beyond :shared for an environment, you
# do not need to call configure() for that environment.
# 
# For specific environments:
# 
#   Blacklight.configure(:test) {}
#   Blacklight.configure(:development) {}
#   Blacklight.configure(:production) {}
# 

Blacklight.configure(:shared) do |config|
  
  # default params for the SolrDocument.search method
  SolrDocument.default_params[:search] = {
    :qt=>:search,
    :per_page => 10,
    :facets => {:fields=>
      [ "worktitle_facet",
        "date_facet",
        "countryname_facet",
        "directorname_facet",
        "format_facet",
        "genrename_facet",
        "langname_facet",
        "alttitlename_facet"
        ]
    }  
  }
  
  # default params for the SolrDocument.find_by_id method
  SolrDocument.default_params[:find_by_id] = {:qt => :document}
  

  
  ##############################
  
  
  config[:default_qt] = "search"
  

  # solr field values given special treatment in the show (single result) view
  config[:show] = {
    :html_title => "worktitle_t",
    :heading => "worktitle_t",
     :display_type => "format_t"
  }

  # solr fld values given special treatment in the index (search results) view
  config[:index] = {
    :show_link => "worktitle_display",
    :num_per_page => 10,
    :record_display_type => "format"
  }

  # solr fields that will be treated as facets by the blacklight application
  #   The ordering of the field names is the order of the display 
  config[:facet] = {
    :field_names => [
      "worktitle_facet",
        "date_facet",
        "countryname_facet",
        "directorname_facet",
        "format_facet",
        "genrename_facet",
        "langname_facet",
        "alttitlename_facet"
      ],
    :labels => {
      "worktitle_facet" => "Title",
        "date_facet"=> "Date",
        "countryname_facet" => "Country",
        "directorname_facet" => "Director",
        "format_facet" => "Format",
        "genrename_facet" => "Genre",
        "langname_facet" => "Language",
        "alttitlename_facet" => "Alternate Title"
    },
    :limits=> {nil=>10}
  }

  # solr fields to be displayed in the index (search results) view
  #   The ordering of the field names is the order of the display 
  config[:index_fields] = {
    :field_names => [
      "date_display",
      "worktitle_display",
      "format_display",
      ],
    :labels => {
      "date_display"=>"Date",
      "worktitle_display"=>"Title",
      "format_display"=>"Format"
    }
  }

  # solr fields to be displayed in the show (single result) view
  #   The ordering of the field names is the order of the display 
  config[:show_fields] = {
    :field_names => [
      "worktitle_display",
        "date_display",
        "countryname_display",
        "directorname_display",
        "format_display",
        "genrename_display",
        "langname_display",
        "alttitlename_disaply",
    ],
    :labels => {
       "worktitle_display" => "Title",
          "date_display"=> "Date",
          "countryname_display" => "Country",
          "directorname_display" => "Director",
          "format_display" => "Format",
          "genrename_display" => "Genre",
          "langname_display" => "Language",
          "alttitlename_display" => "Alternate Title",
    }
  }

# FIXME: is this now redundant with above?
  # type of raw data in index.  Currently marcxml and marc21 are supported.
  config[:raw_storage_type] = "marc21"
  # name of solr field containing raw data
  config[:raw_storage_field] = "marc_display"

  # "fielded" search select (pulldown)
  # label in pulldown is followed by the name of a SOLR request handler as 
  # defined in solr/conf/solrconfig.xml
  config[:search_fields] ||= []
  config[:search_fields] << ['All Fields', 'search']
  #config[:search_fields] << ['Descriptions and full text', 'fulltext']
  
  # "sort results by" select (pulldown)
  # label in pulldown is followed by the name of the SOLR field to sort by and
  # whether the sort is ascending or descending (it must be asc or desc
  # except in the relevancy case).
  # label is key, solr field is value
  config[:sort_fields] ||= []
  config[:sort_fields] << ['relevance', 'score desc, year_facet desc, month_facet asc, title_facet asc']
  config[:sort_fields] << ['date -', 'year_facet desc, month_facet asc, title_facet asc']
  config[:sort_fields] << ['date +', 'year_facet asc, month_facet asc, title_facet asc']
  config[:sort_fields] << ['title', 'title_facet asc']
  config[:sort_fields] << ['document type', 'medium_t asc, year_facet desc, month_facet asc, title_facet asc']
  config[:sort_fields] << ['location', 'series_facet asc, box_facet asc, folder_facet asc, year_facet desc, month_facet asc, title_facet asc']
  
  # If there are more than this many search results, no spelling ("did you 
  # mean") suggestion is offered.
  config[:spell_max] = 5
  
  # number of facets to show before adding a more link
  config[:facet_more_num] = 10
end