// global vars & initialize vars
started = false;
updateInterval = 500;
heart_rate_data = [];
sweat_data = [];
muscle_data = [];
accelero_data_x = [];
accelero_data_y = [];
accelero_data_z = [];
gyro_data_x = [];
gyro_data_y = [];
gyro_data_z = [];
peac_data = [];
post_data = [];
resp_data = [];
eeg_data1 = [];
eeg_data2 = [];
eeg_current = [];
intervalId = "";
delay = 5;

//init script
$(document).ready(function($){
	setup_plots();
	draw_bpmrate();
	draw_sweat();
	draw_muscle();
	draw_accel();
	draw_gyro();
	draw_peak_accel();
	draw_posture();
	draw_respiration();
	draw_eeg();
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
		// beats per minute
		options_bpm = {
	      series: { shadowSize: 0 },
	      yaxis: { min: 0, max: 180 },
	      xaxis: { show: false }
    };
  	// sweat
		options_sw = {
				series: { shadowSize: 0 },
				yaxis: { show: false},
				xaxis: { show: false }
    };
  	// muscle tension
		options_mt = {
				series: { shadowSize: 0 },
				yaxis: { show: false},
				xaxis: { show: false }
    };
  	// accelerometer
		options_ac = {
				series: { shadowSize: 0 },
				yaxis: { show: false},
				xaxis: { show: false }
    };
  	// gyroscope
		options_gy = {
				series: { shadowSize: 0 },
				yaxis: { show: false},
				xaxis: { show: false }
    };
  	// peakaccel
		options_pa = {
				series: { shadowSize: 0 },
				yaxis: { show: false},
				xaxis: { show: false }
    };
  	// posture
		options_po = {
				series: { shadowSize: 0 },
				yaxis: { show: false},
				xaxis: { show: false }
    };
  	// respiration
		options_rs = {
				series: { shadowSize: 0 },
				yaxis: { show: false},
				xaxis: { show: false }
    };
		//eeg
		options_eeg = {
				series: { shadowSize: 0 },
				yaxis: { show: false},
				xaxis: { show: false },
				colors: ["rgb(255,0,0)", "rgb(100,149,237)"]
		    };

		options_eeg_current = {
				series: {
					        stack: 1,
					        bars: {
					            show: true,
					            barWidth: 0.6,
					            fill:1
					        }
        },
				
        yaxes: { show: false },
        xaxis: { show: false }
	    };
}

function start() {
	if (!(started)) {
		started = true;
		if (intervalId == "") {
			intervalId = setInterval(function(){
				get_data();
				draw_sweat();
				draw_muscle();
				draw_accel();
				draw_gyro();
				draw_peak_accel();
				draw_posture();
				draw_respiration();
				draw_eeg();
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
	$.plot($("#accelerometer_plot"), [ 
		{
		  data: accelero_data_x,
			color: 'red'
		},
		{
		  data: accelero_data_y,
			color: 'blue'
		},
		{
		  data: accelero_data_z,
			color: 'yellow'
		}
	], options_ac);
}

function draw_gyro() {
	$.plot($("#gyroscope_plot"), [ 
		{
		  data: gyro_data_x,
			color: 'red'
		},
		{
		  data: gyro_data_y,
			color: 'blue'
		},
		{
		  data: gyro_data_z,
			color: 'yellow'
		}
	], options_gy);
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
function draw_eeg() {
	$.plot($("#eeg_plot"), [ 
		{
		  data: eeg_data1
		},
		{
		  data: eeg_data2
		}
	], options_eeg);
	$.plot($("#eeg_current_plot"), [eeg_current], options_eeg_current);
}