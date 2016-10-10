from random import randint

class CreditCard(object):	
	credit_card_number = None
	first_name = None
	last_name = None
	expiration_date = None
	security_number = None

	def __init__(self, credit_card_number, first_name, last_name, expiration_date, security_number):
		self.credit_card_number = credit_card_number
		self.first_name = first_name
		self.last_name = last_name
		self.expiration_date = expiration_date
		self.security_number = security_number

	def is_number_valid(self):
		if len(self.credit_card_number) == 16:
			return True
		return False

	def has_enough_funds(self, amount):
		rand_choice = randint(0,1)
		if rand_choice == 1:
			return True
		return False
		