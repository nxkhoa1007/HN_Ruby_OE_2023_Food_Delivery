$(document).on('turbo:load', function() {
  var clickedIndex = 0;
  function remove_background(product_id){
    for(var count=1;count<=5;count++){
      $('#'+product_id+'-'+count).css('color','#ccc');
    }
  }
  $(document).on('click', '.rating', function () {
    clickedIndex = $(this).data("index");
    var product_id = $(this).data("product_id");
    remove_background(product_id);
    for (var count = 1; count <= clickedIndex; count++) {
      $('#' + product_id + '-' + count).css('color', '#ffcc00');
    }
    $('#clickedIndexField').val(clickedIndex);
  });
});
