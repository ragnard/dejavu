![Imgur](http://i.imgur.com/jwmkk1G.jpg?1)

# Déjà vu

[wrk](https://github.com/wg/wrk) script for replaying [ELB access logs](http://docs.aws.amazon.com/ElasticLoadBalancing/latest/DeveloperGuide/access-log-collection.html).

**WIP**

## Usage

```
$ wrk -d 10 -c 10 -t 1 -s script.lua --latency http://localhost:8080 -- logs/12345_elasticloadbalancing_eu-west-1_some_elb_20150604T0700Z_1.2.3.4_zmnfd91q.log.txt
Thread 1 loaded 63155 requests from logs/12345_elasticloadbalancing_eu-west-1_some_elb_20150604T0700Z_1.2.3.4_zmnfd91q.log.txt
Running 10s test @ http://localhost:8080
  1 threads and 10 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   102.75ms  253.24ms   1.61s    88.61%
    Req/Sec     3.93k     0.92k    4.51k    93.67%
  Latency Distribution
     50%    1.67ms
     75%    2.05ms
     90%  399.90ms
     99%    1.35s 
  31508 requests in 10.01s, 10.37MB read
  Non-2xx or 3xx responses: 31508
Requests/sec:   3149.17
Transfer/sec:      1.04MB
$
```
