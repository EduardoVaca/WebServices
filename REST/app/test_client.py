import requests

data = {'last_name': 'Vaca', 
		'first_name': 'Eduardo',
		'credit_card_number': '1234567891234567',
		'expiration_date': '1509',
		'security_number': '540',
		'amount': 10}

r = requests.post('http://localhost:8080/process_payment', data=data)
print(r.text)