class PartsComGrabber < Struct.new(:fields, :datetime, :sleeping)
  def perform
    # 1. Каталожный номер найден один в один (123 : 123)
    # 2. Каталожный номер найден, но написание отличается (12-3 : 123)
    # 3. Каталожный номер заменен на новый (123 : 123X)
    # 4. Предложения по каталожному номеру отсутсвует

    catch(:next_parts) do

      while true

        begin

          proxy = Proxy.where('good > 0').order('RAND()').limit(1).first
          puts "Сделали выборку по прокси серверам"
          raise 'Нет ни одного доступного proxy' if proxy.blank?
          puts "В proxy что-то есть"

          Timeout::timeout(360) do
            puts "Зашли в 360 сек. интервал"
            agent = Mechanize.new
            agent.set_proxy(proxy.ip, proxy.port)
            puts 'Назначили proxy'
            puts proxy.ip
            puts proxy.port
            result = agent.get("http://www.parts.com")
            puts 'Получили главную страницу'

            parts = []
            # Блокируем интересующие записи и обновляем что они защищены от чтения
            ActiveRecord::Base.transaction do
              locked_parts = Part.includes(:manufacturer).where("price_checked < ? OR price_checked is NULL", datetime).where(:locked => false).limit(10 + rand(fields) * 10).lock(true)
              puts 'Сделали выборку по каталожным номерам'
              return if locked_parts.none?
              locked_parts.update_all(:locked => true)
              puts 'Заблокировали'
              parts = locked_parts.all
            end

            keys = {}
            parts.each_with_index do |part, i|
              keys["partNumber#{i+1}"] = part.catalog_number
              keys["makeid#{i+1}"] = part.manufacturer.parts_com_id
            end

            if @first_time
              sleep(rand(sleeping.to_i))
            else 
              @first_time = true
            end
            puts 'Отоспались'
      
            result = agent.post("http://www.parts.com/oemcatalog/index.cfm?action=getMultiSearchItems&siteid=2&items=#{parts.length}", keys)

            puts 'Сделали post'
            result.search("//table[@border=1]").each_with_index do |line, i|

              # Если детали совсем не найдены, 
              # то сбрасываем блокировку и переходим к следующим
              puts 'Проходим по результатам'
              if line.text =~ /No parts found!/
                puts 'Ничего не найдено'
                locked_parts.update_all(:locked => false)
                throw :next_parts 
              end

              catalog_number, price, title = nil

              # Запомниаем название только если оно реально присутствует
              begin
                tmp = URI.decode(line.css('td[1]').css('input[3]').attribute('value').text).strip
                title = tmp if tmp != "No Part Found"
                puts tmp
              rescue
              end

              # Запоминаем цену, безусловно (всегда число)
              begin
                price = line.css('td[1]').css('input[6]').attribute('value').text
                puts price
              rescue
              end
              
              # Запоминаем каталожный номер, безусловно
              catalog_number = line.css('td[1]').text.match(/Part Number: (.*)./)[1]
              puts catalog_number

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

                puts "Новый или выбранный номер"
                puts title
                puts "Новая цена"
                puts price

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
          end
        rescue Timeout::Error, Net::HTTP::Persistent::Error,Net::HTTPMethodNotAllowed, Net::HTTPServiceUnavailable, Mechanize::ResponseCodeError, Errno::ECONNREFUSED, Errno::ETIMEDOUT, Errno::EHOSTUNREACH => e
          proxy.good = 0
          proxy.save
          proxy = nil
          retry
        rescue Exception => e
          debugger
          puts 1
          sleep 5
          retry
        end
      end
    end
  end
end
