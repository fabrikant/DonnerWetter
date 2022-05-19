using Toybox.Background;
using Toybox.Communications;
using Toybox.System;
using Toybox.Position;
using Toybox.Time;

class WeatherForecast {
	
	var lat, lon, appid;
	
	function initialize() {
		self.lat = Tools.getProperty("Lat");
		self.lon = Tools.getProperty("Lon");
		self.appid = Tools.getProperty("keyOW");
    }

	function startRequest(type, callback){
		
		var exclude = "current,minutely,hourly,daily";
		exclude = Tools.stringReplace(exclude, type, "");
		exclude = Tools.stringReplace(exclude, ",,", ",");
		
		var units = "metric";
		if (System.getDeviceSettings().temperatureUnits == System.UNIT_STATUTE){
			units = "imperial";
		}
		
		var url = "https://api.openweathermap.org/data/2.5/onecall";
		var parametres = {
			"lat" => lat,
			"lon" => lon,
			"appid" => appid,
			"units" => units,
			"exclude" => exclude,
			"lang" => getLang()
		};
		var options = {};
		var req = new RequestDelegate(self.method(:onResponse), callback);
		req.makeWebRequest(url, parametres, options);
		 
	} 
	
	function startRequestCurrent(callback) {

		var url = "https://api.openweathermap.org/data/2.5/weather";
		var units = "metric";
		if (System.getDeviceSettings().temperatureUnits == System.UNIT_STATUTE){
			units = "imperial";
		}
		var parametres =	{
			"lat" => lat,
			"lon" => lon,
			"appid" => appid,
			"units" => units,
			"lang" => getLang()				
		};
		var req = new RequestDelegate(self.method(:onResponse), callback);
		req.makeWebRequest(url, parametres, {});
	}


	function setCoord(){
		lat = Tools.getProperty("Lat"); 
		lon = Tools.getProperty("Lon");
	}
	
	function onResponse(code, data, context){
		context.invoke(code, data);
	}

	function getLang(){
		
		var res = "en";
		var sysLang = System.getDeviceSettings().systemLanguage;
		
		if (sysLang == System.LANGUAGE_ARA){
			res = "ar";
		}else if (sysLang  == System.LANGUAGE_BUL){
			res = "bg";		
		}else if (sysLang == System.LANGUAGE_CES){
			res = "cz";		
		}else if (sysLang == System.LANGUAGE_CHS){
			res = "zh_cn";		
		}else if (sysLang == System.LANGUAGE_CHT){
			res = "zh_tw";		
		}else if (sysLang == System.LANGUAGE_DAN){
			res = "da";		
		}else if (sysLang == System.LANGUAGE_DEU){
			res = "de";		
		}else if (sysLang == System.LANGUAGE_DUT){
			res = "de";		
		}else if (sysLang == System.LANGUAGE_FIN){
			res = "fi";		
		}else if (sysLang == System.LANGUAGE_FRE){
			res = "fr";		
		}else if (sysLang == System.LANGUAGE_GRE){
			res = "el";		
		}else if (sysLang == System.LANGUAGE_HEB){
			res = "he";		
		}else if (sysLang == System.LANGUAGE_HRV){
			res = "hr";		
		}else if (sysLang == System.LANGUAGE_HUN){
			res = "hu";		
		}else if (sysLang == System.LANGUAGE_IND){
			res = "hi";		
		}else if (sysLang == System.LANGUAGE_ITA){
			res = "it";		
		}else if (sysLang == System.LANGUAGE_JPN){
			res = "ja";		
		}else if (sysLang == System.LANGUAGE_KOR){
			res = "	kr";		
		}else if (sysLang == System.LANGUAGE_LAV){
			res = "la";		
		}else if (sysLang == System.LANGUAGE_LIT){
			res = "lt";		
		}else if (sysLang == System.LANGUAGE_NOB){
			res = "no";		
		}else if (sysLang == System.LANGUAGE_POL){
			res = "pl";		
		}else if (sysLang == System.LANGUAGE_POR){
			res = "pt";		
		}else if (sysLang == System.LANGUAGE_RON){
			res = "ro";		
		}else if (sysLang == System.LANGUAGE_RUS){
			res = "ru";		
		}else if (sysLang == System.LANGUAGE_SLO){
			res = "sk";		
		}else if (sysLang == System.LANGUAGE_SLV){
			res = "	sl";		
		}else if (sysLang == System.LANGUAGE_SPA){
			res = "sp";		
		}else if (sysLang == System.LANGUAGE_SWE){
			res = "sv";		
		}else if (sysLang == System.LANGUAGE_THA){
			res = "th";		
		}else if (sysLang == System.LANGUAGE_TUR){
			res = "tr";		
		}else if (sysLang == System.LANGUAGE_UKR){
			res = "ua";		
		}else if (sysLang == System.LANGUAGE_VIE){
			res = "vi";		
		}else if (sysLang == System.LANGUAGE_ZSM){
			res = "zu";		
		}
		return res;
	}
	
}