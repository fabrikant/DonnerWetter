using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Activity;
using Toybox.Application;

(:glance)
class WeatherGlanceView extends WatchUi.GlanceView {

	function initialize() {
    	GlanceView.initialize();
	}

    function onShow() {
    	var weatherForecast = new WeatherForecast();
    	weatherForecast.startRequestCurrent(self.method(:onWeatherUpdate)); 
    }

	function onUpdate(dc) {
        
		var bColor = GlanceTools.getBackgroundColor();
        var fColor = GlanceTools.getForegroundColor();
        
		dc.setColor(bColor, bColor);
		dc.clear();
		dc.setColor(fColor, Graphics.COLOR_TRANSPARENT);
	    var data = Application.Storage.getValue(STORAGE_KEY_CURRENT);
        
		if (data == null){
			dc.drawText(
				dc.getWidth()/2, 
				dc.getHeight()/2, 
				Graphics.FONT_GLANCE, 
        		"NO DATA", 
        		Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
			);
        	return;
		}

		var interval = 10;
		var x = interval;
		var image = Icons.getImage(data[ID], data[ICON], true);
		if (image != null){
			var imageH = image.getDc().getHeight();
			var y = (dc.getHeight()-imageH)/2; 
			dc.drawBitmap(x, y, image);
			x += image.getDc().getWidth()+interval;
		}
		dc.drawText(x, dc.getHeight()/2, Graphics.FONT_GLANCE_NUMBER, getTemperature(data[TEMP]), Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
		
	}
	
	function getTemperature(temp){
		var unit = "C";
		if (System.getDeviceSettings().temperatureUnits == System.UNIT_STATUTE){
			unit = "F";
		}
		return temp.format("%d")+"°"+unit;
	}

	function onWeatherUpdate(code, data){
		if (code == 200){
			var dict ={
				ID => data["weather"][0]["id"],
				ICON => data["weather"][0]["icon"],
				TEMP => data["main"]["temp"],
				WIND_DEG => data["wind"]["deg"],
				WIND_SPEED => data["wind"]["speed"],
				DESCRIPTION => data["weather"][0]["description"],
				FIELD_TYPE_HUMIDITY => data["main"]["humidity"],
				FIELD_TYPE_PRESSURE => data["main"]["pressure"],
				FIELD_TYPE_UVI => data["uvi"],
				FIELD_TYPE_VISIBILITY => data["visibility"],
				FIELD_TYPE_DEW_POINT => data["dew_point"]};
			Application.Properties.setValue(STORAGE_KEY_CURRENT, dict);
			WatchUi.requestUpdate();
		}
	}
	
}