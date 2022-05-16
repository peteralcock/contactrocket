# ContactRocket
Next-generation lead-generation software-as-a-service

![Screenshot](/screenshot.jpg?raw=true "Dashboard Screenshot")

## Introduction
This is a project I obsessed over for a couple years, several years ago, for which I lost countless hours of sleep, but ultimately failed to launch as a SaaS product (marketing is expensive). It has sat uncelebrated on my external hard-drive "mountain" for over seven years, and since I am on the hunt for a new RoR-heavy technical role, figured I may as well just give it away and sacrifice a monetization pipedream to make an open-source contribution as an expression my gratitude for Ruby on Rails, Sidekiq (<a href="https://www.mikeperham.com/">Mike Perham</a>, you're the fucking man.) GitHub, Amazon Web Services, and the internet. Thanks to all of you corporate and human entities, my life-long love for software has been all the more enjoyable. <b>Gladiators, I salute you.</b>

## Quick Start
Wow I can't believe how long I've been using Docker... totally forgot how much infrastructure code I put into this project. I have dockerized this whole thing into a few services: CRM, Web, and the Engine(s). If you know Docker and Rails, you should be fine. If you don't, this promotional explainer video I made in order to advertise this product on social media.

[![Watch the video](/logo.jpg?raw=true )](https://www.youtube.com/watch?v=cXQpZ4bjAEc)


## Infrastructure / Deployment
I set this up to easily be deployed on Elastic Beanstalk, for the lazy people folks, and created a series of ansible scripts to do all the configuration for you, BeanStalk or not. But if you wanna kick some real ass, there are a few tweaks to make in order to give my spider engines unlimited scaling power on AWS (albeit this will be very expensive, so I didn't make it the default). MySQL stores the records created from crawls, and Redis is used with a bloom filter to keep track of all the pending crawl jobs and to track previously crawled URLs. ElasticSearch is used to index render all of the returned results into a performantly searchable format. You will wanna tune the Redis configuration to use the LRU cache policy (least recently used) for when it needs to choose was to abandon. Using LRU will result in punting problematic URLs first when memory starts to bloat on the EC2 instance from crawling too fast and running too hard.

    https://y.yarn.co/a21ae108-5e1c-49e8-a69a-f634dab43d8e.mp4

Amazon's ElastiCache can be used for background job data store, but for finer grain control you will want to run your own Redis cluster on EC2s, and you can easily use Amazon's Elasticsearch service if you don't know how to run your own ES cluster. (No, I will not go into how to do this right here and now. Hire me to do it for you.)


## Dashboard





## Engines



Background processing engines are broken into separate parts for separate purposes. Social Media crawling is network intensive. Website crawling is as well, and is very write-heavy on the I/O front, both of which Amazon charges a pound of flesh. So I recommend running engine workers on Linode or DO, albeit at a significant latency cost between the front and back end application services. But hey, it's your money.







