# shortr
This is Alex Fine's Nintex interview project.  Shortr is a url shortner running on rails, using dynamodb for storage, and running on AWS.  It can be seen at shortr-rayidchvfk.elasticbeanstalk.com.  An example link that can be used to view statistics is "mylink434234".

# Why rails?

Rails was chosen based on the fact that I was comfortable with ruby (though realized it has been a long time since I dealt with rails, adding some complexity to the project) and that rails supported both the backend and front end of the system.  Ruby/Rails is also a first class supported platform on AWS (SDK) and Elastic Beanstalk.

# Controllers
Shortr has a basic design.  There are 2 controllers: index and stats.  Index has 5 actions: 
* Home - Display the home page
* Expand - Show the long url for this short url
* Go - Go to the long url for the short url
* Create - Create a short url either with a random short url or pre-defined one
* Not_Found - The action if a short url is not found

Stats has 1 action:
* Stats - Show statistics for this URL

Going to the main will load the homepage, but going to URL/SOMETHING will take you to the SOMETHING long url assuming it exists.  Going to URL/stats/SOMETHING will load statistics for that short url if it exists.

# Models and storage
There are 2 models, short_url and click.  Both of them are stored in dynamoDB.  DynamoDB was chosen because:
* It is schema free, adding the ability to add new fields at any time
* Distributed, so no single DB or need for partitioned DBs
* No need for joins or views that SQL provides - 2 tables, independent of each other

There are some downsides of DynamoDB
* Eventual consistnecy - while normally a problem, with tool that requires human action (either creating or clicking a link) this is acceptable
* DynamoDB cannot create new secondary indexes on the fly.  If this is needed, a migration to another noSQL system (such as mongoDB) can be performed 

Short_url is made up of a long_url, short_url, owner (set to System at this point, see out of scope section), creation_date, and end_date (out of scope).  The hash key for this in dynamo is short_url, with a secondary index on long_url and owner (both for features not implemented).

Users can define a given short url they want to use (such as alexshorturl).  It is checked to make sure it is valid format (A-Za-z0-9) and it is not in use.  If no defined short url is provided, it is generated at random using the full long size for the computer running the server.  The long is then encoded in base 62 (A-Za-z0-9) using the base62 gem and checked if it is in use.  If so, a new one is generated and checked.  Short_url has static methods to both create itself with and without a defined short url, and static method to create itself from a given short_url.

Click is made up of time, country (pulled from the IP address using the gem geocoder), browser, platform (both pulled from the user agent using the UserAgent gem), short_url, and unique_hash, the browser and platform.  The unique hash is generated based on the date, short url and hash of the ip address.  Since it is only used for a unique hash key for the data, this algorithm can be changed at any time, just making sure it stays unique across algorithm generations.

The connection to dynamoDB is in the class dynamo_data_source which extends a generic data_source class.  It supports puts, gets with primary and secondary key/index and exists with primary key.

#Platform and Deployment

I picked AWS to support this environment due to my familiarity with it (due to limited time), it's support for Ruby as a first class language, noSQL support in dynamoDB, and the features of Elastic Beanstalk in deploying and monitoring.

The rails application is deployed on AWS Elastic Beanstalk.  Elastic Beanstalk provides hosting, deployment and monitoring systems.  Once the original EB project was set up, all that it takes to deploy new code to production is running the "eb deploy" command on your environment (see http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_Ruby_rails.html).  This will upload the code into S3, spin up new EC2 instances with the code, and put them behind the load balancer.

This may be cheating on the request for a deployment system (to use one built into the infrastructure), but not outside the bounds of the project to pick.   

#Unit Testing

There are specs for testing helper functions in the 2 controllers and a helper function in short_url.  RSpec was used because of its flexibility and ease of use with rails. 

Unfortunately I was planning to use fake_dynamo gem for testing the dynamoDB calls, but realized too late it would not support my needs.  This means that I was not able to finish unit testing the parts of the code that call dynamoDB, leaving a big hole in my testing.  AWS has a jar for local dynamo that can be used, but will require additional work that I did not scope for.

#Out of scope

There are many other features I discussed with Marcin to implement, but I deemed them out of scope for this project

* User accounts - this would allow a user to end date a short url, and see all of their short urls.  The schema right now supports this, but not implemented.
* Raw backend reporting - Using a regular SQL provider would make this easier, but not impossible with dynamo, but de-scoped
* Verifying the link is valid - I do some basic validation (using the Adressable gem) but work could be done to verify the URL exists before creating the short url
* Deduping short urls - The system supports this (lookup by long url) but does not dedupe new short urls.  This is debatable if it is wanted, for example a user might want a unique url to measure statistics for that url only and not other short urls to that long url.

# Lessons Learned

I should have made sure I could unit test the basic functionality (mocking dynamoDB) before adding more complicated features such as statistics.  This would provide a better core platform for adding new features.  

I also shouldn't have discounted that it had been a long time since using Rails, which added some additional time to the project.
