require 'date'

module UtmLogs
  module Report
    class Log
      def initialize(file, interface)
        interface.debug "Open log file: '#{file}'"
        @file = file
      end

      attr_reader :file

      def every_line
        IO.popen(get_nf_direct) do |io|
          loop do
            line = io.gets
            break unless line
            yield line
          end
        end
      end

      def parse_line(line)
        begin
          line_array = line.split
          return unless line_array.length == 14
          return if line_array.first == 'timestamp'
          data = {}
          data[:timestamp] = DateTime.new Integer line_array[0]
          data[:account_id] = Integer line_array[1]
          data[:source] = line_array[2]
          data[:destination] = line_array[3]
          data[:t_class] = Integer line_array[4]
          data[:packets] = Integer line_array[5]
          data[:bytes] = Integer line_array[6]
          data[:sport] = Integer line_array[7]
          data[:dport] = Integer line_array[8]
          data
        rescue
          nil
        end
      end

      def parse
        every_line do |line|
          data = parse_line line
          next unless data
          yield data
        end
      end

      def unzip

      end

      def is_archive?

      end

      def get_nf_direct
        'cat /Users/dilyin/iptraffic_raw.txt'
      end

    end
  end
end
