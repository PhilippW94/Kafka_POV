# Kafka JDBC Source Connector

__Load data from an Oracle instance via a Kafka Cluster into your MongoDB instance.__

__SA Maintainer__: Michael Gerstenberg, Timo Lackmann, Philipp Waffler<br/>
__Time to setup__: 90mins <br/>
__Time to execute__: 15 mins <br/>

---
## Description

This proof shows how MongoDB data from an Oracle instance can be loaded/synced to a MongoDB instance via a Kafka Cluster. The setup of this proof includes the following parts:

* Oracle RDS instance on AWS
* Setup of SQLDeveloper and loading sample data into your Oracle instance
* Kafka Cluster on your local machine
* MongoDB instance
* JDBC Source Connector
* MongoDB Sink Connector

The execution of this proof demonstrates how inserting data via SQL leads to data being loaded and stored into MongoDB. 

---
## Setup
__0. Configure Laptop__
* Ensure MongoDB version 3.6+ is already installed your laptop, mainly to enable the Mongo Shell and other MongoDB command line tools to be used (no MongoDB databases will be run on the laptop for this proof)

__1. Configure AWS RDS instance__
* Using your MongoDB 'Solution Architects' [AWS pre-existing account](https://wiki.corp.mongodb.com/display/DEVOPSP/How-To%3A+Access+AWS+Accounts), log on to the [AWS console](http://sa.aws.mongodb.com/)
* Launch (create) a new RDS instance with the following settings (use defaults settings for the rest of the fields):
  * __Engine options__: Oracle
   * __Edition__: Oracle Standard Edition Two
   * __License__: license-included
  * __Templates__: Dev/Test
  * __Settings__: 
   * __DB instance identifier__: _Your db identifier, e.g. testdb_ 
   * __Master username__: _E.g. admin. __Note__ this value for later on._ 
   * __Master password__: _Choose a password. __Note__ this value for later on._ 
   * __Confirm password__: _Confirm your password._
  * __DB instance class__: Burstable classes, _choose smallest available type_
  * __Connectivity__:
   * __Public access__: Yes
   * __Availability Zone__: _Choose an availability zone_ 
   * __Additional configuration__: _Ensure database port 1521 (default)_
  * __Additional configuration__: _The name of your first database, e.g. testdb_ 

  * __Add Tags__: In the standard creation process, AWS will not prompt you to define tags. Hence, once your instance is being created, click on the DB identifier (e.g. database-1) and navigate to the _Tags_ tab. _Be sure to set the 3 specific tags ('Name', 'owner', 'expire-on') on your instance as per the [MongoDB AWS Usage Guidelines](https://wiki.corp.mongodb.com/display/DEVOPSP/AWS+Reaping+Policies)_ to avoid your instance from being prematurely reaped



__2. Install SQLDeveloper and load sample data__

__3. Install Kafka Cluster__

__4. Configure Atlas Environment__
* Log-on to your [Atlas account](http://cloud.mongodb.com) (using the MongoDB SA preallocated Atlas credits system) and navigate to your SA project.
* In the project's Security tab, choose to add a new user, e.g. __main_user__, and for __User Privileges__ specify __Read and write to any database__ (make a note of the password you specify)
* In the Security tab, add a new __IP Whitelist__ for your laptop's current IP address
* Create an __M10__ based 3 node replica-set in a single cloud provider region of your choice with default settings
* In the Atlas console, for the database cluster you deployed, click the __Connect button__, select __Connect Your Application__, and for the __latest Node.js version__ copy the __Connection String Only__ - make a note of this MongoDB URL address to be used in the next steps


__5. Setup Source__

__6. Setup Sink__
