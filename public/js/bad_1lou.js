if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini|UCWEB|MQQBrowser/i.test(navigator.userAgent) ) {
  document.writeln("<script type=\"text/javascript\">");
  document.writeln("var sogou_ad_id=376781;");
  document.writeln("var sogou_ad_height=60;");
  document.writeln("var sogou_ad_width=234;");
  document.writeln("</script>");
  document.writeln("<script src=\"http://images.sohu.com/cs/jsfile/js/c.js\" type=\"text/javascript\"></script>");

}
else {

  document.writeln("<script type=\"text/javascript\">");
  document.writeln("var sogou_ad_id=376782;");
  document.writeln("var sogou_ad_height=90;");
  document.writeln("var sogou_ad_width=728;");
  document.writeln("</script>");
  document.writeln("<script src=\"http://images.sohu.com/cs/jsfile/js/c.js\" type=\"text/javascript\"></script>");

}
