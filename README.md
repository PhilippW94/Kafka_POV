# Kafka JDBC Source Connector

__Load data from an Oracle instance via a Kafka Cluster into your MongoDB instance.__

__SA Maintainer__: Michael Gerstenberg, Timo Lackmann, Philipp Waffler<br/>
__Time to setup__: 120 min <br/>
__Time to execute__: 15 min <br/>

---
## Description Contents
There is **no prior knowledge of Kafka required** in order to successfully execute this proof. 

This proof shows **how MongoDB data from an Oracle instance can be loaded/synced to a MongoDB instance via a local Kafka Cluster**. The setup of this proof includes the following parts:

1. [Configure your Laptop](#-configure-laptop)
2. [Configure and Setup your AWS RDS instance](#-configure-your-aws-rds-instance)
3. [Install SQL Developer & Load Sample Data](#-install-sql-developer-and-load-sample-data)
4. [Install Kafka Cluster on your local machine](#-install-kafka-cluster)
5. [Configure Atlas Environment](#-configure-atlas-environment)
6. [Setup JDBC Source Connector](#-setup-jdbc-source-connector)
7. [Setup MongoDB Sink Connector](#-setup-mongodb-sink-connector)

An [execution and demonstration guide](#execution) is also provided. Last but no least we built a [Realm Function and Trigger](#merge-two-collections-with-a-realm-function-and-a-trigger) to merge collections in order to handle 1:N relations between entities.

The execution of **this proof demonstrates how inserting data via SQL leads to data being loaded and stored into MongoDB**. With the used Kafka Connectors, we demonstrate the following **additional capabilities**:
* How to ```JOIN``` **two tables** via the JDBC Source Connector. Here only **1:1 relationships** are implemented. For **1:N relationships** refer to the section regarding **"Realm Function and Trigger"**
* How to load rich documents into MongoDB by **nesting fields into subdocuments** via the MongoDB Sink Connector.

---
# Setup
## ![1](https://github.com/PhilippW94/Kafka_POV/blob/main/images/1b.png) Configure Laptop 
Ensure MongoDB version 3.6+ is already installed your laptop, mainly to enable the Mongo Shell and other MongoDB command line tools to be used (no MongoDB databases will be run on the laptop for this proof)

## ![2](https://github.com/PhilippW94/Kafka_POV/blob/main/images/2b.png) Configure your AWS RDS instance
Using your MongoDB 'Solution Architects' [AWS pre-existing account](https://wiki.corp.mongodb.com/display/DEVOPSP/How-To%3A+Access+AWS+Accounts), log on to the [AWS console](http://sa.aws.mongodb.com/). Launch (create) a new RDS instance with the following settings (use defaults settings for the rest of the fields):
   * __Engine options__: Oracle
     * __Edition__: Oracle Standard Edition Two
     * __License__: license-included
  * __Templates__: Dev/Test
  * __Settings__: 
    * __Master username__: _E.g. admin. __Note__ this value for later on._ 
    * __Master password__: _Choose a password. __Note__ this value for later on._ 
    * __Confirm password__: _Confirm your password._
  * __DB instance class__: Burstable classes, _choose smallest available type_
  * __Connectivity__:
    * __Public access__: Yes
    * __Availability Zone__: _Choose an availability zone_ 
    * __Additional configuration__: _Ensure database port 1521 (default)_
  * __Additional configuration__: _The name of your first database, e.g. testdb. __Note__ this for later on._ 

  * __Add Tags__: In the standard creation process, AWS will not prompt you to define tags. Hence, once your instance is being created, click on the DB identifier (e.g. database-1) and navigate to the _Tags_ tab. _Be sure to set the four specific tags ('Name', 'owner', 'purpose', 'expire-on' e.g. 2021-12-31) on your instance as per the [MongoDB AWS Usage Guidelines](https://wiki.corp.mongodb.com/display/DEVOPSP/AWS+Reaping+Policies)_ to avoid your instance from being prematurely reaped

Once your database was created, __note__ the Endpoint in the "Connectivity & security" tab for later on. Creation may take up to 10-15min. 

[Proof Contents](#description-contents)

![end](https://github.com/PhilippW94/Kafka_POV/blob/main/images/section-end.png)

## ![3](https://github.com/PhilippW94/Kafka_POV/blob/main/images/3b.png) Install SQL Developer and Load Sample Data

In order to manage the contents of your Oracle database, install the [Oracle SQL Developer](https://www.oracle.com/tools/downloads/sqldev-downloads.html):
* Choose your operating system 
* __Create an Oracle Account__ _(you might not want to use your @mongodb.com address here)_
* Try to launch SQL Developer. In the current version of __MacOS this can be problematic__. The following workarounds exist:
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
  * In SQL Developer, click on the top left on the green cross: <img src="https://github.com/PhilippW94/Kafka_POV/blob/main/images/Screenshot%202021-04-22%20at%2009.45.49.png?raw=true" width="20"><br/>
    <img src="https://github.com/PhilippW94/Kafka_POV/blob/main/images/Screenshot%202021-04-22%20at%2010.07.59.png?raw=true" width="500">
  * The following screen should show. Fill in the fields as follows:
    <img src="https://github.com/PhilippW94/Kafka_POV/blob/main/images/Screenshot%202021-04-22%20at%2009.44.50.png?raw=true" width="700">
  * __Name__: _Choose and arbitrary name__
  * __Username__: _The username you chose when configuring your RDS instance, e.g. by default admin_
  * __Password__: _The password you chose_
  * __Hostname__: _The endpoint of your AWS RDS instance you noted before_
  * __Port__: _By default 1521_
  * __SID__: _The database name defined before, e.g. __testdb__ _
* __Load the sample data__:
  * __Create tables__ by copying out of the downloaded Oracle sample data the contents __ot_schema.sql__ into the worksheet tab in SQL Developer:<br/>
    <img src="https://github.com/PhilippW94/Kafka_POV/blob/main/images/Screenshot%202021-04-22%20at%2009.45.00.png?raw=true" width="700">
  * Press the following button in order to execute the script: <img src="https://github.com/PhilippW94/Kafka_POV/blob/main/images/Screenshot%202021-04-22%20at%2009.45.39.png?raw=true" width="20">
  * In the __ot_data.sql__ file, delete all "OT." prefixes, _e.g. by replacing "OT." --> ""_. 
  * __Load the actual data__ by copying the adjusted contents of the __ot_data.sql__ file to the worksheet tab and executing the script again.
  * This step should take 1-2 min. Once the insert process commences, you should be able to browse your freshly generated SQL database with the loaded sample data.

[Proof Contents](#description-contents)

![end](https://github.com/PhilippW94/Kafka_POV/blob/main/images/section-end.png)

## ![4](https://github.com/PhilippW94/Kafka_POV/blob/main/images/4b.png) Install Kafka Cluster
In this step all required software in order to operate a Kafka Cluster locally is installed **via Docker**. With the image the following applications are installed and started in a new docker container:
* **Zookeeper**: From [Kafka Getting Started](https://kafka.apache.org/08/documentation.html): "Kafka uses zookeeper so you need to first start a zookeeper server if you don't already have one."
* **Kafka**: From [What is Apache Kafka®](https://www.confluent.io/what-is-apache-kafka/): "Apache Kafka is a community distributed event streaming platform capable of handling trillions of events a day."
* **Confluent Schema Registry**: [From Confluent Docs](https://docs.confluent.io/platform/current/schema-registry/index.html): "Confluent Schema Registry provides a serving layer for your metadata."
* **Confluent Kafka Connect**: [From Confluent Docs](https://docs.confluent.io/platform/current/connect/index.html): "Kafka Connect is a tool for scalably and reliably streaming data between Apache Kafka® and other data systems." _Kafka Connect will be used in this proof to host the connector from Oracle to Kafka as well as the connector from Kafka to MongoDB._
* **Confluent KSQL Server**: [From Confluent Docs](https://docs.confluent.io/platform/current/ksqldb/index.html): "ksqlDB is a database purpose-built to help developers create stream processing applications on top of Apache Kafka"
* **Confluent Control Center**: [From Confluent Docs](https://docs.confluent.io/platform/current/control-center/index.html) "Confluent Control Center is a web-based tool for managing and monitoring Apache Kafka®." _The Confluent Control Center will be used in this POV to control and demonstrate the Kafka Cluster_
* **Kafka Rest Proxy**: [From Confluent Docs](https://docs.confluent.io/platform/current/kafka-rest/index.html): "The Confluent REST Proxy provides a RESTful interface to a Apache Kafka® cluster"
* **Kafka Topics UI**: [From Github kafka-topics-ui](https://github.com/lensesio/kafka-topics-ui): "Browse Kafka topics and understand what's happening on your cluster."

The following contains a detailed explanation of how to spin up the above mentioned containers:
* First of all, make sure that you have a running version of Docker on your laptop. If not, install it via:
  ```bash
  brew install --cask docker
  ```
* **Download** [docker-compose.yaml](https://github.com/PhilippW94/Kafka_POV/blob/main/Kafka/docker-compose.yml)
* In the directory where you downloaded _docker-compose.yaml_, open a terminal window and run the Docker container:
  ```bash
  docker-compose up -d
  ```
* _Optional: You might receive an error message, that this container already exists. In this case, remove all pre-existing and conflicting containers._
* Downloading and spinning up the Containers can take **10-15min** depending on your internet
* **Once the setup has finished**, check your environment:
  ```bash
  docker-compose ps
  ```
  The output should look as follows: <br/>
  <img src="https://github.com/PhilippW94/Kafka_POV/blob/main/images/Screenshot%202021-04-22%20at%2009.45.22.png?raw=true" width="700">
* You can **view your Kafka cluster's** control pane by going to [localhost:9021](http://localhost:9021) in your browser.

[Proof Contents](#description-contents)

![end](https://github.com/PhilippW94/Kafka_POV/blob/main/images/section-end.png)

## ![5](https://github.com/PhilippW94/Kafka_POV/blob/main/images/5b.png) Configure Atlas Environment
* Log-on to your [Atlas account](http://cloud.mongodb.com) (using the MongoDB SA preallocated Atlas credits system) and navigate to your SA project.
* In the project's Security tab, choose to add a new user, e.g. __main_user__, and for __User Privileges__ specify __Read and write to any database__ (make a note of the password you specify)
* In the Security tab, add a new __IP Whitelist__ for your laptop's current IP address
* Create an __M10__ based 3 node replica-set in a single cloud provider region of your choice with default settings
* In the Atlas console, for the database cluster you deployed, click the __Connect button__, select __Connect Your Application__, and for the __latest Node.js version__ copy the __Connection String Only__ - make a note of this MongoDB URL address to be used in the next steps

[Proof Contents](#description-contents)

![end](https://github.com/PhilippW94/Kafka_POV/blob/main/images/section-end.png)

## ![6](https://github.com/PhilippW94/Kafka_POV/blob/main/images/6b.png) Setup JDBC Source Connector

First, the MongoDB and JDBC connector have to be installed in your environment:
* Retrieve the _CONTAINER ID_ from your **Kafka Connect** container by executing the following command in your terminal:
  ```bash
  docker ps -a | grep connect
  ```
* **Note** the _CONTAINER ID_ from **Kafka Connect**:
  <img src="https://github.com/PhilippW94/Kafka_POV/blob/main/images/Screenshot%202021-04-22%20at%2009.45.14.png?raw=true" width="900">
  ```bash
  containerid=<CONTAINER ID>
  ```
* **Install the connectors** by executing the following commands in your shell: _(Confirm all prompts by typing 1,y,y,y)_
  ```bash
  docker exec -it $containerid confluent-hub install confluentinc/kafka-connect-jdbc:latest
  docker exec -it $containerid confluent-hub install mongodb/kafka-connect-mongodb:1.5.0
  docker restart $containerid
  ```

* It **might take 2-3min** to have these change visible in your control center
* **Check** if connectors are installed via the control center on [localhost:9021](http://localhost:9021):
  * Click on your cluster
  * On the left, click on **connect**
  * Click on **connect-default**, your connect cluster
  * Click **Add Connector**
  * You should see the following overview of selectable connectors:
    <img src="https://github.com/PhilippW94/Kafka_POV/blob/main/images/Screenshot%202021-04-22%20at%2009.45.31.png?raw=true" width="700">

After the installation, configure your JDBC Source Connector. The connector us using polling anyway, but different modes can be choosen:
* bulk: perform a bulk load of the entire table each time it is polled
* incrementing: use a strictly incrementing column on each table to detect only new rows. Note that this will not detect modifications or deletions of existing rows.
* timestamp: use a timestamp (or timestamp-like) column to detect new and modified rows. This assumes the column is updated with each write, and that values are monotonically incrementing, but not necessarily unique.
* timestamp+incrementing: use two columns, a timestamp column that detects new and modified rows and a strictly incrementing column which provides a globally unique ID for updates so each row can be assigned a unique stream offset.

Find more information here: https://docs.confluent.io/kafka-connect-jdbc/current/source-connector/source_config_options.html

The Source Connector will be launched via the terminal by the means of an API call to the Kafka Connect Cluster. You will need do **configure the following API call's payload**:
  
```bash
curl -X POST http://localhost:8083/connectors -H "Content-Type: application/json" -d '{
"name": "oracle-source-products",
"config": {
        "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
        "topic.prefix": "oracle-kafka-mongodb",
        "connection.url": "jdbc:oracle:thin:@database-1.c7qrltnpbuzd.eu-central-1.rds.amazonaws.com:1521:testdb",
        "connection.user": "admin",
        "connection.password": "password",
        "query":"SELECT p.PRODUCT_ID, p.PRODUCT_NAME, p.DESCRIPTION, p.STANDARD_COST, p.LIST_PRICE, c.CATEGORY_NAME FROM PRODUCTS p INNER JOIN PRODUCT_CATEGORIES c ON p.CATEGORY_ID = c.CATEGORY_ID",
        "mode": "bulk",
        "batch.max.rows": "1",
        "poll.interval.ms": "5000"
    }
}'
```

* **connection.uri**: Use the following format, by using the previously noted endpoint of your AWS RDS instance:
  ```
  jdbc:oracle:thin:@<endpoint of oracle db>:<port, default 1521>:<inital database name from before>
  ```
  Example:
  ```
  jdbc:oracle:thin:@database-1.c7qrltnpbuzd.eu-central-1.rds.amazonaws.com:1521:testdb
  ```
* **connection.user**: _Your chosen username for the AWS RDS instance, e.g. admin_
* **connection.password**: _Your chose password_
* **query**: 
  ```SQL
   SELECT p.PRODUCT_ID, p.PRODUCT_NAME, p.DESCRIPTION, p.STANDARD_COST, p.LIST_PRICE, c.CATEGORY_NAME FROM PRODUCTS p INNER JOIN PRODUCT_CATEGORIES c ON p.CATEGORY_ID = c.CATEGORY_ID;
  ```

Launch the connector by executing the configured API call. The **query** will join the sample data's ```PRODUCTS```and ```PRODUCT_CATEGORIES```tables.

Having configured ```"mode": "bulk"```will continuously send the data previously loaded into the Oracle instance to our Kafka Cluster. This simulates a constant write load on the Oracle instance.

[Proof Contents](#description-contents)

![end](https://github.com/PhilippW94/Kafka_POV/blob/main/images/section-end.png)

## ![7](https://github.com/PhilippW94/Kafka_POV/blob/main/images/7b.png) Setup MongoDB Sink Connector
The Sink Connector will be launched by the same means as the Source Connector. You will need do **configure the following API call's payload**:
```bash
curl -X PUT http://localhost:8083/connectors/oracle-mongo-sink/config -H "Content-Type: application/json" -d ' {
        "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
        "tasks.max":"1",
        "topics":"oracle-kafka-mongodb",
        "connection.uri":"mongodb+srv://user:password@cluster1.l3iko.mongodb.net",
        "database":"FromOracle",
        "collection":"productData",
        "document.id.strategy":"com.mongodb.kafka.connect.sink.processor.id.strategy.PartialValueStrategy",
        "document.id.strategy.partial.value.projection.list":"PRODUCT_ID",
        "document.id.strategy.partial.value.projection.type":"AllowList",
        "writemodel.strategy":"com.mongodb.kafka.connect.sink.writemodel.strategy.UpdateOneBusinessKeyTimestampStrategy",
        "transforms": "RenameField",
        "transforms.RenameField.type": "org.apache.kafka.connect.transforms.ReplaceField$Value",
        "transforms.RenameField.renames": "STANDARD_COST:prices.standard,LIST_PRICE:prices.list"
}'
```
* **connection.uri**: Use the same format as given above.
* **database**: The database name in MongoDB Atlas, you want your Oracle data to be loaded to.
* **collection**: The collection name in MongoDB Atlas, you want your Oracle data to be loaded to.

Launch the connector by executing the configured API call. The defined _transforms_ nest the price information into a subdocument.

[Proof Contents](#description-contents)

![end](https://github.com/PhilippW94/Kafka_POV/blob/main/images/section-end.png)

# Execution 
The execution of this POV is rather straightforward, as at this point there should not be much left to do. You might want to show your prospect the setup of the connectors. 

Once the connectors are configured and launched, navigate to _Connect_ in the [control center](http://localhost:9021) of your Kafka Cluster and click on your connect cluster. You should be seeing the following connectors: <br/><br/>
    <img src="https://github.com/PhilippW94/Kafka_POV/blob/main/images/Screenshot%202021-04-27%20at%2014.58.49.png?raw=true" width="900">

Here we can see the successfully launched connectors. In order to demonstrate that the JDBC Source Connector is actually doing its job, navigate in the control center of your Kafka Cluster to _Topics_. Here you should see the _oracle-kafka-mongodb_ topic, which includes the data loaded from the Oracle instance to the Kafka Cluster: <br/><br/>
    <img src="https://github.com/PhilippW94/Kafka_POV/blob/main/images/Screenshot%202021-04-27%20at%2015.06.36.png?raw=true" width="900">
    
If you click on the topic itself and select the _messages_ tab you should see the constantly loaded data coming in continuously. 

Last but not least, we show that the MongoDB Sink Connector does it's job by showing that the data actually arrives in Atlas. The resulting documents should be of the following form: <br/><br/>
    <img src="https://github.com/PhilippW94/Kafka_POV/blob/main/images/Screenshot%202021-04-27%20at%2015.01.22.png?raw=true" width="700">

**Conclusion**: You can easily load data from Oracle to MongoDB via Kafka and additionally transform, nest and ```JOIN``` it on the way.

[Proof Contents](#description-contents)

![end](https://github.com/PhilippW94/Kafka_POV/blob/main/images/section-end.png)

# Merge two collections with a Realm Function and a Trigger

To be independent from the above use case we install a couple more connectors, additional to the JDBC connector already in place from the previous sections of this POV:
* [connectors/orcale-source-table-whitelisting.sh](https://github.com/PhilippW94/Kafka_POV/blob/main/connectors/orcale-source-table-whitelisting.sh): this Oracle source connector streams all data from the CUSTOMERS and ORDERS tables into the topics oracle-bulk-<tablename>
* [connectors/mongo-sink-customers.sh](https://github.com/PhilippW94/Kafka_POV/blob/main/connectors/mongo-sink-customers.sh) : this Mongo sink connector reads the oracle-bulk-CUSTOMERS topic and stores it into MongoDB
* [connectors/mongo-sink-orders.sh](https://github.com/PhilippW94/Kafka_POV/blob/main/connectors/mongo-sink-orders.sh): this Mongo sink connector reads the oracle-bulk-ORDERS topic and stores it into MongoDB

We are going to merge the **ORDERS** collection into the **CUSTOMERS** collection. For that we create an Atlas Trigger and a Realm Function.

To do so we log into MongoDB Atlas and choose **Triggers** on the left side and click **Add Trigger** on the new loaded page. We choose the following parameters:

* Trigger Type: Database
* Name: Choose an appropriate name
* Enabled: ON
* Choose your Cluster and the database
* Choose *orders* for the collection, because we want to follow this change stream
* Operation Type: Insert and Update
* Full Document: ON
* Event Type: Function

You can find the function inside [realm_functions/addOrderToCustomer.js](https://github.com/PhilippW94/Kafka_POV/blob/main/realm_functions/addOrderToCustomer.js). Not all customers have orders.  

[Proof Contents](#description-contents)
As a result all orders will be merged into the customers collection. Once the the Realm function is up and running, check result with Compass or the Atlas GUI. No all customers have orders, thus you might want to filter the results by using the following filter parameters: ```{orders:{$exists:true}}```

Thus the 1:N relationship of customer to orders can be implemented "automatically" in MongoDB by nesting the orders in the customer collection. This demonstrates not only the transfer of data from an Oracle Instance to MongoDB, but also the shift in paradigm that data is stored the way it is accessed. 
