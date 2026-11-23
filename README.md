# DBs for SQL courses from Hexlet

credentials:

```text
user: student
password: student
```

See [Makefile](./Makefile) and [Dockerfile](./Dockerfile)

`make test` builds the image, starts it and compares row counts of every table
with [test/expected_counts.tsv](./test/expected_counts.tsv). CI runs the same
check before pushing the image. After a deliberate change of the data, update
the counts in that file.
