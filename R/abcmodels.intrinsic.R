#intrinsic models
#note that these work for univariate, but need to be generalized for multivariate
#otherstates has one row per taxon, one column per state
#states is a vector for each taxon, with length=nchar



#' Intrinsic Character Evolution Models
#'
#' This function describes a model of no intrinsic character change
#'
#'
#' @param params describes input paramaters for the model
#' @param states vector of states for each taxon
#' @param timefrompresent which time slice in the tree
#' @return A matrix of values representing character displacement from a single
#' time step in the tree.
#' @author Brian O'Meara and Barb Banbury
#' @references O'Meara and Banbury, unpublished
#' @keywords nullIntrinsic intrinsic
nullIntrinsic<-function(params,states, timefrompresent) {
	newdisplacement<-0*states
	return(newdisplacement)
}




#' Intrinsic Character Evolution Models
#'
#' This function describes a model of intrinsic character evolution via
#' Brownian motion.
#'
#'
#' @param params describes input paramaters for the model.
#' \code{boundaryIntrinsic} params = sd
#' @param states vector of states for each taxon
#' @param timefrompresent which time slice in the tree
#' @return A matrix of values representing character displacement from a single
#' time step in the tree.
#' @author Brian O'Meara and Barb Banbury
#' @references O'Meara and Banbury, unpublished
#' @keywords boundaryIntrinsic intrinsic
brownianIntrinsic<-function(params,states, timefrompresent) {
	newdisplacement<-rnorm(n=length(states),mean=0,sd=params) #mean=0 because we ADD this to existing values
	return(newdisplacement)
}




#' Intrinsic Character Evolution Models
#'
#' This function describes a model of intrinsic character evolution. Character
#' change is restricted above a minimum and below a maximum threshold
#'
#'
#' @param params describes input paramaters for the model.
#' \code{boundaryMinIntrinsic} params = sd, minimum, maximum
#' @param states vector of states for each taxon
#' @param timefrompresent which time slice in the tree
#' @return A matrix of values representing character displacement from a single
#' time step in the tree.
#' @author Brian O'Meara and Barb Banbury
#' @references O'Meara and Banbury, unpublished
#' @keywords boundaryIntrinsic intrinsic
boundaryIntrinsic<-function(params, states, timefrompresent) {
	#params[1] is sd, params[2] is min, params[3] is max. params[2] could be 0 or -Inf, for example
	newdisplacement<-rnorm(n=length(states),mean=0,sd=params[1])
	for (i in length(newdisplacement)) {
		newstate<-newdisplacement[i]+states[i]
		if (newstate<params[2]) { #newstate less than min
			newdisplacement[i]<-params[2]-states[i] #so, rather than go below the minimum, this moves the new state to the minimum
		}
		if (newstate>params[3]) { #newstate greater than max
			newdisplacement[i]<-params[3]-states[i] #so, rather than go above the maximum, this moves the new state to the maximum
		}
	}
	return(newdisplacement)
}




#' Intrinsic Character Evolution Models
#'
#' This function describes a model of intrinsic character evolution. Character
#' change is restricted above a minimum threshold
#'
#'
#' @param params describes input paramaters for the model.
#' \code{boundaryMinIntrinsic} params = sd, minimum
#' @param states vector of states for each taxon
#' @param timefrompresent which time slice in the tree
#' @return A matrix of values representing character displacement from a single
#' time step in the tree.
#' @author Brian O'Meara and Barb Banbury
#' @references O'Meara and Banbury, unpublished
#' @keywords boundaryMinIntrinsic intrinsic
boundaryMinIntrinsic <-function(params, states, timefrompresent) {
	#params[1] is sd, params[2] is min boundary
	newdisplacement<-rnorm(n=length(states),mean=0,sd=params[1])
	for (i in length(newdisplacement)) {
		newstate<-newdisplacement[i]+states[i]
		if (newstate<params[2]) { #newstate less than min
			newdisplacement[i]<-params[2]-states[i] #so, rather than go below the minimum, this moves the new state to the minimum
		}
	}
	return(newdisplacement)
}




#' Intrinsic Character Evolution Models
#'
#' This function describes a model of intrinsic character evolution. New
#' character values are generated after one time step via a discrete-time OU
#' process.
#'
#'
#' @param params describes input paramaters for the model.
#' \code{autoregressiveIntrinsic} params = sd (sigma), attractor (character
#' mean), attraction (alpha)
#' @param states vector of states for each taxon
#' @param timefrompresent which time slice in the tree
#' @return A matrix of values representing character displacement from a single
#' time step in the tree.
#' @author Brian O'Meara and Barb Banbury
#' @references O'Meara and Banbury, unpublished
#' @keywords autoregressiveIntrinsic intrinsic
autoregressiveIntrinsic<-function(params,states, timefrompresent) { #a discrete time OU, same sd, mean, and attraction for all chars
	#params[1] is sd (sigma), params[2] is attractor (ie. character mean), params[3] is attraction (ie. alpha)
	sd<-params[1]
	attractor<-params[2]
	attraction<-params[3]	#in this model, this should be between zero and one
	newdisplacement<-rnorm(n=length(states),mean=(attractor-states)*attraction,sd=sd) #subtract current states because we want displacement
	return(newdisplacement)

}




#' Intrinsic Character Evolution Models
#'
#' This function describes a model of intrinsic character evolution. New
#' character values are generated after one time step via a discrete-time OU
#' process with a minimum bound.
#'
#'
#' @param params describes input paramaters for the model.
#' \code{MinBoundaryAutoregressiveIntrinsic} params = sd (sigma), attractor
#' (character mean), attraction (alpha), minimum
#' @param states vector of states for each taxon
#' @param timefrompresent which time slice in the tree
#' @return A matrix of values representing character displacement from a single
#' time step in the tree.
#' @author Brian O'Meara and Barb Banbury
#' @references O'Meara and Banbury, unpublished
#' @keywords MinBoundaryAutoregressiveIntrinsic intrinsic
MinBoundaryAutoregressiveIntrinsic<-function(params,states, timefrompresent) { #a discrete time OU, same sd, mean, and attraction for all chars
	#params[1] is sd (sigma), params[2] is attractor (ie. character mean), params[3] is attraction (ie. alpha), params[4] is min bound
	sd<-params[1]
	attractor<-params[2]
	attraction<-params[3]	#in this model, this should be between zero and one
	minBound<-params[4]
	newdisplacement<-rnorm(n=length(states),mean=(attractor-states)*attraction,sd=sd) #subtract current states because we want displacement
	#print(newdisplacement)
	for (i in length(newdisplacement)) {
		newstate<-newdisplacement[i] + states[i]
		#print(newstate)
			if (newstate <params[4]) { #newstate less than min
				newdisplacement[i]<-params[4] - states[i] #so, rather than go below the minimum, this moves the new state to the minimum
			}
	}
	return(newdisplacement)

}




#' Intrinsic Character Evolution Models
#'
#' This function describes a model of intrinsic character evolution. New
#' character values are generated after one time step via a discrete-time OU
#' process with differing means, sigma, and attraction over time
#'
#' In the TimeSlices models, time threshold units are in time before present
#' (i.e., 65 could be 65 MYA). The last time threshold should be 0.
#'
#' @param params describes input paramaters for the model.
#' \code{autoregressiveIntrinsicTimeSlices} params = sd-1 (sigma-1),
#' attractor-1 (character mean-1), attraction-1 (alpha-1), time threshold-1,
#' sd-2 (sigma-2), attractor-2 (character mean-2), attraction-2 (alpha-2), time
#' threshold-2
#' @param states vector of states for each taxon
#' @param timefrompresent which time slice in the tree
#' @return A matrix of values representing character displacement from a single
#' time step in the tree.
#' @author Brian O'Meara and Barb Banbury
#' @references O'Meara and Banbury, unpublished
#' @keywords autoregressiveIntrinsicTimeSlices intrinsic
autoregressiveIntrinsicTimeSlices<-function(params,states, timefrompresent) { #a discrete time OU, differing mean, sigma, and attaction with time
	#params=[sd1, attractor1, attraction1, timethreshold1, sd2, attractor2, attraction2, timethreshold2, ...]
	#time is time before present (i.e., 65 could be 65 MYA). The last time threshold should be 0, one before that is the end of the previous epoch, etc.
	numRegimes<-length(params)/4
	timeSliceVector=c(Inf,params[which(c(1:length(params))%%4==0)])
	#print(timeSliceVector)
	sd<-params[1]
	attractor<-params[2]
	attraction<-params[3]	#in this model, this should be between zero and one
	#print(paste("timefrompresent = ",timefrompresent))
	for (regime in 1:numRegimes) {
		#print(paste ("tryiing regime = ",regime))
		if (timefrompresent<timeSliceVector[regime]) {
			#print("timefrompresent>timeSliceVector[regime] == TRUE")
			if (timefrompresent>=timeSliceVector[regime+1]) {
				#print("timefrompresent<=timeSliceVector[regime+1] == TRUE")
				#print(paste("choose regime ",regime, " so 4*(regime-1)=",4*(regime-1)))
				sd<-params[1+4*(regime-1)]
				attractor<-params[2+4*(regime-1)]
				attraction<-params[3+4*(regime-1)]
					#print(paste("sd = ",sd," attractor = ",attractor, " attraction = ", attraction))

			}
		}
	}
	#print(paste("sd = ",sd," attractor = ",attractor, " attraction = ", attraction))
	newdisplacement<-rnorm(n=length(states),mean=(attractor-states)*attraction,sd=sd)
	return(newdisplacement)
}



#' Intrinsic Character Evolution Models
#'
#' This function describes a model of intrinsic character evolution. New
#' character values are generated after one time step via a discrete-time OU
#' process with differing sigma and attraction over time
#'
#' In the TimeSlices models, time threshold units are in time before present
#' (i.e., 65 could be 65 MYA). The last time threshold should be 0.
#'
#' @param params describes input paramaters for the model.
#' \code{autoregressiveIntrinsicTimeSlicesConstantMean} params = sd-1
#' (sigma-1), attraction-1 (alpha-1), time threshold-1, sd-2 (sigma-2),
#' attraction-2 (alpha-2), time threshold-2, attractor (character mean)
#' @param states vector of states for each taxon
#' @param timefrompresent which time slice in the tree
#' @return A matrix of values representing character displacement from a single
#' time step in the tree.
#' @author Brian O'Meara and Barb Banbury
#' @references O'Meara and Banbury, unpublished
#' @keywords autoregressiveIntrinsicTimeSlicesConstantMean intrinsic
autoregressiveIntrinsicTimeSlicesConstantMean<-function(params,states, timefrompresent) { #a discrete time OU, constant mean, differing sigma, and differing attaction with time
	#params=[sd1 (sigma1), attraction1 (alpha 1), timethreshold1, sd2 (sigma2), attraction2 (alpha 2), timethreshold2, ..., attractor (mean)]
	#time is time before present (i.e., 65 could be 65 MYA). The last time threshold should be 0, one before that is the end of the previous epoch, etc.
	numTimeSlices<-(length(params)-1)/3
	sd<-params[1]
	attractor<-params[length(params)]
	attraction<-params[2]	#in this model, this should be between zero and one
	previousThresholdTime<-Inf
	for (slice in 0:(numTimeSlices-1)) {
		thresholdTime<-params[3+3*slice]
		if (thresholdTime >= timefrompresent) {
			if (thresholdTime<previousThresholdTime) {
				sd<-params[1+3*slice]
				attraction<-params[2+3*slice]
			}
		}
		previousThresholdTime<-thresholdTime
	}
	newdisplacement<-rnorm(n=length(states),mean=attraction*states + attractor,sd=sd)-states
	return(newdisplacement)
}



#' Intrinsic Character Evolution Models
#'
#' This function describes a model of intrinsic character evolution. New
#' character values are generated after one time step via a discrete-time OU
#' process with differing means and attraction over time.
#'
#' In the TimeSlices models, time threshold units are in time before present
#' (i.e., 65 could be 65 MYA). The last time threshold should be 0.
#'
#' @param params describes input paramaters for the model.
#' \code{autoregressiveIntrinsicTimeSlicesConstantSigma} params = sd (sigma),
#' attractor-1 (character mean-1), attraction-1 (alpha-1), time threshold-1,
#' attractor-2 (character mean-2), attraction-2 (alpha-2), time threshold-2
#' @param states vector of states for each taxon
#' @param timefrompresent which time slice in the tree
#' @return A matrix of values representing character displacement from a single
#' time step in the tree.
#' @author Brian O'Meara and Barb Banbury
#' @references O'Meara and Banbury, unpublished
#' @keywords autoregressiveIntrinsicTimeSlicesConstantSigma intrinsic
autoregressiveIntrinsicTimeSlicesConstantSigma<-function(params,states, timefrompresent) { #a discrete time OU, differing mean, constant sigma, and attaction with time
	#params=[sd, attractor1, attraction1, timethreshold1, attractor2, attraction2, timethreshold2, ...]
	#time is time before present (i.e., 65 could be 65 MYA). The last time threshold should be 0, one before that is the end of the previous epoch, etc.
	numRegimes<-(length(params)-1)/3
	#print(numRegimes)
	timeSliceVector<-c(Inf)
	for (regime in 1:numRegimes) {
		timeSliceVector<-append(timeSliceVector,params[4+3*(regime-1)])
	}
	#timeSliceVector=c(Inf,params[which(c(1:length(params))%%4==0)])
	#print(timeSliceVector)
	sd<-params[1]
	attractor<-params[2]
	attraction<-params[3]	#in this model, this should be between zero and one
	#print(paste("timefrompresent = ",timefrompresent))
	for (regime in 1:numRegimes) {
		#print(paste ("trying regime = ",regime))
		if (timefrompresent<timeSliceVector[regime]) {
			#print("timefrompresent>timeSliceVector[regime] == TRUE")
			if (timefrompresent>=timeSliceVector[regime+1]) {
				#print("timefrompresent>=timeSliceVector[regime+1] == TRUE")
				#print(paste("chose regime ",regime))
				#sd<-params[1+4*(regime-1)]
				attractor<-params[2+3*(regime-1)]
				attraction<-params[3+3*(regime-1)]
				#print(paste("sd = ",sd," attractor = ",attractor, " attraction = ", attraction))

			}
		}
	}
	#print(paste("sd = ",sd," attractor = ",attractor, " attraction = ", attraction))
	newdisplacement<-rnorm(n=length(states),mean=(attractor-states)*attraction,sd=sd)
	return(newdisplacement)
}


varyingBoundariesFixedSigmaIntrinsic<-function(params,states, timefrompresent) { #differing boundaries with time
	#params=[sd, min1, max1, timethreshold1, min2, max2, timethreshold2, ...]
	#time is time before present (i.e., 65 could be 65 MYA). The last time (present) threshold should be 0, one before that is the end of the previous epoch, etc.
	numRegimes<-(length(params)-1)/3
	#print(numRegimes)
	timeSliceVector<-c(Inf)
	for (regime in 1:numRegimes) {
		timeSliceVector<-append(timeSliceVector,params[4+3*(regime-1)])
	}
	#timeSliceVector=c(Inf,params[which(c(1:length(params))%%4==0)])
	#print(timeSliceVector)
	sd<-params[1]
	minBound<-params[2]
	maxBound<-params[3]
	for (regime in 1:numRegimes) {
		#print(paste ("trying regime = ",regime))
		if (timefrompresent<timeSliceVector[regime]) {
			#print("timefrompresent>timeSliceVector[regime] == TRUE")
			if (timefrompresent>=timeSliceVector[regime+1]) {
				#print("timefrompresent>=timeSliceVector[regime+1] == TRUE")
				#print(paste("chose regime ",regime))
				#sd<-params[1+4*(regime-1)]
				minBound<-params[2+3*(regime-1)]
				maxBound<-params[3+3*(regime-1)]
				#print(paste("sd = ",sd," attractor = ",attractor, " attraction = ", attraction))

			}
		}
	}
	#print(paste("sd = ",sd," attractor = ",attractor, " attraction = ", attraction))
	newdisplacement<-rnorm(n=length(states),mean=0,sd=sd)
		for (i in length(newdisplacement)) {
		newstate<-newdisplacement[i]+states[i]
		if (newstate<minBound) { #newstate less than min
			newdisplacement[i]<-minBound-states[i] #so, rather than go below the minimum, this moves the new state to the minimum
		}
		if (newstate>maxBound) { #newstate greater than max
			newdisplacement[i]<-maxBound-states[i] #so, rather than go above the maximum, this moves the new state to the maximum
		}
	}
	return(newdisplacement)
}

varyingBoundariesVaryingSigmaIntrinsic<-function(params,states, timefrompresent) { #differing boundaries with time
	#params=[sd1, min1, max1, timethreshold1, sd2, min2, max2, timethreshold2, ...]
	#time is time before present (i.e., 65 could be 65 MYA). The last time (present) threshold should be 0, one before that is the end of the previous epoch, etc.
	numRegimes<-(length(params))/3
	#print(numRegimes)
	timeSliceVector<-c(Inf)
	for (regime in 1:numRegimes) {
		timeSliceVector<-append(timeSliceVector,params[4+4*(regime-1)])
	}
	#timeSliceVector=c(Inf,params[which(c(1:length(params))%%4==0)])
	#print(timeSliceVector)
	sd<-params[1]
	minBound<-params[2]
	maxBound<-params[3]
	for (regime in 1:numRegimes) {
		#print(paste ("trying regime = ",regime))
		if (timefrompresent<timeSliceVector[regime]) {
			#print("timefrompresent>timeSliceVector[regime] == TRUE")
			if (timefrompresent>=timeSliceVector[regime+1]) {
				#print("timefrompresent>=timeSliceVector[regime+1] == TRUE")
				#print(paste("chose regime ",regime))
				#sd<-params[1+4*(regime-1)]
				sd<-params[1+4*(regime-1)]
				minBound<-params[2+4*(regime-1)]
				maxBound<-params[3+4*(regime-1)]
				#print(paste("sd = ",sd," attractor = ",attractor, " attraction = ", attraction))

			}
		}
	}
	#print(paste("sd = ",sd," attractor = ",attractor, " attraction = ", attraction))
	newdisplacement<-rnorm(n=length(states),mean=0,sd=sd)
		for (i in length(newdisplacement)) {
		newstate<-newdisplacement[i]+states[i]
		if (newstate<minBound) { #newstate less than min
			newdisplacement[i]<-minBound-states[i] #so, rather than go below the minimum, this moves the new state to the minimum
		}
		if (newstate>maxBound) { #newstate greater than max
			newdisplacement[i]<-maxBound-states[i] #so, rather than go above the maximum, this moves the new state to the maximum
		}
	}
	return(newdisplacement)
}

#this model assumes a pull (perhaps weak) to a certain genome size, but with
#    occasional doublings
genomeDuplicationAttraction<-function(params, states, timefrompresent) {
	#params = [sd, attractor, attraction, doubling.prob]
	sd<-params[1]
	attractor<-params[2]
	attraction<-params[3]	#in this model, this should be between zero and one
	doubling.prob<-params[4]
	newdisplacement<-rnorm(n=length(states),mean=(attractor-states)*attraction,sd=sd) #subtract current states because we want displacement
	for (i in length(newdisplacement)) {
		newstate<-newdisplacement[i]+states[i]
		if (newstate<0) { #newstate less than min
			newdisplacement[i]<-0-states[i] #so, rather than go below the minimum, this moves the new state to the minimum
		}
	}
	if (runif(1,0,1)<doubling.prob) { #we double
		newdisplacement<-states
	}
	return(newdisplacement)
}

#This is the same as the above model, but where the states are in log units
#  The only difference is how doubling occurs
genomeDuplicationAttractionLogScale<-function(params, states, timefrompresent) {
	#params = [sd, attractor, attraction, doubling.prob]
	sd<-params[1]
	attractor<-params[2]
	attraction<-params[3]	#in this model, this should be between zero and one
	doubling.prob<-params[4]
	newdisplacement<-rnorm(n=length(states),mean=(attractor-states)*attraction,sd=sd) #subtract current states because we want displacement
	if (runif(1,0,1)<doubling.prob) { #we double
		newdisplacement<-log(2*exp(states))-states
	}
	return(newdisplacement)
}


#Genome duplication, but with no attraction. However, each duplication may shortly result in less than a full doubling. Basically, the increased size is based on a beta distribution. If you want pure doubling only,
#shape param 1 = Inf and param 2 = 1
genomeDuplicationPartialDoublingLogScale<-function(params, states, timefrompresent) {
	#params = [sd, shape1, doubling.prob]
	sd<-params[1]
	beta.shape1<-params[2] #the larger this is, the more the duplication is exactly a doubling. To see what this looks like, plot(density(1+rbeta(10000, beta.shape1, 1)))
	duplication.prob<-params[3]
	newdisplacement<-rnorm(n=length(states),mean=0,sd=sd)
	if (runif(1,0,1)<duplication.prob) { #we duplicate
		newdisplacement<-log((1+rbeta(1,beta.shape1,1))*exp(states))-states
	}
	return(newdisplacement)
}


##Get Genome duplication priors
GetGenomeDuplicationPriors <- function(numSteps, phy, data) {
	#returns a matrix with 3 priors for genome duplication (genomeDuplicationPartialDoublingLogScale)
	timeStep<-1/numSteps  #out of doRun_rej code
	sd <- GetBMRatePrior(phy, data, timeStep)  #new TreEvo function
	beta.shape1 <- 1 #for(i in 1:10) {lines(density(1+rbeta(10000, 10^runif(1,0,2), 1)), xlim=c(1,2))}  seems to produce nice distributions, but how to justify using 3?
	duplication.prob <- 2 #exponential, but which rate?

}
