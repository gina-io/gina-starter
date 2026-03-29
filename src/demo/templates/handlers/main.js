/**
 * Demo Main handler
 */

// requires are put here

 var DemoHandler = ( function onDemoMainHandled() {
     var self                = {}
     ;

     var init = function() {

         // Define global handlers/bindings here

         handle();
     }


     var handle = function () {
         console.debug('Main Demo handler loaded !');
     };

     init();
 })();
