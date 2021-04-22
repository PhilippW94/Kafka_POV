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
### __0. Configure Laptop__ <br/>
Ensure MongoDB version 3.6+ is already installed your laptop, mainly to enable the Mongo Shell and other MongoDB command line tools to be used (no MongoDB databases will be run on the laptop for this proof)

### __1. Configure your AWS RDS instance__ <br/>
Using your MongoDB 'Solution Architects' [AWS pre-existing account](https://wiki.corp.mongodb.com/display/DEVOPSP/How-To%3A+Access+AWS+Accounts), log on to the [AWS console](http://sa.aws.mongodb.com/). Launch (create) a new RDS instance with the following settings (use defaults settings for the rest of the fields):
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
  * __Additional configuration__: _The name of your first database, e.g. testdb. __Note__ this for later on._ 

  * __Add Tags__: In the standard creation process, AWS will not prompt you to define tags. Hence, once your instance is being created, click on the DB identifier (e.g. database-1) and navigate to the _Tags_ tab. _Be sure to set the 3 specific tags ('Name', 'owner', 'expire-on') on your instance as per the [MongoDB AWS Usage Guidelines](https://wiki.corp.mongodb.com/display/DEVOPSP/AWS+Reaping+Policies)_ to avoid your instance from being prematurely reaped

Once your database was created, __note__ the Endpoint in the "Connectivity & security" tab for later on. Creation may take up to 10-15min. 

### __2. Install SQL Developer & Load Sample Data__
In order to manage the contents of your Oracle database, install the [Oracle SQL Developer](https://www.oracle.com/tools/downloads/sqldev-downloads.html):
* Chose your operating system 
* __Create an Oracle Account__ _(you might not want to use your @mongodb.com address here)_
* Try launch SQL Developer. In the current version of __MacOS this can be problematic__. The following workarounds exist:
  * In the Security & Privacy Settings of MacOS _(Access via Spotlight Search)_ you should see the following: <img src="https://github.com/PhilippW94/Kafka_POV/blob/main/images/Screenshot%202021-04-22%20at%2009.44.31.png?raw=true " width="500">
  * Click on __Open Anyway__. Check if SQL Developer opens anyway.
* If this workaround did not work, the following one should:
  *  Open the terminal in folder where SQL Developer.app is placed _(The file you downloaded from Oracle)_ 
      ```bash
      cd SQLDeveloper.app/Contents/Resources/sqldeveloper/
      zsh sqldeveloper.sh
      ```
  * Ignore error messages in the shell, as long as SQLDeveloper starts
* Once Oracle opens, __do not allow Oracle usage tracking__.<br/><br/>

Now it is time to load some sample data into our Oracle RDS instance:
* __Download__ the [official Oracle sample data](https://www.oracletutorial.com/getting-started/oracle-sample-database/)
* __Connect to your database__ in SQL Developer:
  * In SQL Developer, click on the top left on the green cross: <img src="https://github.com/PhilippW94/Kafka_POV/blob/main/images/Screenshot%202021-04-22%20at%2009.45.49.png?raw=true" width="20">
    <img src="https://github.com/PhilippW94/Kafka_POV/blob/main/images/Screenshot%202021-04-22%20at%2009.44.43.png?raw=true" width="500">
  * The following screen should show. Fill in the fields as follows:
    <img src="https://github.com/PhilippW94/Kafka_POV/blob/main/images/Screenshot%202021-04-22%20at%2009.44.50.png?raw=true" width="700">
  * __Name__: _Choose and arbitrary name__
  * __Username__: _The username you chose when configuring your RDS instance, e.g. by default admin_
  * __Password__: _The password you chose_
  * __Hostname__: _The endpoint of your AWS RDS instance you noted before_
  * __Port__: _By default 1521_
  * __SID__: _The database name defined before, e.g. __testdb__ _
  * 
  



### __3. Install Kafka Cluster__

### __4. Configure Atlas Environment__
* Log-on to your [Atlas account](http://cloud.mongodb.com) (using the MongoDB SA preallocated Atlas credits system) and navigate to your SA project.
* In the project's Security tab, choose to add a new user, e.g. __main_user__, and for __User Privileges__ specify __Read and write to any database__ (make a note of the password you specify)
* In the Security tab, add a new __IP Whitelist__ for your laptop's current IP address
* Create an __M10__ based 3 node replica-set in a single cloud provider region of your choice with default settings
* In the Atlas console, for the database cluster you deployed, click the __Connect button__, select __Connect Your Application__, and for the __latest Node.js version__ copy the __Connection String Only__ - make a note of this MongoDB URL address to be used in the next steps


### __5. Setup JDBC Source Connector__

### __6. Setup MongoDB Sink__
