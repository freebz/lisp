import java.io.*;
import java.lang.reflect.*;
import java.util.*;

public class Wizard {

    //관련 풍경 묘사하기
    private static HashMap<String, String> nodes = new HashMap<String, String>() {
	{
	    put("living-room", "You are in the living-room. A wizard is snoring loudly on the couch.");
	    put("garden", "You are in a beautiful garden. There is a well in front of you.");
	    put("attic", "You are in the attic. There is a giant welding torch in the corner.");
	}		      		
    };

    // 장소 묘사하기
    private static String describe_location(String location, HashMap<String, String>nodes) {
	return nodes.get(location);
    }

    // 경로 묘사하기
    private static HashMap<String, String[][]> edges = new HashMap<String, String[][]>() {
	{
	    put("living-room", new String[][]{{"garden", "west", "door"},
					  {"attic", "upstairs", "ladder"}});
	    put("garden", new String[][]{{"living-room", "east", "door"}});
	    put("attic", new String[][]{{"living-room", "downstairs", "ladder"}});
	}
    };
    
    private static String describe_path (String[] edge) {
	return String.format("There is a %s goding %s from here.", edge[2], edge[1]);
    }

    // 한 번에 여러 경로 정의하기
    private static String describe_paths (String location, HashMap<String, String[][]> edges) {
	StringBuffer sb = new StringBuffer();
	for(String[] edge : edges.get(location)) {
	    sb.append(describe_path(edge));
	    sb.append(" ");
	}
	return sb.toString();
    }

    // 특정 장소의 물건 설명하기
    // 눈에 보이는 물건 나열하기
    //    private static String[] objects = new String[]{"whiskey", "bucket", "frog", "chain"};
    private static ArrayList<String> objects = new ArrayList<String>() {
	{
	    add("whiskey");
	    add("bucket");
	    add("frog");
	    add("chain");
	}
    };

    private static HashMap<String, String> object_locations = new HashMap<String, String>() {
	{
	    put("whiskey", "living-room");
	    put("bucket", "living-room");
	    put("chain", "garden");
	    put("frog", "garden");
	}
    };

    private static ArrayList<String> objects_at (String loc, ArrayList<String> objs, HashMap<String, String> obj_locs) {
	ArrayList<String> retList = new ArrayList<String>();
	for(String obj : objs) {
	    if(loc.equals(obj_locs.get(obj))) {
		retList.add(obj);
	    }
	}
	return retList;
    }
    
    // 눈에 보이는 물건 묘사하기
    private static String describe_objects (String loc, ArrayList<String> objs, HashMap<String, String> obj_locs) {
	StringBuffer sb = new StringBuffer();
	for(String obj : objects_at(loc, objs, obj_locs)) {
	    sb.append(String.format("You see a %s on the floor.", obj));
	    sb.append(" ");
	}
	return sb.toString();
    }

    // 전부 출력하기
    private static String location = "living-room";

    private static String look() {
	StringBuffer sb = new StringBuffer();
	sb.append(describe_location(location, nodes));
	sb.append(describe_paths(location, edges));
	sb.append(describe_objects(location, objects, object_locations));
      	return sb.toString();
    }

    // 게임 세계 둘러보기
    private static String walk(String direction) {
	String result = null;
	for(String[] edge : edges.get(location)) {
	    if (direction.equals(edge[1])) {
		result = edge[0];
		break;
	    }	  
	}
	if (result != null) {
	    location = result;
	    return look();
	}
	else {
	    return "You cannot go that way.";
	}
    }

    // 물건 집기
    private static String pickup(String object) {
	for(String obj : objects_at(location, objects, object_locations)) {
	    if (object.equals(obj)) {
		object_locations.put(object, "body");
		return String.format("You are now carrying the %s", object);
	    }
	}
	return "You cannot get that.";
    }

    // 보관함 확인하기
    private static String inventory() {
	return "items- " + objects_at("body", objects, object_locations);
    }
	    
    // 게임 엔진에 직접 만든 인터페이스 추가하기
    // 직접 만드는 REPL
    // 종료 기능을 추가
    private static void game_repl() throws Exception {

	Method[] methods = Wizard.class.getDeclaredMethods();
	while(true) {
	    String[] cmd = game_read();
	    if ("quit".equals(cmd[0])) break;
	    System.out.println(game_eval(cmd));
	}
    }
	    
    // read 함수 직접 작성하기
    private static String[] game_read() throws Exception {
	BufferedReader in = 
	    new BufferedReader(new InputStreamReader(System.in));
	return in.readLine().split(" ", 2);
    }

    // game-eval 함수 작성하기
    private static ArrayList<String> allowed_commands = new ArrayList<String>() {
	{
	    add("look");
	    add("walk");
	    add("pickup");
	    add("inventory");
	}
    };

    private static String game_eval(String[] sexp) throws Exception {
	int index = allowed_commands.indexOf(sexp[0]);
	if (index >= 0) {
	    if (sexp.length > 1) {
		Method method = Wizard.class.getDeclaredMethod(sexp[0], String.class );
		return (String) method.invoke(null, sexp[1]);
	    }
	    else {
		Method method = Wizard.class.getDeclaredMethod(sexp[0]);
		return (String) method.invoke(null);
	    }	
	}
	else {
	    return "I do not know that command.";
	}
    }
	
    
    public static void main (String args[]) throws Exception {
	game_repl();
    }
}