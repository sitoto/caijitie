
(function($) {
  $(document).keydown(handleKey);
  function handleKey(e) {
    var left_arrow = 37;
    var right_arrow = 39;
    if (e.target.nodeName == 'BODY' || e.target.nodeName == 'HTML') {
      if (!e.ctrlKey && !e.altKey && !e.shiftKey && !e.metaKey) {
        var code = e.which;
        if (code == left_arrow) {
          prevPage();
        }
        else if (code == right_arrow) {
          nextPage();
        }
      }
    }
  }

  function prevPage() {
    var href = $('.pagination .prev a').attr('href');
    if (href && href != document.location && href != "#") {
      document.location = href;
    }
  }

  function nextPage() {
    var href = $('.pagination .next a').attr('href');
    if (href && href != document.location && href != "#") {
      document.location = href;
    }
  }
})(jQuery);


$(document).ready(function() {
  $('#ajax_top').bind("ajax:success", function(event, data) {
    var top = $('#ajax_top');
    var num = $('#num');
    //alert(data.top);
    top.html( data.top );
    num.text(data.top);
    top.hide();
    num.show();
  });
});


