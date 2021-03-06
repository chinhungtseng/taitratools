
<!-- README.md is generated from README.Rmd. Please edit that file -->

# taitratools <a href=''><img src='man/figures/logo.png' align="right" height="138.5" /></a>

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

area_tbl <- tt_read_table(path)
head(area_tbl)
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
```

``` r
mof_industry_data <- mof_data %>% 
  tt_industry_grouped_sum(industry_type = "industry21", sub = 6, verbose = FALSE)

str(mof_industry_data)
head(mof_industry_data$data, 5)
```

#### Area data transforming

  - `tt_bind_area()`
  - `tt_append_global()`
  - `tt_append_area()`

Adding a area column

``` r
mof_industry_data$data %>% tt_bind_area() %>% head(5)
```

Append area data

``` r
mof_industry_data$data %>% tt_append_area() %>% head(5)
```

Append only world data

``` r
mof_industry_data$data %>% tt_append_global() %>% head(5)
```

#### Others

  - `tt_grouped_sum()`
  - `tt_df_sub_hscode()`

grouped data and sum the value

``` r
mof_data %>% tt_grouped_sum(country, year, by = "value") %>% head(5)
mof_data %>% tt_grouped_sum(year, month, by = "count") %>% head(5)
mof_data %>%
  tt_bind_industry(industry_type = "industry21", verbose = FALSE) %>% 
  tt_grouped_sum(industry, country, year, by = "weight") %>% head(5)
```
