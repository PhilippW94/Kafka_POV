curl -X PUT http://localhost:8083/connectors/mongo-sink-orders/config -H "Content-Type: application/json" -d ' {
        "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
        "tasks.max":"1",
        "topics":"oracle-bulk-ORDERS",
        "connection.uri":"mongodb+srv://michael:gLkUCOBEkkFLuXMH@cluster0.da1ep.mongodb.net",
        "database":"DHL",
        "collection":"orders",
        "document.id.strategy":"com.mongodb.kafka.connect.sink.processor.id.strategy.PartialValueStrategy",
        "document.id.strategy.partial.value.projection.list":"ORDER_ID",
        "document.id.strategy.partial.value.projection.type":"AllowList",
        "writemodel.strategy":"com.mongodb.kafka.connect.sink.writemodel.strategy.UpdateOneBusinessKeyTimestampStrategy"
}'