require 'ostruct'

module UtmLogs
  module Interface

    def options
      return @options if @options
      @options = OpenStruct.new
      @options.debug = 1
      @options.dry_run = false
      @options
    end

    def debug_level
      options[:debug]
    end

    def dry_run?
      options[:dry_run]
    end

    def debug(msg, level=1)
      puts msg if debug_level >= level
    end

    def fail(msg)
      puts msg
      exit 1
    end

    def error(msg)
      puts msg
    end

    def output(msg)
      puts msg
    end

    def warning(msg)
      puts msg
    end

    def run(cmd)
      if dry_run?
        output "Run: #{cmd}"
      else
        system cmd
      end
    end

  end
end