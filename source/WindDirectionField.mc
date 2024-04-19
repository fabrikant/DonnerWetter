using Toybox.System;
using Toybox.Graphics;

class WindDirectionField {
  protected var x, y, w, h, color;

  function initialize(params) {
    self.x = params[:x];
    self.y = params[:y];
    self.w = params[:w];
    self.h = params[:h];
    self.color = params[:color];
    if (self.color == null) {
      self.color = Graphics.COLOR_BLACK;
    }
  }

  function draw(dc, direction) {
    if (direction != -1) {
      dc.setColor(getColor(), Graphics.COLOR_TRANSPARENT);
      var windDirection = windDirection(h * 0.8, direction.toNumber(), [x, y]);
      dc.fillPolygon(windDirection);
    }
  }

  //arraySize = [x,y,w,h]
  function drawToCenter(dc, direction, arraySize) {
    if (direction != -1) {
      dc.setColor(getColor(), Graphics.COLOR_TRANSPARENT);
      var windDirection = windDirection(h * 0.8, direction.toNumber(), [x, y]);
      var minXY = [99999, 99999];
      var maxXY = [-9999, -9999];
      for (var i = 0; i < windDirection.size(); i++) {
        if (maxXY[0] < windDirection[i][0]) {
          maxXY[0] = windDirection[i][0];
        }
        if (maxXY[1] < windDirection[i][1]) {
          maxXY[1] = windDirection[i][1];
        }
        if (minXY[0] > windDirection[i][0]) {
          minXY[0] = windDirection[i][0];
        }
        if (minXY[1] > windDirection[i][1]) {
          minXY[1] = windDirection[i][1];
        }
      }
      var windW = maxXY[0] - minXY[0];
      var windH = maxXY[1] - minXY[1];
      var offsetX = arraySize[0] - minXY[0] + (arraySize[2] - windW) / 2;
      var offsetY = arraySize[1] - minXY[1] + (arraySize[3] - windH) / 2;
      for (var i = 0; i < windDirection.size(); i++) {
        windDirection[i] = [
          windDirection[i][0] + offsetX,
          windDirection[i][1] + offsetY,
        ];
      }
      dc.fillPolygon(windDirection);
    }
  }

  private function windDirection(size, angle, leftTop) {
    var angleRad = Math.toRadians(angle);
    var centerPoint = [size / 2, size / 2];
    var coords = [
      [0 + size / 8, 0],
      [size / 2, size],
      [size - size / 8, 0],
      [size / 2, size / 4],
    ];
    var result = new [4];
    var cos = Math.cos(angleRad);
    var sin = Math.sin(angleRad);
    var min = [99999, 99999];
    var maxY = -99999;
    // Transform the coordinates
    for (var i = 0; i < coords.size(); i += 1) {
      var x = coords[i][0] * cos - coords[i][1] * sin + 0.5;
      var y = coords[i][0] * sin + coords[i][1] * cos + 0.5;
      result[i] = [centerPoint[0] + x, centerPoint[1] + y];
      if (min[0] > result[i][0]) {
        min[0] = result[i][0];
      }
      if (min[1] > result[i][1]) {
        min[1] = result[i][1];
      }
      if (maxY < result[i][1]) {
        maxY = result[i][1];
      }
    }
    //To LEFT TOP Corner
    var offset = [leftTop[0] - min[0], leftTop[1] - min[1]];
    offset[1] += (size - (maxY - min[1])) / 2 + 2;

    for (var i = 0; i < coords.size(); i += 1) {
      result[i][0] = result[i][0] + offset[0];
      result[i][1] = result[i][1] + offset[1];
    }
    return result;
  }

  function getColor() {
    return self.color;
  }
}
