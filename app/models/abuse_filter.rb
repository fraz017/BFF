class AbuseFilter < ApplicationRecord
	def self.import(file)
		AbuseFilter.destroy_all
	  spreadsheet = open_spreadsheet(file)
	  header = spreadsheet.row(1)
	  (2..spreadsheet.last_row).each do |i|
	    row = Hash[[header, spreadsheet.row(i)].transpose]
	    abuse = AbuseFilter.find_or_initialize_by(abuse: row["Abuse"])
	    abuse.save!
	  end
	end

	def self.open_spreadsheet(file)
	  case File.extname(file.original_filename)
	   when '.csv' then Roo::Csv.new(file.path)
	   when '.xls' then Roo::Excel.new(file.path)
	   when '.xlsx' then Roo::Excelx.new(file.path)
	   else raise "Unknown file type: #{file.original_filename}"
	  end
	end
end
