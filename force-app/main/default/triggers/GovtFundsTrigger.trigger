trigger GovtFundsTrigger on Govt_Funds__c (Before update) {
    if(trigger.isBefore){
       Map<id,Govt_Funds__c> calcFunds=new Map<id,Govt_Funds__c> ();
        for(Govt_Funds__c gvtf: trigger.new){
        
            if(gvtf.Stage__c=='SE_Reviewed' || gvtf.Stage__c=='	M-Book created' || gvtf.Stage__c=='AE_Reviewed')
                calcFunds.put(gvtf.id,gvtf);
             }
         
        if(!calcFunds.isEmpty())
         Project_GovtBillAmtCalculation.totalAmtandDueCal(calcFunds);
       
    }
}