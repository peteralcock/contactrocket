
![ContactRocket](/logo.png?raw=true "ContactRocket")

## Welcome to the machine
This is a project I obsessed over for too long several years ago. I lost countless hours of sleep working on it and ultimately failed to launch it as a SaaS product (marketing is expensive). It has sat uncelebrated on my external hard-drive "mountain" for years, and since I am on the hunt for a new RoR-heavy technical role, figured I may as well just give it away and sacrifice my monetization pipedream to make an open-source contribution as an expression of my gratitude for Ruby on Rails, Sidekiq (<a href="https://www.mikeperham.com/">Mike Perham</a>, you're the fucking man.) GitHub, Amazon Web Services, and the internet. Thanks to these aformentioned corporate and human entities, my life-long love for software has been all the more enjoyable. Gladiators, I salute you.

## Quick Start
Wow I can't believe how long I've been using Docker... and I forgot how much infrastructure code I put into this project. This whole thing is dockerized into a few services: CRM, Web, and the Engine(s). If you know Docker and Rails, you should be fine. If you don't, watch this cute promotional explainer video I made instead... [![Watch the video](/logo.jpg?raw=true )](https://www.youtube.com/watch?v=cXQpZ4bjAEc)


## Infrastructure / Deployment
I set this up to easily be deployed on Elastic Beanstalk and created a series of ansible scripts to do all the configuration for you. But if you wanna kick some real ass, there are a few tweaks to make in order to give my spider engines unlimited scaling power on AWS (albeit this will be very expensive, so it  ain't the default). PostgreSQL stores the records created from crawls, Redis is used in combination with a bloom filter and hiredis client (for performance) to keep track of all the pending crawl jobs and to track previously crawled URLs. ElasticSearch is used to index render all of the returned results into a performantly searchable format. You will wanna tune the Redis configuration to use the LRU cache policy (least recently used) for when it needs to choose was to abandon. Using LRU will result in punting problematic URLs first when memory starts to bloat on the EC2 instance from crawling too fast and running too hard. Amazon's ElastiCache can be used for background job data store. For finer grain control you will want to run your own Redis cluster, and you can  use Amazon's Elasticsearch service if you don't know how to run your own ES cluster. (No, I will not go into how to do this right now. Hire me to do it for you.)

## Web Dashboard / Front-End

I created the dashboard using websockets and AJAX to deliver live visual indicators of your crawlers progress because it's much more exciting to watch than having to refresh the page everytime a user wants to "check their score". A thousand man hours went into this simple improvement to the UX/UI, so be grateful.

![Screenshot](/screenshot.jpg?raw=true "Dashboard Screenshot")

![Screenshot](/emails.jpg?raw=true "Emails Found")


## Crawler Engines / Back-End

![ContactRocket Engine](/engine.jpg?raw=true "Engine Design")

Background processing engines are broken into separate parts for separate purposes. Social Media crawling is network intensive, cached page crawling is as well, returned data is very write-heavy on the I/O for RDS instances (or however you decide to host your SQL store), both of which Amazon charges a pound of flesh to consume (look into "IOPS Provisioning" if you don't believe my warning). I may recommend running the engine workers on Linode or DO, albeit at a significant latency cost between the back-end and the front-end application. But hey, it's your money.

## Scaling Up

If you want to crawl millions of websites in an evening with this you will need to use the deployment scripts I've included for Amazon Web Services' Auto-Scaling EC2 clusters. This will cost you a pretty penny, but I've optimized these scripts to dynamically configure themselves to whatever size EC2 you choose to use by making the deployment script aware of the number of cores and available memory on their server and adjusting the multi-threading configuration accordingly. You're welcome.


## Testing

I have written tests for every function of the engine, and then some. It's all done in RSpec with Capyabara-Webkit handling headless browser simulations for testing the web dashboard, which can be a dependency nightmare, so use my https://github.com/peteralcock/rubylab repo to jumpstart your success.
