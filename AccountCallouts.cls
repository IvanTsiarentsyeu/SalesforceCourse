/**
 * Created by Ivan Tsiarentsyeu on 15.08.2021.
 */

public with sharing class AccountCallouts {

    final static string ACCESS_TOKEN = '00D5g000007prPT!ARIAQAASfZ2HmwbiNFdWt2ifEmDx9oxxeWjXu_TRCfV_gsh3IIvVQ76pJBHYBmAu.tUvauf8lE9Se6pZhwz9gYofvovrVpxZ';

//System.debug(AccountCallouts.getAccount('0015g00000LPvmcAAD'));
//System.debug(AccountCallouts.getAccount('all'));
    public static List<Account> getAccount(String accountId) {
        HTTP http = new HTTP();
        HttpRequest request = new HttpRequest();
        setRequestHeader(request);
        request.setMethod('GET');
        request.setEndpoint('https://playful-narwhal-ax9yxb-dev-ed.my.salesforce.com/services/apexrest/Accounts/' + accountId);
        HttpResponse response = http.send(request);
        List<Account> accounts = new List<Account>();
        if (response.getStatusCode() == 200) {
            accounts = (List<Account>) JSON.deserialize(response.getBody(), List<Account>.class);
        }
        return accounts;
    }

// system.debug(AccountCallouts.postAccount(AccountCallouts.randomAccount()));
    public static Id postAccount(Account account) {
        HTTP http = new HTTP();
        HttpRequest request = new HttpRequest();
        setRequestHeader(request);
        request.setMethod('POST');
        request.setEndpoint('https://playful-narwhal-ax9yxb-dev-ed.my.salesforce.com/services/apexrest/Accounts/');
        request.setBody(JSON.serialize(account));
        HttpResponse response = http.send(request);
        Id accountId;
        if (response.getStatusCode() == 200) {
            accountId = (Id) JSON.deserialize(response.getBody(), Id.class);
        }
        return accountId;
    }

//  System.debug(AccountCallouts.deleteAccount('0015g00000N6oWNAAZ'));
    public static HttpResponse deleteAccount(String accountId) {
        HTTP http = new HTTP();
        HttpRequest request = new HttpRequest();
        setRequestHeader(request);
        request.setMethod('DELETE');
        request.setEndpoint('https://playful-narwhal-ax9yxb-dev-ed.my.salesforce.com/services/apexrest/Accounts/' + accountId);
        HttpResponse response = http.send(request);
        return response;
    }

// System.debug(AccountCallouts.upsertAccount('Aquarium','212-85-06','212-85-07','RU','','191014','Saint Petersburg', '46, Foundry pass.'));
    public static ID upsertAccount(
            String name,
            String phone,
            String fax,
            String billingCountry,
            String billingState,
            String billingPostalCode,
            String billingCity,
            String billingStreet) {
        return upsertAccount(name, phone, fax, billingCountry, billingState, billingPostalCode,
                billingCity, billingStreet, null);
    }

    public static Id upsertAccount(
            String name,
            String phone,
            String fax,
            String billingCountry,
            String billingState,
            String billingPostalCode,
            String billingCity,
            String billingStreet,
            String id) {
        HTTP http = new HTTP();
        HttpRequest request = new HttpRequest();
        setRequestHeader(request);
        request.setMethod('PUT');
        request.setEndpoint('https://playful-narwhal-ax9yxb-dev-ed.my.salesforce.com/services/apexrest/Accounts/');
        String requestBody =  '{"name" : "' + name + '", "phone" : "' + phone + '", "fax": "' + fax +
                '", "billingCountry" : "' + billingCountry + '", "billingState" : "' + billingState +
                '", "billingPostalCode" : "' + billingPostalCode + '", "billingCity" : "' + billingCity +
                '", "billingStreet" : "' + billingStreet;
        if (id<>null) requestBody = requestBody + '", "id" : "' + id;
        requestBody = requestBody + '"}';
        request.setBody(requestBody);
        HttpResponse response = http.send(request);
        System.debug(response);
        Id accountId;
        if (response.getStatusCode() == 200) {
            accountId = (Id) JSON.deserialize(response.getBody(), Id.class);
        }
        return accountId;
    }

//System.debug(AccountCallouts.updateAccountBillingAddress('RU','','191014','Saint Petersburg', '46, Foundry passage','0015g00000N6pqrAAB'));
    public static Id updateAccountBillingAddress (
            String billingCountry,
            String billingState,
            String billingPostalCode,
            String billingCity,
            String billingStreet,
            String id) {
        HTTP http = new HTTP();
        HttpRequest request = new HttpRequest();
        setRequestHeader(request);
        request.setMethod('PATCH');
        request.setEndpoint('https://playful-narwhal-ax9yxb-dev-ed.my.salesforce.com/services/apexrest/Accounts/' + id);
        String requestBody =  '{"billingCountry" : "' + billingCountry +
                '", "billingState" : "' + billingState + '", "billingPostalCode" : "' + billingPostalCode +
                '", "billingCity" : "' + billingCity + '", "billingStreet" : "' + billingStreet + '"}';
        request.setBody(requestBody);
        HttpResponse response = http.send(request);
        System.debug(response);
        Id accountId;
        if (response.getStatusCode() == 200) {
            accountId = (Id) JSON.deserialize(response.getBody(), Id.class);
        }
        return accountId;
    }

// helper method
    private static void setRequestHeader(HttpRequest request) {
        request.setHeader('Authorization', 'Bearer ' + ACCESS_TOKEN);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json');
    }

// helper method for demonstration purposes only
    public static Account randomAccount() {
        Account account = [
                SELECT Id, Name, Industry, Phone, Fax, Website, TickerSymbol, Ownership, Sic,
                        BillingCountry, BillingState, BillingPostalCode, BillingCity, BillingStreet
                From Account
                LIMIT 1
        ];
        account.Name = account.Name + ' - REST TEST - ';
        return account;
    }

}
