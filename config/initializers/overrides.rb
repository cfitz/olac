
module Fedora
  class Repository

   def find_model(pid, klazz)
        obj = self.find_objects("pid=#{pid}").first
        unless obj.nil?
          doc = Nokogiri::XML::Document.parse(obj.object_xml)
          klazz.deserialize(doc)
        else
          return nil
        end
    end #find_model
  end #class
end #module

