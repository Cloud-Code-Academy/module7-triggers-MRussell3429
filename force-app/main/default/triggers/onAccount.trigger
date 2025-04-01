trigger onAccount on Account (before insert, after insert) {
    
    /*
    * Question 1
    * Account Trigger
    * When an account is inserted change the account type to 'Prospect' if there is no value in the type field.
    * Trigger should only fire on insert.
    

    * Question 2
    * Account Trigger
    * When an account is inserted copy the shipping address to the billing address.
    * BONUS: Check if the shipping fields are empty before copying.
    * Trigger should only fire on insert.
    
    
    * Question 3
    * Account Trigger
	* When an account is inserted set the rating to 'Hot' if the Phone, Website, and Fax ALL have a value.
    * Trigger should only fire on insert.

    * Question 4
    * Account Trigger
    * When an account is inserted create a contact related to the account with the following default values:
    * LastName = 'DefaultContact'
    * Email = 'default@email.com'
    * Trigger should only fire on insert.
    */

    if(trigger.isBefore){
        for(Account acc : Trigger.new){
            //question 1:
            if(acc.type == null){
            acc.type = 'Prospect';
            }

            //question 2:
            if(acc.ShippingStreet != null){
                //in the real world, no address lacks a street,
                //I'm willing to risk that there's basic address validation at intake.
                acc.BillingStreet = acc.ShippingStreet;
                acc.BillingCity = acc.ShippingCity;
                acc.BillingState = acc.ShippingState;
                acc.BillingPostalCode = acc.ShippingPostalCode;
                acc.BillingCountry = acc.ShippingCountry;
            }

            //question 3: 
            if(acc.Phone != null && acc.Website != null && acc.Fax != null){
                acc.Rating = 'Hot';
            }
        }
    }

        if (trigger.isAfter && trigger.isInsert){
            
            String contactLastName = 'DefaultContact';
            String contactEmail = 'default@email.com';
            List <Contact> contactsToInsert = new List <Contact>();

            for(Account acc : trigger.new){
                //question 4:
                Contact relatedContact = new Contact();
                relatedContact.LastName = contactLastName;
                relatedContact.Email = contactEmail;
                relatedContact.AccountId = acc.id;
                contactsToInsert.add(relatedContact);
            }
            insert contactsToInsert;
        }




}