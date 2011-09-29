class Importer < Struct.new(:path)
  def perform
    FasterCSV.foreach(path, {:col_sep => "\t", :quote_char => "\xA"}) do |csv|
      begin
        Part.create!(:catalog_number => csv[1], :manufacturer => Manufacturer.where(:title => csv[3]).first)
      rescue => e
        next if e.record.errors[:catalog_number]
      end
    end
  end
end
