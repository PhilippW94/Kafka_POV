curl -X PUT http://localhost:8083/connectors/mongo-sink-time-products/config -H "Content-Type: application/json" -d ' {
        "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
        "tasks.max":"1",
        "topics":"oracle-time-PRODUCTS",
        "connection.uri":"mongodb+srv://{username}:{password}@{host}.mongodb.net",
        "database":"TEDDY",
        "collection":"products",
        "document.id.strategy":"com.mongodb.kafka.connect.sink.processor.id.strategy.PartialValueStrategy",
        "document.id.strategy.partial.value.projection.list":"PRODUCT_ID",
        "document.id.strategy.partial.value.projection.type":"AllowList",
        "writemodel.strategy":"com.mongodb.kafka.connect.sink.writemodel.strategy.UpdateOneBusinessKeyTimestampStrategy",
        "transforms": "RenameField",
        "transforms.RenameField.type": "org.apache.kafka.connect.transforms.ReplaceField$Value",
        "transforms.RenameField.renames": "STANDARD_COST:prices.standard,LIST_PRICE:prices.list"
}'