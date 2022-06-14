
![ContactRocket](/logo.png?raw=true "ContactRocket")
[![INTRO VIDEO](https://img.youtube.com/vi/cXQpZ4bjAEc/0.jpg)](https://www.youtube.com/watch?v=cXQpZ4bjAEc)

![]([contactrocket.mp4](https://github.com/peteralcock/contactrocket/raw/main/contactrocket.mp4))

=
## Getting Started
This whole thing is containerized into a few core services: CRM, Dashboard, and the Engine. If you know Docker and Rails and AWS, you should be fine. If you don't, watch this cute explainer video I made instead... [![Watch the video](/logo.jpg?raw=true )](https://www.youtube.com/watch?v=cXQpZ4bjAEc)


## Infrastructure / Deployment
PostgreSQL stores the records created from crawls, Redis is used in combination with a bloom filter and hiredis client (for performance) to keep track of all the pending crawl jobs and to track previously crawled URLs. ElasticSearch is used to make all of the returned results searchable, with each added record being asynchroniously indexed by the background workers to prevent bottlenecks. You will wanna tune the Redis configuration to use the LRU cache policy (least recently used) for when it needs to choose was to abandon. Using LRU will result in punting problematic URLs first when memory starts to bloat on the EC2 instance.

## Web Dashboard / Front-End

The dashboard uses websockets and AJAX to deliver live visual indicators of your crawlers progress.

![Screenshot](/screenshot.jpg?raw=true "Dashboard")

![Screenshot](/emails.jpg?raw=true "Email")


## Crawler Engines / Back-End

![ContactRocket Engine](/engine.jpg?raw=true "Engine Design")

Background processing engines are broken into separate parts for separate purposes. Social Media crawling is network intensive, cached page crawling is as well, returned data is very write-heavy on the I/O for RDS instances.


## Scaling Up

If you want to crawl millions of websites in an evening with this you will need to use the deployment scripts I've included for Amazon Web Services' Auto-Scaling EC2 clusters. This will cost you a pretty penny, but I've optimized these scripts to dynamically configure themselves to whatever size EC2 you choose to use by making the deployment script aware of the number of cores and available memory on their server and adjusting the multi-threading configuration accordingly. Make sure you database connections match your worker threads counts. 10-25 is typically the appropriate range.


## Testing

Capyabara's headless browser simulations are dependency nightmares. Use my https://github.com/peteralcock/rubylab repo to jump start TDD.
