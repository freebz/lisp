class Foo {

    def small = 1
    def big = 100

    // guess-my-number 함수 정의하기
    def guess_my_number() {
	return small + big >> 1;
    }

    // smaller와 bigger 함수 정의하기
    def smaller() {
	big = guess_my_number() - 1;
	return guess_my_number();
    }

    def bigger() {
	small = guess_my_number() + 1;
	return guess_my_number();
    }

    // start-over 함수 정의하기
    def start_over() {
	small = 1;
	big = 100;
	return guess_my_number();
    }
}
