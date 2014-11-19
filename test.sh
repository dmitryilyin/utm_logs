sh test/prepare.sh
bin/archive_logs -l test/netflow/ -a test/archive/ -d2 ${@}
sh test/check.sh
