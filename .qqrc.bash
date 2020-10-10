# variables
export QADMIN=admin
export QARCH=qa01.storage.example.com
export QPROD=qp01.storage.example.com
export QTEST=q01.storage.example.com

# aliases
alias qplogin='~/Downloads/qumulo_api/qq --host $QPROD login -u $QADMIN'
alias qalogin='~/Downloads/qumulo_api/qq --host $QARCH login -u $QADMIN'
alias qtlogin='~/Downloads/qumulo_api/qq --host $QTEST login -u $QADMIN'
alias qq='~/Downloads/qumulo_api/qq --host ${QPROD}'
alias qa='~/Downloads/qumulo_api/qq --host ${QARCH}'
alias qt='~/Downloads/qumulo_api/qq --host ${QTEST}'

# functions
qls() {
qq fs_read_dir_aggregates --path "${1}" | \
jq -r '.files | to_entries[] | [.value.capacity_usage, .value.num_directories, .value.num_files, .value.num_symlinks, .value.type, .value.name] | @tsv' | \
sort -nrk1 | \
awk 'BEGIN{printf "%9s %9s %10s %10s %22s %s\n","capacity","dirs","files","symlinks","type          ","name"}
{if ($1 > 1099511627776) printf "%6.2f TB %9d %10d %10d %-22s %s\n",$1/1024/1024/1024/1024,$2,$3,$4,$5,substr($0,index($0,$6));
if ($1 > 1048580000 && $1 < 1099511627776) printf "%6.2f GB %9d %10d %10d %-22s %s\n",$1/1024/1024/1024,$2,$3,$4,$5,substr($0,index($0,$6));
if ($1 > 1048576 && $1 < 1048579999) printf "%6.2f MB %9d %10d %10d %-22s %s\n",$1/1024/1024,$2,$3,$4,$5,substr($0,index($0,$6));
if ($1 < 1048576) printf "%6.2f KB %9d %10d %10d %-22s %s\n",$1/1024,$2,$3,$4,$5,substr($0,index($0,$6))}';
}
