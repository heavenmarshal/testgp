\name{SL2D}
\alias{SL2D}

\title{
  Square \eqn{L_{2}} Discrepancy Approach for Estimating the
  Solution to the Inverse Problem
}

\description{This function fits an SVD-based GP model on the
  design set \code{design} and response matrix \code{resp}, and
  minimizes the square \eqn{L_{2}} discrepancy between the target
  response and the predicted mean of the SVD-based GP model on the
  candidate set \code{candidate} to estimate the solution to the inverse
  problem. It is a naive approach for estimating the solution provided
  in Chapter 4 of Zhang (2018).
}
\usage{
SL2D(design,resp,yobs,candidate,frac=.95,
     mtype=c("zmean","cmean","lmean"),
     gstart=0.0001)
}
\arguments{

  \item{design}{ An \eqn{N} by \eqn{d} matrix of \eqn{N}
    training/design inputs.}

  \item{resp}{ An \eqn{L} by \eqn{N} response matrix of \code{design},
    where \eqn{L} is the length of the time series outputs, \eqn{N} is
    the number of design points.}

  \item{yobs}{ An array of length \eqn{L} of the time-series valued
    field observations or the target response.
  }

  \item{candidate}{ An \eqn{M} by \eqn{d} matrix of \eqn{M} candidate points
    on which the estimated solution to the inverse problem is obtained.
  }

  \item{frac}{
    The threshold in the cumulative percentage criterion to select the
    number of SVD bases. The default value is 0.9.
  }

  \item{mtype}{ The type of mean functions for the SVD-based GP models. The choice
    "zmean" denotes zero-mean, "cmean" indicates constant-mean, "lmean" indicates
    linear-mean.
  }
  \item{gstart}{
    The starting number and upper bound of for estimating the nugget
    parameter. If \code{gstart = sqrt(.Machine$double.eps)}, the nugget
    will be fixed at \code{sqrt(.Machine$double.eps)}, since the it is
    the lower bound of the nugget term. The default value is 0.0001.
  }
}

\value{
  \item{xhat}{The estimated solution to the inverse problem obtained on the
    candidate set \code{candidate}.}
}

\author{Ru Zhang \email{heavenmarshal@gmail.com},

  C. Devon Lin \email{devon.lin@queensu.ca},

  Pritam Ranjan \email{pritam.ranjan@gmail.com}}

\seealso{\code{\link{ESL2D}}, \code{\link{saEI}}.}

\references{ Zhang, R. (2018) \emph{Modeling and Analysis of Dynamic Computer Experiments},
    PhD thesis, Queen's University.}
\examples{
  library("lhs")
  forretal <- function(x,t,shift=1)
  {
    par1 <- x[1]*6+4
    par2 <- x[2]*16+4
    par3 <- x[3]*6+1
    t <- t+shift
    y <- (par1*t-2)^2*sin(par2*t-par3)
  }
  timepoints <- seq(0,1,len=200)
  design <- lhs::randomLHS(30,3)
  candidate <- lhs::randomLHS(1000,3)
  ## evaluate the response matrix on the design matrix
  resp <- apply(design,1,forretal,timepoints)
  x0 <- runif(3)
  y0 <- forretal(x0,timepoints)
  yobs <- y0+rnorm(200,0,sd(y0)/sqrt(50))
  xhat <- SL2D(design,resp,yobs,candidate)
}
\keyword{GP model}
\keyword{Inverse problem}
\keyword{SVD}
