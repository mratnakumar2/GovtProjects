trigger ExpenseTrigger on Expense__c (before insert,before update,after insert,after update,before delete,after delete) {
    if(Trigger.isAfter){
         Project_AmountCalculation.totalAmtandDueCal(Trigger.newMap,Trigger.oldMap);
        // Project_AmountCalculation.dueAmountCal(Trigger.newMap,Trigger.oldMap);
    }
}