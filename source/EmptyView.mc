using Toybox.System;
using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.Position;

///////////////////////////////////////////////////////////////////////////////
//View Empty Directory
class EmptyView extends WatchUi.View {
  var gpsOn;

  function initialize() {
    gpsOn = true;
    Position.enableLocationEvents(
      Position.LOCATION_ONE_SHOT,
      method(:onPosition)
    );
    View.initialize();
  }

  function onUpdate(dc) {
    var gpsStatus = "\n" + "gps: " + (gpsOn ? "on" : "off");

    var message =
      gpsStatus +
      "\nlat: " +
      Application.Properties.getValue("Lat") +
      "\nlon: " +
      Application.Properties.getValue("Lon") +
      "\nkey:\n" +
      Application.Properties.getValue("keyOW") +
      "\n";
    dc.setColor(Tools.getBackgroundColor(), Graphics.COLOR_WHITE);
    dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
    dc.setColor(Tools.getForegroundColor(), Graphics.COLOR_TRANSPARENT);
    dc.drawText(
      dc.getWidth() / 2,
      dc.getHeight() / 2,
      Graphics.FONT_SYSTEM_MEDIUM,
      message,
      Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
    );
  }

  function onShow() {
    var location = Activity.getActivityInfo().currentLocation;
    if (location != null) {
      location = location.toDegrees();
      Application.Properties.setValue("Lat", location[0].toFloat());
      Application.Properties.setValue("Lon", location[1].toFloat());
      WatchUi.requestUpdate();
    }
  }

  function onPosition(info) {
    gpsOn = false;
    var location = info.position.toDegrees();
    Application.Properties.setValue("Lat", location[0].toFloat());
    Application.Properties.setValue("Lon", location[1].toFloat());
    WatchUi.requestUpdate();
  }
}

class ExitOnSelectDelegate extends WatchUi.BehaviorDelegate {
  function initialize() {
    BehaviorDelegate.initialize();
  }

  function onSelect() {
    System.exit();
  }
}
