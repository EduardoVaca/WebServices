package ws;

import javax.xml.ws.Endpoint;

/**
 * Created by eduardovaca on 11/10/16.
 */
public class BankServicePublisher {
    public static void main(String[] args) {
        Endpoint.publish("http://localhost:9000/BankService", new BankService());
    }
}
