using Toybox.Application;
using Toybox.Graphics;
using Toybox.System;

(:glance)
module Icons {
  function getImage(id, icon, small) {
    var key = id.toString() + icon + small;
    var image = globalCache[key];
    if (image == null) {
      var res = findResByCode(id, icon, small);
      if (res == null) {
        res = small ? Rez.Drawables.Small_NA : Rez.Drawables.Big_NA;
      }
      image = createImage(res);
      globalCache[key] = image;
    }
    return image;
  }

  function createImage(resorse) {
    var _bitmap = Application.loadResource(resorse);
    if (Graphics has :createBufferedBitmap) {
      var _bufferedBitmapRef = Graphics.createBufferedBitmap({
        :bitmapResource => _bitmap,
        :width => _bitmap.getWidth(),
        :height => _bitmap.getHeight(),
      });
      var _bufferedBitmap = _bufferedBitmapRef.get();
      _bufferedBitmap.setPalette([
        GlanceTools.getForegroundColor(),
        Graphics.COLOR_TRANSPARENT,
      ]);
      return _bufferedBitmap;
    } else {
      var _bufferedBitmap = new Graphics.BufferedBitmap({
        :bitmapResource => _bitmap,
        :width => _bitmap.getWidth(),
        :height => _bitmap.getHeight(),
      });
      _bufferedBitmap.setPalette([
        GlanceTools.getForegroundColor(),
        Graphics.COLOR_TRANSPARENT,
      ]);
      return _bufferedBitmap;
    }
  }

  function findResByCode(id, icon, small) {
    var codes;
    if (id < 300) {
      codes = small ? codesSmall200() : codesBig200();
    } else if (id < 500) {
      codes = small ? codesSmall300() : codesBig300();
    } else if (id < 600) {
      codes = small ? codesSmall500() : codesBig500();
    } else if (id < 700) {
      codes = small ? codesSmall600() : codesBig600();
    } else if (id < 800) {
      codes = small ? codesSmall700() : codesBig700();
    } else {
      codes = small ? codesSmall800() : codesBig800();
    }

    var len = icon.length();
    var key = id.toString() + icon.substring(len - 1, len);

    return codes[key];
  }

  ///////////////////////////////////////////////////////////////////////////
  function codesBig200() {
    //Thunderstorm
    return {
      "200d" => Rez.Drawables.Big_200d,
      "200n" => Rez.Drawables.Big_200n,
      "201d" => Rez.Drawables.Big_201d,
      "201n" => Rez.Drawables.Big_201n,
      "202d" => Rez.Drawables.Big_202d,
      "202n" => Rez.Drawables.Big_202n,
      "210d" => Rez.Drawables.Big_210d,
      "210n" => Rez.Drawables.Big_210n,
      "211d" => Rez.Drawables.Big_211d,
      "211n" => Rez.Drawables.Big_211n,
      "212d" => Rez.Drawables.Big_212d,
      "212n" => Rez.Drawables.Big_212n,
      "221d" => Rez.Drawables.Big_221d,
      "221n" => Rez.Drawables.Big_221n,
      "230d" => Rez.Drawables.Big_230d,
      "230n" => Rez.Drawables.Big_230n,
      "231d" => Rez.Drawables.Big_231d,
      "231n" => Rez.Drawables.Big_231n,
      "232d" => Rez.Drawables.Big_232d,
      "232n" => Rez.Drawables.Big_232n,
    };
  }

  function codesBig300() {
    //Drizzle
    return {
      "300d" => Rez.Drawables.Big_300d,
      "300n" => Rez.Drawables.Big_300n,
      "301d" => Rez.Drawables.Big_301d,
      "301n" => Rez.Drawables.Big_301n,
      "302d" => Rez.Drawables.Big_302d,
      "302n" => Rez.Drawables.Big_302n,
      "310d" => Rez.Drawables.Big_310d,
      "310n" => Rez.Drawables.Big_310n,
      "311d" => Rez.Drawables.Big_311d,
      "311n" => Rez.Drawables.Big_311n,
      "312d" => Rez.Drawables.Big_312d,
      "312n" => Rez.Drawables.Big_312n,
      "313d" => Rez.Drawables.Big_313d,
      "313n" => Rez.Drawables.Big_313n,
      "314d" => Rez.Drawables.Big_314d,
      "314n" => Rez.Drawables.Big_314n,
      "321d" => Rez.Drawables.Big_321d,
      "321n" => Rez.Drawables.Big_321n,
    };
  }

  function codesBig500() {
    //Rain
    return {
      "500d" => Rez.Drawables.Big_500d,
      "500n" => Rez.Drawables.Big_500n,
      "501d" => Rez.Drawables.Big_501d,
      "501n" => Rez.Drawables.Big_501n,
      "502d" => Rez.Drawables.Big_502d,
      "502n" => Rez.Drawables.Big_502n,
      "503d" => Rez.Drawables.Big_503d,
      "503n" => Rez.Drawables.Big_503n,
      "504d" => Rez.Drawables.Big_504d,
      "504n" => Rez.Drawables.Big_504n,
      "511d" => Rez.Drawables.Big_511d,
      "511n" => Rez.Drawables.Big_511n,
      "520d" => Rez.Drawables.Big_520d,
      "520n" => Rez.Drawables.Big_520n,
      "521d" => Rez.Drawables.Big_521d,
      "521n" => Rez.Drawables.Big_521n,
      "522d" => Rez.Drawables.Big_522d,
      "522n" => Rez.Drawables.Big_522n,
      "531d" => Rez.Drawables.Big_531d,
      "531n" => Rez.Drawables.Big_531n,
    };
  }

  function codesBig600() {
    //Snow
    return {
      "600d" => Rez.Drawables.Big_600d,
      "600n" => Rez.Drawables.Big_600n,
      "601d" => Rez.Drawables.Big_601d,
      "601n" => Rez.Drawables.Big_601n,
      "602d" => Rez.Drawables.Big_602d,
      "602n" => Rez.Drawables.Big_602n,
      "611d" => Rez.Drawables.Big_611d,
      "611n" => Rez.Drawables.Big_611n,
      "612d" => Rez.Drawables.Big_612d,
      "612n" => Rez.Drawables.Big_612n,
      "613d" => Rez.Drawables.Big_613d,
      "613n" => Rez.Drawables.Big_613n,
      "615d" => Rez.Drawables.Big_615d,
      "615n" => Rez.Drawables.Big_615n,
      "616d" => Rez.Drawables.Big_616d,
      "616n" => Rez.Drawables.Big_616n,
      "620d" => Rez.Drawables.Big_620d,
      "620n" => Rez.Drawables.Big_620n,
      "621d" => Rez.Drawables.Big_621d,
      "621n" => Rez.Drawables.Big_621n,
      "622d" => Rez.Drawables.Big_622d,
      "622n" => Rez.Drawables.Big_622n,
    };
  }

  function codesBig700() {
    //Atmosphere
    return {
      "701d" => Rez.Drawables.Big_701d,
      "701n" => Rez.Drawables.Big_701n,
      "711d" => Rez.Drawables.Big_711d,
      "711n" => Rez.Drawables.Big_711n,
      "721d" => Rez.Drawables.Big_721d,
      "721n" => Rez.Drawables.Big_721n,
      "731d" => Rez.Drawables.Big_731d,
      "731n" => Rez.Drawables.Big_731n,
      "741d" => Rez.Drawables.Big_741d,
      "741n" => Rez.Drawables.Big_741n,
      "751d" => Rez.Drawables.Big_751d,
      "751n" => Rez.Drawables.Big_751n,
      "761d" => Rez.Drawables.Big_761d,
      "761n" => Rez.Drawables.Big_761n,
      "762d" => Rez.Drawables.Big_762d,
      "762n" => Rez.Drawables.Big_762n,
      "771d" => Rez.Drawables.Big_771d,
      "771n" => Rez.Drawables.Big_771n,
      "781d" => Rez.Drawables.Big_781d,
      "781n" => Rez.Drawables.Big_781n,
    };
  }

  function codesBig800() {
    //Cloud
    return {
      "800d" => Rez.Drawables.Big_800d,
      "800n" => Rez.Drawables.Big_800n,
      "801d" => Rez.Drawables.Big_801d,
      "801n" => Rez.Drawables.Big_801n,
      "802d" => Rez.Drawables.Big_802d,
      "802n" => Rez.Drawables.Big_802n,
      "803d" => Rez.Drawables.Big_803d,
      "803n" => Rez.Drawables.Big_803n,
      "804d" => Rez.Drawables.Big_804d,
      "804n" => Rez.Drawables.Big_804n,
    };
  }

  ///////////////////////////////////////////////////////////////////////////
  function codesSmall200() {
    //Thunderstorm
    return {
      "200d" => Rez.Drawables.Small_200d,
      "200n" => Rez.Drawables.Small_200n,
      "201d" => Rez.Drawables.Small_201d,
      "201n" => Rez.Drawables.Small_201n,
      "202d" => Rez.Drawables.Small_202d,
      "202n" => Rez.Drawables.Small_202n,
      "210d" => Rez.Drawables.Small_210d,
      "210n" => Rez.Drawables.Small_210n,
      "211d" => Rez.Drawables.Small_211d,
      "211n" => Rez.Drawables.Small_211n,
      "212d" => Rez.Drawables.Small_212d,
      "212n" => Rez.Drawables.Small_212n,
      "221d" => Rez.Drawables.Small_221d,
      "221n" => Rez.Drawables.Small_221n,
      "230d" => Rez.Drawables.Small_230d,
      "230n" => Rez.Drawables.Small_230n,
      "231d" => Rez.Drawables.Small_231d,
      "231n" => Rez.Drawables.Small_231n,
      "232d" => Rez.Drawables.Small_232d,
      "232n" => Rez.Drawables.Small_232n,
    };
  }

  function codesSmall300() {
    //Drizzle
    return {
      "300d" => Rez.Drawables.Small_300d,
      "300n" => Rez.Drawables.Small_300n,
      "301d" => Rez.Drawables.Small_301d,
      "301n" => Rez.Drawables.Small_301n,
      "302d" => Rez.Drawables.Small_302d,
      "302n" => Rez.Drawables.Small_302n,
      "310d" => Rez.Drawables.Small_310d,
      "310n" => Rez.Drawables.Small_310n,
      "311d" => Rez.Drawables.Small_311d,
      "311n" => Rez.Drawables.Small_311n,
      "312d" => Rez.Drawables.Small_312d,
      "312n" => Rez.Drawables.Small_312n,
      "313d" => Rez.Drawables.Small_313d,
      "313n" => Rez.Drawables.Small_313n,
      "314d" => Rez.Drawables.Small_314d,
      "314n" => Rez.Drawables.Small_314n,
      "321d" => Rez.Drawables.Small_321d,
      "321n" => Rez.Drawables.Small_321n,
    };
  }

  function codesSmall500() {
    //Rain
    return {
      "500d" => Rez.Drawables.Small_500d,
      "500n" => Rez.Drawables.Small_500n,
      "501d" => Rez.Drawables.Small_501d,
      "501n" => Rez.Drawables.Small_501n,
      "502d" => Rez.Drawables.Small_502d,
      "502n" => Rez.Drawables.Small_502n,
      "503d" => Rez.Drawables.Small_503d,
      "503n" => Rez.Drawables.Small_503n,
      "504d" => Rez.Drawables.Small_504d,
      "504n" => Rez.Drawables.Small_504n,
      "511d" => Rez.Drawables.Small_511d,
      "511n" => Rez.Drawables.Small_511n,
      "520d" => Rez.Drawables.Small_520d,
      "520n" => Rez.Drawables.Small_520n,
      "521d" => Rez.Drawables.Small_521d,
      "521n" => Rez.Drawables.Small_521n,
      "522d" => Rez.Drawables.Small_522d,
      "522n" => Rez.Drawables.Small_522n,
      "531d" => Rez.Drawables.Small_531d,
      "531n" => Rez.Drawables.Small_531n,
    };
  }

  function codesSmall600() {
    //Snow
    return {
      "600d" => Rez.Drawables.Small_600d,
      "600n" => Rez.Drawables.Small_600n,
      "601d" => Rez.Drawables.Small_601d,
      "601n" => Rez.Drawables.Small_601n,
      "602d" => Rez.Drawables.Small_602d,
      "602n" => Rez.Drawables.Small_602n,
      "611d" => Rez.Drawables.Small_611d,
      "611n" => Rez.Drawables.Small_611n,
      "612d" => Rez.Drawables.Small_612d,
      "612n" => Rez.Drawables.Small_612n,
      "613d" => Rez.Drawables.Small_613d,
      "613n" => Rez.Drawables.Small_613n,
      "615d" => Rez.Drawables.Small_615d,
      "615n" => Rez.Drawables.Small_615n,
      "616d" => Rez.Drawables.Small_616d,
      "616n" => Rez.Drawables.Small_616n,
      "620d" => Rez.Drawables.Small_620d,
      "620n" => Rez.Drawables.Small_620n,
      "621d" => Rez.Drawables.Small_621d,
      "621n" => Rez.Drawables.Small_621n,
      "622d" => Rez.Drawables.Small_622d,
      "622n" => Rez.Drawables.Small_622n,
    };
  }

  function codesSmall700() {
    //Atmosphere
    return {
      "701d" => Rez.Drawables.Small_701d,
      "701n" => Rez.Drawables.Small_701n,
      "711d" => Rez.Drawables.Small_711d,
      "711n" => Rez.Drawables.Small_711n,
      "721d" => Rez.Drawables.Small_721d,
      "721n" => Rez.Drawables.Small_721n,
      "731d" => Rez.Drawables.Small_731d,
      "731n" => Rez.Drawables.Small_731n,
      "741d" => Rez.Drawables.Small_741d,
      "741n" => Rez.Drawables.Small_741n,
      "751d" => Rez.Drawables.Small_751d,
      "751n" => Rez.Drawables.Small_751n,
      "761d" => Rez.Drawables.Small_761d,
      "761n" => Rez.Drawables.Small_761n,
      "762d" => Rez.Drawables.Small_762d,
      "762n" => Rez.Drawables.Small_762n,
      "771d" => Rez.Drawables.Small_771d,
      "771n" => Rez.Drawables.Small_771n,
      "781d" => Rez.Drawables.Small_781d,
      "781n" => Rez.Drawables.Small_781n,
    };
  }

  function codesSmall800() {
    //Cloud
    return {
      "800d" => Rez.Drawables.Small_800d,
      "800n" => Rez.Drawables.Small_800n,
      "801d" => Rez.Drawables.Small_801d,
      "801n" => Rez.Drawables.Small_801n,
      "802d" => Rez.Drawables.Small_802d,
      "802n" => Rez.Drawables.Small_802n,
      "803d" => Rez.Drawables.Small_803d,
      "803n" => Rez.Drawables.Small_803n,
      "804d" => Rez.Drawables.Small_804d,
      "804n" => Rez.Drawables.Small_804n,
    };
  }
}
