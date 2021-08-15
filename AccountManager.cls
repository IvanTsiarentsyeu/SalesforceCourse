/**
 * Created by Ivan Tsiarentsyeu on 15.08.2021.
 */

@RestResource(urlMapping='/Accounts/*')
global class AccountManager {

    @HttpGet global static List<Account> getAccount() {
        RestRequest request = RestContext.request;
        String accountId = request.requestURI.substring (
                request.requestURI.lastIndexOf('/') + 1);
        List<Account> result = new List<Account>();
        If (accountId.toUpperCase() == 'ALL') {
             result = [ SELECT Id, Name, Industry, Phone, Fax, Website, TickerSymbol,
                            Ownership, NumberOfEmployees, Sic,
                            BillingCountry, BillingState, BillingPostalCode,
                            BillingCity, BillingStreet
                    FROM Account ];
        } else {
             result = [ SELECT Id, Name, Industry, Phone, Fax, Website, TickerSymbol,
                        Ownership, NumberOfEmployees, Sic,
                        BillingCountry, BillingState, BillingPostalCode,
                        BillingCity, BillingStreet
                FROM Account
                WHERE Id = :accountId ];
        }
        return result;
    }

    @HttpPost global static Id CreateAccount() {
        RestRequest request = RestContext.request;
        Account account = (Account)
                JSON.deserialize(request.requestBody.toString(), Account.class);
        account.Id = null;
        try {
            insert account;
        } catch (DmlException e) {
            System.debug(e);
        }
        return account.Id;
    }

    @HttpDelete
    global static void deleteAccount() {
        RestRequest request = RestContext.request;
        String accountId = request.requestURI.substring (
                request.requestURI.lastIndexOf('/') + 1);
        Account account = [SELECT Id FROM Account WHERE Id = :accountId];
        try {
            delete account;
        } catch (DmlException e) {
            System.debug(e);
        }
    }

    @HttpPut
    global static ID upsertAccount(
            String name,
            String phone,
            String fax,
            String billingCountry,
            String billingState,
            String billingPostalCode,
            String billingCity,
            String billingStreet,
            String id)
    {
        Account account = new Account(
                Id = id,
                Name = name,
                Phone = phone,
                Fax = fax,
                BillingCountry = billingCountry,
                BillingState = billingState,
                BillingPostalCode = billingPostalCode,
                BillingCity = billingCity,
                BillingStreet = billingStreet);
        try {
            upsert account;
        } catch (DmlException e) {
            System.debug(e);
            account.Id = null;
        }
        return account.Id;
    }

    @HttpPatch
    global static ID updateAccount() {
        RestRequest request = RestContext.request;
        String accountId = request.requestURI.substring (
                request.requestURI.lastIndexOf('/') + 1);
        Account account = [SELECT Id FROM Account WHERE Id = :accountId];
        Map<String, Object> parameters = (Map<String, Object>)
                JSON.deserializeUntyped(request.requestbody.tostring());
        for (String fieldName : parameters.keySet()) {
            account.put(fieldName, parameters.get(fieldName));
        }
        try {
            update account;
        } catch (DmlException e) {
            System.debug(e);
            account.Id = null;
        }
        return account.Id;
    }

}

