import java.io.*;
import java.lang.reflect.*;
import java.util.*;

public class Wizard {

    //���� ǳ�� �����ϱ�
    private static HashMap<String, String> nodes = new HashMap<String, String>() {
	{
	    put("living-room", "You are in the living-room. A wizard is snoring loudly on the couch.");
	    put("garden", "You are in a beautiful garden. There is a well in front of you.");
	    put("attic", "You are in the attic. There is a giant welding torch in the corner.");
	}		      		
    };

    // ��� �����ϱ�
    private static String describe_location(String location, HashMap<String, String>nodes) {
	return nodes.get(location);
    }

    // ��� �����ϱ�
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

    // �� ���� ���� ��� �����ϱ�
    private static String describe_paths (String location, HashMap<String, String[][]> edges) {
	StringBuffer sb = new StringBuffer();
	for(String[] edge : edges.get(location)) {
	    sb.append(describe_path(edge));
	    sb.append(" ");
	}
	return sb.toString();
    }

    // Ư�� ����� ���� �����ϱ�
    // ���� ���̴� ���� �����ϱ�
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
    
    // ���� ���̴� ���� �����ϱ�
    private static String describe_objects (String loc, ArrayList<String> objs, HashMap<String, String> obj_locs) {
	StringBuffer sb = new StringBuffer();
	for(String obj : objects_at(loc, objs, obj_locs)) {
	    sb.append(String.format("You see a %s on the floor.", obj));
	    sb.append(" ");
	}
	return sb.toString();
    }

    // ���� ����ϱ�
    private static String location = "living-room";

    private static String look() {
	StringBuffer sb = new StringBuffer();
	sb.append(describe_location(location, nodes));
	sb.append(describe_paths(location, edges));
	sb.append(describe_objects(location, objects, object_locations));
      	return sb.toString();
    }

    // ���� ���� �ѷ�����
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

    // ���� ����
    private static String pickup(String object) {
	for(String obj : objects_at(location, objects, object_locations)) {
	    if (object.equals(obj)) {
		object_locations.put(object, "body");
		return String.format("You are now carrying the %s", object);
	    }
	}
	return "You cannot get that.";
    }

    // ������ Ȯ���ϱ�
    private static String inventory() {
	return "items- " + objects_at("body", objects, object_locations);
    }
	    
    // ���� ������ ���� ���� �������̽� �߰��ϱ�
    // ���� ����� REPL
    // ���� ����� �߰�
    private static void game_repl() throws Exception {

	Method[] methods = Wizard.class.getDeclaredMethods();
	while(true) {
	    String[] cmd = game_read();
	    if ("quit".equals(cmd[0])) break;
	    System.out.println(game_eval(cmd));
	}
    }
	    
    // read �Լ� ���� �ۼ��ϱ�
    private static String[] game_read() throws Exception {
	BufferedReader in = 
	    new BufferedReader(new InputStreamReader(System.in));
	return in.readLine().split(" ", 2);
    }

    // game-eval �Լ� �ۼ��ϱ�
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