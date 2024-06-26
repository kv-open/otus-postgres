var docURL;
function changeSt(layerRef)
{
 var strObj=document.getElementById(layerRef);
 if(strObj.style.display=="none")
 { // яюърчрЄ№
    strObj.style.display="inline";
//    strObj.style.textAlign="left";
    document.images["img"+layerRef].src="/images/bluedrop.gif";
    if(layerRef=='rat'){
    document.fm1.nn.focus();
    document.fm1.nn.select();
    				   }
 }
 else
 { // ёяЁ ЄрЄ№
    strObj.focus();
    strObj.style.display="none";
    document.images["img"+layerRef].src="/images/blueup.gif";
 }
}

function URLreplace(namev, val)
{
    var n = document.URL.indexOf(namev);
	var m = document.URL.indexOf("#");
	var strll, docURL=document.URL;
	if (m>0){
	  strll=document.URL.substring(m, document.URL.length);
	  docURL=document.URL.substring(0,m);
	}
	if (n>0){
	  var strl=docURL.substr(0, n+namev.length);
	  var strr=docURL.substring(n+namev.length, docURL.length);
	  var namp=strr.indexOf("&");
	  if (namp>0)
		strr=strr.substring(namp,strr.length);
	  else
		strr="";
	  result=strl + "=" + val + strr;
	}
	else{
	  if(docURL.indexOf("?")>0)
		result=docURL + "&" +namev + "=" + val;
	  else
		result=docURL + "?" +namev + "=" + val;
	}
	if (m>0)
	  result+=strll;
	return result;
}

function Sel_Reg(Index)
{
	document.location=URLreplace("Reg", Index);
}

function Sel_Lang(Index)
{
	document.location=URLreplace("Lang", Index);
	try{
       Help_Win.document.location.replace();
	}catch(e){}
}

function openHelp(helpDoc)
{
	var hwin=screen.width/2-screen.width/20;
	var xwin=screen.width/2+screen.width/20-15;
	var ywin=screen.height-screen.height/10;
	var brzFeatures="directories=no,location=no,menubar=no,status=no,resizable=yes,dependent=yes,scrollbars=yes,top=0,left="+hwin+",width="+xwin+",height="+ywin;
//	alert("#"+helpDoc+"#");
	if(helpDoc==undefined) // попытаться найти открытое окно и focus() в него
	{
	 try{
	   Help_Win.focus();
	 }catch(e)
	 {
	  Help_Win=window.open('/help/select0.php', "Help_Win",brzFeatures);
	  Help_Win.focus();
	//  alert('error '+e);
	 }
	}
	else{
	  Help_Win=window.open(helpDoc, "Help_Win",brzFeatures);
	  Help_Win.focus();
	}
}

function openPhoto(photo,lgn)
{
	var hwin=screen.width/3;
	var xwin=150;
	var ywin=180;
	var brzBars='titlebar=no,directories=no,location=no,menubar=no,status=no,alwaysRaised=no,';
	var brzWin='resizable=yes,dependent=yes,scrollbars=no,ScreenY='+hwin+',ScreenX='+hwin+',width='+xwin+',height='+ywin;
	var wlgn=new String(lgn);
	wlgn=wlgn.replace(" ","_");
	//alert(lgn+" |"+wlgn+" |"+photo);
	var PhWin=open("", "photo",brzBars+brzWin);
	PhWin.document.writeln('<title>'+wlgn+'</title>');
	PhWin.document.writeln('<body><img src="'+photo+'" width="130"></body>');
	PhWin.document.close();
	PhWin.moveTo(hwin,hwin);
	PhWin.focus();
//	return false;
}
