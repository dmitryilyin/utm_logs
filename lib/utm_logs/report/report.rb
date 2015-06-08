module UtmLogs
  module Report
    class Report
      def initialize
        @incoming_traffic = {}
        @incoming_daily_traffic = {}
        @incoming_port_stats = {}

        @outgoing_traffic = {}
        @outgoing_daily_traffic = {}
        @outgoing_port_stats = {}
      end


      def process_record(record)
        record_incoming record
      end

      def filter_by_date_pass?(date_from, date_to)

      end

      def filter_by_account_id_pass?(account_id)

      end

      def record_incoming(record)
        @incoming_traffic[record[:source]] = 0 unless @incoming_traffic.key? record[:source]
        @incoming_traffic[record[:source]] += record[:bytes]
        @incoming_traffic[:all] = 0 unless @incoming_traffic.key? :all
        @incoming_traffic[:all] += record[:bytes]
      end

      def record_incoming_daily(record)

      end

      def record_incoming_port_stats(record)

      end

      def record_outgoing_traffic(record)

      end

      def record_daily_outgoing_traffic(record)

      end

      def record_outgoing_port_stats(record)

      end

    end
  end
end