package ws;

import javax.jws.WebMethod;
import javax.jws.WebService;

/**
 * Created by eduardovaca on 11/10/16.
 */
@WebService
public interface BankServiceInterface {

    @WebMethod int chargeCard(String number, String firstName,
                              String lastName, String expirationDate,
                              int securityNumber, int amount);
}
