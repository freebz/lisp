small = 1
big = 100

def guess_my_number():
    return (small + big) >> 1

def smaller():
    global big
    big = guess_my_number() - 1
    return guess_my_number()

def bigger():
    global small
    small = guess_my_number() + 1
    return guess_my_number()

def start_over():
    global small
    global big
    small = 1
    big = 100
    return guess_my_number()

