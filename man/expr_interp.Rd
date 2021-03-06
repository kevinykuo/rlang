% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/expr-interp.R
\name{expr_interp}
\alias{expr_interp}
\title{Process unquote operators in a captured expression}
\usage{
expr_interp(x, env = NULL)
}
\arguments{
\item{x}{A function, raw expression, or formula to interpolate.}

\item{env}{The environment in which unquoted expressions should be
evaluated. By default, the formula or closure environment if a
formula or a function, or the current environment otherwise.}
}
\description{
While all capturing functions in the tidy evaluation framework
perform unquote on capture (most notably \code{\link[=quo]{quo()}}),
\code{expr_interp()} manually processes unquoting operators in
expressions that are already captured. \code{expr_interp()} should be
called in all user-facing functions expecting a formula as argument
to provide the same quasiquotation functionality as NSE functions.
}
\examples{
# All tidy NSE functions like quo() unquote on capture:
quo(list(!! 1 + 2))

# expr_interp() is meant to provide the same functionality when you
# have a formula or expression that might contain unquoting
# operators:
f <- ~list(!! 1 + 2)
expr_interp(f)

# Note that only the outer formula is unquoted (which is a reason
# to use expr_interp() as early as possible in all user-facing
# functions):
f <- ~list(~!! 1 + 2, !! 1 + 2)
expr_interp(f)


# Another purpose for expr_interp() is to interpolate a closure's
# body. This is useful to inline a function within another. The
# important limitation is that all formal arguments of the inlined
# function should be defined in the receiving function:
other_fn <- function(x) toupper(x)

fn <- expr_interp(function(x) {
  x <- paste0(x, "_suffix")
  !!! body(other_fn)
})
fn
fn("foo")
}
