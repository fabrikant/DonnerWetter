using Toybox.System;
using Toybox.Graphics;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Application;
using Toybox.Lang;

class WeatherMenuHourly extends WeatherMenu{

	function initialize(){
		storageKey = STORAGE_KEY_HOURLY;
		var itemHeight = Tools.max(Graphics.getFontHeight(fontSmall) * 2, Graphics.getFontHeight(fontMed));
		WeatherMenu.initialize(itemHeight);
	}

	function addItems(){
		var data = Tools.getStorage(storageKey, null);
		var dataSize = 1;
		if (data != null){
			dataSize = data.size();
		}
		var interval = Application.Properties.getValue("HourlyIntrval");
		for (var i = itemsCount; i < dataSize; i+=interval){
			itemsCount = i+1;
			addItem(new WeatherMenuItemHourly(i, storageKey, self));
		}
	}

	function getTitleText(){
		return Application.loadResource(Rez.Strings.ForecastHourly);
	}
}

class WeatherMenuItemHourly extends WeatherMenuItem{

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
		
        var columnInterval = 10;
        var x = columnInterval;
        var y = 0;
        var halfY = dc.getHeight()/2; 
        var fontH = Graphics.getFontHeight(fontSmall);
  
        //Date
        var dt = new Time.Moment(data[DATE]);
        var info = Gregorian.info(dt, Time.FORMAT_MEDIUM);
        x += drawDate(dc, x, y, info)+columnInterval;
        
        //image
        var image = Icons.getImage(data[ID], data[ICON], true);
        if (image != null){
       		dc.drawBitmap(x, (dc.getHeight()-image.getDc().getHeight())/2, image);
        	x += image.getDc().getWidth()+columnInterval;
        }
        
        //Temperature
		var tmp = getTemperature(data);
		var tempW = dc.getTextWidthInPixels("-40°", fontMed); 
		dc.setColor(Tools.getTempColor(data[TEMP]) , Graphics.COLOR_TRANSPARENT);
		dc.drawText(x+tempW/2, halfY, fontMed, tmp, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
		x += tempW; 
		
		//Wind
		var windArSize = dc.getHeight()/2;
		var wind = new WindDirectionField(
			{:x => x,:y => 0, :h => windArSize, :w=> windArSize, :color => Tools.getWindColor(data[WIND_SPEED])}
		);
		wind.drawToCenter(dc, data[WIND_DEG], [x, 0,windArSize ,dc.getHeight()-Graphics.getFontHeight(fontSmall)]);
		
		//Wind speed
		var wSpeed = Tools.windSpeedConvert(data[WIND_SPEED]);
		//var wSpeedString = Lang.format("$1$ $2$", [wSpeed[:valueString], wSpeed[:unit]]);
		var wSpeedString = wSpeed[:valueString];
		var wSpeedStringW = dc.getTextWidthInPixels(wSpeedString, fontSmall);
		if (wSpeedStringW > dc.getWidth()-x){
			dc.drawText(dc.getWidth(), dc.getHeight()-Graphics.getFontHeight(fontSmall), fontSmall, wSpeedString, Graphics.TEXT_JUSTIFY_RIGHT);
		}else{
			dc.drawText(x, dc.getHeight()-Graphics.getFontHeight(fontSmall), fontSmall, wSpeedString, Graphics.TEXT_JUSTIFY_LEFT);
		}
		
		border(dc);
	}

	function drawDate(dc, x, y, info){
        var fontH = Graphics.getFontHeight(fontSmall);
		var time = Tools.infoToString(info);
		y += (dc.getHeight()-y-2*fontH)/2;
        dc.drawText(x, y, fontSmall, info.day_of_week, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(x, y + fontH, fontSmall, time, Graphics.TEXT_JUSTIFY_LEFT);
        return dc.getTextWidthInPixels(time, fontSmall);
	}

	function getTemperature(data){
		return data[TEMP].format("%d")+"°";
	}

}