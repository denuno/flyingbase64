component output="false" {

	/* Application name, should be unique */
	this.name = "ApplicationName";
	/* How long application vars persist */
	this.applicationTimeout = createTimeSpan(0,2,0,0);
	/* Should client vars be enabled? */
	this.clientManagement = false;
	/* Where should we store them, if enable? */
	this.clientStorage = "registry";
	/* Where should cflogin stuff persist */
	this.loginStorage = "session";
	/* Should we even use sessions? */
	this.sessionManagement = true;
	/* How long do session vars persist? */
	this.sessionTimeout = createTimeSpan(0,0,20,0);
	/* Should we set cookies on the browser? */
	this.setClientCookies = true;
	/* should cookies be domain specific, ie, *.foo.com or www.foo.com */
	this.setDomainCookies = false;
	/* should we try to block 'bad' input from users */
	this.scriptProtect = "none";
	/* should we secure our JSON calls? */
	this.secureJSON = false;
	/* Should we use a prefix in front of JSON strings? */
	this.secureJSONPrefix = "";
	/* Used to help CF work with missing files and dir indexes */
	this.welcomeFileList = "";

	/* define custom coldfusion mappings. Keys are mapping names, values are full paths  */
	this.mappings = structNew();
	/* define a list of custom tag paths. */
	this.customtagpaths = "";

	/* Run when application starts up */
	boolean function onApplicationStart()  {
		return true;
	}

	/* Run when application stops */
	void function onApplicationEnd(required applicationScope)  {
	}

	/* Fired when user requests a CFM that doesn't exist. */
	boolean function onMissingTemplate(required string targetpage)  {
		return true;
	}

	/* Run before the request is processed */
	boolean function onRequestStart(required string thePage)  {
		var req = getPageContext().getRequest();
		var ServletFileUpload = createObject("java","org.apache.commons.fileupload.servlet.ServletFileUpload","commons-fileupload-1.2.2.jar");
		var Streams = createObject("java","org.apache.commons.fileupload.util.Streams","commons-fileupload-1.2.2.jar");
		var Base64InputStream = createObject("java","org.apache.commons.codec.binary.Base64InputStream","commons-codec-1.6.jar");
		var isMultipart = ServletFileUpload.isMultipartContent(req);
		if(isMultipart) {
			var iter = ServletFileUpload.getItemIterator(req);
			while (iter.hasNext()) {
			    var item = iter.next();
			    var name = item.getFieldName();
			    var stream = item.openStream();
			    if (item.isFormField()) {
			        writeOutput("Form field " & name & " with value " & Streams.asString(stream) & " detected.");
			    } else {
			        writeOutput("File field " & name & " with file name " & item.getName() & " detected.");
			        var decoderStream = Base64InputStream.init(stream);
			        var result = "";
					var byteClass = createObject("java","java.lang.Byte");
					var tmp = createObject("java","java.lang.reflect.Array").newInstance(byteClass.Init(1).TYPE, 1024);
					while(decoderStream.available()>0){
						var i=decoderStream.read(tmp, 0, 1024);
						if(i<0)break;
						var str = createObject("java","java.lang.String").init(tmp,0,i);
						result = result & str;
					}
					writeOutput(result);
			    }
			}
		} else {
			writeOutput(fileRead("upload.html"));
			abort;
		}
		abort;
		return true;
	}

	/* Runs before request as well, after onRequestStart */
	/*
	WARNING!!!!! THE USE OF THIS METHOD WILL BREAK FLASH REMOTING, WEB SERVICES, AND AJAX CALLS.
	DO NOT USE THIS METHOD UNLESS YOU KNOW THIS AND KNOW HOW TO WORK AROUND IT!
	EXAMPLE: http://www.coldfusionjedi.com/index.cfm?mode=entry&entry=ED9D4058-E661-02E9-E70A41706CD89724
	*/
	void function onRequest(required string thePage)  {
		include "#arguments.thePage#";
	}

	/* Runs at end of request */
	void function onRequestEnd(required string thePage)  {
	}

	/* Runs on error */
	void function onError(required exception ,required string eventname)  {
		dump(var="#arguments#" );abort;
	}

	/* Runs when your session starts */
	void function onSessionStart()  {
	}

	/* Runs when session ends */
	void function onSessionEnd(required struct sessionScope ,required struct appScope)  {
	}
}