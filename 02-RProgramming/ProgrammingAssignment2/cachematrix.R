## These two functions are responsible to store the
## inverse of a matrix in cache, so that it is not
## necessary to recompute it again after the first time

## This function creates a special matrix, which is actually
## a list containing a function to set/get value of matrix
## and to set/get the inverste of the matrix

makeCacheMatrix <- function(x = matrix()) {
  inv <- NULL
  set <- function(y) {
    x <<- y
    inv <<- NULL
  }
  get <- function() x
  setInverse <- function(invMatrix) inv <<- invMatrix
  getInverse <- function() inv

  list(set = set, get = get, setInverse = setInverse,
       getInverse = getInverse)
}


## This function computes the inverse of a matrix using
## the "matrix" defined in the above function. If the
## inverse had already been computed, return the cached
## value, though.

cacheSolve <- function(x, ...) {
  inv <- x$getInverse()
  if (!is.null(inv)) {
    message("Getting cached data")
    return(inv)
  }
  data <- x$get()
  inv <- solve(data, ...)
  x$setInverse(inv)
  inv
}
