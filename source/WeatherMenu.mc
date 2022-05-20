using Toybox.WatchUi;
using Toybox.System;
using Toybox.Graphics;
using Toybox.Application;

class WeatherMenu extends WatchUi.CustomMenu{
	
	protected var storageKey;
	protected var itemsCount;
	var weatherForecast;
	
	function initialize(itemHeight){
		itemsCount = 0;
		weatherForecast = new WeatherForecast();
		weatherForecast.startRequest(storageKey, self.method(:onWeatherUpdate));
		CustomMenu.initialize(itemHeight, Tools.getBackgroundColor(), {});
		addItems();
	}
	
	function drawTitle(dc){
		dc.setColor(Tools.getBackgroundColor(), Tools.getBackgroundColor());
		dc.clear();
		dc.setColor(Tools.getForegroundColor(), Graphics.COLOR_TRANSPARENT);
		dc.drawText(
			dc.getWidth()/2, 
			dc.getHeight()/2, 
			fontSmall, 
			getTitleText(), 
			Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
		);
	}
	
	function onWeatherUpdate(code, data){
		if (code == 200){
			var dataArray = [];
			if (storageKey == STORAGE_KEY_DAILY){
				var owmArray = data["daily"];
				for(var i = 0; i<owmArray.size(); i++){
					dataArray.add({
						ID => owmArray[i]["weather"][0]["id"],
						ICON => owmArray[i]["weather"][0]["icon"],
						TEMP => owmArray[i]["temp"]["eve"],
						TEMP_MIN => owmArray[i]["temp"]["min"],
						TEMP_MAX => owmArray[i]["temp"]["max"],
						WIND_DEG => owmArray[i]["wind_deg"],
						WIND_SPEED =>owmArray[i]["wind_speed"],
						DATE => owmArray[i]["dt"]});
				}
			}else{
				var owmArray = data["hourly"];
				for(var i = 0; i<owmArray.size(); i++){
					dataArray.add({
						ID => owmArray[i]["weather"][0]["id"],
						ICON => owmArray[i]["weather"][0]["icon"],
						TEMP => owmArray[i]["temp"],
						WIND_DEG => owmArray[i]["wind_deg"],
						WIND_SPEED =>owmArray[i]["wind_speed"],
						DATE => owmArray[i]["dt"]});
				}
			}
			Application.Storage.setValue(storageKey, dataArray);
			globalCache[storageKey] = dataArray;
			addItems();
			WatchUi.requestUpdate();
		}
	}
	
}

class WeatherMenuItem extends WatchUi.CustomMenuItem{
	
	protected var storageKey;
	protected var ownerMenu;
	
	function initialize(identifier, key, owner){
		storageKey = key;
		ownerMenu = owner;
		CustomMenuItem.initialize(identifier, {:drawable => Tools.createEmptyDrawable(identifier)});
	}

    function border(targetDc){
	    targetDc.setColor(Tools.getForegroundColor(), Graphics.COLOR_TRANSPARENT);
		targetDc.drawRectangle(0, 0, targetDc.getWidth(), targetDc.getHeight());
	}
	
}

class WeatherMenuDelegate extends WatchUi.Menu2InputDelegate {
	
	function initialize(){
		Menu2InputDelegate.initialize();	
	}
	
	function onSelect(item){
		if (System.getSystemStats().totalMemory > 62000){
			WatchUi.pushView(new WeatherMenuHourly(), new EmptyDelegate(), WatchUi.SLIDE_IMMEDIATE);
		}    	
	}
}

class EmptyDelegate extends WatchUi.Menu2InputDelegate {
	function initialize(){
		Menu2InputDelegate.initialize();	
	}
}
