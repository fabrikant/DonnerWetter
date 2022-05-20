using Toybox.Application;
using Toybox.System;

var globalCache;
var fontSmall;
var fontMed;

(:glance)
class WFApp extends Application.AppBase {

    function initialize() {
    	globalCache = {};
        AppBase.initialize();
    }
	
	function getGlanceView() {
		globalCache = {};
        return [ new WeatherGlanceView() ];
    }
    
    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
    	if (Tools.getProperty("Lat").equals(0.0) || Tools.getProperty("Lon").equals(0.0) || Tools.getProperty("keyOW").equals("")){
    		return [ new EmptyView(), new ExitOnSelectDelegate() ];
    	}else{
        	return [ new CurrentView(), new CurrenInputDelegate() ];
        }
    }
    

}