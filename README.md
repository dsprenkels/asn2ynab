# `asn2ynab.sh`

`asn2ynab.sh` is a shell script that allows you to convert transaction
exports from the [ASN Bank](https://www.asnbank.nl) CSV format, to the
files suitable for importing into
[You Need A Budget (YNAB)](https://youneedabudget.com).

To use this file, use the export functionality in the ASN banking app.
(In Dutch),

- go to `Transactieoverzicht`;
- click `Downloaden`;
- for `Bestandsformaat`, select `CSV` (_not `CSV 2004`!_);
- choose a date range and download the file.

```sh
# Call the script on the newly downloaded file:
./asn2ynab.sh downloaded_file.csv

# This will produce a file called 'downloaded_file_ynab.csv'.
```

The converted file can now be imported into YNAB (e.g., by drag-and-dropping).