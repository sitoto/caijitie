if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini|UCWEB|MQQBrowser/i.test(navigator.userAgent) ) {
  document.writeln("<script type=\"text/javascript\">");
  document.writeln("var cpro_id = \"u1520137\";");
  document.writeln("</script>");
  document.writeln("<script src=\"http://cpro.baidustatic.com/cpro/ui/cm.js\" type=\"text/javascript\"></script>");

} else {
  document.writeln("<script type=\"text/javascript\">");
  document.writeln("var cpro_id = \"u890150\";");
  document.writeln("</script>");
  document.writeln("<script src=\"http://cpro.baidustatic.com/cpro/ui/f.js\" type=\"text/javascript\"></script>");

  document.writeln("<script type=\"text/javascript\">");
  document.writeln("var cpro_id = \"u1616354\";");
  document.writeln("</script>");
  document.writeln("<script src=\"http://cpro.baidustatic.com/cpro/ui/i.js\" type=\"text/javascript\"></script>");
}
