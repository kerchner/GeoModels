\name{GeoNeighborhood}
\alias{GeoNeighborhood}
\encoding{UTF-8}
\title{Spatio (temporal) neighborhood selection for local kriging.}
\description{
The procedure select a spatio (temporal) neighborhood for  
a given spatial (temporal) location.
}

\usage{
GeoNeighborhood(data, coordx, coordy=NULL, coordt=NULL, coordx_dyn=NULL, distance="Eucl", grid=FALSE, 
                  loc, maxdist=NULL,maxtime=NULL, radius=6371, time=NULL, X=NULL)
}
\arguments{
  \item{data}{A \eqn{d}{d}-dimensional vector (a single spatial realisation)  or a (\eqn{d \times d}{d x d})-matrix (a single spatial realisation on regular grid)
   or a
   (\eqn{t \times d}{t x d})-matrix (a single spatial-temporal realisation)   or an (\eqn{d \times d \times t \times n }{d x d x t})-array
   (a single spatial-temporal realisation on regular grid).}
  \item{coordx}{A numeric (\eqn{d \times 2}{d x 2})-matrix (where
    \code{d} is the number of spatial sites) giving 2-dimensions of spatial coordinates or a numeric \eqn{d}{d}-dimensional vector giving
    1-dimension of spatial coordinates.
     Coordinates on a sphere for a  fixed radius \code{radius} 
    are passed in lon/lat format expressed in decimal degrees.}
  \item{coordy}{A numeric vector giving 1-dimension of
    spatial coordinates; \code{coordy} is interpreted only if \code{coordx} is a numeric
    vector or \code{grid=TRUE} otherwise it will be ignored. Optional argument, the default is \code{NULL} then \code{coordx} is expected to
    be numeric a (\eqn{d \times 2}{d x 2})-matrix.}
  \item{coordt}{A numeric vector giving 1-dimension of
    temporal coordinates.  Optional argument, the default is \code{NULL}
    then a spatial RF is expected.}
  \item{coordx_dyn}{A list of \eqn{m} numeric (\eqn{d_t \times 2}{d x 2})-matrices
       containing dynamical (in time) spatial coordinates. Optional argument, the default is \code{NULL}
    }
  \item{distance}{String; the name of the spatial distance. The default
    is \code{Eucl}, the euclidean distance. See the Section
    \bold{Details}  of \code{\link{GeoFit}}.}
  \item{grid}{Logical; if \code{FALSE} (the default) the data
    are interpreted as spatial or spatial-temporal realisations on a set
    of non-equispaced spatial sites (irregular grid).}
  \item{loc}{A (\eqn{1 \times 2}{1 x 2})-matrix  giving the spatial coordinate
     of the location for which a neighborhood is computed .}
 \item{maxdist}{Numeric; a positive value indicating the maximum
    spatial distance considered in the spatial neighborhood
    selection.}
  \item{maxtime}{Numeric; a positive value indicating the maximum
    temporal distance considered in the temporal neighborhood
    selection.}
    \item{radius}{Numeric; a value indicating  the radius of the sphere when using the great 
    circle distance. Default value is the radius of the earth in Km (i.e. 6371)}  
   \item{time}{Numeric; a value  giving the temporal instant for which a neighborhood is computed.}
  \item{X}{Numeric; Matrix of space-time covariates.}
}


\value{
  Returns a list  containing the following informations:
  \item{coordx}{A matrix of  the  coordinates of the computed spatial neighborhood;}
  \item{coordt}{A vector  of the computed temporal neighborhood;}
  \item{data}{The vector of data associated with the spatio  (temporal) neighborhood;}
  \item{distance}{The type of spatial distance;}
  \item{numcoord}{The number of location sites of the spatial neighborhood;}
  \item{numtime}{The number of instants of the temporal neighborhood;}
  \item{radius}{The radius of the sphere if coordinates are passed in lon/lat format;}
  \item{spacetime}{\code{TRUE} if spatio-temporal and \code{FALSE} if spatial RF;}
  \item{X}{The matrix of spatio  (temporal) covariates associated with the computed spatio  (temporal) neighborhood;}
}



\author{Moreno Bevilacqua, \email{moreno.bevilacqua@uv.cl},\url{https://sites.google.com/a/uv.cl/moreno-bevilacqua/home},
Víctor Morales Oñate, \email{victor.morales@uv.cl}, \url{https://sites.google.com/site/moralesonatevictor/}
}


\examples{
library(GeoModels)
##########################################
#### Example: spatial local kriging ######
##########################################
set.seed(7)
coords=cbind(runif(100),runif(100))

param=list(nugget=0,mean=0,scale=0.2,sill=1,
            power2=4,smooth=1)

data_all = GeoSim(coordx=coords, corrmodel="GenWend", 
                         param=param)$data

##location to predict
loc_to_pred<-matrix(c(0.5,0.5),1,2)

loc_kri=GeoNeighborhood(data_all, coordx=coords,  
                  loc=loc_to_pred,maxdist=0.15)

## global kriging 
pr_all=GeoKrig(loc=loc_to_pred,coordx=coords,corrmodel="GenWend",
                param=param,mse=TRUE, data=data_all)
## local kriging 
pr_loc=GeoKrig(loc=loc_to_pred,coordx=loc_kri$coordx,corrmodel="GenWend",
                param=param,mse=TRUE, data=loc_kri$data)

pr_all$pred;pr_loc$pred
pr_all$mse;pr_loc$mse


###################################################
#### Example: spatio temporal  local kriging ######
###################################################

set.seed(78)
coords=cbind(runif(100),runif(100))
coordt=seq(0,4,0.25)

param=list(nugget=0,mean=0,scale_s=0.2/3,scale_t=0.5/3,sill=1)

data_all = GeoSim(coordx=coords, coordt=coordt,corrmodel="Exp_Exp", 
                         param=param)$data
##location to predict
loc_to_pred<-matrix(c(0.5,0.5),1,2)
time=2

loc_kri=GeoNeighborhood(data_all, coordx=coords,  coordt=coordt,
                  loc=loc_to_pred,maxdist=0.4,maxtime=2.5)
## global kriging 
pr_all=GeoKrig(loc=loc_to_pred,time=time,coordx=coords,coordt=coordt,
                corrmodel="Exp_Exp",
                param=param,mse=TRUE, data=data_all)
## local kriging 
pr_loc=GeoKrig(loc=loc_to_pred,time=time,coordx=loc_kri$coordx,
              coordt=loc_kri$coordt,corrmodel="Exp_Exp",
                param=param,mse=TRUE, data=loc_kri$data)

pr_all$pred;pr_loc$pred
pr_all$mse;pr_loc$mse

}
