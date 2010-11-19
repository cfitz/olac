#!/usr/bin/env ruby
require 'rubygems'
require 'nokogiri'
require 'solr'


xml = Nokogiri::XML(open('../spec/fixtures/items_export_from_db.xml'))

@connection = Solr::Connection.new('http://saltworks.stanford.edu/chris_solr/', :autocommit => :on )
#@connection = Solr::Connection.new("http://localhost:8983/solr/development", :autocommit => :on )

#@connection = Solr::Connection.new("http://localhost:8983/solr", :autocommit => :on )




xml.root.children.each do |child|
  if child.name == "ROW"
    values = {}
   # puts child["RECORDID"]
    child.children.each do |grandchildren|
     
      grandchildren.children.each do |value|
        if  values["#{grandchildren.name.downcase}"].nil?
          values["#{grandchildren.name.downcase}"] = []
        end #if .nil?
        values["#{grandchildren.name.downcase}"] << value.content.gsub(/^./) {|x| x.upcase}
      end #grandchildren
      
      @id = values["mannum"]
      @work_id = values["worknum"]
      
      @document = Solr::Document.new(:id => "manifestation_#{@id}") 
      @document << Solr::Field.new("documentType_s" => "manifestation")
      
    end #children.each  
    
    if values["subtitlelang"].nil?
      values["subtitlelang"] = ["None"]
    end
    
    if values["libname"].nil?
      values["libname"] = ["None"]
    end
    
    unless values["workdate"].nil?
      if values["decade"].nil?
         values["decade"] = [] 
      end
      values["workdate"].each {|v| values["decade"] << "#{v.slice(0..2)}0s" }        
    end
 
    
   output = [values["format"].map {|x| "format_facet_#{x.downcase}" },
    values["libname"].map {|x| "libname_facet_#{x.downcase}"}, 
   values["subtitlelang"].map {|x| "subtitlelang_facet_#{x.downcase}"},
    values["langname"].map {|x| "langname_facet_#{x.downcase}"},
    values["genrename"].map {|x| "genrename_facet_#{x.downcase}"},
    values["decade"].map {|x| "workdate_facet_#{x}"},
    values["worklang"].map {|x| "worklang_facet_#{x.downcase}"},
    values["directorname"].map {|x| "directorname_facet_#{x.downcase}"}]
   
   @final = [""]
   output.each do |o|
     @final = @final * o.length
     o.each_with_index do |v,k|
       i = k * (@final.length / o.length)
       while i < (k * (@final.length / o.length)) + (@final.length / o.length)
         @final[i] = @final[i] + " " + v
         i +=1
      end #while
     end #o.each_with_index
   end #output.each
   #puts @final
     
   @final.each do |f|
     @document << Solr::Field.new("holdings_t" => f)
   end
     
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
             
             elsif key == "workdate"
                @document << Solr::Field.new("workdate_s" => v)
                @document << Solr::Field.new("workdate_t" => v)
                @document << Solr::Field.new("workdate_sort" => v)
                unless v == "unspecified"
                  decade = "#{v.slice(0..2)}0s"
                  @document << Solr::Field.new("workdate_facet" => decade)    
                else
                  @document << Solr::Field.new("workdate_facet" => "Unspecified")    
                end
            elsif key != "holdings" and key != "holdings_regular"
              if v == "unspecified"
              
                @document << Solr::Field.new("#{key}_s" => "Unspecified")
                @document << Solr::Field.new("#{key}_t" => "Unspecified")
                @document << Solr::Field.new("#{key}_facet" => "Unspecified")  
                @document << Solr::Field.new("#{key}_display" => "Unspecified")
              else
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
  
  @work_id.each do |wi|
      
    unless File.exists?(File.join('/tmp', "#{wi}.txt"))
    
        file = File.open(File.join('/tmp', "#{wi}.txt"), 'w')
        @final.each do |f|
          file << f + "\n"
        end
        file.close
        
    else
       puts wi
        puts "man id #{@id}"
      file = File.open(File.join('/tmp', "#{wi}.txt"), 'a')
      @final.each do |f|
        file << f + "\n"
      end
      file.close
  
    end #unless file.exists
  
  end #work_id each
               
  @connection.add(@document)
  end #if child.name
end #each


