curl -X POST http://localhost:8083/connectors -H "Content-Type: application/json" -d '{
"name": "source-oracle-bulk",
"config": {
        "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
        "topic.prefix": "oracle-bulk-",
        "connection.url": "jdbc:oracle:thin:@teddy.c2fwyhwvkqkf.us-east-2.rds.amazonaws.com:1521:teddy",
        "connection.user": "admin",
        "connection.password": "Michi#87",
        "table.whitelist":"CUSTOMERS,ORDERS",
        "mode": "bulk",
        "batch.max.rows": "50",
        "poll.interval.ms": "5000"
    }
}'