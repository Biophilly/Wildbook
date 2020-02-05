<%@ page contentType="text/html; charset=utf-8" language="java"
         import="org.ecocean.servlet.ServletUtilities,org.ecocean.*,
org.ecocean.media.*,
org.json.JSONObject,
java.net.URL,
java.util.ArrayList,
java.util.Properties,org.slf4j.Logger,org.slf4j.LoggerFactory" %>
<%

if (AccessControl.isAnonymous(request)) {
    response.sendError(401, "Denied");
    return;
}
String context = ServletUtilities.getContext(request);
Shepherd myShepherd = new Shepherd(context);
myShepherd.setAction("individualGallery.jsp");
myShepherd.beginDBTransaction();

User user = myShepherd.getUser(request);

boolean admin = (user.hasRoleByName("admin", myShepherd) || user.hasRoleByName("super_volunteer", myShepherd));
String id = request.getParameter("id");
String skipEncId = request.getParameter("subject");
  //handle some cache-related security
  response.setHeader("Cache-Control", "no-cache"); //Forces caches to obtain a new copy of the page from the origin server
  response.setHeader("Cache-Control", "no-store"); //Directs caches not to store the page under any circumstance
  response.setDateHeader("Expires", 0); //Causes the proxy cache to see the page as "stale"
  response.setHeader("Pragma", "no-cache"); //HTTP 1.0 backward compatibility

MarkedIndividual indiv = myShepherd.getMarkedIndividualQuiet(id);
if (indiv == null) {
    out.println("<h1>unknown id</h1>");
    return;
}



%>
<script type="text/javascript">

var imgData = {};

function imgLoaded(el) {
    var id = el.id.substring(4);
console.log('asset id=%o', id);
    var imgEl = $(el);
    if (!imgEl.length) return;
    if (!imgData[id] || !imgData[id].bbox) {
        imgEl.css({
            width: '100%',
            top: 0,
            left: 0
        });
        imgEl.show();
        imgEl.panzoom({maxScale:9}).on('panzoomend', function(ev, panzoom, matrix, changed) {
            if (!changed) return $(ev.currentTarget).panzoom('zoom');
        });
        return;
    }
    var wrapper = imgEl.parent();
    var ow = imgData[id].origWidth;
    var oh = imgData[id].origHeight;
    var iw = imgEl[0].naturalWidth;
    var ih = imgEl[0].naturalHeight;
    var ww = wrapper.width();
    var wh = wrapper.height();
    var padding = ww * 0.15;
    for (var i = 0 ; i < imgData[id].bbox.length ; i++) {
        imgData[id].bbox[i] *= iw / ow;
    }
    var ratio = ww / (imgData[id].bbox[2] + padding);
    if ((wh / (imgData[id].bbox[3] + padding)) < ratio) ratio = wh / (imgData[id].bbox[3] + padding);
console.log('img=%dx%d / wrapper=%dx%d / box=%dx%d', iw, ih, ww, wh, imgData[id].bbox[2], imgData[id].bbox[3]);
console.log('%.f', ratio);
	var dx = (ww / 2) - ((imgData[id].bbox[2] + padding) * ratio / 2);
	var dy = (wh / 2) - ((imgData[id].bbox[3] + padding) * ratio / 2);
console.log('dx, dy %f, %f', dx, dy);
	var css = {
                transformOrigin: '0 0',
		transform: 'scale(' + ratio + ')',
		left: (dx - ratio * imgData[id].bbox[0] + padding/2*ratio) + 'px',
		top: (dy - ratio * imgData[id].bbox[1] + padding/2*ratio) + 'px'
	};
console.log('css = %o', css);
	imgEl.css(css);
/*
        imgEl.on('click', function(ev) {
console.log('CLICK IMG %o', ev);
            ev.target.style.transformOrigin = '50% 50%';
            ev.target.style.width = '100%';
        });
*/
	imgEl.show();

        var box = $('<div class="gallery-box" />');
        box.css({
            transform: 'scale(1.9)',
            opacity: 0.5,
            left: ((ww - imgData[id].bbox[2]) / 2) + 'px',
            top: ((wh - imgData[id].bbox[3]) / 2) + 'px',
            width: imgData[id].bbox[2] + 'px',
            height: imgData[id].bbox[3] + 'px'
        });
        wrapper.append(box);
}


</script>

<style>
.img-wrapper {
    width: 48%;
    height: 650px;
    display: inline-block;
    margin: 10px 4px;
    position: relative;
    overflow: hidden;
    background-color: #DDD;
}
.gallery-img {
    position: absolute;
    max-width: none;
    display: none;
}
.gallery-box {
    position: absolute;
    outline: solid 2px #bff223;
}
.img-info {
    position: absolute;
    right: 10px;
    top: 10px;
    display: inline-block;
    background-color: rgba(255,255,0,0.7);
    border-radius: 4px;
    padding: 2px 10px;
}
</style>
<jsp:include page="header.jsp" flush="true" />
<script src="tools/panzoom/jquery.panzoom.min.js"></script>

<div style="text-align: center;" class="maincontent">
<div style="margin-top: 30px;"></div>
<%
if (!Util.collectionIsEmptyOrNull(indiv.getEncounters())) for (Encounter enc : indiv.getEncounters()) {
    if ((skipEncId != null) && skipEncId.equals(enc.getCatalogNumber())) continue;
    if (!Util.collectionIsEmptyOrNull(enc.getAnnotations())) for (Annotation ann : enc.getAnnotations()) {
        MediaAsset ma = ann.getMediaAsset();
        if (ma == null) continue;
        JSONObject j = new JSONObject();
        j.put("annotationId", ann.getId());
        j.put("origWidth", ma.getWidth());
        j.put("origHeight", ma.getHeight());
        if (!ann.isTrivial()) j.put("bbox", ann.getBbox());
/*
        ArrayList<MediaAsset> kids = ma.findChildrenByLabel(myShepherd, "_mid");
        if (!Util.collectionIsEmptyOrNull(kids)) ma = kids.get(0);
*/
        URL url = ma.safeURL(myShepherd, request);
        out.println("<script> imgData[" + ma.getId() + "] = " + j.toString() + "; </script>");
%>

<div id="wrapper-<%=ma.getId()%>" class="img-wrapper">
    <img id="img-<%=ma.getId()%>" class="gallery-img" src="<%=url%>" onLoad="imgLoaded(this);" />

<% if (admin) { %>
    <div class="img-info"
        onClick="wildbook.openInTab('encounters/encounter.jsp?number=<%=enc.getCatalogNumber()%>');" title="open this encounter" style="cursor: pointer;"
><%=(ma.hasKeyword("MatchPhoto") ? "<b>Match Photo</b>" : "&#x2b08;")%></div>
<% } %>

</div>


<%
    }  //media loop
}  //enc loop
%>

<div id="gallery">
</div>

</div>


<jsp:include page="footer.jsp" flush="true" />


<%
myShepherd.rollbackDBTransaction();
%>
