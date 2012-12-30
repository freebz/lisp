$small = 1
$big = 100

def guess_my_number
  ($small + $big) << -1
end

def smaller
  $big = guess_my_number - 1
  guess_my_number
end

def bigger
  $small = guess_my_number + 1
  guess_my_number
end

def start_over
  $small = 1
  $big = 100
  guess_my_number
end
