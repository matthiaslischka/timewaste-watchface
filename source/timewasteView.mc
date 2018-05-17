using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Time.Gregorian;

class timewasteView extends Ui.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
    }

    function onShow() {
    }

    function onUpdate(dc) {    
    	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();
               
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        
        var hour = today.hour;
        if(!Sys.getDeviceSettings().is24Hour){
        	hour = hour % 12;
        	if( hour == 0){
        		hour = 12;
        	}
        }
        
        var startActiveTimeInMinutes = 8 * 60;
        var stopActiveTimeInMinutes = 18 * 60;
        
        var passedTimeInMinutes = (today.hour * 60 + today.min);
        
        var timeString = Lang.format("$1$:$2$", [hour.format("%02d"), today.min.format("%02d")]);
		var dateString = Lang.format("$1$ $2$", [today.day_of_week, today.day.format("%02d")]);
        
        var isWithinActiveHours = passedTimeInMinutes > startActiveTimeInMinutes && passedTimeInMinutes < stopActiveTimeInMinutes;
        
        if(isWithinActiveHours){
        
        	var passedTimePercentage = (passedTimeInMinutes - startActiveTimeInMinutes) * 100 / (stopActiveTimeInMinutes - startActiveTimeInMinutes);
        	drawProgressBar(dc, passedTimePercentage);
        	
        	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);			       	
        	dc.drawText(dc.getWidth()/2, 120, Gfx.FONT_LARGE, timeString + "  " + dateString, Gfx.TEXT_JUSTIFY_CENTER);
        	
        } else{
        	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);    		
        	dc.drawText(dc.getWidth()/2, 55, Gfx.FONT_NUMBER_HOT, timeString, Gfx.TEXT_JUSTIFY_CENTER);
        	
        	dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_BLACK);
        	dc.drawText(dc.getWidth()/2, 120, Gfx.FONT_LARGE, dateString, Gfx.TEXT_JUSTIFY_CENTER);
        }        
    }
    
    function drawProgressBar(dc, progress){
    	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
    	
    	var progressBarX = 15;
    	var progressBarY = 60;
    	var progressBarWidth = dc.getWidth()-30;
    	var progressBarHeight = 50;
    	
    	dc.fillRectangle(progressBarX, progressBarY, progressBarWidth, 50);
    	
    	var progressColor = Gfx.COLOR_DK_GRAY;
    	dc.setColor(progressColor, Gfx.COLOR_TRANSPARENT);
    	dc.fillRectangle(progressBarX, progressBarY, (progressBarWidth * progress) / 100, 50);
    	
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
    	var textFont = Gfx.FONT_LARGE;
    	var percentText = progress + "%";
    	dc.drawText(dc.getWidth()/2, 70, textFont, percentText, Gfx.TEXT_JUSTIFY_CENTER);
    	
    	dc.setPenWidth(8);
    	dc.drawArc(45, 85, 40, Gfx.ARC_CLOCKWISE , 270, 90);
    	dc.drawArc(dc.getWidth()-30-15, 85, 40, Gfx.ARC_CLOCKWISE , 90, 270);
    }

    function onHide() {
    }

    function onExitSleep() {
    }

    function onEnterSleep() {
    }

}
