
var xmlHttp;

function createXMLHttpRequest() {
	if (window.ActiveXObject) {
		xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
	} else if (window.XMLHttpRequest) {
		xmlHttp = new XMLHttpRequest();
	}
}

function doGET(url, qs, handler) {
	createXMLHttpRequest();

	xmlHttp.onreadystatechange = handler;
	xmlHttp.open("GET", url + "?" + qs, true);
	// 禁止缓存
	xmlHttp.setRequestHeader("If-Modified-Since", "0");
	xmlHttp.send(null);
}

function doPOST(url, qs, handler) {
	createXMLHttpRequest();

	xmlHttp.open("POST", url, true);
	xmlHttp.onreadystatechange = handler;
	xmlHttp.send(qs);
}

function httpReady() {
	if (xmlHttp.readyState == 4) {
		if (xmlHttp.status == 200) {
			return true;
		}
	}

	return false;
}

function failed(info) {
	if (info.search(/failed/) == 0)
		return true;
	else
		return false;
}


/* 设置cookie */
function setCookie(name, value, expire) {
	var sCookie = name + "=" + escape(value);

	if (expire > 0) {
		var d = new Date();
		d.setTime(d.getTime() + expire);
		sCookie = sCookie + "; expire=" + d.toGMTString();
	}

	document.cookie = sCookie;
}
/* 获取指定名称的cookie值 */
function getCookie(name) {
	var sCookie = document.cookie;
	var aCookie = sCookie.split("; ");
	for (var i = 0; i < aCookie.length; i++) {
		var a = aCookie[i].split("=");
		if (a[0] == name)
			return a[1];
	}

	return "";
}
/* 删除指定名称的cookie */
function deleteCookie(name) {
	var d = new Date();
	d.setTime(d.getTime()-10000);
	document.cookie = name + "=v; expire=" + d.toGMTString();
}
