# Initialize Vectors for Queue Simulation

## set seed for random number generator to replicate results

rand.seed <- 99 

## set mu (service rate)

mu <- 1.5 ### service rate (customer/minute)

## set lambda (arrival rate)

### set lamba randomly (different lambda for each interval)
for (i in 1:20) {
  lambda[i] <- runif(1,min=1.5, max=5)
}

### or manually input lamba
lambda <- c(.83,2.4,2.86,2.53,1.73,.83,.83,.83,.83,.83,.83,.83) ## arrival rate for half-hour intervals (customers/minute)

## set hours to simulate

hours = 6

## set half-hour intervals (each half hour is 1800 seconds)

interval <- rep(1,(hours*2)+1) ### create vector of half hour intervals (unit is seconds)

for (i in 1:length(interval)) { ### store intervals
  interval[i] <- (1800*i)-1800 
}

## set queue duration

t.end <- (3600*hours) ### multiply total hours for simulation by number seconds in hour
t.step = 1 ### set 1 second intervals

## initialize queue 
### (customers arrive for each second interval)

queue <- rep(0, t.end)

## set temporary list to store depart time 
### (customers depart for each second interval)

timedepart <- rep(0, t.end)



# Simulate Queue

for (j in 1:length(interval)) {
  
  for (i in ((interval[j]+1):(interval[j+1]))) {
    
    print(paste0("Current time: ", i/60)) ## if desired, print interval
    
    if (rexp(1,rate=1/lambda[j]) < (1-exp(-lambda[j]/60))) { ## generate arrival event
      
      print(paste0("Arrival Minute: ", i/60, " Lambda: ",lambda[j])) ## print arrival time and rate
      
      queue[i+1] <- queue[i] + 1 ## add customer to queue
      
      z = round(i+((1+rexp(1,rate=1/mu))*60)) ## draw randomly generated value from exponential distribution
      
      timedepart[i] = z ## store temp departure time
      
    }
    
    else if ((i %in% timedepart)==TRUE){ ## departure event
      
      print(paste0("Depart Minute: ", i/60)) ## print departure time
      
      queue[i+1] <- queue[i] - 1 ## subtract customer from queue
      
    }
    else { ## nothing happens to queue in this interval
      
      queue[i+1] <- queue[i]
      
    }
  }
}

## delete last observation

queue <- tail(queue,-1)



# Compute queuing metrics
queue_result <- data.frame(Utilization=1-total_idle_time/t.end, # total efficiency rate is 1 - percentage of time the queue is idle
                           AverTimeInQueue=total_wait_time/num_arrivals, # total wait time divided by the total number of arrivals
                           AverTimeInSystem=total_wait_time/num_arrivals + mu, # total wait time as proportion of total number arrivals plus service rate
                           AverNumberInQueue=total_wait_time/total_arrival_time, # total wait time as proportion of total inter-arrival time
                           AverNumberInSystem=total_wait_time/total_arrival_time + mu/(1/mean(lambda)), # total wait time as proportion of total arrival time plus mean number of customers being served at given time
                           AverQueueLength=mean(queue)) # average number of customers in queue over the simulation duration



# Create Plot and Print Metrics

## set hour interval for plot

hourinterval <- seq(from=0, to=t.end, by=3600)
hourlabel <- c(11,12,1,2,3,4,5)

## generate queue plot

plot(seq(from=1, to=t.end, by=t.step), queue, type='l',
     xlab='Time of Day', ylab='queue size',xaxt='n')

axis(side = 1,
     at = hourinterval,
     labels = hourlabel)

title(paste('Queuing Simulation. Average Arrival Rate:', round(mean(lambda),2),
            'Service rate:', mu))

## print queue metrics

print(queue_result)

