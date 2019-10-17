
<!-- README.md is generated from README.Rmd. Please edit that file -->

# taitratools

<!-- badges: start -->

<!-- badges: end -->

Taitra Tools package gather all useful helper functions.

Most function in `taitratools` are prefix with `tt_`.

You can list all source path with `tt_ls()` funciton, read data with
`tt_read_table()` or `tt_read_mof()` …

``` r
install.packages("taitratools")
```

## Example

This is a basic example which shows you how to list all source path:

``` r
library(taitratools)

tt_ls()
#> :( SOURCE_UN.insighteye  ==>  "//172.26.1.102/dstore/uncomtrade/un_merge_data"
#> :( SOURCE_UN.jack        ==>  "//172.20.23.190/ds/01_jack/jack工作內容/02_資料彙整與運算/01_UN_data.feather"
#> :( SOURCE_GTA            ==>  "//172.20.23.190/ds/01_jack/jack工作內容/02_資料彙整與運算/02_GTA_data.feather"
#> :( SOURCE_ITC            ==>  "//172.20.23.190/ds/01_jack/jack工作內容/02_資料彙整與運算/03_ITC_data.feather"
#> :( SOURCE_MIX            ==>  "//172.20.23.190/ds/01_jack/jack工作內容/02_資料彙整與運算/05_all_data_20190823.feather"
#> :( SOURCE_MOF            ==>  "//172.26.1.102/dstore/Projects/data"
#> :( PATH_AREA             ==>  "//172.26.1.102/dstore/重要資料/area.xlsx"
#> :( PATH_INDUSTRY         ==>  "//172.26.1.102/dstore/重要資料/產業hscode對照表_20191015.xlsx"
#> :( PATH_FULL_HSCODE      ==>  "//172.26.1.102/dstore/Projects/data/hscode_data/full_hscode11_20190822.tsv"
#> :( PATH_COUNTRY          ==>  "//172.26.1.102/dstore/重要資料/國家中英文對照.xlsx"
```
