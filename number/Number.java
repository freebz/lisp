import java.io.*;

public class Number {

    private static int small = 1;
    private static int big = 100;

    // guess-my-number 함수 정의하기
    private static int guess_my_number() {
	return small + big >> 1;
    }

    // smaller와 bigger 함수 정의하기
    private static int smaller() {
	big = guess_my_number() - 1;
	return guess_my_number();
    }

    private static int bigger() {
	small = guess_my_number() + 1;
	return guess_my_number();
    }

    // start-over 함수 정의하기
    private static int start_over() {
	small = 1;
	big = 100;
	return guess_my_number();
    }

    public static void main (String args[]) throws IOException {

	BufferedReader in =
	    new BufferedReader(new InputStreamReader(System.in));
	
	while(true) {
	    String inputString = in.readLine();     
	    if("quit".equals(inputString)) {
		break;
	    }
	    else if("guess-my-number".equals(inputString)) {
		System.out.println(guess_my_number());
	    }
	    else if("bigger".equals(inputString)) {
		System.out.println(bigger());
	    }
	    else if("smaller".equals(inputString)) {
		System.out.println(smaller());
	    }
	    else if("start-over".equals(inputString)) {
		System.out.println(start_over());
	    }
	}
    }
}
