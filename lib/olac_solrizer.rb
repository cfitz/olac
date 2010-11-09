#!/usr/bin/env ruby
require 'rubygems'
require 'nokogiri'
require 'solr'


xml = Nokogiri::XML(open('../spec/fixtures/export_from_db.xml'))

#@connection = Solr::Connection.new('http://salt-prod.stanford.edu:8080/chris_solr/', :autocommit => :on )
@connection = Solr::Connection.new("http://localhost:8983/solr/development", :autocommit => :on )

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
    
    puts values.inspect

    values.each do |key,value|
      uniques = value.uniq
      uniques.each do |v|
        v.strip!
        unless v.empty?
          
          if key == "captioning" && v == "yes"
            puts "captioning"
            @document << Solr::Field.new("accessibility_facet" => "Captioning")
            @document << Solr::Field.new("accessibility_t" => "Captioning")
            @document << Solr::Field.new("accessibility_s" => "Captioning")
            @document << Solr::Field.new("accessibility_display" => "Captioning")
          elsif key == "worktitle"
            @document << Solr::Field.new("#{key}_s" => v)
            @document << Solr::Field.new("#{key}_t" => v)
            @document << Solr::Field.new("#{key}_facet" => v)          
          else
            @document << Solr::Field.new("#{key}_s" => v)
            @document << Solr::Field.new("#{key}_t" => v)
            @document << Solr::Field.new("#{key}_facet" => v)  
            @document << Solr::Field.new("#{key}_display" => v)
          end
        end
      end #value.each
    end #values.each
    
    @document << Solr::Field.new("worktitle_display" => "#{@document["worktitle_s"]} ( #{@document["workdate_s"]} )") 
               
    @connection.add(@document)
  end #if child.name
end #each


