curl -X POST http://localhost:8083/connectors -H "Content-Type: application/json" -d '{
"name": "source-oracle-time-products",
"config": {
        "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
        "topic.prefix": "oracle-time-",
        "connection.url": "jdbc:oracle:thin:@teddy.c2fwyhwvkqkf.us-east-2.rds.amazonaws.com:1521:teddy",
        "connection.user": "admin",
        "connection.password": "Michi#87",
        "table.whitelist":"PRODUCTS",    
        "mode": "timestamp",
        "timestamp.column.name": "DATE_MODIFIED",
        "batch.max.rows": "1",
        "poll.interval.ms": "5000"
    }
}'