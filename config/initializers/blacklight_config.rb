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
  config[:manifestations_qt] = "manifestations_search"

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
  #   usually , The ordering of the field names is the order of the display 
  # however, we are overriding this in the app/catalog/facets paritals
  config[:facet] = {
    :field_names => [
       "genrename_facet",  
        "workdate_facet",
        "worklang_facet",
        "countryname_facet",
        "directorname_facet",
      ],
    :labels => {
        "genrename_facet" => "Genre:",
        "workdate_facet" => "Dates:",
        "worklang_facet" => "Original Language:",
        "countryname_facet" => "Country:",
        "directorname_facet" => "Director:",
    },
    :limits=> {nil=>10}
  }
  
  
  config[:facet_manifestations] = {
    :field_names => [
      "libname_facet",
      "format_facet",
      "pubdate_facet",
      "langname_facet",
      "subtitlelang_facet",
       "accessibility_facet"
      ],
    :labels => {
      "libname_facet" => "At Library:",
       "format_facet" => "Format:",
       "pubdate_facet" => "Publication Date:",
      "langname_facet" => "Spoken Language:",
        "subtitlelang_facet"=> "Subtitle/Caption Language:",
        "accessibility_facet" => "Accessibility Options:"
    },
    :limits=> {nil=>10}
  }





  # solr fields to be displayed in the index (search results) view
  #   The ordering of the field names is the order of the display 
  config[:index_fields] = {
    :field_names => [
      "alttitlename_display",
       "largerworks_display",
      "directorname_display",
      "worklang_display",
      "countryname_display",
      "genrename_display",
      "summary_display"
      ],
    :labels => {
      "alttitlename_display"=>"Alternate Title",
      "directorname_display"=>"Director",
      "largerworks_display" => "Part Of", 
      "worklang_display" => "Language",
       "countryname_display" => "Country",
      "genrename_display"=>"Genre",
      "summary_display" => "Description"
     
    }
  }


  config[:manifestation_index_fields] = {
    :field_names => [
      "langname_display",
      "subtitlelang_display",
      "aspect_display"
      ],
    :labels => {
      "langname_display"=>"Spoken Language",
      "subtitlelang_display" => "Subtitle Language",
      "aspect_display" => "Aspect Ratio"
    }
  }


  # solr fields to be displayed in the show (single result) view
  #   The ordering of the field names is the order of the display 
  config[:show_fields] = {
    :field_names => [
      "alttitlename_disaply",
        "largerworks_display",
         "directorname_display",
      "genrename_display",
      "worklang_display",
      "countryname_display",
      "workduration_display",
      "workcolor_display",
      "worksound_display",
        "summary_display"
    ],
    :labels => {
       "alttitlename_display" => "Alternate Title",
       "directorname_display" => "Director",
         "largerworks_display" => "In", 
        "genrename_display" => "Genre",
        "worklang_display" => "Language",
        "countryname_display" => "Country",
        "workduration_display" => "Run Time",
        "workcolor_display" => "Color",
        "worksound_display" => "Sound",
          "summary_display" => "Description"
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
  config[:sort_fields] << ['relevance', 'score desc, worktitle_sort asc, workdate_sort desc']
  config[:sort_fields] << ['date -', 'workdate_sort desc, worktitle_sort asc']
  config[:sort_fields] << ['date +', 'workdate_sort asc, worktitle_sort asc']
  config[:sort_fields] << ['title', 'worktitle_sort asc']
  
  # If there are more than this many search results, no spelling ("did you 
  # mean") suggestion is offered.
  config[:spell_max] = 5
  
  # number of facets to show before adding a more link
  config[:facet_more_num] = 10
end