//Imports goes here.
// var md       = require('marked'); // visit: https://github.com/jmcmanus/pagedown-extra
// var lib      = require('gina').lib;
// var merge    = lib.merge;

/**
 * Setup Class
 * Allows you to extend setup to all your controllers.
 * Most of the things you can do inside a controller, you can do here.
 *
 * E.g.: use it inside the controller `onReady` by calling `self.setup(req, res, next)`
 *
 *
 * @param {object} req
 * @param {object} res
 * @callback [next]
 * */
function SetupClass(req, res, next){
    // get `app` config
    // var conf = this.getConfig('app')

    // defining filters
    var engine = this.engine;

    /**
     * Inherited filters from Gina are:
     * [ getWebroot ]
     * Will get the current webroot
     *  e.g.:
     *      {{ '' | getWebroot() }}
     *
     * [ getUrl ]
     * Will translate a route name to a url
     *  e.g.:
     *      <a href="{{ '/homepage' | getUrl() }}">Homepage</a>
     *      <a href="{{ 'users-add' | getUrl({ id: user.id }) }}">Add User</a>
     *      <a href="{{ 'users-edit' | getUrl({ id: user.id }) }}">Edit user</a>
     *      <a href="{{ 'users-get-empty' | getUrl({ id: '' }) }}">Get empty</a>
     *      <a href="{{ 'users-list' | getUrl(null, 'http://domain.com') }}">Display all users</a>
     *      <a href="{{ '/dashboard' | getUrl(null, 'admin') }}">Go to admin bundle's dashboard page</a>
     *      <a href="{{ 'home@admin' | getUrl() }}">Go to admin bundle's dashboard page</a>
     *
     * [ length ]
     *  Extends default template engine `length` filter
     *
     * [ nl2br ]
     * Will replace all `\n` by `<br/>`
     *  e.g.:
     *      {{ contact.address | nl2br }}
     */

    if (engine && typeof(setupFilters) != 'undefined') { // not always available: redirect, xhr requests
        setupFilters(engine)
    }

};

module.exports = SetupClass
