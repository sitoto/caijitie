function ImgRebuild() {
  $(".content img").each(function(i){
    url = this.src;
    width = this.width;
    height = this.height;
    var imgid = Math.random(),
  frameid = 'frameimg' + imgid;
  window['img'+imgid] = '<img id="img" src=\''+url+'?kilobug\' /><script>window.onload = function() { parent.document.getElementById(\''+frameid+'\').height = document.getElementById(\'img\').height+\'px\'; }<'+'/script>';
  img_r = '<iframe id="'+frameid+'" src="javascript:parent[\'img'+imgid+'\'];" frameBorder="0" height="' +height+ '" scrolling="no" width="100%"></iframe>';
  $(this).replaceWith(img_r);
  });
  return '';
}
ImgRebuild();

