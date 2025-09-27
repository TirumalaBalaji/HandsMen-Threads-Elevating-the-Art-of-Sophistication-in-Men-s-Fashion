global class BulkOrderBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Quantity__c, Product__c FROM Order__c WHERE Status__c = \'Pending\'');
    }
    
    global void execute(Database.BatchableContext bc, List<Order__c> orders) {
        List<Product__c> productsToUpdate = new List<Product__c>();
        
        for (Order__c o : orders) {
            Product__c prod = [
                SELECT Id, Stock_Quantity__c 
                FROM Product__c 
                WHERE Id = :o.Product__c 
                LIMIT 1
            ];
            prod.Stock_Quantity__c -= o.Quantity__c;
            productsToUpdate.add(prod);
            
            o.Status__c = 'Processed';
        }
        
        update orders;
        update productsToUpdate;
    }
    
    global void finish(Database.BatchableContext bc) {
        System.debug('Bulk Order Batch Completed.');
    }
}