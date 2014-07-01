# cldr
> cldr is a library to use information from [CLDR](http://cldr.unicode.org/) data.

## Plural Rules

To extract the plural rules from CLDR data, you need the file `common/supplemental/plurals.xml` from the core archive. Then, use `Cldr.PluralRules.Extract.from("path/to/plurals.xml")`.