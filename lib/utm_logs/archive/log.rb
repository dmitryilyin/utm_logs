require 'date'
require 'zlib'
require 'fileutils'

module UtmLogs
  module Archive
    class Log
      LOG_FORMAT = %r{^iptraffic_raw_(\d+).*?(\.utm|\.utm\.gz)$}

      def initialize(path, interface)
        raise "File '#{path}' is not readable!" unless File.readable? path
        name = File.basename path
        if name =~ LOG_FORMAT
          @timestamp = $1.to_i
          if $2.end_with? '.gz'
            @compressed = true
          else
            @compressed = false
          end
          @path = path
          @name = name
          @interface = interface
          @compression_enabled = false
        else
          raise "File '#{path}' is not a UTM5 log!"
        end
        interface.debug "Create #{self.class} with path: '#{path}' ts: #{timestamp} compressed: #{compressed?}", 3
      end

      attr_reader :interface, :name, :path, :timestamp

      def archive!
        @compression_enabled = true
        interface.debug "Archive file '#{path}' to #{archive_path}", 2
        return if interface.dry_run?
        if compressed?
          copy!
        else
          compress!
        end
        remove_file! if archive_present?
      end

      def compress!
        @compression_enabled = true
        interface.debug "Compress file '#{path}' to #{archive_path}", 2
        return if interface.dry_run?
        gz = Zlib::GzipWriter.open(archive_path)
        gz.mtime = File.mtime(path)
        gz.orig_name = name
        gz.comment = date_suffix
        written_size = gz.write IO.binread(path)
        gz.close
        if file_size == written_size
          true
        else
          remove_archive!
          raise "Compression of file '#{path}' to #{archive_path} failed!"
        end
      end

      def remove_file!
        interface.debug "Remove file '#{path}'", 2
        return if interface.dry_run?
        FileUtils.remove path if File.exist? path
      end

      def remove_archive!
        interface.debug "Remove file '#{path}'", 2
        return if interface.dry_run?
        FileUtils.remove archive_path if File.exist? archive_path
      end

      def move!
        interface.debug "Move file '#{path}' to '#{archive_path}'", 2
        return if interface.dry_run?
        FileUtils.move path, archive_path
      end

      def copy!
        interface.debug "Copy file '#{path}' to '#{archive_path}'", 2
        return if interface.dry_run?
        FileUtils.copy path, archive_path
      end

      def symlink!
        interface.debug "Symlink file '#{path}' to '#{archive_path}'", 2
        return if interface.dry_run?
        FileUtils.symlink path, archive_path
      end

      def hardlink!
        interface.debug "Hardlink file '#{path}' to '#{archive_path}'", 2
        return if interface.dry_run?
        FileUtils.link path, archive_path
      end

      # @return [String]
      def file_size
        File.size? path
      end

      # @return [String]
      def name_without_extension
        name.split('.').first
      end

      # @return [DateTime]
      def datetime
        return @datetime if @datetime
        time = Time.at timestamp
        @datetime = time.localtime.to_datetime
      end

      # @return [String]
      def date_suffix
        datetime.strftime '%Y_%m_%d-%H_%M_%S'
      end

      # @return [String]
      def archive_name
        archive_name = "#{name_without_extension}-#{date_suffix}.utm"
        archive_name += '.gz' if compression_enabled? or compressed?
        archive_name
      end

      # @return [String]
      def archive_path
        return @archive_path if @archive_path
        archive_basedir = File.join archive_dir, datetime.year.to_s, datetime.month.to_s, datetime.mday.to_s
        archive_path = File.join archive_basedir, archive_name
        return archive_path if interface.dry_run?
        FileUtils.mkdir_p archive_basedir unless File.exist? archive_basedir
        if File.directory? archive_basedir
          @archive_path = archive_path
        else
          raise "Cannot create directory '#{archive_basedir}' for file #{path}"
        end
      end

      # @return [TrueClass,FalseClass]
      def archive_present?
        !!File.size?(archive_path)
      end

      # @return [TrueClass,FalseClass]
      def file_present?
        File.readable? path
      end

      # @return [TrueClass,FalseClass]
      def compressed?
        @compressed
      end

      # @return [TrueClass,FalseClass]
      def compression_enabled?
        @compression_enabled
      end

      # @return [String]
      def archive_dir
        interface.options[:archive_dir]
      end

      # @return [String]
      def to_s
        path
      end

      # @return [String]
      def inspect
        path
      end
    end

  end
end