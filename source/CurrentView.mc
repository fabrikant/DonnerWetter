using Toybox.WatchUi;
using Toybox.System;
using Toybox.Graphics;
using Toybox.Application;
using Toybox.Time;

class CurrentView extends WatchUi.View {

	var storageKey;
	var weatherForecast;
	
    function initialize(key) {
    	fontSmall = Application.loadResource(Rez.Fonts.small);
    	fontMed = Application.loadResource(Rez.Fonts.medium);
    	
    	storageKey = key;
        View.initialize();
    }

     function onShow() {
     
       	var location = Activity.getActivityInfo().currentLocation;
    	if (location != null) {
			location = location.toDegrees();
			var lat = location[0].toFloat();
			var lon = location[1].toFloat();
			if (!lat.equals(0.0) && !lon.equals(0.0)){
				Tools.setProperty("Lat", lat);
				Tools.setProperty("Lon", lon);
			}
		}
       	weatherForecast = new WeatherForecast();
		weatherForecast.startRequestCurrent(self.method(:onWeatherUpdate));    	
    }
    
    function onUpdate(dc) {
        dc.setColor(Tools.getBackgroundColor(), Tools.getBackgroundColor());
        dc.clear();
        var data = Tools.getStorage(storageKey, null);
        if (data == null){
        	return;
        }
        
        //image
        dc.setColor(Tools.getForegroundColor(), Graphics.COLOR_TRANSPARENT);
        var image = Icons.getImage(data[ID], data[ICON], false);
        var halfWidth = dc.getWidth()/2;
        var y = 0; 
        if (image != null){
        	dc.drawBitmap(halfWidth-image.getDc().getWidth()/2, y, image);
        	y += image.getDc().getHeight();
        }
        
       	//description
       	var r = dc.getWidth()/2;
       	var x = r - Math.sqrt(Math.pow(r, 2)-Math.pow(r - y, 2));
       	dc.drawText(x, y, Graphics.FONT_SYSTEM_TINY, data[DESCRIPTION], Graphics.TEXT_JUSTIFY_LEFT);
       	y += dc.getFontHeight(Graphics.FONT_SYSTEM_TINY);
       	
       	//temperature
       	var temp = data[TEMP];

       	dc.setColor(Tools.getTempColor(temp) , Graphics.COLOR_TRANSPARENT);
       	var unit = "C";
		if (System.getDeviceSettings().temperatureUnits == System.UNIT_STATUTE){
			unit = "F";
		}
       	
       	dc.drawText(halfWidth/2, y, fontMed,temp.format("%d")+"°"+unit, Graphics.TEXT_JUSTIFY_CENTER);
        
        var h = dc.getFontHeight(fontMed);
       	var wind = new WindDirectionField({:x => halfWidth, :y => y, :h => h, :w => h, :color => Tools.getWindColor(data[WIND_SPEED])});
       	wind.draw(dc, data[WIND_DEG]);
       	
       	var wSpeed = Tools.windSpeedConvert(data[WIND_SPEED]);
       	x = dc.getWidth()- 5 - Tools.max(dc.getTextWidthInPixels(wSpeed[:valueString], fontSmall), dc.getTextWidthInPixels(wSpeed[:unit], fontSmall));
       	dc.drawText(x, y, fontSmall,wSpeed[:valueString], Graphics.TEXT_JUSTIFY_LEFT);
       	dc.drawText(x, y + dc.getFontHeight(fontSmall), fontSmall, wSpeed[:unit], Graphics.TEXT_JUSTIFY_LEFT);
       	
       	y += h;
       	dc.setColor(Tools.getForegroundColor(), Graphics.COLOR_TRANSPARENT);
       	dc.drawLine(0, y, dc.getWidth(), y);
       	x = dc.getWidth()/2;
       	dc.drawLine(x, y, x, dc.getHeight());
       	
       	var offset = 5;
       	var field = Tools.getValueByFieldType(Application.Properties.getValue("FT0"), data);
       	dc.drawText(x-offset, y+offset, fontSmall, field[1], Graphics.TEXT_JUSTIFY_RIGHT);
       	dc.drawText(x-offset, y+offset+dc.getFontHeight(fontSmall), fontSmall, field[0], Graphics.TEXT_JUSTIFY_RIGHT);
       	 
		field = Tools.getValueByFieldType(Application.Properties.getValue("FT1"), data);
       	dc.drawText(x+offset, y+offset, fontSmall, field[1], Graphics.TEXT_JUSTIFY_LEFT);
       	dc.drawText(x+offset, y+offset+dc.getFontHeight(fontSmall), fontSmall, field[0], Graphics.TEXT_JUSTIFY_LEFT);
       	 
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
			Tools.setStorage(storageKey, dict);
			globalCache[storageKey] = dict;
			WatchUi.requestUpdate();
		}
	}
}
class CurrenInputDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }
	
	function onKey(keyEvent){
		
		var key = keyEvent.getKey();
		if (keyEvent.getKey() == WatchUi.KEY_ENTER){
			showMenuDaily();
		}else if (keyEvent.getKey() == WatchUi.KEY_UP){
			showMenuDaily();
		}else if (keyEvent.getKey() == WatchUi.KEY_DOWN){
			showMenuHourly();
		}else{
			System.exit();
		}
		return false;
	}
	
	function showMenuHourly(){
		if (System.getSystemStats().totalMemory > 62000){
			WatchUi.pushView(new WeatherMenuHourly(), new EmptyDelegate(), WatchUi.SLIDE_IMMEDIATE);
		}else{
			WatchUi.pushView(new WeatherMenuDaily(), new WeatherMenuDelegate(), WatchUi.SLIDE_IMMEDIATE);
		}    	
	}
	
	function onTap(clickEvent){
		showMenuDaily();
		return false;
	}
	
	function showMenuDaily(){
		WatchUi.pushView(new WeatherMenuDaily(), new WeatherMenuDelegate(), WatchUi.SLIDE_IMMEDIATE);
	}
}
