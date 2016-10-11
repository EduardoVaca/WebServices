package client;

import ws.BankService;
import ws.BankServiceInterface;

import javax.xml.namespace.QName;
import javax.xml.ws.Service;
import java.net.URL;

/**
 * Created by eduardovaca on 11/10/16.
 */
public class BankClient {

    public static void evaluateRespinse(int response) {
        if (response == 200) {
            System.out.println("Transaction successful!");
        } else if (response == 401) {
            System.out.println("Invalid Card number");
        } else if (response == 402) {
            System.out.println("Not enough funds in card");
        }
    }

    public static void main(String[] args) throws Exception {

        URL url = new URL("http://localhost:9000/BankService?wsdl");
        QName qname = new QName("http://ws/", "BankServiceService");

        Service service = Service.create(url, qname);
        BankServiceInterface bank = service.getPort(BankServiceInterface.class);

        evaluateRespinse(bank.chargeCard("12", "Eduardo", "Vaca", "Nov", 123, 10));
        evaluateRespinse(bank.chargeCard("1234567890123456", "Eduardo", "Vaca", "Nov", 123, 1000000));
        evaluateRespinse(bank.chargeCard("1234567890123456", "Eduardo", "Vaca", "Now", 123, 10));
    }
}
