#import "SnapshotHelper.js"

var target = UIATarget.localTarget();
var app = target.frontMostApp();
var window = app.mainWindow();

target.delay(10)
captureLocalizedScreenshot("0-LandingScreen")
target.delay(2)

target.frontMostApp().mainWindow().switches()[0].setValue(1);
target.delay(15)
captureLocalizedScreenshot("0-RecondingRunning")
// recodinng on
target.frontMostApp().mainWindow().switches()[0].setValue(0);
target.delay(5)
captureLocalizedScreenshot("0-RecondingDone")
// reconding off

target.frontMostApp().mainWindow().buttons()[""].tap();
target.delay(2)
captureLocalizedScreenshot("0-ArchiveView")
// goto Archive view

target.frontMostApp().mainWindow().tableViews()[0].dragInsideWithOptions({startOffset:{x:0.92, y:0.07}, endOffset:{x:0.25, y:0.07}});
captureLocalizedScreenshot("0-ArchiveView-Delete")
// delete first
target.delay(3)
