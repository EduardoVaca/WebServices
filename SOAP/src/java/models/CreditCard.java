package models;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


import java.util.Random;

/**
 *
 * @author eduardovaca
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
