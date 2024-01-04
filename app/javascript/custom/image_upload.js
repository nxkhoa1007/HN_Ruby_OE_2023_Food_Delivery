import I18n from 'i18n-js'

$(document).on('turbo:load', function() {
  var locale = $('body').data('locale');
  I18n.locale = locale;

  $('#image-input').on('change',function() {
    var input = this;
    var imagePreview = $('#image-preview');
    var image_upload = $('#image-input')[0];
    var size_in_megabytes = image_upload.files[0].size / 1024 / 1024;

    if (size_in_megabytes > 1) {
      alert(I18n.t('alert.limit_size'));
      image_upload.value = '';
    } else {
      if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function(e) {
          imagePreview.attr('src', e.target.result);
        };

        reader.readAsDataURL(input.files[0]);
      }
    }
  });
});
