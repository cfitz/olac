#!/usr/bin/env ruby
require 'rubygems'
require 'nokogiri'
require 'solr'


xml = Nokogiri::XML(open('/tmp/test.xml'))

@connection = Solr::Connection.new('http://salt-prod.stanford.edu:8080/chris_solr/', :autocommit => :on )

xml.root.children.each do |child|
  if child.name == "ROW"
    document = Solr::Document.new(:id => child["RECORDID"])
    puts child["RECORDID"]
    child.children.each do |grandchildren|
      values = []
      grandchildren.children.each do |value|
        document << Solr::Field.new("#{grandchildren.name.downcase}_s" => value.content)
        document << Solr::Field.new("#{grandchildren.name.downcase}_t" => value.content)
        document << Solr::Field.new("#{grandchildren.name.downcase}_facet" => value.content)  
        document << Solr::Field.new("#{grandchildren.name.downcase}_display" => value.content)    
      end #each
      @connection.add(document)
    end #if child.children
  end #if child.name
end #each


