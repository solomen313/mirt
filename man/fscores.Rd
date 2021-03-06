% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fscores.R
\name{fscores}
\alias{fscores}
\title{Compute factor score estimates (a.k.a, ability estimates, latent trait estimates, etc)}
\usage{
fscores(object, method = "EAP", full.scores = TRUE, rotate = "oblimin",
  Target = NULL, response.pattern = NULL, plausible.draws = 0,
  plausible.type = "normal", quadpts = NULL, returnER = FALSE,
  return.acov = FALSE, mean = NULL, cov = NULL, verbose = TRUE,
  full.scores.SE = FALSE, theta_lim = c(-6, 6), MI = 0, QMC = FALSE,
  custom_den = NULL, custom_theta = NULL, min_expected = 1,
  converge_info = FALSE, ...)
}
\arguments{
\item{object}{a computed model object of class \code{SingleGroupClass},
\code{MultipleGroupClass}, or \code{DiscreteClass}}

\item{method}{type of factor score estimation method. Can be expected
a-posteriori (\code{"EAP"}), Bayes modal (\code{"MAP"}), weighted likelihood estimation
(\code{"WLE"}), maximum likelihood (\code{"ML"}), or expected a-posteriori for sum scores
(\code{"EAPsum"}). Can also be \code{"plausible"} for a single plausible value imputation for
each case, and this is equivalent to setting \code{plausible.draws = 1}}

\item{full.scores}{if \code{FALSE} then a summary table with
factor scores for each unique pattern is displayed. Otherwise, a matrix of factor scores
for each response pattern in the data is returned (default)}

\item{rotate}{prior rotation to be used when estimating the factor scores. See
\code{\link{summary-method}} for details. If the object is not an exploratory model
then this argument is ignored}

\item{Target}{target rotation; see \code{\link{summary-method}} for details}

\item{response.pattern}{an optional argument used to calculate the factor scores and standard
errors for a given response vector or matrix/data.frame}

\item{plausible.draws}{number of plausible values to draw for future researchers
to perform secondary analyses of the latent trait scores. Typically used in conjunction
with latent regression predictors (see \code{\link{mirt}} for details), but can
also be generated when no predictor variables were modeled. If \code{plausible.draws}
is greater than 0 a list of plausible values will be returned}

\item{plausible.type}{type of plausible values to obtain. Can be either \code{'normal'} (default)
to use a normal approximation based on the ACOV matrix, or \code{'MH'} to obtain Metropolis-Hastings
samples from the posterior (silently passes object to \code{\link{mirt}}, therefore arguemnts like
\code{technical} can be supplied to increase the number of burn-in draws and discarded samples)}

\item{quadpts}{number of quadratures to use per dimension. If not specified, a suitable
one will be created which decreases as the number of dimensions increases
(and therefore for estimates such as EAP, will be less accurate). This is determined from
the switch statement
\code{quadpts <- switch(as.character(nfact), '1'=61, '2'=31, '3'=15, '4'=9, '5'=7, 3)}}

\item{returnER}{logical; return empirical reliability (also known as marginal reliability)
estimates as a numeric values?}

\item{return.acov}{logical; return a list containing covariance matrices instead of factors
scores? \code{impute = TRUE} not supported with this option}

\item{mean}{a vector for custom latent variable means. If NULL, the default for 'group' values
from the computed mirt object will be used}

\item{cov}{a custom matrix of the latent variable covariance matrix. If NULL, the default for
'group' values from the computed mirt object will be used}

\item{verbose}{logical; print verbose output messages?}

\item{full.scores.SE}{logical; when \code{full.scores == TRUE}, also return the
standard errors associated with each respondent? Default is \code{FALSE}}

\item{theta_lim}{lower and upper range to evaluate latent trait integral for each dimension. If
omitted, a range will be generated automatically based on the number of dimensions}

\item{MI}{a number indicating how many multiple imputation draws to perform. Default is 0,
indicating that no MI draws will be performed}

\item{QMC}{logical; use quasi-Monte Carlo integration? If \code{quadpts} is omitted the
default number of nodes is 15000}

\item{custom_den}{a function used to define the integration density (if required). The NULL default
  assumes that the multivariate normal distribution with the 'GroupPars' hyper-parameters are
  used. At the minimum must be of the form:

  \code{function(Theta, ...)}

  where Theta is a matrix of latent trait values (will be a grid of values
  if \code{method == 'EAPsum'} or \code{method == 'EAP'}, otherwise Theta will have only 1 row).
  Additional arguments may included and are caught through the \code{fscores(...)} input. The
  function \emph{must} return a numeric vector of density weights (one for each row in Theta)}

\item{custom_theta}{a matrix of custom integration nodes to use instead of the default, where
each column corresponds to the respective dimension in the model}

\item{min_expected}{when computing goodness of fit tests when \code{method = 'EAPsum'}, this value is used
to collapse across the conditioned total scores until the expected values are greater than this value. Note
that this only affect the goodness of fit tests and not the returned EAP for sum scores table}

\item{converge_info}{logical; include a column in the return objects containing a logical for each
response pattern indicating whether a maximum value was found (not relavent non-iterative methods,
such as EAP and EAPsum). Value is a reflection of the \code{code} element from \code{\link{nlm}}
(e.g., 1 indicates convergence)}

\item{...}{additional arguments to be passed to \code{nlm}}
}
\description{
Computes MAP, EAP, ML (Embretson & Reise, 2000), EAP for sum-scores (Thissen et al., 1995),
or WLE (Warm, 1989) factor scores with a multivariate normal
prior distribution using equally spaced quadrature. EAP scores for models with more than
three factors are generally not recommended since the integration grid becomes very large,
resulting in slower estimation and less precision if the \code{quadpts} are too low.
Therefore, MAP scores should be used instead of EAP scores for higher dimensional models.
Multiple imputation variants are possible for each estimator if a parameter
information matrix was computed, which are useful if the sample size/number of items were small.
As well, if the model contained latent regression predictors this information will
be used in computing MAP and EAP estimates (for these models, \code{full.scores=TRUE}
will always be used). Finally, plausible value imputation is also available, and will also account
for latent regression predictor effects.
}
\details{
The function will return either a table with the computed scores and standard errors,
the original data matrix with scores appended to the rightmost column, or the scores only. By
default the latent means and covariances are determined from the estimated object,
though these can be overwritten. Iterative estimation methods can be estimated
in parallel to decrease estimation times if a \code{\link{mirtCluster}} object is available.

If the input object is a discrete latent class object estimated from \code{\link{mdirt}}
then the returned results will be with respect to the posterior classification for each
individual. The method inputs for \code{'DiscreteClass'} objects may only be \code{'EAP'},
for posterior classification of each response pattern, or \code{'EAPsum'} for posterior
classification based on the raw sum-score.
}
\examples{

\dontrun{

mod <- mirt(Science, 1)
tabscores <- fscores(mod, full.scores = FALSE)
head(tabscores)
fullscores <- fscores(mod)
fullscores_with_SE <- fscores(mod, full.scores.SE=TRUE)
head(fullscores)
head(fullscores_with_SE)

#change method argument to use MAP estimates
fullscores <- fscores(mod, method='MAP')
head(fullscores)

#calculate MAP for a given response vector
fscores(mod, method='MAP', response.pattern = c(1,2,3,4))
#or matrix
fscores(mod, method='MAP', response.pattern = rbind(c(1,2,3,4), c(2,2,1,3)))

#use custom latent variable properties (diffuse prior for MAP is very close to ML)
fscores(mod, method='MAP', cov = matrix(1000), full.scores = FALSE)
fscores(mod, method='ML', full.scores = FALSE)

# EAPsum table of values based on total scores
fscores(mod, method = 'EAPsum', full.scores = FALSE)

#WLE estimation, run in parallel using available cores
mirtCluster()
head(fscores(mod, method='WLE', full.scores = FALSE))

#multiple imputation using 30 draws for EAP scores. Requires information matrix
mod <- mirt(Science, 1, SE=TRUE)
fs <- fscores(mod, MI = 30)
head(fs)

# plausible values for future work
pv <- fscores(mod, plausible.draws = 5)
lapply(pv, function(x) c(mean=mean(x), var=var(x), min=min(x), max=max(x)))

## define a custom_den function. EAP with a uniform prior between -3 and 3
fun <- function(Theta, ...) as.numeric(dunif(Theta, min = -3, max = 3))
head(fscores(mod, custom_den = fun))

# custom MAP prior: standard truncated normal between 5 and -2
library(msm)
# need the :: scope for parallel to see the function (not require if no mirtCluster() defined)
fun <- function(Theta, ...) msm::dtnorm(Theta, mean = 0, sd = 1, lower = -2, upper = 5)
head(fscores(mod, custom_den = fun, method = 'MAP', full.scores = FALSE))

}
}
\author{
Phil Chalmers \email{rphilip.chalmers@gmail.com}
}
\references{
Embretson, S. E. & Reise, S. P. (2000). Item Response Theory for Psychologists. Erlbaum.

Thissen, D., Pommerich, M., Billeaud, K., & Williams, V. S. L. (1995).
Item Response Theory for Scores on Tests Including Polytomous Items with Ordered Responses.
\emph{Applied Psychological Measurement, 19}, 39-49.

Warm, T. A. (1989). Weighted likelihood estimation of ability in item response theory.
\emph{Psychometrika, 54}, 427-450.
}
\seealso{
\code{\link{averageMI}}
}
\keyword{factor.scores}

