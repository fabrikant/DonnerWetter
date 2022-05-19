using Toybox.Communications;
using Toybox.System;

class RequestDelegate
{
    hidden var callback; // function always takes 3 arguments
    hidden var context;  // this is the 3rd argument

    function initialize(callback, context) {
        self.callback = callback;
        self.context = context;
    }

    // Perform the request using the previously configured callback
    function makeWebRequest(url, params, options) {
        Communications.makeWebRequest(url, params, options, self.method(:onWebResponse));
    }

    function makeImageRequest(url, params, options) {
        Communications.makeImageRequest(url, params, options, self.method(:onWebResponse));
    }

    // Forward the response data and the previously configured context
    function onWebResponse(code, data) {
        callback.invoke(code, data, context);
    }
}
