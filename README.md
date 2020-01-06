
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

### Get data source path

### Read data

  - Get source path with `tt_get_path(PATH NAME)`
  - Read file with `tt_read_table`

<!-- end list -->

``` r
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

  - read mof data
      - `tt_vroom_mof()`
      - `tt_read_mof()`

This is a basic example which shows you how to read data from MOF, if
you want to read data with past year, you can set `period = N`

``` r
# Default is `export` and `usd`
mof_data <- tt_vroom_mof("2019-01", "2019-02", period = 1, direct = "export", money = "usd", dep_month_cols = TRUE)
head(mof_data)
#> # A tibble: 6 x 11
#>   hscode hscode_ch hscode_en country count count_unit weight weight_unit
#>   <chr>  <chr>     <chr>     <chr>   <dbl> <chr>       <dbl> <chr>      
#> 1 01061~ 海豹、海獅及海象~ Seals, s~ 中國大陸~     0 -             176 KGM        
#> 2 01061~ 松鼠      Squirrel~ 馬來西亞~     0 -               3 KGM        
#> 3 01062~ 鱉（甲魚）及苗~ Soft-she~ 中國大陸~     0 -           19839 KGM        
#> 4 01062~ 其他陸龜（象龜）~ Other to~ 菲律賓      0 -              50 KGM        
#> 5 01063~ 鸚鵡目﹝包括鸚鵡~ Psittaci~ 伊拉克      0 -             105 KGM        
#> 6 01063~ 鸚鵡目﹝包括鸚鵡~ Psittaci~ 孟加拉      0 -              50 KGM        
#> # ... with 3 more variables: value <dbl>, year <chr>, month <chr>
```

### Data Transform

#### Industry data transforming

  - `tt_bind_industry()`
  - `tt_industry_grouped_sum()`

<!-- end list -->

``` r
# industry_type => "all_industry", "industry21", "version1", "version2"
mof_data %>% 
  tt_bind_industry(sub = 8, col_more = TRUE, industry_type = "industry21", verbose = FALSE) %>% 
  head(5)
#> # A tibble: 5 x 15
#>   hscode hscode_ch hscode_en country count count_unit weight weight_unit
#>   <chr>  <chr>     <chr>     <chr>   <dbl> <chr>       <dbl> <chr>      
#> 1 01061~ 海豹、海獅及海象~ Seals, s~ 中國大陸~     0 -             176 KGM        
#> 2 01061~ 松鼠      Squirrel~ 馬來西亞~     0 -               3 KGM        
#> 3 01062~ 鱉（甲魚）及苗~ Soft-she~ 中國大陸~     0 -           19839 KGM        
#> 4 01062~ 其他陸龜（象龜）~ Other to~ 菲律賓      0 -              50 KGM        
#> 5 01063~ 鸚鵡目﹝包括鸚鵡~ Psittaci~ 伊拉克      0 -             105 KGM        
#> # ... with 7 more variables: value <dbl>, year <chr>, month <chr>,
#> #   type <chr>, major <chr>, minor <chr>, industry <chr>
```

``` r
mof_industry_data <- mof_data %>% 
  tt_industry_grouped_sum(industry_type = "industry21", sub = 6, verbose = FALSE)

str(mof_industry_data)
#> List of 2
#>  $ industry_type: chr "industry21"
#>  $ data         :Classes 'tbl_df', 'tbl' and 'data.frame':   6152 obs. of  7 variables:
#>   ..$ type    : chr [1:6152] "全部產品" "全部產品" "全部產品" "全部產品" ...
#>   ..$ major   : chr [1:6152] "全部產品" "全部產品" "全部產品" "全部產品" ...
#>   ..$ minor   : chr [1:6152] "全部產品" "全部產品" "全部產品" "全部產品" ...
#>   ..$ industry: chr [1:6152] "全部產品_全部產品" "全部產品_全部產品" "全部產品_全部產品" "全部產品_全部產品" ...
#>   ..$ country : chr [1:6152] "千里達及托巴哥" "千里達及托巴哥" "土耳其" "土耳其" ...
#>   ..$ year    : chr [1:6152] "2018" "2019" "2018" "2019" ...
#>   ..$ value   : num [1:6152] 6282 4776 271304 144290 166 ...
head(mof_industry_data$data, 5)
#> # A tibble: 5 x 7
#>   type     major    minor    industry          country        year   value
#>   <chr>    <chr>    <chr>    <chr>             <chr>          <chr>  <dbl>
#> 1 全部產品 全部產品 全部產品 全部產品_全部產品 千里達及托巴哥 2018    6282
#> 2 全部產品 全部產品 全部產品 全部產品_全部產品 千里達及托巴哥 2019    4776
#> 3 全部產品 全部產品 全部產品 全部產品_全部產品 土耳其         2018  271304
#> 4 全部產品 全部產品 全部產品 全部產品_全部產品 土耳其         2019  144290
#> 5 全部產品 全部產品 全部產品 全部產品_全部產品 土庫曼         2018     166
```

#### Area data transforming

  - `tt_bind_area()`
  - `tt_append_global()`
  - `tt_append_area()`

Adding a area column

``` r
mof_industry_data$data %>% tt_bind_area() %>% head(5)
#> # A tibble: 5 x 8
#>   type     major    minor   industry        country      year   value area 
#>   <chr>    <chr>    <chr>   <chr>           <chr>        <chr>  <dbl> <chr>
#> 1 全部產品 全部產品 全部產品~ 全部產品_全部產品~ 千里達及托巴哥~ 2018    6282 全球 
#> 2 全部產品 全部產品 全部產品~ 全部產品_全部產品~ 千里達及托巴哥~ 2019    4776 全球 
#> 3 全部產品 全部產品 全部產品~ 全部產品_全部產品~ 土耳其       2018  271304 全球 
#> 4 全部產品 全部產品 全部產品~ 全部產品_全部產品~ 土耳其       2019  144290 全球 
#> 5 全部產品 全部產品 全部產品~ 全部產品_全部產品~ 土庫曼       2018     166 全球
```

Append area data

``` r
mof_industry_data$data %>% tt_append_area() %>% head(5)
#> # A tibble: 5 x 7
#>   type     major    minor    industry          country    year    value
#>   <chr>    <chr>    <chr>    <chr>             <chr>      <chr>   <dbl>
#> 1 全部產品 全部產品 全部產品 全部產品_全部產品 大洋洲     2018   622281
#> 2 全部產品 全部產品 全部產品 全部產品_全部產品 大洋洲     2019   615697
#> 3 全部產品 全部產品 全部產品 全部產品_全部產品 中東及近東 2018  1189816
#> 4 全部產品 全部產品 全部產品 全部產品_全部產品 中東及近東 2019   859674
#> 5 全部產品 全部產品 全部產品 全部產品_全部產品 中美洲     2018   493986
```

Append only world data

``` r
mof_industry_data$data %>% tt_append_global() %>% head(5)
#> # A tibble: 5 x 7
#>   type        major         minor  industry           country year    value
#>   <chr>       <chr>         <chr>  <chr>              <chr>   <chr>   <dbl>
#> 1 全部產品    全部產品      全部產品~ 全部產品_全部產品  全球    2018   4.94e7
#> 2 全部產品    全部產品      全部產品~ 全部產品_全部產品  全球    2019   4.74e7
#> 3 財政部定義產業~ 01_活動物,動物產品~ 全部產品~ 01_活動物,動物產品_全部產品~ 全球    2018   3.47e5
#> 4 財政部定義產業~ 01_活動物,動物產品~ 全部產品~ 01_活動物,動物產品_全部產品~ 全球    2019   3.18e5
#> 5 財政部定義產業~ 02_植物產品   全部產品~ 02_植物產品_全部產品~ 全球    2018   1.14e5
```

#### Others

  - `tt_grouped_sum()`
  - `tt_df_sub_hscode()`

grouped data and sum the value

``` r
mof_data %>% tt_grouped_sum(country, year, by = "value") %>% head(5)
#> # A tibble: 5 x 3
#>   country        year   value
#>   <chr>          <chr>  <dbl>
#> 1 千里達及托巴哥 2018    6282
#> 2 千里達及托巴哥 2019    4776
#> 3 土耳其         2018  271304
#> 4 土耳其         2019  144290
#> 5 土庫曼         2018     166
mof_data %>% tt_grouped_sum(year, month, by = "count") %>% head(5)
#> # A tibble: 4 x 3
#>   year  month        count
#>   <chr> <chr>        <dbl>
#> 1 2018  01    115226513407
#> 2 2018  02     92634718086
#> 3 2019  01    107429262706
#> 4 2019  02     73474545476
mof_data %>%
  tt_bind_industry(industry_type = "industry21", verbose = FALSE) %>% 
  tt_grouped_sum(industry, country, year, by = "weight") %>% head(5)
#> # A tibble: 5 x 4
#>   industry                    country        year  weight
#>   <chr>                       <chr>          <chr>  <dbl>
#> 1 01_活動物,動物產品_全部產品 千里達及托巴哥 2018  786310
#> 2 01_活動物,動物產品_全部產品 千里達及托巴哥 2019  306143
#> 3 01_活動物,動物產品_全部產品 土耳其         2019    9026
#> 4 01_活動物,動物產品_全部產品 大溪地         2018   16550
#> 5 01_活動物,動物產品_全部產品 大溪地         2019   15207
```
