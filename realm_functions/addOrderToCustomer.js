exports = function(changeEvent) {

  const fullDocument = changeEvent.fullDocument;
  const collection = context.services.get("Cluster0").db("DHL").collection("customers");

  const doc = collection.updateOne(
    {
      "CUSTOMER_ID": fullDocument.CUSTOMER_ID
    },{
      "$addToSet": {
        "orders": {
          "orderId": fullDocument.ORDER_ID,
          "status": fullDocument.STATUS
        }
      }
    }
  );

};