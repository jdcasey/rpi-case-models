include <indexes.scad>;
include <defaults.scad>;
include <common-case-pegs.scad>;
use <fillets.scad>;

// Taken from direct measurements

wall_pad = 0.25;
fi = 3+wall_pad; // inner fillet
bolt_d=2.75;

board_w=86;
board_d=57;
board_t=1.6;

bolt_off=3.5;
x_interbolt=59;
y_interbolt=49;

bolts = [
  [bolt_off, bolt_off],
  [bolt_off + x_interbolt, bolt_off],
  [bolt_off, board_d-bolt_off],
  [bolt_off + x_interbolt, board_d-bolt_off]
];

// x-offset (midpoint), width, y-offset (midpoint), depth, z-offset (midpoint), height:

// x-offset (midpoint), width, height:
sd_w=13;
sd_d=14;
sd_t=3.5;

sd = [sd_w/2, sd_w, 22+sd_d/2, sd_d, -sd_t/2, sd_t+board_t];

pow_w=8;
pow_d=7.5;
pow_t=3;

power=[10.6, pow_w, 
       pow_d/2, pow_d, 
       pow_t/2, pow_t]; // power

hdmi_w=16.5;
hdmi_d=12;
hdmi_t=7.001;

hdmi=[32, hdmi_w, 
      hdmi_d/2, hdmi_d, 
      hdmi_t/2, hdmi_t]; // hdmi

audio_w=8;
audio_d=15;
audio_t=7;

audio=[53.5, audio_w, 
       audio_d/2, audio_d, 
       audio_t/2, audio_t]; // audio

usb_w=17;
usb_d=14.5;
usb_t=16;

eth_w=17.5;
eth_t=14.5;

// x-offset (midpoint), width, y-offset (midpoint), depth, height:
eth = [board_w-eth_w/2, 22, 10.25, 17.25, eth_t/2, eth_t];
usb1 = [board_w-usb_w/2, usb_w, 29, usb_d, usb_t/2, usb_t];
usb2 = [board_w-usb_w/2, usb_w, 47, usb_d, usb_t/2, usb_t];

header_w=53;
header_d=6.5;
header_t=8.5;

header=[6.5+header_w/2, header_w, 
        board_d-7.5+header_d/2, header_d, 
        header_t/2, header_t]; // GPIO


cam_w=2;
cam_d=17.75;
cam_t=5.75;

cam=[hdmi[XOFF]+13, cam_w, 
     2.5+cam_d/2, cam_d, 
     cam_t/2, cam_t]; // camera
     
led_w=2.5;
led_d=7;
led_t=5.75;

leds=[led_w/2, led_w, 
      6+led_d/2, led_d, 
      led_t/2, led_t]; // LEDs

front_edge_wall=[
  power,
  hdmi,
  audio
];

back_edge_wall=[
];

right_edge_wall=[
  eth,
  usb1,
  usb2
];

left_edge_wall=[
  sd
];

top_wall=[
  header, cam, leds
];

function tolerances()=[wall_pad, fi, bolt_d];
function board()=[board_w, board_d, board_t];
function front()=front_edge_wall;
function back()=back_edge_wall;
function right()=right_edge_wall;
function left()=left_edge_wall;
function top()=top_wall;
function bolts()=bolts;
//function sd()=sd;

function max_lid_t()=usb1[HEIGHT]-2*wall;

module imprint(){
    translate([40, 20, -2*wall-0.01])
    scale([1.2,1.2,1.2])
    rotate([0,0,90])
    linear_extrude(height=10){
      import("raspberry.dxf");
    }
    
    translate([54, 25, -2*wall-0.01])
    rotate([0,0,90])
    difference(){
      linear_extrude(height=10){
        text("3B+");
      }
      
      translate([4.2,1,-0.001])
      cube([0.8,10,10.002]);
    }
}

function max_comp_t()=header[HEIGHT];

avg_lid_t=usb1[HEIGHT]-3*wall;
max_comp_t=eth[HEIGHT];

function tolerances()=[wall_pad, fi, bolt_d];
function board()=[board_w, board_d, board_t];
function front()=front_edge_wall;
function back()=back_edge_wall;
function right()=right_edge_wall;
function left()=left_edge_wall;
function top()=top_wall;
function bolts()=bolts;
function max_comp_t()=eth[HEIGHT];
function max_lid_t()=usb1[HEIGHT]-3*wall;

module imprint(){
  translate([38, 2, -2*wall-0.01])
  scale([1.2,1.2,1.2])
  rotate([0,0,90])
  linear_extrude(height=10){
    import("raspberry.dxf");
  }
  
  translate([5, 27, -2*wall-0.01])
  rotate([0,0,0])
  difference(){
    linear_extrude(height=10){
      text("3B+");
    }
    
    translate([11.5,-1,-0.001])
      cube([0.8,12,10.002]);
  }
}
