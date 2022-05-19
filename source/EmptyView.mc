using Toybox.System;
using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Position;

///////////////////////////////////////////////////////////////////////////////
//View Empty Directory
class EmptyView extends WatchUi.View{
	
	var gpsOn;
	var weatherForecast;
	
	function initialize() {

//    	Toybox.Application.Properties.setValue("Lat", 54);
//    	Toybox.Application.Properties.setValue("Lon", 74);
//    	Toybox.Application.Properties.setValue("keyOW", "d72271af214d870eb94fe8f9af450db4");
	
		gpsOn = true;
		weatherForecast = new WeatherForecast();
		Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));
        View.initialize();
    }

	function onUpdate(dc) {
		
		var gpsStatus = "\n"+"gps: "+ (gpsOn ? "on":"off");
		 
		var message = gpsStatus
			+ "\nlat: "+weatherForecast.lat+"\nlon: "+weatherForecast.lon
			+ "\nkey:\n"+weatherForecast.appid+"\n";
		dc.setColor(Tools.getBackgroundColor(), Graphics.COLOR_WHITE);
		dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
		dc.setColor(Tools.getForegroundColor(), Graphics.COLOR_TRANSPARENT);
		dc.drawText(dc.getWidth()/2, dc.getHeight()/2,
			Graphics.FONT_SYSTEM_MEDIUM,
			message,
			Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
	}

    function onShow() {
       	var location = Activity.getActivityInfo().currentLocation;
    	if (location != null) {
			location = location.toDegrees();
			Tools.setProperty("Lat", location[0].toFloat());
			Tools.setProperty("Lon", location[1].toFloat());
			weatherForecast.setCoord();
			WatchUi.requestUpdate();
		}
    }
    
    function onPosition(info) {
    	gpsOn = false;
	    var location = info.position.toDegrees();
		Tools.setProperty("Lat", location[0].toFloat());
		Tools.setProperty("Lon", location[1].toFloat());
		weatherForecast.setCoord();
		WatchUi.requestUpdate();
	}
	
}

class ExitOnSelectDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

	function onSelect(){
		System.exit();
	}
}


