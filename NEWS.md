# taitratools 1.0.6 (in development)

## Data updates
* `.full_hscode` new add hscode: `0304499014`,`0304499015`,`0304499019`,`0304499091`,`0304499099`,
`0304599014`,`0304599015`,`0304599019`,`0304599091`,`0304599099`,`0304870040`,`0304870050`,
`0304870060`,`0304870099`,`0304999024`,`0304999025`,`0304999029`,`0304999030`

# taitratools 1.0.5

## New functions

* `contain_any_keywords()` check a character vector contain specified words 
* `contain_all_keywords()` check a character vector contain all specified words 
* `print_with_time()` fancy print
* `tt_industry_grouped_sum()` input data bind industry and grouped sum the value
* `tt_ext_world_value()` 
* `tt_df_sub_hscode()` cut the length of hscode, and sum the value
* `tt_df_filter_top_and_bottom_n()` filter a data.frame top n and bottom n rows
* `tt_parse_hscode()` input hscode, output hscode chinese name
* `tt_df_mutate_chinese_hscode()` same as `tt_parse_hscode()` but input is data.frame, output data.frame
* `rpt_mof_export_top_n_product()` 
* `rpt_mof_export_summary()`
* `rpt_mof_summary_dev()`

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
