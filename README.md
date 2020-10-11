# Qumulo Bash Tools for File Storage API

- Click `Download Qumulo qq Command-Line Tool` from your cluster: `qp01.storage.example.com/api`
- Place the `qq` binary somewhere we can reference easily: `~/Downloads/qumulo_api/`
- Create [.qqrc.bash](https://github.com/JacobsLadd3r/Qumulo/blob/main/.qqrc.bash) file to source
- Add a source line [.bashrc](https://github.com/JacobsLadd3r/Qumulo/blob/main/.bashrc)

## Login to API

- Login to your Production cluster with our ```qplogin``` alias
```
qplogin
Password:
```

## Use qq alias to make API calls

- Take a look at [all qq CLI commands](https://care.qumulo.com/hc/en-us/articles/115013331308-QQ-CLI-Comprehensive-List-of-Commands)
- Now you can simply use your `qq` alias to directly call commands
- Most will return raw JSON responses:

```bash
qq fs_read_dir_aggregates --path /qumuloFS/tmp/
{
    "files": [
        {
            "capacity_usage": "1305235456",
            "data_usage": "1303920640",
            "id": "159263776948",
            "meta_usage": "1314816",
            "name": "0-keep",
            "named_stream_data_usage": "0",
            "num_directories": "49",
            "num_files": "265",
            "num_named_streams": "0",
            "num_other_objects": "0",
            "num_symlinks": "0",
            "type": "FS_FILE_TYPE_DIRECTORY"
        },
...

```

- You can then use other command-line tools like `jq`, `sort`, `column` and more to adjust the display of data:

```bash
qq fs_read_dir_aggregates --path /qumuloFS/tmp/ | jq -r '.files | to_entries[] | [.value.capacity_usage, .value.num_directories, .value.num_files, .value.num_symlinks, .value.type, .value.name] | @tsv' | sort -nrk1 | column -t | head

1305235456  49  265  0  FS_FILE_TYPE_DIRECTORY  0-keep
1552384     0   1    0  FS_FILE_TYPE_FILE       dnf.librepo.log-20200913
1323008     0   1    0  FS_FILE_TYPE_FILE       prefs.txt
12288       0   1    0  FS_FILE_TYPE_FILE       jobs.txt
```

## Use qls function for formatted API calls

- The `qls` function from our [.qqrc.bash](https://github.com/JacobsLadd3r/Qumulo/blob/main/.qqrc.bash) can be used to get a formatted directory listing:

```bash
qls /qumuloFS/tmp

 capacity      dirs      files   symlinks         type           name
  1.22 GB        49        265          0 FS_FILE_TYPE_DIRECTORY 0-keep
  1.48 MB         0          1          0 FS_FILE_TYPE_FILE      dnf.librepo.log-20200913
  1.26 MB         0          1          0 FS_FILE_TYPE_FILE      prefs.txt
 12.00 KB         0          1          0 FS_FILE_TYPE_FILE      jobs.txt
```
