//Imports goes here.

/**
 * DemoController
 * This controller is inherited by all the namespace controllers.
 * This means that all public methods written here are reusable by the other controllers
 * without calling `require` in case you decide to add a namespace.
 * It is strongly advised to use namespaces to organize your code:
 * E.g.:
 *      gina namespace:add demo/blogpost @myproject
 *      gina namespace:add demo/account @myproject
 *      ...
 * */
function DemoController() {
    var self = this;
    // get config/app.json content
    // var appConf = this.getConfig('app');



    // The onReady Event is called when the controller is loaded
    // You can use this to define, overwrite and customise default controller methods & swig filters
    this.onReady = function(req, res, next){
       // e.g: Define a `setup` function (inside this controller) that you can call when the controller is ready
       // Or better, you can just complete and reuse the `setup.js` and call self.setup(req, res, next)
       self.setup(req, res, next)
    }
};

module.exports = DemoController
