class Importer < Struct.new(:path, :col_sep, :quote_char, :catalog_number_colnum, :manufacturer_colnum)
  def perform
    FasterCSV.foreach(path, {:col_sep => Price::COL_SEPS[quote_char.to_i][:real], :quote_char => Price::COL_SEPS[col_sep.to_i][:real]}) do |csv|
      #begin
        # Заполнен ли производитель в прайсе
        if csv[manufacturer_colnum.to_i].present?
          # Ищем синоним
          manufacturer_synonym = ManufacturerSynonym.where(:title => csv[manufacturer_colnum.to_i]).first
          # Если не нашли 
          if manufacturer_synonym.blank?
              manufacturer_synonym = ManufacturerSynonym.new(:title => csv[manufacturer_colnum.to_i])
              manufacturer = Manufacturer.where(:title => csv[manufacturer_colnum.to_i]).first
              if manufacturer
                manufacturer_synonym.manufacturer = manufacturer
              end
              manufacturer_synonym.save(:validate => false)
          end
          unless !manufacturer_synonym.nil? && manufacturer_synonym.manufacturer.nil?
            manufacturer = Manufacturer.where(:title => csv[manufacturer_colnum.to_i]).first
            if manufacturer.present?
              part = Part.where(:catalog_number => csv[catalog_number_colnum.to_i], :manufacturer_id => manufacturer.id).first
              unless part.present?
                Part.create!(:catalog_number => csv[catalog_number_colnum.to_i], :manufacturer => manufacturer)
              end
            end
          end
        end
      #rescue => e
      #  #debugger
      #  #puts 1
      #end
    end
  end
end
