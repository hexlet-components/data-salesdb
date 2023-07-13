Run  script to obfuscate data in db

## Flags

* `- i, --input` - input csv file
* `-o --output` - output csv file (`./out.csv` by default)
* `-c --config` - txt file with configs

## Configs

Script supports given configs:

* `obfuscate` - fields to obfuscate
* `random` - fiedls to randomize (numbers only)
* `delete` - fields to remove

## Usage

*y_params*
```txt

obfuscate=id
delete=term
randomize=cost
```

`python obfs.py -i y_ads.csv -o y_ads_obfs.csv -c y_params.txt`
