import ballerinax/exchangerates;
import ramith/countryprofile;
import ballerina/http;

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    resource function get convert(decimal amount = 1.00, string target = "AUD", string base = "USD") returns PricingInfo|error {

        countryprofile:Client countryprofileEp = check new (config = {
            auth: {
                clientId: clientId,
                clientSecret: clientSecret
            }
        });
        exchangerates:Client exchangeratesEp = check new ();
        exchangerates:CurrencyExchangeInfomation getExchangeRateForResponse = check exchangeratesEp->getExchangeRateFor(apikey = apiKey, baseCurrency = base);
        countryprofile:Currency getCurrencyCodeResponse = check countryprofileEp->getCurrencyCode(code = target);
    
    
        decimal exchangeRate = <decimal>getExchangeRateForResponse.conversion_rates[target];
        decimal convertedAmount = amount * exchangeRate;
        
        PricingInfo pricingInfo = {
            amount: convertedAmount,
            currency: getCurrencyCodeResponse.displayName
        };

        return pricingInfo;
    }

}

type PricingInfo record{
    decimal amount;
    string currency;
};

configurable string apiKey = ?;
configurable string clientId = ?;
configurable string clientSecret = ?;