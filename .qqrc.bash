# variables
export QADMIN=admin
export QARCH=qa01.storage.example.com
export QPROD=qp01.storage.example.com
export QTEST=qt01.storage.example.com

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
awk -F'\t' 'BEGIN{printf "%9s %9s %10s %10s %22s %s\n","capacity","dirs","files","symlinks","type          ","name"}
{split("B KB MB GB TB PB",v); s=1; while($1>1000 && s < 6){$1/=1000; s++} printf "%6.2f %2s %9d %10d %10d %-22s %s\n",$1,v[s],$2,$3,$4,$5,$6}'
}
