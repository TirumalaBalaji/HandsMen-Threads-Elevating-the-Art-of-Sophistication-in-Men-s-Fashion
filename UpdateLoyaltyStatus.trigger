trigger UpdateLoyaltyStatus on Order__c (after insert) {
    for (Order__c order : Trigger.New) {
        if (order.Customer__c != null && order.Total_Amount__c != null) {
            LoyaltyProgram.updateLoyaltyPoints(order.Customer__c, order.Total_Amount__c);
        }
    }
}