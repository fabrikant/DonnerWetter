using Toybox.Lang;
using Toybox.System;
using Toybox.Application;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Graphics;
using Toybox.Math;

enum {
  ID,
  ICON,
  TEMP,
  TEMP_MIN,
  TEMP_MAX,
  WIND_DEG,
  WIND_SPEED,
  DATE,
  DESCRIPTION,
  HUMIDITY,
  PRESSURE,

  STORAGE_KEY_CURRENT,
  STORAGE_KEY_DAILY,
  STORAGE_KEY_HOURLY,
}

(:glance)
module GlanceTools {
  function getBackgroundColor() {
    if (Application.Properties.getValue("Theme") == 0) {
      return Graphics.COLOR_WHITE;
    } else {
      return Graphics.COLOR_BLACK;
    }
  }

  function getForegroundColor() {
    if (Application.Properties.getValue("Theme") == 0) {
      return Graphics.COLOR_BLACK;
    } else {
      return Graphics.COLOR_WHITE;
    }
  }
}

module Tools {
  function getBackgroundColor() {
    return GlanceTools.getBackgroundColor();
  }

  function getForegroundColor() {
    return GlanceTools.getForegroundColor();
  }

  function getValueByFieldType(type, data) {
    var res = ["", ""]; //EMPTY

    if (type == HUMIDITY) {
      res = [
        data[HUMIDITY].format("%d") + "%",
        Application.loadResource(Rez.Strings.Humidity),
      ];
    } else if (type == PRESSURE) {
      res = [
        Tools.pressureToString(data[PRESSURE]),
        Application.loadResource(Rez.Strings.Pressure),
      ];
    }
    return res;
  }

  ///////////////////////////////////////////////////////////////////////////
  function distanceToString(rawData) {
    rawData = rawData.toNumber(); //meters
    var value = rawData;
    if (System.getDeviceSettings().distanceUnits == System.UNIT_METRIC) {
      /*km*/
      value = rawData / 1000.0;
    } else {
      /*mile*/
      value = rawData / 1609.344;
    }
    return value.format("%.2f");
  }

  ///////////////////////////////////////////////////////////////////////////
  function pressureToString(rawData) {
    rawData *= 100;
    var value = rawData; /*Pa */
    var unit = Application.Properties.getValue("PressureUnit");
    if (unit == 0) {
      /*MmHg*/
      value = Math.round(rawData / 133.322).format("%d");
    } else if (unit == 1) {
      /*Psi*/
      value = (rawData.toFloat() / 6894.757).format("%.2f");
    } else if (unit == 2) {
      /*InchHg*/
      value = (rawData.toFloat() / 3386.389).format("%.2f");
    } else if (unit == 3) {
      /*miliBar*/
      value = (rawData / 100).format("%d");
    } else if (unit == 4) {
      /*kPa*/
      value = (rawData / 1000).format("%d");
    }
    return value;
  }

  ///////////////////////////////////////////////////////////////////////////
  function getStorage(key, defaultValue) {
    var currentValue = globalCache[key];
    if (currentValue == null) {
      currentValue = Application.Storage.getValue(key);
      globalCache[key] = currentValue;
    }
    if (currentValue == null) {
      return defaultValue;
    } else {
      return currentValue;
    }
  }

  ///////////////////////////////////////////////////////////////////////////
  function infoToString(info) {
    var hours = info.hour;
    if (!System.getDeviceSettings().is24Hour) {
      if (hours > 12) {
        hours = hours - 12;
      }
    }
    var f = "%02d";
    return hours.format(f) + ":" + info.min.format(f);
  }

  ///////////////////////////////////////////////////////////////////////////
  function createEmptyDrawable(id) {
    return new Toybox.WatchUi.Drawable({
      :identifier => id,
      :locX => 0,
      :locY => 0,
      :width => 0,
      :height => 0,
    });
  }

  ///////////////////////////////////////////////////////////////////////////
  function max(a, b) {
    if (a > b) {
      return a;
    } else {
      return b;
    }
  }

  ///////////////////////////////////////////////////////////////////////////
  function min(a, b) {
    if (a < b) {
      return a;
    } else {
      return b;
    }
  }

  ///////////////////////////////////////////////////////////////////////////
  function windSpeedConvert(rawData) {
    var unit = Application.Properties.getValue("WindSpeedUnit");
    var value = 0;
    var valueString = "";
    var unitName = "";
    rawData = rawData.toDouble();
    if (System.getDeviceSettings().temperatureUnits == System.UNIT_STATUTE) {
      rawData /= 2.237;
    }

    if (unit == 0) {
      value = rawData;
      valueString = value.format("%d");
      unitName = Application.loadResource(Rez.Strings.SpeedUnitMSec);
    } else if (unit == 1) {
      /*km/h*/
      value = rawData * 3.6;
      valueString = value.format("%d");
      unitName = Application.loadResource(Rez.Strings.SpeedUnitKmH);
    } else if (unit == 2) {
      /*mile/h*/
      value = rawData * 2.237;
      valueString = value.format("%d");
      unitName = Application.loadResource(Rez.Strings.SpeedUnitMileH);
    } else if (unit == 3) {
      /*ft/s*/
      value = rawData * 3.281;
      valueString = value.format("%d");
      unitName = Application.loadResource(Rez.Strings.SpeedUnitFtSec);
    } else if (unit == 4) {
      /*Beaufort*/
      value = getBeaufort(rawData);
      valueString = value.format("%d");
      unitName = Application.loadResource(Rez.Strings.SpeedUnitBof);
    } else if (unit == 5) {
      /*knots*/
      value = rawData * 1.944;
      valueString = value.format("%d");
      unitName = Application.loadResource(Rez.Strings.SpeedUnitKnots);
    }

    return { :value => value, :unit => unitName, :valueString => valueString };
  }

  ///////////////////////////////////////////////////////////////////////////
  function getBeaufort(rawData) {
    if (rawData >= 33) {
      return 12;
    } else if (rawData >= 28.5) {
      return 11;
    } else if (rawData >= 24.5) {
      return 10;
    } else if (rawData >= 20.8) {
      return 9;
    } else if (rawData >= 17.2) {
      return 8;
    } else if (rawData >= 13.9) {
      return 7;
    } else if (rawData >= 10.8) {
      return 6;
    } else if (rawData >= 8) {
      return 5;
    } else if (rawData >= 5.5) {
      return 4;
    } else if (rawData >= 3.4) {
      return 3;
    } else if (rawData >= 1.6) {
      return 2;
    } else if (rawData >= 0.3) {
      return 1;
    } else {
      return 0;
    }
  }

  ///////////////////////////////////////////////////////////////////////////
  function getWindColor(windSpeed) {
    var color = GlanceTools.getForegroundColor();
    if (Application.Properties.getValue("WindAutocolor")) {
      if (System.getDeviceSettings().temperatureUnits == System.UNIT_STATUTE) {
        windSpeed /= 2.237;
      }
      var bf = getBeaufort(windSpeed);
      var backIsLight = true;
      if (Application.Properties.getValue("Theme") != 0) {
        backIsLight = false;
      }

      if (backIsLight) {
        if (bf > 9) {
          color = 0xaa0000;
        } else if (bf > 8) {
          color = 0xaa0055;
        } else if (bf > 7) {
          color = 0xaa00aa;
        } else if (bf > 6) {
          color = 0x5500ff;
        } else if (bf > 5) {
          color = 0x5555ff;
        } else if (bf > 4) {
          color = Graphics.COLOR_ORANGE;
        } else if (bf > 3) {
          color = 0x005500;
        } else if (bf > 2) {
          color = 0x00aa00;
        } else {
          color = Graphics.COLOR_DK_GRAY;
        }
      } else {
        if (bf > 9) {
          color = 0xff0000;
        } else if (bf > 8) {
          color = 0xff00aa;
        } else if (bf > 7) {
          color = 0xffaaff;
        } else if (bf > 6) {
          color = 0x00ffff;
        } else if (bf > 5) {
          color = 0xaaffff;
        } else if (bf > 4) {
          color = Graphics.COLOR_YELLOW;
        } else if (bf > 3) {
          color = 0x00ff00;
        } else if (bf > 2) {
          color = 0x55ff55;
        } else {
          color = Graphics.COLOR_WHITE;
        }
      }
    }
    return color;
  }

  ///////////////////////////////////////////////////////////////////////////
  function getTempColor(temp) {
    var color = GlanceTools.getForegroundColor();
    if (Application.Properties.getValue("TempAutocolor")) {
      if (System.getDeviceSettings().temperatureUnits == System.UNIT_STATUTE) {
        temp = ((temp - 32) * 5) / 9;
      }

      var backIsLight = true;
      if (Application.Properties.getValue("Theme") != 0) {
        backIsLight = false;
      }

      if (backIsLight) {
        if (temp > 30) {
          color = 0xaa0000;
        } else if (temp > 25) {
          color = 0xff0055;
        } else if (temp > 20) {
          color = 0xff5500;
        } else if (temp > 15) {
          color = 0x005500;
        } else if (temp > 10) {
          color = 0x555500;
        } else if (temp > 5) {
          color = 0xaa5500;
        } else if (temp > 0) {
          color = 0xff5500;
        } else if (temp > -10) {
          color = 0x0000ff;
        } else if (temp > -20) {
          color = 0x0000aa;
        } else {
          color = 0x000055;
        }
      } else {
        if (temp > 30) {
          color = 0xff0000;
        } else if (temp > 25) {
          color = 0xff0055;
        } else if (temp > 20) {
          color = 0x00ff00;
        } else if (temp > 15) {
          color = 0x00ff55;
        } else if (temp > 10) {
          color = 0x55ff00;
        } else if (temp > 5) {
          color = 0xffff00;
        } else if (temp > 0) {
          color = 0xffffaa;
        } else if (temp > -10) {
          color = 0xaaffff;
        } else if (temp > -20) {
          color = 0x55ffff;
        } else {
          color = 0x00ffff;
        }
      }
    }
    return color;
  }
}
