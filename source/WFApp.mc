using Toybox.Application;
using Toybox.System;
using Toybox.Activity;

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
       	var location = Activity.getActivityInfo().currentLocation;
    	if (location != null) {
			location = location.toDegrees();
			Application.Storage.setValue("Lat", location[0].toFloat());
			Application.Storage.setValue("Lon", location[1].toFloat());
		} else {
			if (Toybox has :Weather){
				location = Toybox.Weather.getCurrentConditions();
				if (location != null) {
					location = location.observationLocationPosition;
			    	if (location != null) {
						location = location.toDegrees();
						Application.Storage.setValue("Lat", location[0].toFloat());
						Application.Storage.setValue("Lon", location[1].toFloat());
					}
				}
			}
		}
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
    	if (Application.Properties.getValue("Lat").equals(0.0) || Application.Properties.getValue("Lon").equals(0.0) || Application.Properties.getValue("keyOW").equals("")){
    		return [ new EmptyView(), new ExitOnSelectDelegate() ];
    	}else{
        	return [ new CurrentView(), new CurrenInputDelegate() ];
        }
    }
    

}