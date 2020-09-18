<%@ page contentType="text/html; charset=utf-8" language="java"
     import="org.ecocean.*,
java.util.Map,
java.util.ArrayList,
java.util.Collections,
java.io.BufferedReader,
java.io.IOException,
java.io.InputStream,
java.io.InputStreamReader,
java.io.File,
org.json.JSONArray,
org.json.JSONObject,
org.ecocean.identity.*,
org.ecocean.Project,
org.ecocean.media.*
              "
%>




<%




String id = request.getParameter("id");
String taskId = request.getParameter("taskId");
String projectId = request.getParameter("projectId");
if ((id == null) && (taskId == null)) {
	out.println("{\"success\": false, \"error\": \"no object/task id passed\"}");
	return;
}

Shepherd myShepherd=null;
myShepherd = new Shepherd("context0");
myShepherd.setAction("iaLogs.jsp");

myShepherd.beginDBTransaction();

ArrayList<IdentityServiceLog> logs = null;
if (id != null) {
	logs = IdentityServiceLog.loadMostRecentByObjectID("IBEISIA", id, myShepherd);
} else {
	logs = IdentityServiceLog.loadByTaskID(taskId, "IBEISIA", myShepherd);
	Collections.reverse(logs);  //so it has newest first like mostRecent above
}

if (logs == null) {
	out.println("[]");
	myShepherd.rollbackDBTransaction();
	myShepherd.closeDBTransaction();
	return;
}

JSONArray all = new JSONArray();
for (IdentityServiceLog l : logs) {
	all.put(l.toJSONObject());
}

if (projectId!=null) {
	Project project = myShepherd.getProjectByResearchProjectId(projectId);
	if (project!=null) {
		JSONObject projectData = new JSONObject();
		projectData.put("projectData", project.asJSONObjectWithEncounterMetadata(myShepherd));
		System.out.println("iaLogs sending this projectData to iaResults: "+project.asJSONObjectWithEncounterMetadata(myShepherd));
		projectData.put("projectAcmIds", project.getAllACMIdsJSON());
		System.out.println("iaLogs sending this pprojectAcmIds to iaResults: "+project.getAllACMIdsJSON());
	}
}


out.println(all.toString());

myShepherd.rollbackDBTransaction();
myShepherd.closeDBTransaction();

%>



