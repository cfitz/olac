#!/usr/bin/env ruby
require 'rubygems'
require 'nokogiri'
require 'solr'


xml = Nokogiri::XML(open('../spec/fixtures/export_from_db.xml'))

@connection = Solr::Connection.new('http://saltworks.stanford.edu/chris_solr/', :autocommit => :on )
#@connection = Solr::Connection.new("http://localhost:8983/solr/development", :autocommit => :on )

#@connection = Solr::Connection.new("http://localhost:8983/solr", :autocommit => :on )


xml.root.children.each do |child|
  if child.name == "ROW"
    values = {}
    puts child["RECORDID"]
    child.children.each do |grandchildren|
     
      grandchildren.children.each do |value|
        if  values["#{grandchildren.name.downcase}"].nil?
          values["#{grandchildren.name.downcase}"] = []
        end #if .nil?
        values["#{grandchildren.name.downcase}"] << value.content
      end #grandchildren
    
    
      @document = Solr::Document.new(:id => child["RECORDID"])  
      
    end #children.each  
    
    #puts values.inspect

    values.each do |key,value|
      uniques = value.uniq
      uniques.each do |values|
        val = values.split("\n")
        val.each do |v|
          v.strip!
          unless v.empty?
          
            if key == "captioning" && v == "yes"
              puts "captioning"
              @document << Solr::Field.new("accessibility_facet" => "Captioning")
              @document << Solr::Field.new("accessibility_t" => "Captioning")
              @document << Solr::Field.new("accessibility_s" => "Captioning")
              @document << Solr::Field.new("accessibility_display" => "Captioning")
            elsif key == "holdings_regular"
              holding_info = v.gsub("yes", "Captioning").gsub("\n", ":").split(":")
              holding_info.delete_if{|x| x.empty?}
              holding_info.delete_if{|x| x == "sub"}                        
              i = 0 
              while i < 5 do
              
                holding_info.permutation(i) do |x|
                 value =  x.compact.join(":")
                 @document << Solr::Field.new("holdings_regular_s" => value)
                end #do
                 i += 1
              end
            elsif key == "worktitle"
              @document << Solr::Field.new("#{key}_s" => v)
              @document << Solr::Field.new("#{key}_t" => v)
              @document << Solr::Field.new("#{key}_facet" => v)    
            elsif key == "workdate"
              @document << Solr::Field.new("workdate_s" => v)
              @document << Solr::Field.new("workdate_t" => v)
              @document << Solr::Field.new("workdate_sort" => v)
              unless v == "unspecified"
                decade = "#{v.slice(0..2)}0s"
                puts decade
                @document << Solr::Field.new("workdate_facet" => decade)    
              else
                @document << Solr::Field.new("workdate_facet" => "Unspecified")    
              end
            else
              unless v == "unspecified"
              
                @document << Solr::Field.new("#{key}_s" => v)
                @document << Solr::Field.new("#{key}_t" => v)
                @document << Solr::Field.new("#{key}_facet" => v)  
                @document << Solr::Field.new("#{key}_display" => v)
              end
            end
          end #unless
        end #v.each
      end #value.each
    end #values.each
    
    @document << Solr::Field.new("worktitle_display" => "#{@document["worktitle_s"]} ( #{@document["workdate_s"]} )") 
               
    @connection.add(@document)
  end #if child.name
end #each


