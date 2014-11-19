# UtmLogs

A set of tools to work with NetFlow logs of UTM5

* archive_logs - archive or sort logs

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'utm_logs'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install utm_logs

## archive_logs

*  -d, --debug LEVEL                Debug level
* -l, --log_dir DIRECTORY          Take logs from this log directory
* -a, --archive_dir DIRECTORY      Put logs to this archive directory
* -n, --dry_run                    Don't actually do anything
* -c, --compress                   Archive log files to the archive directory with compression (default)
* -m, --move                       Move log files to the archive directory without compression
* -s, --symlink                    Symlink log files to the archive directory
* -S, --hardlink                   Hardlink log files to the archive directory
* -C, --copy                       Copy log files to the archive directory

### Archive logs
    $ archive_logs -l /path/to/logs -a /path/to/archive --compress
Will take log files from the first directory and archive them to the second directory.
Files will be named by their timestamp date and archived files will be removed
from the first directory. If there are files that are already compressed they will be
simply copied.

### Sort logs
    $ archive_logs -l /path/to/unsorted/logs -a /path/to/unsorted/logs  --move
If you specify both directories to a heap of unsorted log and use --move option the logs
will be sorted and renamed within this directory. It can be useful to sort logs by date.

### Link maps
    $ archive_logs -l /path/to/logs -a /map/folder --symlink

This will create symlinks in the second folder pointing to the files in the first folder.
So that files may seem like sorted without being touched at all.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/utm_logs/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
