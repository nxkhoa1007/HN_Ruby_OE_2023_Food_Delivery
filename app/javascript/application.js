// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import '@hotwired/turbo-rails'
import 'controllers'
import 'bootstrap-icon-js'
import '@vendor/@coreui/coreui/js/coreui.bundle.min'
import 'jquery'
import I18n from 'i18n-js'
import 'i18n/en'
import 'i18n/vi'
window.I18n = I18n
I18n.locale = document.querySelector('body').getAttribute('data-locale');
import 'custom/toastr'
import 'custom/script'
