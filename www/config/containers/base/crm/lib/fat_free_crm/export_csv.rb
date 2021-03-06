# Copyright (c) 2011-2016 Velo Inc.
#
#
#
#------------------------------------------------------------------------------
require "csv"

module ContactRocketCRM
  class ExportCSV
    # CSV export. Based on to_csv Rails plugin by Ary Djmal
    # https://github.com/arydjmal/to_csv
    #----------------------------------------------------------------------------
    def self.from_array(items = [])
      return '' if items.empty?
      # Infer column types from the first item in the array
      klass = items.first.class
      columns = klass.columns.map(&:name).reject { |column| column =~ /password|token/ }
      columns << 'tags' if klass.taggable?
      CSV.generate do |csv|
        csv << columns.map { |column| klass.human_attribute_name(column) }
        items.each do |item|
          csv << columns.map do |column|
            if column == 'tags'
              item.tag_list.join(' ')
            else
              item.send(column)
            end
          end
        end
      end
    end
  end
end
