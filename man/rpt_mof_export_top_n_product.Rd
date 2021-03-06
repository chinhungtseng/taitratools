% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rpt_mof_export_top_n_product.R
\name{rpt_mof_export_top_n_product}
\alias{rpt_mof_export_top_n_product}
\title{rpt_mof_export_top_n_product}
\usage{
rpt_mof_export_top_n_product(
  start_date,
  end_date,
  period = 3,
  sub_hs_digits = 11,
  n = 3,
  country_list = NULL,
  money = "usd",
  industry_type = "all_industry",
  verbose = TRUE
)
}
\arguments{
\item{start_date}{start_date}

\item{end_date}{end_date}

\item{period}{period}

\item{sub_hs_digits}{hscode digits}

\item{n}{top n}

\item{country_list}{country list}

\item{money}{usd or twd}

\item{industry_type}{`all_industry` or `industry21` or `version1` or `version2`}

\item{verbose}{verbose}
}
\value{
list
}
\description{
rpt_mof_export_top_n_product
}
