class Grabber < Struct.new(:fields, :datetime, :sleeping)
  def perform
      # Каталожный номер найден
      # Каталожный номер не найден
      # |- Был заменен и найден
      # |- Был заменен и не найден
      # |- Каталожный номер больше не существует

        catch(:next_parts) do

          while true
            parts = Part.includes(:manufacturer).where("price_checked < ? OR price_checked is NULL", datetime).limit(fields).lock(true).all
            
            return if parts.blank?

            keys = {}
            parts.each_with_index do |part, i|
              keys["partNumber#{i+1}"] = part.catalog_number
              keys["makeid#{i+1}"] = part.manufacturer.parts_com_id
            end

            agent = Mechanize.new
            puts keys
            result = agent.post("http://www.parts.com/oemcatalog/index.cfm?action=getMultiSearchItems&siteid=2&items=#{parts.length}", keys)

            begin
              
              result.search("//table[@border=1]").each_with_index do |line, i|

                throw :next_parts if line.text =~ /No parts found!/

                price, title = nil
                
                begin
                  title = URI.decode(line.css('td[1]').css('input[3]').attribute('value').text).strip
                  parts[i].title = title unless title == "No Part Found"
                rescue
                end

                begin
                  price = line.css('td[1]').css('input[6]').attribute('value').text
                  parts[i].price = price
                rescue
                end
                
                catalog_number = line.css('td[1]').text.match(/Part Number: (.*)./)[1]

                unless parts[i].catalog_number == catalog_number
                  part = Part.where(:catalog_number => catalog_number, :manufacturer_id => parts[i].manufacturer.id).first
                  unless part.present?
                    part = Part.new(:catalog_number => catalog_number, :manufacturer => parts[i].manufacturer)
                  end
                  part.old_catalog_number = parts[i].catalog_number

                  if title
                    part.title = title
                  end
                  
                  if price
                    part.price = price
                  end

                  part.price_checked = DateTime.now
                    
                  part.save
                end  
                
                parts[i].price_checked = DateTime.now
                parts[i].save

              end
            rescue Exception => e
              debugger
              return result.body
            end
            sleep(sleeping.to_i)
          end
        end
  end
end
