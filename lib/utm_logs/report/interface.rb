require File.join File.dirname(__FILE__), '../interface'
require File.join File.dirname(__FILE__), 'log'

require 'optparse'
require 'optparse/date'
require 'find'
require 'time'

module UtmLogs
  module Report
    class Interface
      include UtmLogs::Interface

      def initialize
        options.log_dir = nil
        options.archive_dir = nil
        options.compress = false
        options.move = false
        options.symlink = false
        options.hardlink = false
        options.copy = false

        parser = OptionParser.new do |opts|
          opts.banner = 'Usage: archive_logs [options]'
          opts.on('-d', '--debug LEVEL', Integer, 'Debug level') do |v|
            options.debug = v
          end

          opts.on('-f', '--date-from DATE', OptionParser::Date, 'Search for date from this date') do |date|
            options.date_from = date
          end
        end
        parser.parse!
        check_options
      end

    end
  end
end

