require File.join File.dirname(__FILE__), '../interface'
require File.join File.dirname(__FILE__), 'log'

require 'optparse'
require 'find'
require 'time'

module UtmLogs
  module Archive
    class Interface
      include UtmLogs::Interface

      def log_dir
        options.log_dir
      end

      def archive_dir
        options.archive_dir
      end

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
          opts.on('-l DIRECTORY', '--log_dir DIRECTORY', 'Take logs from this log directory') do |v|
            options.log_dir = v
          end
          opts.on('-a DIRECTORY', '--archive_dir DIRECTORY', 'Put logs to this archive directory') do |v|
            options.archive_dir = v
          end
          opts.on('-n', '--dry_run', 'Don\'t actually do anything') do |v|
            options.dry_run = v
          end
          opts.on('-c', '--compress', 'Archive log files to the archive directory with compression (default)') do |v|
            options.compress = v
          end
          opts.on('-m', '--move', 'Move log files to the archive directory without compression') do |v|
            options.move = v
          end
          opts.on('-s', '--symlink', 'Symlink log files to the archive directory') do |v|
            options.symlink = v
          end
          opts.on('-S', '--hardlink', 'Hardlink log files to the archive directory') do |v|
            options.hardlink = v
          end
          opts.on('-C', '--copy', 'Copy log files to the archive directory') do |v|
            options.copy = v
          end
        end
        parser.parse!
        check_options
      end

      def check_options
        fail 'You should give log_dir!' unless log_dir
        fail 'You should give archive_dir!' unless archive_dir
        fail "No such log_dir '#{log_dir}'!" unless File.directory? log_dir
        fail "No such archive_dir '#{archive_dir}'" unless File.directory? archive_dir
      end

      def run
        case
          when options.compress
            archive_log_files
          when options.move
            move_log_files
          when options.copy
            copy_log_files
          when options.hardlink
            hardlink_log_files
          when options.symlink
            symlink_log_files
          else
            archive_log_files
        end
      end

      def process_log_files
        start_time = Time.now
        Find.find(log_dir) do |file|
          unless File.size? file
            debug "Skipping empty file '#{file}'!", 1
            next
          end
          mtime = File.mtime file
          if mtime > start_time
            debug "Skipping file '#{file}' modified after the script is started!", 1
            next
          end
          if File.fnmatch? '*.utm', file or File.fnmatch? '*.utm.gz', file
            debug "Processing file: #{file}", 1
            begin
              yield UtmLogs::Archive::Log.new(file, self)
            rescue => e
              warning "Error processing file #{file}: #{e.message}"
            end
          end
        end
      end

      def archive_log_files
        process_log_files do |file|
          file.archive!
        end
      end

      def move_log_files
        process_log_files do |file|
          file.move!
        end
      end

      def copy_log_files
        process_log_files do |file|
          file.copy!
        end
      end

      def symlink_log_files
        process_log_files do |file|
          file.symlink!
        end
      end

      def hardlink_log_files
        process_log_files do |file|
          file.hardlink!
        end
      end

    end
  end
end
