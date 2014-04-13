function ImgRebuild() {
  $(".content img").each(function(i){
    if ($(this).attr("original") != "")
  {
    this.src = $(this).attr("original");
    $(this).removeAttr("height");
  }

  });
  return '';
}
ImgRebuild();

