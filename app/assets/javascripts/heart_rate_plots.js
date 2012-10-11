// global vars & initialize vars
polling = false;
updateInterval = 20;
heart_rate_data = [];
bpm_rate_data = [];
intervalId = "";
delay = 50;

//init script
$(document).ready(function($){
	setup_plots();
	draw_live_heartrate();
	draw_bpmrate();
});
function get_data() {
	$.ajax({
		url: "sensors/get_data",
		dataType: "script" 
	});
}

// flot
function setup_plots() {
    // setup plot
	options_lhr = {
        series: { shadowSize: 0 },
        yaxis: { show: false},
		color: "#FF0000", 
        xaxis: { show: false }
    };
	options_bpm = {
        series: { shadowSize: 0 },
		color: "#FF0000", 
        yaxis: { min: 0, max: 180 },
        xaxis: { show: false }
    };
}

function start() {
	if (intervalId == "") {
		intervalId = setInterval(function(){
			get_data();
			draw_live_heartrate()
		}, updateInterval);
		console.log("Started updating plot");
	} else {
		console.log("Called start, but already started.")
	}
}

function stop() {
	if (intervalId == "") {
		console.log("Called stop, but not running.")
	} else {
		clearInterval(intervalId);
		intervalId = "";
	}
}

function draw_live_heartrate() {
	$.plot($("#live_heart_rate_plot"), [ heart_rate_data ], options_lhr);
}

function draw_bpmrate() {
	$.plot($("#bpm_rate_plot"), [ bpm_rate_data ], options_bpm);
}