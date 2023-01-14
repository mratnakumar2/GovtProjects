public class Project_GovtBillAmtCalculation {
    
        
    
    public static void totalAmtandDueCal(Map<Id,Govt_Funds__c> govtFudsNewMap){
 
      
        Set<Id> contractsIds=new Set<Id>();
        Map<Id,Decimal> totalCntrctAmt=new  Map<Id,Decimal> ();
        list<Govt_Funds__c> updFundsLst=new list<Govt_Funds__c>();

       	
        for(Contract__c cntrct:[SELECT Id, Project__c, Contact__c, Due_Amount__c, Fixed_Amount__c, TotalPaidAmount__c, Description__c, Start_date__c, End_Date__c, Title__c, IsItBilled__c, Govt_Funds__c FROM Contract__c
		where Govt_Funds__c IN : govtFudsNewMap.keySet()]){
            contractsIds.add(cntrct.id);
            if(totalCntrctAmt.containsKey(cntrct.Govt_Funds__c)){
               // Decimal expAmt=Integer.valueof(totalAmt.get(cntrct.Govt_Funds__c));
                Decimal ctrexpAmt=totalCntrctAmt.get(cntrct.Govt_Funds__c);
                ctrexpAmt=ctrexpAmt+Decimal.valueOf(cntrct.TotalPaidAmount__c);
                //  system.debug('==ctrexpAmt=='+ctrexpAmt);
                totalCntrctAmt.put(cntrct.Govt_Funds__c,ctrexpAmt);
            }else
              totalCntrctAmt.put(cntrct.Govt_Funds__c,Decimal.valueOf(cntrct.TotalPaidAmount__c));
                    
         
        
         } 
        
       // system.debug('==totalCntrctAmt=='+totalCntrctAmt);
    Map<id,id> accContrlMap=new Map<id,id>();
        for(Govt_Funds__c con: govtFudsNewMap.values()){
            con.TotalContractsAmt__c=totalCntrctAmt.get(con.Id);
            updFundsLst.add(con);
          
         }
       // system.debug('==updFundsLst=='+updFundsLst);
   // Updating Billed amount at account level
     list<account> updacclst=new list<account>();
       Map<Id,Decimal> ttlActBilledAmt=new  Map<Id,Decimal> (); 
        for(Expense__c exp:[select id,Ammount__c,Project__c,Contacts__c,Contracts__c from Expense__c 
                         where  Contracts__c IN :contractsIds]){
     
                if(ttlActBilledAmt.containsKey(exp.Project__c)){
                Decimal ctrexpAmt=totalCntrctAmt.get(exp.Project__c);
                ctrexpAmt=ctrexpAmt+exp.Ammount__c;
                ttlActBilledAmt.put(exp.Project__c,ctrexpAmt);
            }else
              ttlActBilledAmt.put(exp.Project__c,exp.Ammount__c);  
                                   
         }
        for(Account acc:[select id,Billed_Amount__c from account where id IN :ttlActBilledAmt.keySet()]){
            acc.Billed_Amount__c=ttlActBilledAmt.get(acc.id);
            updacclst.add(acc);
        }   
        if(!updacclst.isEmpty())
            update updacclst;
    }

}