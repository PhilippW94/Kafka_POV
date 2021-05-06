curl -X PUT http://localhost:8083/connectors/mongo-sink-customers/config -H "Content-Type: application/json" -d ' {
        "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
        "tasks.max":"1",
        "topics":"oracle-bulk-CUSTOMERS",
        "connection.uri":"mongodb+srv://<username>:<password>@<endpoint>",
        "database":"DHL",
        "collection":"customers",
        "document.id.strategy":"com.mongodb.kafka.connect.sink.processor.id.strategy.PartialValueStrategy",
        "document.id.strategy.partial.value.projection.list":"CUSTOMER_ID",
        "document.id.strategy.partial.value.projection.type":"AllowList",
        "writemodel.strategy":"com.mongodb.kafka.connect.sink.writemodel.strategy.UpdateOneBusinessKeyTimestampStrategy",
        "transforms": "RenameField",
        "transforms.RenameField.type": "org.apache.kafka.connect.transforms.ReplaceField$Value",
        "transforms.RenameField.renames": "NAME:customerDetails.name,WEBSITE:customerDetails.website,ADDRESS:customerDetails.address"
}'