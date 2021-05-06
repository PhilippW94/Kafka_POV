curl -X POST http://localhost:8083/connectors -H "Content-Type: application/json" -d '{
"name": "oracle-source-table-whitelisting",
"config": {
        "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
        "topic.prefix": "oracle-bulk-",
        "connection.url": "jdbc:oracle:thin:@database-1.c2fwyhwvkqkf.us-east-2.rds.amazonaws.com:1521:testdb",
        "connection.user": "admin",
        "connection.password": "Michi#87",
        "mode": "bulk",
        "table.whitelist":"CUSTOMERS,ORDERS",
        "poll.interval.ms": "5000"
    }
}'