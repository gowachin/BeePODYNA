% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/simulate.R
\name{logistic_growth}
\alias{logistic_growth}
\title{Function describing a logistical growth, has to bee included in a beepodyda object when creating it}
\usage{
logistic_growth(pop, community, interactions)
}
\arguments{
\item{pop}{index of the population that will be affected by the function, or the name of the pop}

\item{community}{a `community` object created with community()}

\item{interactions}{an `interactions` object created with interactions()}
}
\value{
The function returns a community similare to the one given in `community` but the population selected with `pop` will have one more time index and size (calculed with its growth rate and capacity, according to a logistical growth)
}
\description{
Function describing a logistical growth, has to bee included in a beepodyda object when creating it
}
\examples{
    data(hudson)
    logistic_growth(1,hudson,interactions(2))

}
