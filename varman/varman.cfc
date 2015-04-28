<cfcomponent output="false	" hint="Variablen - Manager">

<cffunction name="init" returntype="any" access="public" output="false" hint="Konstruktor">
	<cfargument name="ini" type="string" required="false" hint="Pfad zur *.ini Datei mit den Variablen Deklarationen" />
	
	<cfset variables.instance = structNew() />
	<cfset variables.instance.sectionScopes	= structNew() />
	<cfset variables.instance.flatScopes		= "client,cookie,form,url" />
	<cfset variables.instance.defaultScope	= "application" />
	
	<cfif structKeyExists(arguments,"ini")>
		<cfset loadVars(arguments.ini) />
	</cfif>
	
	<cfreturn this />
</cffunction>


<cffunction name="loadVars" returntype="void" access="public" output="false" hint="Laedt Variablen aus einer *.ini Datei">
	<cfargument name="ini"		type="string"	required="true"		hint="Pfad zur *.ini Datei mit den Variablen Deklarationen" />
	<cfargument name="prefix"	type="string"	required="false"	default=""	hint="Optionaler Prefix der fuer die Variablen verwendet werden soll" />
	<cfargument name="scope"	type="string"	required="false"	default=""	hint="Variablenscope der auf die gesamte Datei angewendet werden soll, kann nur im Zusammenhang mit einem Prefix verwendet werden" />
	
	<cfset var local = structNew() />
	<cfset local.ini			= expandPath(arguments.ini) />
	<cfset local.sections	= getProfileSections(local.ini) />
	
	<cfif compare("",arguments.prefix) AND compare("",arguments.scope)>
		<cfset arguments.prefix = "#arguments.prefix#." />
	<cfelse>
		<cfset arguments.prefix = "" />
		<cfset arguments.scope = variables.instance.defaultScope />
	</cfif>
	
	<cfif structKeyExists(local.sections,"scopes")>
		<cfloop list="#local.sections['scopes']#" index="local.section">
			<cfset variables.instance.sectionScopes["#arguments.prefix##local.section#"] = getProfileString(local.ini,"scopes",local.section) />
		</cfloop>
		<cfset structDelete(local.sections,"scopes") />
	</cfif>

	<cfloop collection="#local.sections#" item="local.section">
		<cfloop list="#local.sections[local.section]#" index="local.key">
			<cfset setVar("#arguments.prefix##local.section#.#local.key#",getProfileString(local.ini,local.section,local.key),arguments.scope) />
		</cfloop>
	</cfloop>

</cffunction>


<cffunction name="getVar" returntype="any" access="public" output="false" hint="Getter fuer Variablen">
	<cfargument name="key"		type="string"	required="true"	hint="Name der Variablen" />
	<cfargument name="scope"	type="string"	required="false"	default="#getScope(arguments.key)#"	hint="Scope der Variablen - wird nur benoetigt wenn in unterschiedlichen Scopes gleiche Variablen Namen verwendet werden" />
	
	<cfset var local = structNew() />
	<cfset local.value	= structNew() />
	
	<cfif listFindNoCase(variables.instance.flatScopes,arguments.scope)>
		<cfset local.section			= listFirst(arguments.key,".") />
		<cfset local.myScope			= evaluate(arguments.scope) />
		<cfset local.myKey				= replace(arguments.key,".","_","all") />
		<cfset local.scopeKeyList	= structKeyList(local.myScope) />
		
		<cfif findNoCase("#local.myKey#_",local.scopeKeyList)>
			<cfloop collection="#local.myScope#" item="local.scopeKey">
				<cfif findNoCase("#local.myKey#_",local.scopeKey)>
					<cfset "local.value.#replace(local.scopeKey,'_','.','all')#" = local.myScope[local.scopeKey] />
				</cfif>
			</cfloop>
		<cfelse>
			<cfset local.value = local.myScope[local.myKey] />
		</cfif>
		
	<cfelse>
		<cfset local.value = evaluate("#arguments.scope#.#arguments.key#") />
	</cfif>
	
	<cfreturn local.value />
</cffunction>


<cffunction name="setVar" returntype="void" access="public" output="false" hint="Setter fuer Variablen">
	<cfargument name="key"		type="string"	required="true"		hint="Name der Variablen" />
	<cfargument name="value"	type="any"		required="true"		hint="Wert der Variablen" />
	<cfargument name="scope"	type="string"	required="false"	default="#variables.instance.defaultScope#"	hint="Scope der Variablen - wird nur benoetigt wenn nicht bereits eine Variable mit dem angegebenen Namen existiert" />
	
	<cfset var local = structNew() />
	<cfset local.section		= listFirst(arguments.key,".") />	
	<cfset arguments.scope	= getScope(arguments.key,arguments.scope) />
	
	<cfif NOT structKeyExists(variables.instance.sectionScopes,local.section)>
		<cfset variables.instance.sectionScopes[local.section] = arguments.scope />
		<cfif NOT listFindNoCase(variables.instance.flatScopes,arguments.scope)>
			<cfset "#arguments.scope#.#local.section#" = structNew() />
		</cfif>
	</cfif>
	
	<cfif listFindNoCase(variables.instance.flatScopes,arguments.scope)>
		<cfset arguments.key = replace(arguments.key,".","_","all") />
	</cfif>
	
	<cfset "#arguments.scope#.#arguments.key#" = arguments.value />
</cffunction>


<cffunction name="getScope" returntype="string" access="private" output="false" hint="Liefert den Scope einer Variablen">
	<cfargument name="key"		type="string"	required="true"		hint="Name der Variablen" />
	<cfargument name="scope"	type="string"	required="false"	default="#variables.instance.defaultScope#"	hint="Scope der fuer die Variable wenn moeglich verwendet werden soll" />
	
	<cfset var section = listFirst(arguments.key,".") />
	
	<cfif structKeyExists(variables.instance.sectionScopes,section)>
		<cfset arguments.scope = variables.instance.sectionScopes[section] />
	</cfif>
	
	<cfreturn arguments.scope />
</cffunction>

</cfcomponent>