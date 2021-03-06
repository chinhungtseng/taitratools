% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_mof.R
\name{tt_vroom_mof}
\alias{tt_vroom_mof}
\title{vroom Data from MOF SOURCE}
\usage{
tt_vroom_mof(
  start_date,
  end_date,
  period = 0,
  direct = "export",
  money = "usd",
  columns = NULL,
  dep_month_cols = FALSE,
  fixed_cny_nm = FALSE,
  source_path = "SOURCE_MOF"
)
}
\arguments{
\item{start_date}{Start date with "year-month" format. ex> "2019-01".}

\item{end_date}{End date with "year-month" format. ex> "2019-01".}

\item{period}{Integer.}

\item{direct}{A string used to specify `export` and `import` values. The default value is `export`.}

\item{money}{A string used to specify `usd` and `twd` value. The default value is `usd`.}

\item{columns}{a character vector.}

\item{dep_month_cols}{create year and month column, default is only year column with "\%Y-\%m" format.}

\item{fixed_cny_nm}{boolean: fixed country names. if you want to combine mof and 05_all_data you need to set fixed_cny_cols = TRUE}

\item{source_path}{source path.}
}
\value{
data.frame
}
\description{
Reading mof data with `start date` and `end date`. If you want to read data with many year you can specify the `period`.
}
