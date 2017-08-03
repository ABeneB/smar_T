$(function() {
  $("tbody.sortable").sortable({
    update: function (event, ui) {
      var data = $(this).sortable('serialize');
      $.ajax({
       data: data,
       type: 'POST',
       url: '/tours/positions/update'
     });
     }
  });
});
