What are the actual root causes of an application lagging while Kubernetes stays green?

1. Database Connection Pool Starvation (Most Common)
2. CPU Throttling due to Strict Resource Limits
3. Java JVM Memory Leaks & "Stop-the-World" Garbage Collection
4. Thread Deadlocks in Application Code
5. Slow External Third-Party APIs

"In the real world, this occurs because Kubernetes monitors the infrastructure layer, not the 
application layer. Whether it is a database connection bottleneck, CPU throttling, a JVM Garbage
 Collection freeze, or an external API delay, the process itself remains running. That is why
 relying solely on default container checks is dangerous, and we must implement Liveness 
 Probes with strict timeouts alongside Application Performance Monitoring (APM) tools to 
 capture these application-level blind spots."
