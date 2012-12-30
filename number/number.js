var small = 1;
var big = 100;

function guess_my_number() {
    return (small + big) >> 1;
}

function smaller() {
    big = guess_my_number() - 1;
    return guess_my_number();
}

function bigger() {
    small = guess_my_number() + 1;
    return guess_my_number();
}

function start_over() {
    small = 1;
    big = 100;
    return guess_my_number();
}
