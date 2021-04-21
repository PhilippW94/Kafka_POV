# Kafka JDBC Source Connector

__Load data from an Oracle instance via a Kafka Cluster into your MongoDB instance.__

__SA Maintainer__: Michael Gerstenberg, Timo Lackmann, Philipp Waffler<br/>
__Time to setup__: 90mins <br/>
__Time to execute__: 15 mins <br/>

---
## Description

This proof shows how MongoDB data from an Oracle instance can be loaded/synced to a MongoDB instance via a Kafka Cluster. This setup of this proof includes the following parts:

* Oracle RDS instance on AWS
* Setup of SQLDeveloper and loading sample data into your Oracle instance
* Kafka Cluster on your local machine
* MongoDB instance
* JDBC Source Connector
* MongoDB Sink Connector

The execution of this proof demonstrates how inserting data via SQL leads to data being loaded and stored MongoDB. 

---
## Setup


__1. Configure AWS RDS instance__

__2. Install SQLDeveloper and load sample data__

__3. Install Kafka Cluster__

__4. Configure Atlas Environment__
* Log-on to your [Atlas account](http://cloud.mongodb.com) (using the MongoDB SA preallocated Atlas credits system) and navigate to your SA project.
* In the project's Security tab, choose to add a new user, e.g. __main_user__, and for __User Privileges__ specify __Read and write to any database__ (make a note of the password you specify).
* In the Security tab, add a new __IP Whitelist__ for your laptop's current IP address.
* Create an __M10__ based 3 node replica-set in a single cloud provider region of your choice with default settings.
* In the Atlas console, for the database cluster you deployed, click the __Connect button__, select __Connect Your Application__, and for the __latest Node.js version__ copy the __Connection String Only__ - make a note of this MongoDB URL address to be used in the next steps.


__5. Setup Source__

__6. Setup Sink__
