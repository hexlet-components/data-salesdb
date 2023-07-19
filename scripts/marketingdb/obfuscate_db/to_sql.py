import argparse
import csv
from pathlib import Path


HEADER = "INSERT INTO sessions(visitor_id,datetime,landing_page,source,medium,campaign,content) VALUES "
QUERY =  f"({0})".format


def parse_args():
    parser = argparse.ArgumentParser(
        description='converts csv to sql',)
    parser.add_argument(
        '-i', '--input', type=str,
        help='input file')
    parser.add_argument(
        '-o', '--output', default=Path.cwd() / 'out.sql',
        help='output file', required=False)
    args = parser.parse_args()
    return args


def to_sql(file, out):
    with open(file) as f, open(out, 'w') as o:
        c = csv.reader(f)
        o.write(HEADER)
        next(c)
        acc = []
        for row in c:
            r = ','.join(f"'{w}'" for w in row)
            r = r.replace('(not set)', 'NULL')
            r = f'({r})'
            acc.append(r)
        o.write(','.join(acc))
        o.write(';')


def main():
    args = parse_args()
    to_sql(args.input, args.output)


if __name__ == '__main__':
    main()
