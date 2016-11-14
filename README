# Queueing Simulation

This is a queueing simulation I built in R. I spent a lot of time reading up on queueing theory, and decided on this general approach:

1) First, I initialize vectors for the service rate (mu) and customer arrival rate (lambda). The idea is that these numbers would be recorded empirically on-site and then entered by the user.

2) Second, I initalize the queuing duration. The user would enter how many hours they wish the simulation to last. I also initialize an empty vector for the customers currently in line.

3) Then, I create a 'for' loop and generate discrete arrival and departure events. For each interval, I either add or subtract customers from this vector of customers. To generate these events, I create a condition where I draw values from an exponential distribution with the rate of 1/lambda (the customer arrival rate during that interval). If this condition is satisfied, an arrival event is generated. I also draw a value from an exponential distribution to initiate a departure event. If neither condition is met to generate an arrival or departure event, the queue length stays the same for that interval.

4) Finally, I plot the queue length over the duration of the simulation, and calculate basic queuing metrics and print them to the user.

The idea is that this queueing simulation would give the user a sense of how efficiently servers could get customers through a line when working at a given rate. One can use this simulation with precise empirical data or approximate numbers.