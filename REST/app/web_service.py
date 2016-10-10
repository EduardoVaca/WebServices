#import http
from bottle import Bottle, request, response, get, post, run

from models import CreditCard

app = Bottle()

@app.route('/process_payment', method='POST')
def process_payment():
	data = request.forms
	credit_card = CreditCard(data.get('credit_card_number'),
							data.get('first_name'),
							data.get('last_name'),
							data.get('expiration_date'),
							data.get('security_number'))

	if credit_card.is_number_valid():
		amount = data.get('amount')
		if credit_card.has_enough_funds(amount):
			response.status = 200
			return ('Congratulations, you have paid: {amount} euros!'.format(amount=amount))
		else:
			response.status = 200
			return ('Sorry, not enough funds to pay: {amount} euros'.format(amount=amount))
	else:		
		return('Invalid card number')	

run(app, host='localhost', port=8080)