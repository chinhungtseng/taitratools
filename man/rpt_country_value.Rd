% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/generate_report.R
\name{rpt_country_value}
\alias{rpt_country_value}
\title{Simple calculate sum of every countries by year or month}
\usage{
rpt_country_value(.df, by = "year")
}
\arguments{
\item{.df}{A data frame. Your date must contain `country`, `year`, and `value` columns!}

\item{by}{summarise by year or month}
}
\value{
data.frame
}
\description{
Simple calculate sum of every countries by year or month
}
