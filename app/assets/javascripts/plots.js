// global vars & initialize vars
started = false;
updateInterval = 500;
heart_rate_data = [];
// bpm_rate_data = [];
sweat_data = [];
muscle_data = [];
accelero_data = [];
gyro_data = [];
peac_data = [];
post_data = [];
resp_data = [];
intervalId = "";
delay = 5;

//init script
$(document).ready(function($){
	setup_plots();
	// draw_live_heartrate();
	draw_bpmrate();
	draw_sweat();
	draw_muscle();
	draw_accel();
	draw_gyro();
	draw_peak_accel();
	draw_posture();
	draw_respiration();
	$("#start").click(function(e){
		start();
	});
	$("#stop").click(function(e){
		stop();
	});
});
function get_data() {
	$.ajax({
		url: "sensors/get_data",
		dataType: "script" 
	});
}

// flot
function setup_plots() {
  	// live heart rate
		/*options_lhr = {
        series: { shadowSize: 0 },
        yaxis: { show: false},
				color: "#FF0000", 
        xaxis: { show: false }
    };*/
		// beats per minute
		options_bpm = {
	      series: { shadowSize: 0 },
				color: "#FF0000", 
	      yaxis: { min: 0, max: 180 },
	      xaxis: { show: false }
    };
  	// sweat
		options_sw = {
				series: { shadowSize: 0 },
				yaxis: { show: false},
				color: "#FF0000", 
				xaxis: { show: false }
    };
  	// muscle tension
		options_mt = {
				series: { shadowSize: 0 },
				yaxis: { show: false},
				color: "#FF0000", 
				xaxis: { show: false }
    };
  	// accelerometer
		options_ac = {
				series: { shadowSize: 0 },
				yaxis: { show: false},
				color: "#FF0000", 
				xaxis: { show: false }
    };
  	// gyroscope
		options_gy = {
				series: { shadowSize: 0 },
				yaxis: { show: false},
				color: "#FF0000", 
				xaxis: { show: false }
    };
  	// peakaccel
		options_pa = {
				series: { shadowSize: 0 },
				yaxis: { show: false},
				color: "#FF0000", 
				xaxis: { show: false }
    };
  	// posture
		options_po = {
				series: { shadowSize: 0 },
				yaxis: { show: false},
				color: "#FF0000", 
				xaxis: { show: false }
    };
  	// respiration
		options_rs = {
				series: { shadowSize: 0 },
				yaxis: { show: false},
				color: "#FF0000", 
				xaxis: { show: false }
    };

}

function start() {
	if (!(started)) {
		started = true;
		if (intervalId == "") {
			intervalId = setInterval(function(){
				get_data();
				// draw_live_heartrate();
				draw_sweat();
				draw_muscle();
				draw_accel();
				draw_gyro();
				draw_peak_accel();
				draw_posture();
				draw_respiration();
			}, updateInterval);
			console.log("Started updating plot");
		} else {
			console.log("Called start, but already started.")
		}
	}
}

function stop() {
	if (started) {
		started = false;
		if (intervalId == "") {
			console.log("Called stop, but not running.")
		} else {
			clearInterval(intervalId);
			intervalId = "";
		}
	}
}

// function draw_live_heartrate() {
// 	$.plot($("#live_heart_rate_plot"), [ heart_rate_data ], options_lhr);
// }

function draw_bpmrate() {
	$.plot($("#bpm_rate_plot"), [ heart_rate_data ], options_bpm);
}

function draw_sweat() {
	$.plot($("#sweat_plot"), [ sweat_data ], options_sw);
}

function draw_muscle() {
	$.plot($("#muscle_tension_plot"), [ muscle_data ], options_mt);
}

function draw_accel() {
	$.plot($("#accelerometer_plot"), [ accelero_data ], options_ac);
}

function draw_gyro() {
	$.plot($("#gyroscope_plot"), [ gyro_data ], options_gy);
}

function draw_peak_accel() {
	$.plot($("#peak_accel_plot"), [ peac_data ], options_po);
}

function draw_posture() {
	$.plot($("#posture_plot"), [ post_data ], options_pa);
}
function draw_respiration() {
	$.plot($("#respiration_plot"), [ resp_data ], options_rs);
}