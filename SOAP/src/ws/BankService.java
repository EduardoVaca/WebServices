package ws;

import models.CreditCard;

import javax.jws.WebService;

/**
 * Created by eduardovaca on 11/10/16.
 */
@WebService(endpointInterface = "ws.BankServiceInterface")
public class BankService implements BankServiceInterface{

    @Override
    public int chargeCard(String number, String firstName, String lastName, String expirationDate, int securityNumber, int amount) {
        CreditCard cc = new CreditCard(number, firstName, lastName, expirationDate, securityNumber);
        if (cc.isCardValid()) {
            if(cc.hasEnoughFunds(amount)) {
                return 200;
            } else {
                return 402;
            }
        }else {
            return 401;
        }
    }
}
