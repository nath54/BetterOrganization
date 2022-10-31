class_name Calendar

enum Month { JAN = 1, FEB = 2, MAR = 3, APR = 4, MAY = 5, JUN = 6, JUL = 7,
		AUG = 8, SEP = 9, OCT = 10, NOV = 11, DEC = 12 }

"""const MONTH_NAME = [ 
		"Jan", "Feb", "Mar", "Apr", 
		"May", "Jun", "Jul", "Aug", 
		"Sep", "Oct", "Nov", "Dec" ]"""


const MONTH_NAME = [ 
		"Jan", "Feb", "Mars", "Avr", 
		"Mai", "Juin", "Jul", "Aout", 
		"Sep", "Oct", "Nov", "Dec" ];

"""const WEEKDAY_NAME = [ 
		"Sunday", "Monday", "Tuesday", "Wednesday", 
		"Thursday", "Friday", "Saturday" ]"""

const WEEKDAY_NAME = [ 
		"Dimanche", "Lundi", "Mardi", "Mercredi", 
		"Jeudi", "Vendredi", "Samedi" ];

func get_days_in_month(month : int, year : int) -> int:
	var number_of_days : int
	if(month == Month.APR || month == Month.JUN || month == Month.SEP
			|| month == Month.NOV):
		number_of_days = 30
	elif(month == Month.FEB):
		var is_leap_year = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
		if(is_leap_year):
			number_of_days = 29
		else:
			number_of_days = 28
	else:
		number_of_days = 31
	
	return number_of_days

func avance_days(i_day: int, i_month: int, i_year: int, nb_days: int):
	var nb_days_month = get_days_in_month(i_month, i_year);
	i_day += nb_days;
	# print("NB_DAY : ", nb_days_month, "  - ", i_day);
	#
	while i_day > nb_days_month:
		i_day -= nb_days_month;
		i_month += 1
		if i_month > 12:
			i_month = 1;
			i_year += 1;
		#
		nb_days_month = get_days_in_month(i_month, i_year);
	#
	while i_day < 0:
		i_month -= 1
		i_day += nb_days_month;
		if i_month < 1:
			i_month = 12;
			i_year -= 1;
		#
		nb_days_month = get_days_in_month(i_month, i_year);
	#
	return {"day": i_day, "month": i_month, "year": i_year, "weekday": get_weekday(i_day, i_month, i_year)};

# On suppose que Global sera déjà chargé
func distance_days(d1: Array, d2: Array) -> int: # d1 et d2 de la forme [année, moi, jour]
	var dist: int = 0;
	var sens: int = 1;
	if Global.custom_arrdate_sort([d1], [d2]): sens = -1; # On recule
	# On est pas dans la même année
	while d1[0] != d2[0]:
		if d1[2] != 1: # On se remet au premier jour du moi
			dist -= (d1[2] - 1);
			d1[2] = 1;
		if sens == -1:  # On recule
			while d1[1] > 1:
				dist -= get_days_in_month(d1[1], d1[0]);
				d1[1] = d1[1] - 1;
			d1[0] -= 1;
			d1[1] = 12;
			d1[2] = get_days_in_month(d1[1], d1[0]);
		else: # On avance
			while d1[1] <= 12:
				dist += get_days_in_month(d1[1], d1[0]);
				d1[1] = d1[1] + 1;
			d1[0] += 1;
			d1[1] = 1;
			d1[2] = 1;
	# On est dans la même année, tant que l'on est pas dans le même moi
	while d1[1] != d2[1]:
		if d1[2] != 1: # On se remet au premier jour du moi
			dist -= (d1[2] - 1);
			d1[2] = 1;
		if sens == -1: # On recule
			dist -= get_days_in_month(d1[1], d1[0]);
			d1[1] = d1[1] - 1;
		else: # On avance
			dist += get_days_in_month(d1[1], d1[0]);
			d1[1] = d1[1] + 1;
	# On est dans la même année et dans le même moi
	dist += d2[2] - d1[2]
	return dist;

func get_weekday(day : int, month : int, year : int) -> int:
	var t : Array = [0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4]
	if(month < 3):
		year -= 1
	return (year + year/4 - year/100 + year/400 + t[month - 1] + day) % 7

func get_weekday_name(day : int, month : int, year : int) -> String:
	var day_num = get_weekday(day, month, year)
	return WEEKDAY_NAME[day_num]

func get_month_name(month : int) -> String:
	return MONTH_NAME[month - 1]

func hour() -> int:
	return OS.get_datetime()["hour"]

func minute() -> int:
	return OS.get_datetime()["minute"]

func second() -> int:
	return OS.get_datetime()["second"]

func day() -> int:
	return OS.get_datetime()["day"]

func weekday() -> int:
	return OS.get_datetime()["weekday"]

func month() -> int:
	return OS.get_datetime()["month"]

func year() -> int:
	return OS.get_datetime()["year"]

func daylight_savings_time() -> int:
	return dst()

func dst() -> int:
	return OS.get_datetime()["dst"]
