trigger onOpportunity on Opportunity (before Update, before Delete) {

/*
    * Question 5
    * Opportunity Trigger
    * When an opportunity is updated validate that the amount is greater than 5000.
    * Error Message: 'Opportunity amount must be greater than 5000'
    * Trigger should only fire on update.

    * Question 6
    * Opportunity Trigger
    * When an opportunity is deleted prevent the deletion of a closed won opportunity if the account industry is 'Banking'.
    * Error Message: 'Cannot delete closed opportunity for a banking account that is won'
    * Trigger should only fire on delete.
    
    * Question 7
    * Opportunity Trigger
    * When an opportunity is updated set the primary contact on the opportunity to the contact on the same account with the title of 'CEO'.
    * Trigger should only fire on update.
*/
    if (trigger.isUpdate){
        Set <ID> accIds = new Set <Id>();
        for(Opportunity opp : Trigger.new){
            //question 5:
            if(opp.Amount <= 5000){
                opp.id.addError('Opportunity amount must be greater than 5000');
            }

            //question 7:
            accIds.add(opp.AccountId);
        }


        List <Account> accs = [SELECT id, (SELECT id
                                            FROM Contacts
                                            WHERE title = 'CEO')   
                               FROM Account
                               WHERE id in :accIds];

        Map <Id, Id> accountToContact = new Map <Id, Id> ();

        for(Account fuckThisAcc : accs){
            if(!fuckThisAcc.Contacts.isEmpty())
            accountToContact.put(fuckThisAcc.id, fuckThisAcc.Contacts[0].id);
        }

        for(Opportunity opp : Trigger.new){
            Opp.Primary_Contact__c = accountToContact.get(opp.AccountId);
            
        }

            //set the primary contact on opportunity to the contact where title = ceo for the account
            //will need: opp.acc.id in set
            // map [select id, contact, (select id, contact from contacts where acc.id in set and title = ceo)]
            // ^^really wish it had been that easy.

    }

    if(trigger.isDelete){
        if(trigger.isBefore){
            List <Opportunity> oppsForReview = new List <Opportunity>();
            Set <ID> accts = new Set <ID>();
            //question 6:
            for(Opportunity opp : Trigger.old){
    
                if(opp.StageName == 'Closed Won'){
                    accts.add(opp.AccountId);
                }
            }

            Map <Id, Account> relatedAcc = new Map <Id, Account>([SELECT id, industry
                                                                          FROM Account
                                                                          WHERE id in :accts]);

            for(Opportunity opp : Trigger.old){
                if(opp.StageName == 'Closed Won'
                    && relatedAcc.get(opp.AccountId).Industry == 'Banking'){
                    opp.id.addError('Cannot delete closed opportunity for a banking account that is won');
                }
            }
            
        }
    }
}