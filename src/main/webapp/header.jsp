<%--
  ~ Wildbook - A Mark-Recapture Framework
  ~ Copyright (C) 2008-2015 Jason Holmberg
  ~
  ~ This program is free software; you can redistribute it and/or
  ~ modify it under the terms of the GNU General Public License
  ~ as published by the Free Software Foundation; either version 2
  ~ of the License, or (at your option) any later version.
  ~
  ~ This program is distributed in the hope that it will be useful,
  ~ but WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  ~ GNU General Public License for more details.
  ~
  ~ You should have received a copy of the GNU General Public License
  ~ along with this program; if not, write to the Free Software
  ~ Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
  --%>
<html>
<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Properties" %>
<%@ page import="org.apache.commons.lang.WordUtils" %>
<%@ page import="org.ecocean.*" %>
<%@ page import="org.ecocean.security.Collaboration" %>
<%@ page import="org.ecocean.servlet.ServletUtilities" %>
<%
  String context = ServletUtilities.getContext(request);
  String langCode = ServletUtilities.getLanguageCode(request);
  Properties props = ShepherdProperties.getProperties("header.properties", langCode, context);
  Properties cciProps = ShepherdProperties.getProperties("commonCoreInternational.properties", langCode, context);

Shepherd confShepherd = new Shepherd(context);
CommonConfiguration.ensureServerInfo(confShepherd, request);


  String urlLoc = "//" + CommonConfiguration.getURLLocation(request);
  %>

<html lang="<%=langCode%>" >
    <head>
      <title><%=CommonConfiguration.getHTMLTitle(context)%>
      </title>
      <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
      <meta name="Description"
            content="<%=CommonConfiguration.getHTMLDescription(context) %>"/>
      <meta name="Keywords"
            content="<%=CommonConfiguration.getHTMLKeywords(context) %>"/>
      <meta name="Author" content="<%=CommonConfiguration.getHTMLAuthor(context) %>"/>
      <link rel="shortcut icon"
            href="<%=CommonConfiguration.getHTMLShortcutIcon(context) %>"/>
      <link href='//fonts.googleapis.com/css?family=Oswald:400,300,700' rel='stylesheet' type='text/css'/>
      <link rel="stylesheet" href="<%=urlLoc %>/cust/mantamatcher/css/manta.css" />

      <link href="//fonts.googleapis.com/css?family=Open+Sans" rel="stylesheet">

      <link href="<%=urlLoc %>/tools/jquery-ui/css/jquery-ui.css" rel="stylesheet" type="text/css"/>
      <link href="<%=urlLoc %>/tools/hello/css/zocial.css" rel="stylesheet" type="text/css"/>
	  <link rel="stylesheet" href="<%=urlLoc %>/tools/jquery-ui/css/themes/smoothness/jquery-ui.css" type="text/css" />

    <link rel="stylesheet" href="<%=urlLoc %>/css/createadoption.css">


      <script src="<%=urlLoc %>/tools/jquery/js/jquery.min.js"></script>
      <script src="<%=urlLoc %>/tools/bootstrap/js/bootstrap.min.js"></script>
      <script type="text/javascript" src="<%=urlLoc %>/javascript/core.js"></script>
      <script type="text/javascript" src="<%=urlLoc %>/tools/jquery-ui/javascript/jquery-ui.min.js"></script>

     <script type="text/javascript" src="<%=urlLoc %>/javascript/jquery.blockUI.js"></script>
	<script type="text/javascript" src="<%=urlLoc %>/javascript/jquery.cookie.js"></script>


      <script type="text/javascript" src="<%=urlLoc %>/tools/hello/javascript/hello.all.js"></script>
      <script type="text/javascript"  src="<%=urlLoc %>/JavascriptGlobals.js"></script>
      <script type="text/javascript"  src="<%=urlLoc %>/javascript/collaboration.js"></script>

      <script type="text/javascript"  src="<%=urlLoc %>/javascript/imageEnhancer.js"></script>
      <link type="text/css" href="<%=urlLoc %>/css/imageEnhancer.css" rel="stylesheet" />

      <script src="<%=urlLoc %>/javascript/lazysizes.min.js"></script>

 	<!-- Start Open Graph Tags -->
 	<meta property="og:url" content="<%=request.getRequestURI() %>?<%=request.getQueryString() %>" />
  	<meta property="og:site_name" content="<%=CommonConfiguration.getHTMLTitle(context) %>"/>
  	<!-- End Open Graph Tags -->
    </head>
    
    <body role="document">

        <!-- ****header**** -->
        <header class="page-header clearfix">
            <nav class="navbar navbar-default navbar-fixed-top">
              <div class="header-top-wrapper">
                <div class="container">
                <a href="//www.wildme.org" id="wild-me-badge">A Wild me project</a>
                  <div class="search-and-secondary-wrapper">
                  <%
                  if(CommonConfiguration.allowAdoptions(context)){
                  %>
                    <a href="<%=urlLoc%>/adoptamanta.jsp"><button name='adopt a manta' class='large adopt'><%=props.getProperty("adoptAnAnimal") %></button></a>
                  <%
                  }
                  %> 
                    <ul class="secondary-nav hor-ul no-bullets">
                    
                   
                      <%
                      
	                      if(request.getUserPrincipal()!=null){
	                    	  Shepherd myShepherd = new Shepherd(context);
	                          
	                          try{
	                        	  myShepherd.beginDBTransaction();
		                    	  String username = request.getUserPrincipal().toString();
		                    	  User user = myShepherd.getUser(username);
		                    	  String fullname=username;
		                    	  if(user.getFullName()!=null){fullname=user.getFullName();}
		                    	  String profilePhotoURL=urlLoc+"/images/empty_profile.jpg";
		                          if(user.getUserImage()!=null){
		                          	profilePhotoURL="/"+CommonConfiguration.getDataDirectoryName(context)+"/users/"+user.getUsername()+"/"+user.getUserImage().getFilename();
		                          } 
		                          
		                      		%>
		                      
		                      		<li><a href="<%=urlLoc %>/myAccount.jsp" title=""><img align="left" title="Your Account" style="border-radius: 3px;border:1px solid #ffffff;margin-top: -7px;" width="*" height="32px" src="<%=profilePhotoURL %>" /></a></li>
		             				<li><a href="<%=urlLoc %>/logout.jsp" ><%=props.getProperty("logout") %></a></li>
		                      
		                      		<%
	                          }
	                          catch(Exception e){e.printStackTrace();}
	                          finally{
	                        	  myShepherd.rollbackDBTransaction();
	                        	  myShepherd.closeDBTransaction();
	                          }
	                      }
	                      else{
	                      %>
	                      
	                      	<li><a href="<%=urlLoc %>/welcome.jsp" title=""><%=props.getProperty("login") %></a></li>
	                      
	                      <%
	                      }
                      
                      %>
                      
                       <!--  
                      <li><a href="#" title="">English</a></li>
                     --> 

                      
                      
                      <% 
                      if (CommonConfiguration.getWikiLocation(context)!=null) { 
                      %>
                        <li><a target="_blank" href="<%=CommonConfiguration.getWikiLocation(context) %>"><%=props.getProperty("userWiki")%></a></li>
                      <% 
                      } 
                     	
                      
                      
                      	java.util.List<String> contextNames=ContextConfiguration.getContextNames();
                		int numContexts=contextNames.size();
                		if(numContexts>1){
                		%>
                		
                		<li>
                						<form>
                						<%=props.getProperty("switchContext") %>&nbsp;
                							<select style="color: black;" id="context" name="context">
			                					<%
			                					for(int h=0;h<numContexts;h++){
			                						String selected="";
			                						if(ServletUtilities.getContext(request).equals(("context"+h))){selected="selected=\"selected\"";}
			                					%>
			                					
			                						<option value="context<%=h%>" <%=selected %>><%=contextNames.get(h) %></option>
			                					<%
			                					}
			                					%>
                							</select>
                						</form>
                			</li>
                			<script type="text/javascript">
                		
	                			$( "#context" ).change(function() {
	                			
		                  			//alert( "Handler for .change() called with new value: "+$( "#context option:selected" ).text() +" with value "+ $( "#context option:selected").val());
		                  			$.cookie("wildbookContext", $( "#context option:selected").val(), {
		                  			   path    : '/',          //The value of the path attribute of the cookie 
		                  			                           //(default: path of page that created the cookie).
		                			   
		                  			   secure  : false          //If set to true the secure attribute of the cookie
		                  			                           //will be set and the cookie transmission will
		                  			                           //require a secure protocol (defaults to false).
		                  			});
		                  			
		                  			//alert("I have set the wildbookContext cookie to value: "+$.cookie("wildbookContext"));
		                  			location.reload(true);
		                  			
	                			});
	                	
                			</script>
                			<%
                		}
                		%>
                		   <!-- Can we inject language functionality here? -->
                    <%
                    
            		ArrayList<String> supportedLanguages=CommonConfiguration.getSequentialPropertyValues("language", context);
            		int numSupportedLanguages=supportedLanguages.size();
            		
            		if(numSupportedLanguages>1){
            		%>
            			<li>
            					
            					
            					<%
            					for(int h=0;h<numSupportedLanguages;h++){
            						String selected="";
            						if(ServletUtilities.getLanguageCode(request).equals(supportedLanguages.get(h))){selected="selected=\"selected\"";}
            						String myLang=supportedLanguages.get(h);
            					%>
            						<img style="cursor: pointer" id="flag_<%=myLang %>" title="<%=CommonConfiguration.getProperty(myLang, context) %>" src="<%=urlLoc %>/images/flag_<%=myLang %>.gif" />
            						<script type="text/javascript">
            	
            							$( "#flag_<%=myLang%>" ).click(function() {
            		
            								//alert( "Handler for .change() called with new value: "+$( "#langCode option:selected" ).text() +" with value "+ $( "#langCode option:selected").val());
            								$.cookie("wildbookLangCode", "<%=myLang%>", {
            			   						path    : '/',          //The value of the path attribute of the cookie 
            			                           //(default: path of page that created the cookie).
            		   
            			   						secure  : false          //If set to true the secure attribute of the cookie
            			                           //will be set and the cookie transmission will
            			                           //require a secure protocol (defaults to false).
            								});
            			
            								//alert("I have set the wildbookContext cookie to value: "+$.cookie("wildbookContext"));
            								location.reload(true);
            			
            							});
            	
            						</script>
            					<%
            					}
            					%>
            				
            		</li>
            		<%
            		}
            		%>
            		<!-- end language functionality injection -->
                	
                    
                    
                    
                    </ul>
                    
                    <div class="search-wrapper">
                      <label class="search-field-header">
                            <form name="form2" method="get" action="<%=urlLoc %>/individuals.jsp">
	                            <input type="text" id="search-site" placeholder="<%=props.getProperty("searchPlaceholder")%>" class="search-query form-control navbar-search ui-autocomplete-input" autocomplete="off" name="number" />
	                            <input type="hidden" name="langCode" value="<%=langCode%>"/>
	                            <input type="submit" value="search" />
                          </form>
                      </label>
                    </div>
                  </div>
                  <a class="navbar-brand" target="_blank" href="<%=urlLoc %>">Wildbook for Mark-Recapture Studies</a>
                </div>
              </div>
              
              <div class="nav-bar-wrapper">
                <div class="container">
                  <div class="navbar-header clearfix">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                      <span class="sr-only">Toggle navigation</span>
                      <span class="icon-bar"></span>
                      <span class="icon-bar"></span>
                      <span class="icon-bar"></span>
                    </button>
                  </div>
                  
                  <div id="navbar" class="navbar-collapse collapse">
                  <div id="notifications"><%= Collaboration.getNotificationsWidgetHtml(request) %></div>
                    <ul class="nav navbar-nav">
                                  <!--                -->
                      <li class="active home text-hide"><a href="<%=urlLoc %>"><%=props.getProperty("home")%></a></li>
                      <li><a href="<%=urlLoc %>/submit.jsp"><%=props.getProperty("report")%></a></li>
                   
                      <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><%=props.getProperty("learn")%> <span class="caret"></span></a>
                        <ul class="dropdown-menu" role="menu">
                        	<li class="dropdown"><a href="<%=urlLoc %>/overview.jsp"><%=props.getProperty("aboutYourProject")%></a></li>
                          	<li><a href="<%=urlLoc %>/photographing.jsp"><%=props.getProperty("howToPhotograph")%></a></li>
                                 
                          	<li><a target="_blank" href="//www.wildme.org/wildbook"><%=props.getProperty("learnAboutShepherd")%></a></li>
                        </ul>
                      </li>
                      
                      <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><%=props.getProperty("participate")%> <span class="caret"></span></a>
                        <ul class="dropdown-menu" role="menu">
                          <li><a href="<%=urlLoc %>/adoptamanta.jsp"><%=props.getProperty("adoptions")%></a></li>
                          <li><a href="<%=urlLoc %>/userAgreement.jsp"><%=props.getProperty("userAgreement")%></a></li>
                          
                          <!--  examples of navigation dividers
                          <li class="divider"></li>
                          <li class="dropdown-header">Nav header</li>
                           -->
                          
                        </ul>
                      </li>
                      <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><%=props.getProperty("individuals")%> <span class="caret"></span></a>
                        <ul class="dropdown-menu" role="menu">
                        	<li><a href="<%=urlLoc %>/gallery.jsp"><%=props.getProperty("gallery")%></a></li>
                          <li><a href="<%=urlLoc %>/individualSearchResults.jsp"><%=props.getProperty("viewAll")%></a></li>
                        </ul>
                      </li>
                      <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><%=props.getProperty("encounters")%> <span class="caret"></span></a>
                        <ul class="dropdown-menu" role="menu">
                          <li class="dropdown-header"><%=props.getProperty("states")%></li>
                        
                        <!-- list encounters by state -->
                          <%
                            for (String state : CommonConfiguration.getIndexedPropertyValues("encounterState", context)) {
                              String propKey = "viewEncounters" + WordUtils.capitalize(state);
                          %>
                          <li><a href="<%=urlLoc%>/encounters/searchResults.jsp?state=<%=state%>"><%=props.getProperty(propKey)%></a></li>
                          <%
                            }
                          %>
                          <li class="divider"></li>
                          <li><a href="<%=urlLoc %>/encounters/thumbnailSearchResults.jsp?noQuery=true"><%=props.getProperty("viewImages")%></a></li>
                          <li><a href="<%=urlLoc %>/xcalendar/calendar.jsp"><%=props.getProperty("encounterCalendar")%></a></li>
                          <% if(request.getUserPrincipal()!=null) { %>
                            <li><a href="<%=urlLoc %>/encounters/searchResults.jsp?username=<%=request.getRemoteUser()%>"><%=props.getProperty("viewMySubmissions")%></a></li>
                          <% } %>
                        </ul>
                      </li>
                      
                      <!-- start locationID sites -->
                       <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><%=props.getProperty("sites") %> <span class="caret"></span></a>
                        <ul class="dropdown-menu" role="menu" id="menu-sites">
                         
                        
                        <!-- list sites by locationID -->
                          <%
                            Shepherd myShepherd = new Shepherd(context);
                            try {
                              java.util.List<String> locUsed = myShepherd.getAllLocationIDs();
                              Map<String, String> locMap = CommonConfiguration.getIndexedValuesMap("locationID", context);
                              for (Map.Entry<String, String> me : locMap.entrySet()) {
                                if (!locUsed.contains(me.getValue()))
                                  continue;
                          %>
                          <li><a href="<%=urlLoc %>/encounters/searchResultsAnalysis.jsp?locationCodeField=<%=me.getValue()%>"><%=cciProps.getProperty(me.getKey())%></a></li>
                          <%
                              }
                            }
                            catch (Exception ex) {
                              ex.printStackTrace();
                            }
                            finally {
                                myShepherd.rollbackDBTransaction();
                                myShepherd.closeDBTransaction();
                                myShepherd = null;
                            }
                          %>
                        </ul>
                      </li>
                      <!-- end locationID sites -->
                     
                      <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><%=props.getProperty("search")%> <span class="caret"></span></a>
                        <ul class="dropdown-menu" role="menu">
                              <li><a href="<%=urlLoc %>/encounters/encounterSearch.jsp"><%=props.getProperty("encounterSearch")%></a></li>
                              <li><a href="<%=urlLoc %>/individualSearch.jsp"><%=props.getProperty("individualSearch")%></a></li>
                              <li><a href="<%=urlLoc %>/encounters/searchComparison.jsp"><%=props.getProperty("comparisonSearch")%></a></li>
                              <li><a href="<%=urlLoc %>/occurrenceSearch.jsp"><%=props.getProperty("occurrenceSearch")%></a></li>
                          
                           </ul>
                      </li>
               
                      <li>
                        <a href="<%=urlLoc %>/contactus.jsp"><%=props.getProperty("contactUs")%> </a>
                      </li>
                      <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><%=props.getProperty("administer")%> <span class="caret"></span></a>
                        <ul class="dropdown-menu" role="menu">
                            <% if (CommonConfiguration.getWikiLocation(context)!=null) { %>
                              <li><a target="_blank" href="<%=CommonConfiguration.getWikiLocation(context) %>home"><%=props.getProperty("userWiki")%></a></li>
                            <% }
                            if(request.getUserPrincipal()!=null) {
                            %>
                              <li><a href="<%=urlLoc %>/myAccount.jsp"><%=props.getProperty("myAccount")%></a></li>
                            <% }
                            if(CommonConfiguration.allowBatchUpload(context) && (request.isUserInRole("admin"))) { %>
                              <li><a href="<%=urlLoc %>/BatchUpload/start"><%=props.getProperty("batchUpload")%></a></li>
                            <% }
                            if(request.isUserInRole("admin")) { %>
                              <li><a href="<%=urlLoc %>/appadmin/admin.jsp"><%=props.getProperty("general")%></a></li>
                              <li><a href="<%=urlLoc %>/appadmin/logs.jsp"><%=props.getProperty("logs")%></a></li>
                                <% if(CommonConfiguration.useSpotPatternRecognition(context)) { %>
                                 <li><a href="<%=urlLoc %>/software/software.jsp"><%=props.getProperty("gridSoftware")%></a></li>
                                <% } %>
                                <li><a href="<%=urlLoc %>/appadmin/users.jsp?context=context0"><%=props.getProperty("userManagement")%></a></li>

                                <% if (CommonConfiguration.getTapirLinkURL(context) != null) { %>
                                  <li><a href="<%=CommonConfiguration.getTapirLinkURL(context) %>"><%=props.getProperty("tapirLink")%></a></li>
                                <% } %>

								<li><a href="<%=urlLoc %>/appadmin/intelligentAgentReview.jsp?context=context0"><%=props.getProperty("intelligentAgentReview")%></a></li>
								
                                <% 

                                if (CommonConfiguration.getIPTURL(context) != null) { %>
                                  <li><a href="<%=CommonConfiguration.getIPTURL(context) %>"><%=props.getProperty("iptLink")%></a></li>
                                <% } %>
                                <li><a href="<%=urlLoc %>/appadmin/kwAdmin.jsp"><%=props.getProperty("photoKeywords")%></a></li>
                                <% if (CommonConfiguration.allowAdoptions(context)) { %>
                                  <li class="divider"></li>
                                  <li class="dropdown-header"><%=props.getProperty("adoptions")%></li>
                                  <li><a href="<%=urlLoc %>/adoptions/allAdoptions.jsp"><%=props.getProperty("createEditAdoption")%></a></li>
                                  <li class="divider"></li>
                                <% } %>
                                <li><a target="_blank" href="//www.wildme.org/wildbook"><%=props.getProperty("shepherdDoc")%></a></li>
                                <% if(CommonConfiguration.isCatalogEditable(context)) { %>
                                  <li class="divider"></li>
                                  <li><a href="<%=urlLoc %>/appadmin/import.jsp"><%=props.getProperty("dataImport")%></a></li>
                                <% }
                            } //end if admin %>
                        </ul>
                      </li>
                    </ul>
                    
                 
            		
                    
                  </div>
                  
                </div>
              </div>
            </nav>
        </header>
        
        <script>
        $('#search-site').autocomplete({
            appendTo: $('#navbar-top'),
            response: function(ev, ui) {
                if (ui.content.length < 1) {
                    $('#search-help').show();
                } else {
                    $('#search-help').hide();
                }
            },
            select: function(ev, ui) {
                if (ui.item.type == "individual") {
                    window.location.replace("<%=(urlLoc+"/individuals.jsp?number=") %>" + ui.item.value);
                } 
                else if (ui.item.type == "locationID") {
                	window.location.replace("<%=(urlLoc+"/encounters/searchResultsAnalysis.jsp?locationCodeField=") %>" + ui.item.value);
                } 
                /*
                //restore user later
                else if (ui.item.type == "user") {
                    window.location.replace("/user/" + ui.item.value);
                } 
                else {
                    alertplus.alert("Unknown result [" + ui.item.value + "] of type [" + ui.item.type + "]");
                }
                */
                return false;
            },
            //source: app.config.wildbook.proxyUrl + "/search"
            source: function( request, response ) {
                $.ajax({
                    url: '<%=urlLoc %>/SiteSearch',
                    dataType: "json",
                    data: {
                        term: request.term
                    },
                    success: function( data ) {
                        var res = $.map(data, function(item) {
                            var label;
                            if ((item.type == "individual")&&(item.species!=null)) {
//                                label = item.species + ": ";
                            } 
                            else if (item.type == "user") {
                                label = "User: ";
                            } else {
                                label = "";
                            }
                            return {label: label + item.label,
                                    value: item.value,
                                    type: item.type};
                            });

                        response(res);
                    }
                });
            }
        });
        </script>
        
        <!-- ****/header**** -->
