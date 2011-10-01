class PartsGrabber < Struct.new(:fields, :datetime, :sleeping)
  def perform
      # 1. Каталожный номер найден один в один (123 : 123)
      # 2. Каталожный номер найден, но написание отличается (12-3 : 123)
      # 3. Каталожный номер заменен на новый (123 : 123X)
      # 4. Предложения по каталожному номеру отсутсвует

        catch(:next_parts) do

          while true

            parts = []
            # Блокируем интересующие записи и обновляем что они защищены от чтения
            ActiveRecord::Base.transaction do
              locked_parts = Part.includes(:manufacturer).where("price_checked < ? OR price_checked is NULL", datetime).where(:locked => false).limit(fields).lock(true)
              return if locked_parts.none?
              locked_parts.update_all(:locked => true)
              parts = locked_parts.all
            end

            keys = {}
            parts.each_with_index do |part, i|
              keys["partNumber#{i+1}"] = part.catalog_number
              keys["makeid#{i+1}"] = part.manufacturer.parts_com_id
            end

            begin
              
              if @first_time
                sleep(sleeping.to_i)
              else 
                @first_time = true
              end
          
              agent = Mechanize.new
              puts pp keys
              result = agent.post("http://www.parts.com/oemcatalog/index.cfm?action=getMultiSearchItems&siteid=2&items=#{parts.length}", keys)

              result.search("//table[@border=1]").each_with_index do |line, i|

                # Если детали совсем не найдены, 
                # то сбрасываем блокировку и переходим к следующим
                if line.text =~ /No parts found!/
                  locked_parts.update_all(:locked => false)
                  throw :next_parts 
                end

                catalog_number, price, title = nil

                # Запомниаем название только если оно реально присутствует
                begin
                  tmp = URI.decode(line.css('td[1]').css('input[3]').attribute('value').text).strip
                  title = tmp if tmp != "No Part Found"
                rescue
                end

                # Запоминаем цену, безусловно (всегда число)
                begin
                  price = line.css('td[1]').css('input[6]').attribute('value').text
                rescue
                end
                
                # Запоминаем каталожный номер, безусловно
                catalog_number = line.css('td[1]').text.match(/Part Number: (.*)./)[1]

                if title
                  # Тут название не обновится только если предложения по детали нет
                  # чтобы не затереть имеющееся название (если таковое имеется)
                  parts[i].title = title 
                end

                if price
                  # Цена будет всегда, или 0
                  parts[i].price = price
                end
                
                unless parts[i].catalog_number == catalog_number

                  parts[i].new_catalog_number = catalog_number

                  part = Part.where(:catalog_number => catalog_number, :manufacturer_id => parts[i].manufacturer.id).first
                  unless part.present?
                    part = Part.new(:catalog_number => catalog_number, :manufacturer => parts[i].manufacturer)
                  end

                  if title
                    part.title = title
                  end
 
                  if price
                    part.price = price
                  end

                  part.price_checked = DateTime.now
                  part.locked = false
                  part.locked_will_change!
                  part.save
                end  

                parts[i].price_checked = DateTime.now
                parts[i].locked = false
                parts[i].locked_will_change!
                parts[i].save

              end
            rescue Exception => e
              retry
            end
          end
        end
  end
end
