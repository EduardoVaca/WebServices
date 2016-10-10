/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ws;

import javax.jws.WebService;
import javax.jws.WebMethod;
import javax.jws.WebParam;
import models.CreditCard;

/**
 *
 * @author eduardovaca
 */
@WebService(serviceName = "Payment")
public class Payment {
    
    @WebMethod(operationName = "chargeCard")
    public int makeCharge(@WebParam(name = "creditCardNumber") String number,                           
                            @WebParam(name = "firstName") String firstName,
                            @WebParam(name = "lastName") String lastName,
                            @WebParam(name = "expirationDate") String expirationDate,
                            @WebParam(name = "securityNumber") int securityNumber,
                            @WebParam(name = "amount") int amount) {
        
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
