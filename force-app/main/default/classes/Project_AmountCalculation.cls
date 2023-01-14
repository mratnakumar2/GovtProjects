public class Project_AmountCalculation {
    
    public static void totalAmtandDueCal(Map<Id,Expense__c> expenseNewMap,Map<Id,Expense__c> expenseOldMap){
        Map<Id,Expense__c> expenseMap=new Map<Id,Expense__c>();
        if(Trigger.isdelete)
           expenseMap= expenseOldMap;
        else
          expenseMap= expenseNewMap;  
      
        Set<Id> contIds=new Set<Id>();
        Map<Id,Decimal> totalAmt=new  Map<Id,Decimal> ();
        list<Contact> upContLst=new list<Contact>();

        Set<Id> cntrtIds=new Set<Id>();
        Map<Id,Decimal> totalCntrctAmt=new  Map<Id,Decimal> ();
        list<Contract__c> updContractLst=new list<Contract__c>();
        
        for(Expense__c exp:expenseMap.values()){ 
            contIds.add(exp.Contacts__c);
            cntrtIds.add(exp.Contracts__c);
        }
        for(Expense__c exp:[select id,Ammount__c,Contacts__c,Contracts__c from Expense__c where Contacts__c IN : contIds OR Contracts__c IN :cntrtIds]){
            
            if(totalCntrctAmt.containsKey(exp.Contracts__c)){
               // Decimal expAmt=Integer.valueof(totalAmt.get(exp.Contacts__c));
                Decimal ctrexpAmt=totalCntrctAmt.get(exp.Contracts__c);
                ctrexpAmt=ctrexpAmt+exp.Ammount__c;
                totalCntrctAmt.put(exp.Contracts__c,ctrexpAmt);
            }else
              totalCntrctAmt.put(exp.Contracts__c,exp.Ammount__c);
                    
                    
                if(totalAmt.containsKey(exp.Contacts__c)){
                  // Decimal expAmt=Integer.valueof(totalAmt.get(exp.Contacts__c));
                   Decimal expAmt=totalAmt.get(exp.Contacts__c);
                   expAmt=expAmt+exp.Ammount__c;
                   totalAmt.put(exp.Contacts__c,expAmt);
               }else
                   totalAmt.put(exp.Contacts__c,exp.Ammount__c);
        
         } 
        
        for(Contact con:[select id,name,TotalPaidAmount__c,Fixed_Amount__c,Due_Amount__c from contact where id=:contIds]){
            con.TotalPaidAmount__c=String.valueof(totalAmt.get(con.Id));
          if(con.Fixed_Amount__c<>null)
           con.Due_Amount__c=String.valueOf(Integer.valueof(con.Fixed_Amount__c)-Integer.valueof(totalAmt.get(con.Id)));   
           
          upContLst.add(con);
        } 
        if(upContLst.size()>0)
          update upContLst;  
      
      
        
       for(Contract__c ctrt:[select id,name,Project__c,TotalPaidAmount__c,Fixed_Amount__c,Due_Amount__c from Contract__c  where id=:cntrtIds]){
        ctrt.TotalPaidAmount__c=String.valueof(totalCntrctAmt.get(ctrt.Id));
          if(ctrt.Fixed_Amount__c<>null)
          ctrt.Due_Amount__c=String.valueOf(Integer.valueof(ctrt.Fixed_Amount__c)-Integer.valueof(totalCntrctAmt.get(ctrt.Id)));   
           
          updContractLst.add(ctrt);
        } 
   
        if(updContractLst.size()>0)
        update updContractLst; 
   }
    
    public static void dueAmountCal(Map<Id,Expense__c> expenseNewLst,Map<Id,Expense__c> expenseOldLst){
        
    }

}