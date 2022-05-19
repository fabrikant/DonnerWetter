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
    }

	function onUpdate(dc) {
        
		var bColor = Tools.getBackgroundColor();
        var fColor = Tools.getForegroundColor();
        
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
}