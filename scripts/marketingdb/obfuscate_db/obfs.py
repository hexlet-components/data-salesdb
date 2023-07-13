import argparse
import csv
from urllib.parse import urlparse, urlunparse

from pathlib import Path
import hashlib


def parse_args():
    parser = argparse.ArgumentParser(
        description='sum the integers at the command line',
        add_help="Obfuscate data in given csv field")
    parser.add_argument(
        '-i', '--input', type=str,
        help='input file')
    parser.add_argument(
        '-o', '--output', default=Path.cwd() / 'out.csv',
        help='output file', required=False)
    parser.add_argument(
        '-c', '--configs',
        help='config file with fields (if provided)', required=False)
    args = parser.parse_args()
    if args.configs:
        configs = {}
        with open(args.configs) as c:
            for line in c:
                tokens = line.split('=')
                key = tokens[0]
                values = [t.strip() for t in tokens[1].split(',')]
                configs[key] = values
    obfs = configs.get('obfuscate')
    rand = configs.get('randomize')
    delete = configs.get('delete')
    return {
        'input': args.input,
        'output': args.output,
        'obfuscate': obfs,
        'random': rand,
        'delete': delete,
    }


def parse(inputpath, outpath, obf_fields=None,rand_fields=None, del_fields=None):
    if obf_fields is None:
        obf_fields = []
    if rand_fields is None:
        rand_fields = []
    if del_fields is None:
        del_fields = []

    with open(inputpath) as f, open(outpath, 'w') as o:
        reader = csv.DictReader(f)
        fieldnames = reader.fieldnames
        # change header by deleted fields
        if del_fields:
            fieldnames = [f for f in fieldnames if f not in del_fields]
        writer = csv.DictWriter(o, fieldnames=fieldnames)
        writer.writeheader()
        for row in reader:
            # skip rows with empty values
            if not all(row.values()):
                continue
            # change row by deleted fields
            row = {k:v for k, v in row.items() if k not in del_fields}
            for key, value in row.items():
                # obfuscate given fields
                if key in obf_fields:
                    if is_url(value):
                        new_value = obfuscate_url(value)
                    else:
                        new_value = obfuscate(value)
                    row[key] = new_value
                # randomize given fields
                if key in rand_fields:
                    new_value = randomize(value)
                    row[key] = new_value
            writer.writerow(row)
    return outpath


def is_url(value):
    return value.startswith('http')


def obfuscate(value):
    h = hashlib.sha1(value.encode())
    return h.hexdigest()


def obfuscate_url(url):
    o = urlparse(url)
    new_hostname = 'foobar.com'
    new_path = obfuscate(o.path)
    return urlunparse([o.scheme, new_hostname, new_path, '', '', ''])



def randomize(value):
    return int(float(value) * 2.54)


def main():
    args = parse_args()
    parse(
        args['input'],
        args['output'],
        obf_fields=args['obfuscate'],
        rand_fields=args['random'],
        del_fields=args['delete'],
    )


if __name__ == '__main__':
    main()
