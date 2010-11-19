require 'vendor/plugins/blacklight/app/helpers/catalog_helper.rb'
module CatalogHelper
  	def page_entries_info(collection, options = {})
      start = collection.next_page == 2 ? 1 : collection.previous_page * collection.per_page + 1
      total_hits = @response.total
      start_num = format_num(start)
      end_num = format_num(start + collection.per_page - 1)
      total_num = format_num(total_hits)

      total_manifestation_hits = @manifestation_response.total

      entry_name = options[:entry_name] ||
        (collection.empty?? 'entry' : collection.first.class.name.underscore.sub('_', ' '))

      if collection.total_pages < 2
        case collection.size
        when 0; "No #{entry_name.pluralize} found"
        when 1; "Displaying <b>1</b> work"
        else;   "Displaying <b>all #{total_num}</b> works"
        end
      else
        "<b>#{total_num}</b> works found with <b>#{total_manifestation_hits}</b> #{entry_name.pluralize}. <br/>  Displaying works <b>#{start_num} - #{end_num}</b> of <b>#{total_num}</b>"
      end
  end
  
end