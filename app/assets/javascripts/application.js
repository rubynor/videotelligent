// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require hamlcoffee
//= require angular_1.4.0-rc.2
//= require jquery-plugins
//= require lodash
//= require angular-sanitize
//= require select
//= require videotelligent
//= require_tree ./templates
//= require_tree .

//jQuery(function() {
//  return $.ajax({
//    url: 'https://apis.google.com/js/client:plus.js?onload=gpAsyncInit',
//    dataType: 'script',
//    cache: true
//  });
//});
//
//window.gpAsyncInit = function() {
//  gapi.auth.authorize({
//    immediate: true,
//    response_type: 'code',
//    cookie_policy: 'single_host_origin',
//    client_id: '663769004258-qq4kbh4jrisi4ucuuhfd7aeafekfhnp1.apps.googleusercontent.com',
//    scope: 'email profile'
//  }, function(response) {
//    return;
//  });
//  $('.googleplus-login').click(function(e) {
//    e.preventDefault();
//    gapi.auth.authorize({
//      immediate: false,
//      response_type: 'code',
//      cookie_policy: 'single_host_origin',
//      client_id: '663769004258-qq4kbh4jrisi4ucuuhfd7aeafekfhnp1.apps.googleusercontent.com',
//      scope: 'email profile'
//    }, function(response) {
//      if (response && !response.error) {
//        // google authentication succeed, now post data to server.
//        console.log(response);
//        response['g-oauth-window'] = undefined;
//        jQuery.ajax({type: 'POST', url: "/users/auth/google_oauth2/callback", 
//data: response,
//          success: function(data) {
//            // response from server
//          }
//        });
//      } else {
//        // google authentication failed
//      }
//    });
//  });
//};
