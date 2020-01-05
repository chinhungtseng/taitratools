# taitratools 1.0.5 (in development)

## New functions

* `contain_any_keywords()`
* `contain_all_keywords()`
* `print_with_time()`
* `tt_industry_grouped_sum()`
* `tt_ext_world_value()`
* `rpt_mof_export_summary()`
* `tt_df_sub_hscode()`
* `tt_df_filter_top_and_bottom_n()`
* `tt_parse_hscode()`
* `tt_df_mutate_chinese_hscode()`
* `rpt_mof_export_top_n_product()`

## Major changes

* `tt_bind_industry()` variable `ind21` and `report` are deplicated. New support `industry_type` variable.

# taitratools 1.0.4

* Added a `NEWS.md` file to track changes to the package.

## New functions

* `tt_read_itc_file()`
* `tt_English2Chinese()` Convert countries name from English to Chinese
* `tt_df_lower_name()` Convert column name to lowercase
* `tt_df_upper_name()` Convert column name to uppercase
* `tt_compare_hscode()` Compare two hscode and output the difference
* `tt_format_hscode()` Re-fomat hscode string
* `tt_grouped_sum()` Summarise value by specified columns
* `tt_append_global()` Summarise global value and append to origin data
* `tt_append_area()`
* `tt_spread_value()` Spread value by specifed column and replace NA's value with zero
* `tt_parse_date()`
* `rpt_mof_export_summary_by_each_country_and_industry()`

## Update Package Data

* .industry_tbl
* .industry_tbl_en
* .tt_ind_list_verion_1
* .tt_ind_verion_1_tbl
* .tt_ind_verion_1_tbl_en
* .tt_ind_list_verion_2
* .tt_ind_verion_2_tbl
* .tt_ind_verion_2_tbl_en

# taitratools 1.0.3

## New functions

* `tt_vroom_mof()` Same as `ttreadmof` function but read files faster
* `tt_convert_industry_name()` convert industry chinese name for reports
* `tt_order_by_industry_for_reports() `
* `numeric2Chinese()` Convert numeric numbers to Chinese characters

# taitratools 1.0.0 

## New functions

### Quick look and get source path

* `tt_ls()` List all source path
* `tt_get_path()` Get all source path

### Read data

* `tt_read_mof()` Read Data from MOF SOURCE
* `tt_read_table()` Easily read files.

### Group data by area or industry

* `tt_bind_area()`
* `tt_bind_industry()`

### Filter data by area or industry

* `tt_filter_by_area()` Filter data by area
* `tt_filter_by_hscode()` Filter data by specific hscode

### Data transforming 

* `rpt_area_value()` Simple calculate sum of every area by year or month
* `rpt_country_value()` Simple calculate sum of every country by year or month
* `rpt_mof_industry_region()`

### Calculation

* `cal_cagr()`
* `cal_growth_rate()`
* `cal_share()`

### Dealing with string 

* `break_line()`
* `toChString()`
* `str2regex()`

### Date and time convert

* `get_past_year()`
* `period_month()`
* `period_year()`
* `y2date()`
* `ym2date()`

### Some helper functions

* `tt_df_show()` Show data frame
* `tt_area_show()` Show area data
* `tt_hscode_show()` Show hscode chinese name
* `build_my_env()` Create two directories: './data' and './output'
