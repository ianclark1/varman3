<cfapplication name="varman" clientmanagement="true" />

<cfset varman = createObject("component","varman").init("./varman.ini") />
<cfset varman.setVar("user.skin","default") />
<cfset varman.setVar("system.license","BSD") />
<cfset varman.setVar("temp.hitCount",300,"client") />
<cfset varman.setVar("temp.visitors",150) />

<h2>Vars in Cookie Scope</h2>
<h3>The Varman Way</h3>
<cfdump label="varman: user"					var="#varman.getVar('user')#" />
<cfdump label="varman: user.language"	var="#varman.getVar('user.language')#" />
<h3>The ColdFusion Way</h3>
<cfdump label="coldfusion: cookie" 								var="#cookie#" />
<cfdump label="coldfusion: cookie.user_language"	var="#cookie.user_language#" />
<br /><br />
<h2>Vars in Application Scope</h2>
<h3>The Varman Way</h3>
<cfdump label="varman: system"				var="#varman.getVar('system')#" />
<cfdump label="varman: system.author"	var="#varman.getVar('system.author')#" />
<h3>The ColdFusion Way</h3>
<cfdump label="coldfusion: application"								var="#application#" />
<cfdump label="coldfusion: application.system.author" var="#application.system.author#" />
<br /><br />
<h2>Vars in Client Scope</h2>
<h3>The Varman Way</h3>
<cfdump label="varman: temp" 					var="#varman.getVar('temp')#" />
<cfdump label="varman: temp.hitCount"	var="#varman.getVar('temp.hitCount')#" />
<h3>The ColdFusion Way</h3>
<cfdump label="coldfusion: client"								var="#client#" />
<cfdump label="coldfusion: client.temp_hitCount"	var="#client.temp_hitCount#" />