
<!-- README.md is generated from README.Rmd. Please edit that file -->

# taitratools

<!-- badges: start -->

<!-- badges: end -->

Taitra Tools package gather all useful helper functions.

Most function in `taitratools` are prefix with `tt_`.

You can list all source path with `tt_ls()` funciton, read data with
`tt_read_table()` or `tt_read_mof()` …

``` r
# install.packages("devtools")
devtools::install_github("chinhungtseng/taitratools")
```

## Example

### get data source path

Get source path with `tt_get_path(PATH NAME)` Read file with
`tt_read_table`

``` r
library(taitratools)

path <- tt_get_path("PATH_AREA")
path
#> [1] "//172.26.1.102/dstore/重要資料/area.xlsx"

area_tbl <- tt_read_table(path)
head(area_tbl)
#> # A tibble: 6 x 2
#>   areaName countryName                                                     
#>   <chr>    <chr>                                                           
#> 1 全球     大溪地,巴布亞紐幾內亞,未列名美屬太平洋領域,吉里巴斯,吐瓦魯,其他大洋洲地區,帛琉,東加,美屬薩摩亞,索羅門群島,紐西蘭,紐~
#> 2 亞洲     土耳其,巴林,巴勒斯坦,以色列,卡達,伊拉克,伊朗,沙烏地阿拉伯,其他中東及近東地區,阿拉伯聯合大公國,阿曼,阿富汗,科威特,~
#> 3 歐洲     丹麥,比利時,白俄羅斯,立陶宛,冰島,列支敦斯登,匈牙利,安道爾,西班牙,克羅埃西亞,希臘,其他歐洲地區,拉脫維亞,波士尼亞及~
#> 4 北美洲   加拿大,其他北美洲地區,美國,格陵蘭,其他北美洲地區,美國小島嶼,百慕達,其他北美洲國家~
#> 5 中美洲   千里達及托巴哥,巴貝多,巴哈馬,巴拿馬,牙買加,古巴,尼加拉瓜,未列名法屬中美洲領域,未列名美屬中美洲領域,未列名英屬中美洲領~
#> 6 南美洲   厄瓜多,巴西,巴拉圭,其他南美洲地區,委內瑞拉,法屬圭亞那,阿根廷,玻利維亞,哥倫比亞,烏拉圭,秘魯,智利,圭亞那,蘇利南,福~
```

### MOF

This is a basic example which shows you how to read data from MOF:

``` r
# Default is `export` and `usd`
sample1 <- tt_read_mof("2019-01", "2019-02")
#> [2019-10-25 12:51:37] //172.26.1.102/dstore/Projects/data/mof-export-usd/2019-01.tsv
#> [2019-10-25 12:51:38] //172.26.1.102/dstore/Projects/data/mof-export-usd/2019-02.tsv
head(sample1)
#> # A tibble: 6 x 10
#>   hscode hscode_ch hscode_en country count count_unit weight weight_unit
#>   <chr>  <chr>     <chr>     <chr>   <dbl> <chr>       <dbl> <chr>      
#> 1 01061~ 海豹、海獅及海象~ " Seals,~ 中國大陸~     0 "-   "        176 "KGM "     
#> 2 01061~ 松鼠      " Squirr~ 馬來西亞~     0 "-   "          3 "KGM "     
#> 3 01062~ 鱉（甲魚）及苗~ " Soft-s~ 中國大陸~     0 "-   "      19839 "KGM "     
#> 4 01062~ 其他陸龜（象龜）~ " Other ~ 菲律賓      0 "-   "         50 "KGM "     
#> 5 01063~ 鸚鵡目﹝包括鸚鵡~ " Psitta~ 伊拉克      0 "-   "        105 "KGM "     
#> 6 01063~ 鸚鵡目﹝包括鸚鵡~ " Psitta~ 孟加拉      0 "-   "         50 "KGM "     
#> # ... with 2 more variables: value <dbl>, year <chr>
```

If you want to read data with past year, you can set `period = N`,

``` r
# Read this year and last year, set period = 1
sample2 <- tt_read_mof("2019-01", "2019-02", period = 1)
#> [2019-10-25 12:51:38] //172.26.1.102/dstore/Projects/data/mof-export-usd/2019-01.tsv
#> [2019-10-25 12:51:38] //172.26.1.102/dstore/Projects/data/mof-export-usd/2019-02.tsv
#> [2019-10-25 12:51:38] //172.26.1.102/dstore/Projects/data/mof-export-usd/2018-01.tsv
#> [2019-10-25 12:51:39] //172.26.1.102/dstore/Projects/data/mof-export-usd/2018-02.tsv
head(sample2)
#> # A tibble: 6 x 10
#>   hscode hscode_ch hscode_en country count count_unit weight weight_unit
#>   <chr>  <chr>     <chr>     <chr>   <dbl> <chr>       <dbl> <chr>      
#> 1 01061~ 海豹、海獅及海象~ " Seals,~ 中國大陸~     0 "-   "        176 "KGM "     
#> 2 01061~ 松鼠      " Squirr~ 馬來西亞~     0 "-   "          3 "KGM "     
#> 3 01062~ 鱉（甲魚）及苗~ " Soft-s~ 中國大陸~     0 "-   "      19839 "KGM "     
#> 4 01062~ 其他陸龜（象龜）~ " Other ~ 菲律賓      0 "-   "         50 "KGM "     
#> 5 01063~ 鸚鵡目﹝包括鸚鵡~ " Psitta~ 伊拉克      0 "-   "        105 "KGM "     
#> 6 01063~ 鸚鵡目﹝包括鸚鵡~ " Psitta~ 孟加拉      0 "-   "         50 "KGM "     
#> # ... with 2 more variables: value <dbl>, year <chr>
```

Read mof data and input specified industry

``` r
ind_sample1 <- rpt_mof_industry_region("2019-01", "2019-03", "手工具", "country")
#> [2019-10-25 12:51:39] //172.26.1.102/dstore/Projects/data/mof-export-usd/2019-01.tsv
#> [2019-10-25 12:51:40] //172.26.1.102/dstore/Projects/data/mof-export-usd/2019-02.tsv
#> [2019-10-25 12:51:40] //172.26.1.102/dstore/Projects/data/mof-export-usd/2019-03.tsv
#> [2019-10-25 12:51:40] //172.26.1.102/dstore/Projects/data/mof-export-usd/2018-01.tsv
#> [2019-10-25 12:51:40] //172.26.1.102/dstore/Projects/data/mof-export-usd/2018-02.tsv
#> [2019-10-25 12:51:40] //172.26.1.102/dstore/Projects/data/mof-export-usd/2018-03.tsv
#> [2019-10-25 12:51:41] 手工具_全部產品 (  1/  4)
#> [2019-10-25 12:51:41] 手工具_非動力手工具 (  2/  4)
#> [2019-10-25 12:51:42] 手工具_動力手工具(氣動類) (  3/  4)
#> [2019-10-25 12:51:42] 手工具_動力手工具(電動類) (  4/  4)
#> [2019-10-25 12:51:42] 手工具_全部產品
#> [2019-10-25 12:51:42] 手工具_非動力手工具
#> [2019-10-25 12:51:42] 手工具_動力手工具(氣動類)
#> [2019-10-25 12:51:42] 手工具_動力手工具(電動類)
# The output is a list.
head(ind_sample1[[1]])
#> # A tibble: 6 x 8
#>   country  `2018` `2019` difference growth_rate shared industry   period   
#>   <chr>     <dbl>  <dbl>      <dbl>       <dbl>  <dbl> <chr>      <chr>    
#> 1 全球     926671 921305      -5366      -0.579 100    手工具_全部產品~ 2019-01 ~
#> 2 美國     307267 325853      18586       6.05   35.4  手工具_全部產品~ 2019-01 ~
#> 3 中國大陸 106101  84563     -21538     -20.3     9.18 手工具_全部產品~ 2019-01 ~
#> 4 德國      55770  61686       5916      10.6     6.70 手工具_全部產品~ 2019-01 ~
#> 5 日本      50204  57659       7455      14.8     6.26 手工具_全部產品~ 2019-01 ~
#> 6 荷蘭      33303  31416      -1887      -5.67    3.41 手工具_全部產品~ 2019-01 ~

ind_sample2 <- rpt_mof_industry_region("2019-01", "2019-03", "手工具", "area")
#> [2019-10-25 12:51:42] //172.26.1.102/dstore/Projects/data/mof-export-usd/2019-01.tsv
#> [2019-10-25 12:51:42] //172.26.1.102/dstore/Projects/data/mof-export-usd/2019-02.tsv
#> [2019-10-25 12:51:42] //172.26.1.102/dstore/Projects/data/mof-export-usd/2019-03.tsv
#> [2019-10-25 12:51:42] //172.26.1.102/dstore/Projects/data/mof-export-usd/2018-01.tsv
#> [2019-10-25 12:51:42] //172.26.1.102/dstore/Projects/data/mof-export-usd/2018-02.tsv
#> [2019-10-25 12:51:42] //172.26.1.102/dstore/Projects/data/mof-export-usd/2018-03.tsv
#> [2019-10-25 12:51:43] 手工具_全部產品 (  1/  4)
#> [2019-10-25 12:51:43] 手工具_非動力手工具 (  2/  4)
#> [2019-10-25 12:51:43] 手工具_動力手工具(氣動類) (  3/  4)
#> [2019-10-25 12:51:43] 手工具_動力手工具(電動類) (  4/  4)
#> [2019-10-25 12:51:43] 手工具_全部產品
#> [2019-10-25 12:51:44] 手工具_非動力手工具
#> [2019-10-25 12:51:44] 手工具_動力手工具(氣動類)
#> [2019-10-25 12:51:44] 手工具_動力手工具(電動類)
head(ind_sample2[[2]])
#> # A tibble: 6 x 8
#>   area   `2018` `2019` difference growth_rate shared industry    period    
#>   <chr>   <dbl>  <dbl>      <dbl>       <dbl>  <dbl> <chr>       <chr>     
#> 1 全球   683846 685060       1214       0.178  100   手工具_非動力手工具~ 2019-01 t~
#> 2 北美洲 206802 227110      20308       9.82    33.2 手工具_非動力手工具~ 2019-01 t~
#> 3 歐洲   219097 221675       2578       1.18    32.4 手工具_非動力手工具~ 2019-01 t~
#> 4 歐盟   199249 198286       -963      -0.483   28.9 手工具_非動力手工具~ 2019-01 t~
#> 5 亞洲   202860 185302     -17558      -8.66    27.0 手工具_非動力手工具~ 2019-01 t~
#> 6 新南向  71146  73190       2044       2.87    10.7 手工具_非動力手工具~ 2019-01 t~
```

### Other functions

``` r
# Create a sample data
sample3 <- tt_read_mof("2019-01", "2019-03", period = 1)
#> [2019-10-25 12:51:44] //172.26.1.102/dstore/Projects/data/mof-export-usd/2019-01.tsv
#> [2019-10-25 12:51:44] //172.26.1.102/dstore/Projects/data/mof-export-usd/2019-02.tsv
#> [2019-10-25 12:51:44] //172.26.1.102/dstore/Projects/data/mof-export-usd/2019-03.tsv
#> [2019-10-25 12:51:44] //172.26.1.102/dstore/Projects/data/mof-export-usd/2018-01.tsv
#> [2019-10-25 12:51:44] //172.26.1.102/dstore/Projects/data/mof-export-usd/2018-02.tsv
#> [2019-10-25 12:51:45] //172.26.1.102/dstore/Projects/data/mof-export-usd/2018-03.tsv

# output by year
output3_1 <- rpt_country_value(sample3, by = "year")

head(output3_1)
#> # A tibble: 6 x 3
#>   country    `2018`   `2019`
#>   <chr>       <dbl>    <dbl>
#> 1 全球     79223812 75921015
#> 2 中國大陸 23176617 20290969
#> 3 美國      8852361 10589106
#> 4 香港      9621928  8804760
#> 5 日本      5446953  5727070
#> 6 南韓      3441669  4109946

# output by month
output3_2 <- rpt_country_value(sample3, by = "month")

head(output3_2)
#> # A tibble: 6 x 7
#>   country  `2018-01` `2018-02` `2018-03` `2019-01` `2019-02` `2019-03`
#>   <chr>        <dbl>     <dbl>     <dbl>     <dbl>     <dbl>     <dbl>
#> 1 全球      27261431  22169528  29792853  27121493  20319551  28479971
#> 2 中國大陸   7614588   5809144   9752885   7133549   5285370   7872050
#> 3 美國       3130234   2611255   3110872   3793811   2887835   3907460
#> 4 香港       3509566   2503032   3609330   3131667   2171534   3501559
#> 5 日本       1879262   1571175   1996516   2129904   1536020   2061146
#> 6 南韓       1270958    958835   1211876   1524769   1033680   1551497
```

``` r
# Create a sample data
sample4 <- tt_read_mof("2019-01", "2019-03", period = 1)
#> [2019-10-25 12:51:46] //172.26.1.102/dstore/Projects/data/mof-export-usd/2019-01.tsv
#> [2019-10-25 12:51:46] //172.26.1.102/dstore/Projects/data/mof-export-usd/2019-02.tsv
#> [2019-10-25 12:51:46] //172.26.1.102/dstore/Projects/data/mof-export-usd/2019-03.tsv
#> [2019-10-25 12:51:46] //172.26.1.102/dstore/Projects/data/mof-export-usd/2018-01.tsv
#> [2019-10-25 12:51:46] //172.26.1.102/dstore/Projects/data/mof-export-usd/2018-02.tsv
#> [2019-10-25 12:51:46] //172.26.1.102/dstore/Projects/data/mof-export-usd/2018-03.tsv

# output by year
head(rpt_area_value(sample4, by = "year"))
#> # A tibble: 6 x 3
#>   area     `2018`   `2019`
#>   <chr>     <dbl>    <dbl>
#> 1 全球   79223812 75921015
#> 2 亞洲   59079781 54112189
#> 3 新南向 16474004 14754963
#> 4 東協   14105461 12451742
#> 5 北美洲  9463534 11221635
#> 6 歐洲    7473543  7413348

# output by month
head(rpt_area_value(sample4, by = "month"))
#> # A tibble: 6 x 7
#>   area   `2018-01` `2018-02` `2018-03` `2019-01` `2019-02` `2019-03`
#>   <chr>      <dbl>     <dbl>     <dbl>     <dbl>     <dbl>     <dbl>
#> 1 全球    27261431  22169528  29792853  27121493  20319551  28479971
#> 2 亞洲    20356166  16020030  22703585  19182961  14419201  20510027
#> 3 新南向   5868901   4735744   5869359   5095198   4255484   5404281
#> 4 東協     5064797   4025488   5015176   4289785   3639528   4522429
#> 5 北美洲   3337289   2803944   3322301   4040667   3045491   4135477
#> 6 歐洲     2476206   2362397   2634940   2733210   1989521   2690617
```
