
##########single hour


#set mu
mu <- 1.5 # service rate (customer/minute)

#set lambda randomly
# for (i in 1:20) {
#   lambda[i] <- runif(1,min=1.5, max=5)
# }

#manually input lamba
lambda <- c(.83,2.83) # arrival rate for half-hour intervals (customers/minute)

#set hours to simulate
hours = 1

#set half-hour intervals (each half hour is 1800 seconds)
interval <- rep(1,(hours*2)+1)
for (i in 1:length(interval)) {
  interval[i] <- (1800*i)-1800
}

#set queue duration
t.end <- (3600*hours) # multiple total hours for simulation by number seconds in hour
t.step = 1 # 1 second intervals

#initialize queue
queue <- rep(0, t.end)
#set temporary list to store depart time
timedepart <- rep(0, t.end)

#simulate queue
for (j in 1:length(interval)) {
  for (i in ((interval[j]+1):(interval[j+1]))) {
    if (rexp(1,rate=1/lambda[j]) < (1-exp(-lambda[j]/60))) { # arrival event
      print(paste0("Arrival Minute: ", i/60))
      queue[i+1] <- queue[i] + 1 # add customer to queue
      ###store temp departure time
      z = round(i+((1+rexp(1,rate=1/mu))*60))
      timedepart[i] = z
      # y = i+((1+rexp(1,rate=1/mu))*60)
      # timedepart[i+z] = y
    }
    else if ((i %in% timedepart)==TRUE){ # departure event
      print(paste0("Depart Minute: ", i/60))
      queue[i+1] <- queue[i] - 1
    }
    else { # nothing happens to queue in this interval
      queue[i+1] <- queue[i]
    }
  }
}
#delete last observation
queue <- tail(queue,-1)

# #Queuing Metrics
# queue_result <- data.frame(Utilization=1-total_idle_time/t.end, # total efficiency rate is 1 - percentage of time the queue is idle
#                            AverTimeInQueue=total_wait_time/num_arrivals, # total wait time divided by the total number of arrivals
#                            AverTimeInSystem=total_wait_time/num_arrivals + mu, # total wait time as proportion of total number arrivals plus service rate
#                            AverNumberInQueue=total_wait_time/total_arrival_time, # total wait time as proportion of total inter-arrival time   
#                            AverNumberInSystem=total_wait_time/total_arrival_time + mu/(1/mean(lambda)), # total wait time as proportion of total arrival time plus mean number of customers being served at given time 
#                            AverQueueLength=mean(queue)) # average number of customers in queue over the simulation duration

#set hour interval for plot
hourinterval <- seq(from=0, to=t.end, by=600)
hourlabel <- c(11,1110,1120,1130,1140,1150,12)
#plot
plot(seq(from=1, to=t.end, by=t.step), queue, type='l',
     xlab='Time of Day', ylab='queue size',xaxt='n')
axis(side = 1,
     at = hourinterval,
     labels = hourlabel)
title(paste('Queuing Simulation. Average Arrival Rate:', round(mean(lambda),2),
            'Service rate:', mu))

# #print queue metrics
# print(queue_result)


