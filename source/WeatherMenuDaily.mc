using Toybox.System;
using Toybox.Graphics;
using Toybox.Time;
using Toybox.Time.Gregorian;

class WeatherMenuDaily extends WeatherMenu{
	
	function initialize(){
		storageKey = STORAGE_KEY_DAILY; 
		var itemHeight = Graphics.getFontHeight(fontSmall) * 2 + Graphics.getFontHeight(fontMed);
		WeatherMenu.initialize(itemHeight);
	}

	function addItems(){
		//var data = Tools.getStorage(storageKey, null);
		var data = Application.Storage.getValue(storageKey);
		var dataSize = 1;
		if (data != null){
			dataSize = data.size();
		}
		for (var i = itemsCount; i < dataSize; i++){
			itemsCount = i+1;
			addItem(new WeatherMenuItemDaily(i, storageKey, self));
		}
	}
	
	function getTitleText(){
		return Application.loadResource(Rez.Strings.ForecastDaily);
	}
}

class WeatherMenuItemDaily extends WeatherMenuItem{
	
	function initialize(identifier, key, owner){
		WeatherMenuItem.initialize(identifier, key, owner);
	}

	function draw(dc){
		
		var data = Tools.getStorage(storageKey, null);
		dc.setColor(Tools.getBackgroundColor(), Tools.getBackgroundColor());
		dc.clear();
		dc.setColor(Tools.getForegroundColor(), Graphics.COLOR_TRANSPARENT);

		if (data == null){
			border(dc);
			return;
		}
		
		data = data[getId()];
		
        var size = 1;
        
        var columnInterval = 10;
        var x = columnInterval;
        var y = 0;
        var halfY = dc.getHeight()/2; 
        var fontH = Graphics.getFontHeight(fontSmall);
  
        //Image
        var image = Icons.getImage(data[ID], data[ICON], true);
        if (image != null){
        	var imageH = image.getDc().getHeight();
        	var offset = (dc.getHeight()-imageH-2*Graphics.getFontHeight(fontSmall))/2; 
        	y = offset; 
        	dc.drawBitmap(x, y, image);
        	y += image.getDc().getHeight()+offset;
         }
 
        //Date
        var dt = new Time.Moment(data[DATE]);
        var info = Gregorian.info(dt, Time.FORMAT_MEDIUM);
        x += drawDate(dc, x, y, info)+columnInterval;
        
        //Temperature size calculate
		var tmpEve = getTemperature(data,TEMP);
		var xOffset = Tools.max(0, x+dc.getTextWidthInPixels(tmpEve, fontMed));
		var tmpMax = getTemperature(data,TEMP_MAX);
		xOffset = Tools.max(xOffset, x+dc.getTextWidthInPixels(tmpMax, fontSmall));
		var tmpMin = getTemperature(data,TEMP_MIN);
		xOffset = Tools.max(xOffset, x+dc.getTextWidthInPixels(tmpMin, fontSmall));
		//Temperature draw
		y = 0; 
		dc.setColor(Tools.getTempColor(data[TEMP]) , Graphics.COLOR_TRANSPARENT);
		dc.drawText(x, y, fontMed, tmpEve, Graphics.TEXT_JUSTIFY_LEFT);
		y += dc.getFontHeight(fontMed);
		dc.setColor(Tools.getForegroundColor(), Graphics.COLOR_TRANSPARENT);
		dc.drawText(x, y, fontSmall, tmpMax, Graphics.TEXT_JUSTIFY_LEFT);
		y += dc.getFontHeight(fontSmall);
		dc.drawText(x, y, fontSmall, tmpMin, Graphics.TEXT_JUSTIFY_LEFT);

		//Wind
		var windArSize = Graphics.getFontHeight(fontMed);
		y = 0;
		x = xOffset + columnInterval;
		var wind = new WindDirectionField(
			{:x => x,
			:y => y, 
			:h => windArSize, 
			:w=> windArSize, 
			:color => Tools.getWindColor(data[WIND_SPEED])}
		);
		wind.drawToCenter(dc,data[WIND_DEG], [x, y, dc.getWidth()-x, Graphics.getFontHeight(fontMed)]);
		
		//Wind speed
		var wSpeed = Tools.windSpeedConvert(data[WIND_SPEED]);
		var tmp = wSpeed[:valueString]+" "+wSpeed[:unit];
		
		dc.drawText(x+(dc.getWidth()-x)/2, Graphics.getFontHeight(fontMed), fontSmall,tmp, Graphics.TEXT_JUSTIFY_CENTER);
		border(dc);
	}
	
	function drawDate(dc, x, y, info){
        var fontH = Graphics.getFontHeight(fontSmall);
		var tmp = info.month+" "+info.day;
        dc.drawText(x, y, fontSmall, info.day_of_week, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(x, y + fontH, fontSmall, tmp, Graphics.TEXT_JUSTIFY_LEFT);
        return dc.getTextWidthInPixels(tmp, fontSmall);
	}
	
	function getTemperature(data, type){
		
		var typeDescr = "";
		var unit = "";
		if(type == TEMP){
			if (System.getDeviceSettings().temperatureUnits == System.UNIT_STATUTE){
				unit = "F";
			}else{
				unit = "C";
			}
		}else if (type == TEMP_MIN){
			typeDescr = Application.loadResource(Rez.Strings.Min)+": ";
		}else if (type == TEMP_MAX){
			typeDescr = Application.loadResource(Rez.Strings.Max)+": ";
		}
	
		return typeDescr + data[type].format("%d")+"°"+unit;
	}
}