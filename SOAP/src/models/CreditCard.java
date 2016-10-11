package models;

import java.util.Random;

/**
 * Created by eduardovaca on 11/10/16.
 */
public class CreditCard {
    private final String creditCardNumber;
    private final String firstName;
    private final String lastName;
    private final String expirationDate;
    private final int securityNumber;

    public CreditCard(String creditCardNumber, String firstName, String lastName, String expirationDate, int securityNumber) {
        this.creditCardNumber = creditCardNumber;
        this.firstName = firstName;
        this.lastName = lastName;
        this.expirationDate = expirationDate;
        this.securityNumber = securityNumber;
    }

    public boolean isCardValid() {
        return this.creditCardNumber.length() == 16;
    }

    public boolean hasEnoughFunds(int amount) {
        Random rand = new Random();
        float funds = rand.nextInt(1000);
        return amount <= funds;
    }

}


