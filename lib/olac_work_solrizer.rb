#!/usr/bin/env ruby
require 'rubygems'
require 'nokogiri'
require 'solr'
require 'pp'

xml = Nokogiri::XML(open('../spec/fixtures/works_export_from_db.xml'))
@connection = Solr::Connection.new('http://saltworks.stanford.edu/chris_solr/', :autocommit => :on )
#@connection = Solr::Connection.new("http://localhost:8983/solr/development", :autocommit => :on )


xml.root.children.each do |child|
  if child.name == "ROW"
    values = {}
   
    child.children.each do |grandchildren|
     
      grandchildren.children.each do |value|
        v = value.content.strip.chomp.gsub(/^./) {|x| x.upcase}
        if  values["#{grandchildren.name.downcase}"].nil?
          values["#{grandchildren.name.downcase}"] = []
        end #if .nil?
         unless v.empty?
            values["#{grandchildren.name.downcase}"] << v
          end
      end #grandchildren  
    end #children.each  
    #pp values
      @id = values["worknum"]
      puts @id   

    unless @id.nil? 
        @document = Solr::Document.new(:id => @id)
        @document << Solr::Field.new("documentType_s" => "work")
      #puts values.inspect

      values["subtitlelang"].each do |sub|
        if sub.include?(" ")
          unless sub.include?("Mandarin") or sub.include?("Sign")
            sub.split(" ").each { |s| values["subtitlelang"] << s }
            values["subtitlelang"].delete(sub)
          end
        end
      end
      
       values["langname"].each do |sub|
          if sub.include?(" ") 
            unless sub.include?("Mandarin") or sub.include?("Sign")
              sub.split(" ").each { |s| values["langname"] << s }
              values["langname"].delete(sub)
            end
          end
        end

      values["largerworks"] = []
      unless values["lgworktitle"].nil? or values["lgworktype"].nil?
        values["lgworktype"].each_with_index do |v,k|
          values["largerworks"] << "#{v.capitalize} : #{values["lgworktitle"][k]}"          
        end
      end


       unless values["date"].nil?
          if values["pubdate"].nil?
            values["pubdate"] =[]
          end
          values['date'].each do |v| 
            unless v.include?("Un")
              values["pubdate"] << "#{v.slice(0..2)}0s"
            else
               values["pubdate"] << "Unspecified"
            end
          end
        end
       
        
      values.each do |key,value|
        uniques = value.uniq
        uniques.each do |values|
          val = values.split("\n")
          val.each do |v|
            v.strip!
            unless v.empty?
              
              if key == "captioning" && v == "yes"
                @document << Solr::Field.new("accessibility_facet" => "Captioning")
                @document << Solr::Field.new("accessibility_t" => "Captioning")
                @document << Solr::Field.new("accessibility_s" => "Captioning")
                @document << Solr::Field.new("accessibility_display" => "Captioning")
              elsif key == "holdings_regular"
               #do nothing now. add these below
              elsif key == "worktitle"
                puts v
                @document << Solr::Field.new("#{key}_s" => v)
                @document << Solr::Field.new("#{key}_t" => v)
                @document << Solr::Field.new("#{key}_facet" => v)
                @document << Solr::Field.new("#{key}_sort" => v)    
              elsif key == "holdings"
                 puts "We no longer using this field."
                 #@document << Solr::Field.new("#{key}_display" => v)
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
    
      @document << Solr::Field.new("worktitle_display" => "#{@document["worktitle_s"].gsub(":", "")} ( #{@document["workdate_s"]} )")
    
    
      #now get the holdings information
      if File.exist?(File.join("/tmp", "#{@id}.txt"))
        File.open(File.join("/tmp", "#{@id}.txt")).each {|i|  @document << Solr::Field.new("holdings_tws" => i) }
        @connection.add(@document)
        
      else
        puts "Holdings file does not exists for #{@id}. Not adding to SOLR. "
      end         
    
    end #if @id
  end #if child.name
end #each


