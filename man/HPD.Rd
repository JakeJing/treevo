% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/HPD.R
\name{HPD}
\alias{HPD}
\title{Highest Posterior Density}
\usage{
HPD(particleDataFrame, percent = 0.95, returnData = F)
}
\arguments{
\item{particleDataFrame}{particleDataFrame output from doRun}

\item{percent}{Probability content of HPD}

\item{returnData}{Option to return data that falls within HPD interval}
}
\value{
Returns a matrix with weighted mean, sd, upper and lower HPD for
each free parameter
}
\description{
This function calculates HPD for each free parameter
}
\author{
Brian O'Meara and Barb Banbury
}
\references{
O'Meara and Banbury, unpublished
}

