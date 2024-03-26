public class AccountDefaultActiveContactCreation {
    
    public static void createContactWhenAccountisActive(List<Account> newAccountList){
        List<Contact> defaultContactsToInsert = new List<Contact>();
        List<Contact> existingContactsList = new List<Contact>();
        List<Account> accountListToUpdate = new List<Account>();
        
        Set<Id> accountIdSet = new Set<Id>();
        Set<Id> insertedIdSet = new Set<Id>();
        for(Account acc : newAccountList){
            insertedIdSet.add(acc.id);
        }
        // Map<Id, String> mapOfaccountActivationSummaries = new Map<Id, String>();
        Map<Id, Account> mapOfIdAndAccount = new Map<Id, Account>();
        try{
            for(Account accRec : [SELECT Id,Name,Active__c,Account_Activation_Summary__c,Company_Email__c,Type,Phone FROM Account WHERE Id IN:insertedIdSet]){
                mapOfIdAndAccount.put(accRec.id,accRec);
                if(accRec.Active__c ==true && accRec.Type == 'Customer'){
                    accountIdSet.add(accRec.Id);
                }
                if(accRec.Account_Activation_Summary__c ==null){
                    accRec.Account_Activation_Summary__c = 'Please Provide Activation Summary';
                }
                accountListToUpdate.add(accRec);
            }
            if(accountListToUpdate.size()>0){
                update accountListToUpdate;
                system.debug('Updated Account Record ==>'+accountListToUpdate);
            }
            if(accountIdSet.size()>0){
                existingContactsList = [SELECT Id,Name,Phone,AccountId FROM Contact WHERE AccountId IN:accountIdSet];
                if(existingContactsList.size()>0){
                    system.debug('Default Contact Present');
                }else{
                    for(String str : accountIdSet){
                        Contact conRec = new Contact();
                        conRec.AccountId = str;
                        conRec.FirstName = mapOfIdAndAccount.get(str).Name;
                        conRec.LastName = 'Customer Representative';
                        if(mapOfIdAndAccount.get(str).Company_Email__c !=null){
                            conRec.Email = mapOfIdAndAccount.get(str).Company_Email__c;
                        }
                        if(mapOfIdAndAccount.get(str).Phone !=null){
                            conRec.Phone = mapOfIdAndAccount.get(str).Phone;
                        }
                        defaultContactsToInsert.add(conRec);
                    }
                    if(defaultContactsToInsert.size()>0){
                        insert defaultContactsToInsert;
                        system.debug('Inserted Contact Size === >'+defaultContactsToInsert.size());
                    }
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
    }
    
    @AuraEnabled
    public static String updateAccountDetails(string recordId,Boolean isActivate,String activatonSummary){
        Account accRec = new Account();
        try{
            if(recordId !=null){
                accRec = [SELECT Id,Name,Account_Activation_Summary__c FROM Account WHERE Id=:recordId LIMIT 1];
                if(accRec !=null){
                    if(isActivate !=null){
                        accRec.Active__c = isActivate;
                        if(activatonSummary !=null){
                            accRec.Account_Activation_Summary__c = activatonSummary;
                        }else{
                            return 'Please Provide Activation Summary Before Activation Account !';
                        }
                        update accRec;
                        if(accRec !=null){
                            return 'SUCCESS';
                        }
                    }
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
        return null;
    }
    
}