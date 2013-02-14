import java.io.*;
import java.lang.reflect.*;
import java.util.*;

public class Graph {

    // 그래프 표현하기
    private static HashMap<String, String> wizard_nodes = new HashMap<String, String>() {
	{	    
	    put("living-room", "You are in the living-room. A wizard is snoring loudly on the couch.");	    
	    put("garden", "You are in a beautiful garden. There is a well in front of you.");	    
	    put("attic", "You are in the attic. There is a giant welding torch in the corner.");	
	}
    };
    
    private static HashMap<String, String[][]> wizard_edges = new HashMap<String, String[][]>() {
	{
	    put("living-room", new String[][]{{"garden", "west", "door"},		
					      {"attic", "upstairs", "ladder"}});	   
	    put("garden", new String[][]{{"living-room", "east", "door"}});	  
	    put("attic", new String[][]{{"living-room", "downstairs", "ladder"}});
	}    
    };

    // 그래프 생성하기
    // DOT 정보 생성하기
    // 노드 식별자 변환하기
    private static String dot_name(String exp) {
	return exp.replaceAll("\\W", "_");
    }

    // 그래프 노드에 이름표 추가하기
    private static int MAX_LABEL_LENGTH = 30;

    private static String dot_label(String exp) {
	if(exp.length() > MAX_LABEL_LENGTH) {
	    return exp.substring(0, MAX_LABEL_LENGTH - 3) + "...";
	}
	else {
	    return exp;
	}
    }

    // 노드의 DOT 정보 생성하기
    private static void nodes_to_dot(Map<String, String> nodes) {
	for (Map.Entry<String, String> node : nodes.entrySet()) {
	    System.out.print(dot_name(node.getKey()));
	    System.out.print("[label=\"");
	    System.out.print(dot_label(node.getValue()));
	    System.out.println("\"];");
	}
    }

    // 에지를 DOT포맷으로 변환하기
    private static void edges_to_dot(Map<String, String[][]> edges) {
	for (Map.Entry<String, String[][]> node : edges.entrySet()) {
	    for (String[] edge : node.getValue()) {
		System.out.print(dot_name(node.getKey()));
		System.out.print("->");
		System.out.print(dot_name(edge[0]));
		System.out.print("[label=\"");
		System.out.print(dot_label(join(slice(edge, 1), " ")));
		System.out.println("\"];");
	    }
	}
    }

    // 모든 DOT 데이터 생성하기
    private static void graph_to_dot(Map<String, String> nodes, Map<String, String[][]> edges) {
	System.out.println("digraph{");
	nodes_to_dot(nodes);
	edges_to_dot(edges);
	System.out.println("}");
    }

    // DOT 파일을 그림으로 바꾸기
    private static void dot_to_png(String fname, Method thunk, Object[] parameters) throws Exception {
	FileOutputStream fos = new FileOutputStream(fname);
	PrintStream stdout = System.out;
	System.setOut(new PrintStream(fos));
	thunk.invoke(null, parameters);
	System.setOut(stdout);
	fos.close();
	Runtime.getRuntime().exec("dot -Tpng -O " + fname);
    }

    // 명령창 결과 전송하기

    // 그래프를 그림으로 만들기
    private static void graph_to_png(String fname, Map<String, String> nodes, Map<String, String[][]> edges) 
	throws Exception {
	
	Class[] paramTypes = {Map.class, Map.class};
	Object[] parameters = {nodes, edges};
	Method method = Graph.class.getDeclaredMethod("graph_to_dot", paramTypes);
	dot_to_png(fname, method, parameters);
    }

    // 무향 그래프 생성하기
    private static void uedges_to_dot(Map<String, String[][]> edges) {
	//Object[] lst = edges.keySet().toArray();
	ArrayList<String> lst = new ArrayList<String>();
	lst.addAll(edges.keySet());
	while(!lst.isEmpty()) {
	    String key = lst.remove(0);
	    for (String[] edge : edges.get(key)) {
		if (!lst.contains(edge[0])) {
		    System.out.print(dot_name(key));
		    System.out.print("--");
		    System.out.print(dot_name(edge[0]));
		    System.out.print("[label=\"");
		    System.out.print(dot_label(join(slice(edge, 1), " ")));
		    System.out.println("\"]");
		}
	    }
	}
    }

    private static void ugraph_to_dot(Map<String, String> nodes, Map<String, String[][]> edges) {
	System.out.println("graph{");
	nodes_to_dot(nodes);
	uedges_to_dot(edges);
	System.out.println("}");
    }

    private static void ugraph_to_png(String fname, Map<String, String> nodes, Map<String, String[][]> edges)
	throws Exception {

	Class[] paramTypes = {Map.class, Map.class};
	Object[] parameters = {nodes, edges};
	Method method = Graph.class.getDeclaredMethod("ugraph_to_dot", paramTypes);
	dot_to_png(fname, method, parameters);
    }

    private static String[] slice(String[] source, int index) {
	int len = source.length - index;
	if (len <= 0) {
	    return new String[0];
	}

	String[] dest = new String[len];
	System.arraycopy(source, index, dest, 0, len);
	return dest;
    }

    private static String join(String[] array, String glue) {
	StringBuffer sb = new StringBuffer();
	for (String str : array) {
	    sb.append(glue);
	    sb.append(str);
	}

	if (sb.length() > 0) {
	    sb.delete(0, glue.length());
	}
	return sb.toString();
    }

    public static void main(String[] args) throws Exception {
	/*
	System.out.println(dot_name("living-room"));
	System.out.println(dot_name("foo!"));
	System.out.println(dot_name("24"));
	
	System.out.println(dot_label("1232131233213"));  
	System.out.println(dot_label("123213123321334234fffwerwerwer324234fewr"));
	
	nodes_to_dot(wizard_nodes);
	
	edges_to_dot(wizard_edges);
	
	graph_to_dot(wizard_nodes, wizard_edges);
	*/
	//dot_to_png("wizard.dot");
	//graph_to_png("wizard.dot", wizard_nodes, wizard_edges);
	//	uedges_to_dot(wizard_edges);
	//	ugraph_to_dot(wizard_nodes, wizard_edges);
	ugraph_to_png("uwizard.dot", wizard_nodes, wizard_edges);
    }
}
