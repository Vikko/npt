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
	      yaxis: { 
					min: 0, 
					max: 180 
					},
	      xaxis: { 
					max: 100, 
					show: false 
				}
    };
		
  	// sweat
		options_sw = {
				series: { shadowSize: 0 },
				yaxis: { 
					min: 0,
					show: true,
					max: 1000,
					},
				xaxis: { max: 100,
					show: false }
    };
  	// muscle tension
		options_mt = {
				series: { shadowSize: 0 },
				yaxis: { 
					min: -5,
					show: true,
					max: 5},
				xaxis: { 
					max: 100,
					show: false 
				}
    };
  	// accelerometer
		options_ac = {
				series: { shadowSize: 0 },
				yaxis: { 
					min: 0,
					show: false
				},
				xaxis: { 
					max: 100,
					show: false 
				}
    };
  	// gyroscope
		options_gy = {
				series: { shadowSize: 0 },
				yaxis: { 
					min: 0,
					show: false
				},
				xaxis: { 
					max: 100,
					show: false 
				}
    };
  	// peakaccel
		options_pa = {
				series: { shadowSize: 0 },
				yaxis: { show: false},
				xaxis: { 
					max: 100,
					show: false 
				}
    };
  	// posture
		options_po = {
				series: { shadowSize: 0 },
				yaxis: { show: false},
				xaxis: { 
					max: 100,
					show: false 
				}
    };
  	// respiration
		options_rs = {
				series: { shadowSize: 0 },
				yaxis: { show: false},
				xaxis: { 
					max: 100,
					show: false 
				}
    };
		//eeg
		options_eeg = {
				series: { shadowSize: 0 },
				yaxis: { show: false
					},
				xaxis: { 
					max: 100,
					show: false 
				},
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
				yaxis: { show: true,
					min: 0,
					max: 255
				},
				xaxis: {
					show: false 
				},
	    };
}

function start() {
	if (!(started)) {
		started = true;
		console.log("Started updating plot");
		stream();
	}
}

function stop() {
	if (started) {
		started = false;
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
	$.plot($("#eeg_current_plot"), eeg_current, options_eeg_current);
}

function stream() {
  var client = new Faye.Client('http://memachine-push.herokuapp.com/faye');
	client.setHeader('Access-Control-Allow-Origin', '*');
  client.subscribe("/test", function(packet) {
		$("#data").append(packet.data.hr_data + "<br/>");
		fill(packet.data);
  });
}

function fill(data){
	/* clear arrays */
	debug = data;
	heart_rate_data = [];
	sweat_data = [];
	muscle_data = [];
	accelero_data = [];
	gyro_data = [];
	peac_data = [];
	post_data = [];
	resp_data = [];

	// Heart rate
	if ((hr_data = data.hr_data) != "null") {
		for(i=0; i< hr_data.size; i++){
			if (heart_rate_data.size >= 100){
				heart_rate_data.shift()
			}
			heart_rate_data.push(hr_data[i]);
		}
	}
	// Draw average BPM
	if ((bpm = data.bpm) != "null") {
		current_bpm = bpm.toFixed(1);
		$(".bpm-value").html(current_bpm);
	}

	// Sweat
	if ((sw_data = data.sw_data) != "null") {
		for(i=0; i< sw_data.size; i++){
			sweat_data.push([i, sw_data[i]]);
		}
	}

	// Muscle tension
	if ((mt_data = data.mt_data) != "null") {
		for(i=0; i< mt_data.size; i++){
			muscle_data.push([i, mt_data[i]]);
		}
	}

	// Accelerometer
	if ((accel_data = data.accel_data) != "null") {
		for(i=0; i< accel_data.size; i++){
			accelero_data.push([i, accel_data[i]]);
		}
	}

	// Gyroscope
	if ((gyr_data = data.gyro_data) != "null") {
		for(i=0; i< gyr_data.size; i++){
			gyro_data.push([i, gyr_data[i]]);
		}
	}

	// Peak acceleration
	if ((peak_accel_data = data.peak_accel_data) != "null") {
		for(i=0; i< peak_accel_data.size; i++){
			peac_data.push([i, peak_accel_data[i]]);
		}
	}

	// Posture
	if ((posture_data = data.posture_data) != "null") {
		for(i=0; i< posture_data.size; i++){
			post_data.push([i, posture_data[i]]);
		}
	}

	// Respiration
	if ((respiration_data = data.respiration_data) != "null") {
		for(i=0; i< respiration_data.size; i++){
			resp_data.push([i, respiration_data[i]]);
		}
	}
	
	// Eeg
	if ((eeg_data = data.eeg_data) != "null") {
		for(i=0; i< eeg_data.size; i++){
			eeg_data.push([i, eeg_data[i]]);
		}
	}
	

	// Geolocation
	if ((geo_location = data.geo_location) != "") {
		$("#geolocation").html(geo_location)
	} 
		
}