# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "vendor/admin/vendors", under: "@vendor", to: "vendors"
pin "bootstrap-icon-js", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
pin "jquery", to: "https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.js"
pin "toastr-js", to: "https://cdn.jsdelivr.net/npm/toastr@2.1.4/toastr.min.js"
pin_all_from "app/javascript/custom", under: "custom"
pin "i18n-js", to: "https://ga.jspm.io/npm:i18n-js@3.9.2/app/assets/javascripts/i18n.js"
pin_all_from "app/javascript/i18n", under: "i18n"
