exports = function(changeEvent) {
  

  const fullDocument = changeEvent.fullDocument;

  const collection_c = context.services.get("Cluster0").db("DHL").collection("customers");
  const collection_o = context.services.get("Cluster0").db("DHL").collection("orders");

  const doc = collection_c.updateOne(
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

  const markOrder = collection_o.updateOne({
    "ORDER_ID": fullDocument.ORDER_ID
  },{
    "$set": {
      "_used": true
    }
  });

};

//find it with {orders:{$exists:true}}