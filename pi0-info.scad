include <indexes.scad>;

// Taken from direct measurements
wall=1.2;
post_base_t=5.25+wall;

wall_pad = 0.25;
fi = 3+wall_pad; // inner fillet
bolt_d=2.75;

board_w=66;
board_d=31;
board_t=1.6;

bolt_off=4;
bolts = [
  [bolt_off, bolt_off],
  [board_w-bolt_off, bolt_off],
  [bolt_off, board_d-bolt_off],
  [board_w-bolt_off, board_d-bolt_off]
];

// x-offset (midpoint), width, y-offset (midpoint), depth, z-offset (midpoint), height:

// x-offset (midpoint), width, height:
sd_w=13;
sd_d=14;
sd_t=3.5;

sd = [sd_w/2, sd_w, board_d/2, sd_d, -sd_t/2, sd_t+board_t];

hdmi_d=8.5;
hdmi_w=12.5;
hdmi_t=3.75;

hdmi=[13.5-hdmi_w/2, hdmi_w, 
      hdmi_d/2, hdmi_d, 
      hdmi_t/2, hdmi_t]; // hdmi

usb_w=8;
usb_d=7.5;
usb_t=3;

power = [41.4-usb_w/2, usb_w, 29, usb_d, usb_t/2, usb_t];
usb = [54-usb_w/2, usb_w, 47, usb_d, usb_t/2, usb_t];

header_w=53;
header_d=6.5;
header_t=8.5;

header=[6.5+header_w/2, header_w, 
        board_d-7.5+header_d/2, header_d, 
        header_t/2, header_t]; // GPIO


cam_w=4;
cam_d=19;
cam_t=1.25;

cam=[board_w-cam_w/2, cam_w, 
     board_d/2, cam_d, 
     cam_t/2, cam_t]; // camera
     
//led_w=2.5;
//led_d=7;
//led_t=5.75;
//
//leds=[led_w/2, led_w, 
//      6+led_d/2, led_d, 
//      led_t/2, led_t]; // LEDs

front_edge_wall=[
  hdmi,
  power,
  usb
];

back_edge_wall=[
];

right_edge_wall=[
  cam,
];

left_edge_wall=[
  sd
];

top_wall=[
  header
];

function tolerances()=[wall_pad, fi, bolt_d];
function board()=[board_w, board_d, board_t];
function front()=front_edge_wall;
function back()=back_edge_wall;
function right()=right_edge_wall;
function left()=left_edge_wall;
function top()=top_wall;
function bolts()=bolts;
function max_comp_t()=hdmi[HEIGHT];
function max_lid_t()=hdmi[HEIGHT]+2*wall;
function wall()=wall;
function post_base_t()=post_base_t;

module imprint(){
  translate([35, 2, -2*wall-0.01])
  scale([1,1,1])
  rotate([0,0,90])
  linear_extrude(height=10){
    import("raspberry.dxf");
  }
  
  translate([38, 8, -2*wall-0.01])
  rotate([0,0,0])
  difference(){
    linear_extrude(height=10){
      text("zero", font="Liberation Sans:style=Italic");
    }
    
    translate([22,-1,-0.001])
      cube([0.8,10,10.002]);
    
    translate([10,-1,-0.001])
      cube([0.8,10,10.002]);
  }
}

module upper_case_pegs(){
  tols=tolerances();
  fo=tols[FILLET_INNER]+wall;
  wall_pad=tols[WALL_PAD];
  
  board=board();
  board_w=board[W];
  
  lower_case_t=post_base_t+wall;
  upper_case_t=max_lid_t()-board[T];

  for(x=[hdmi[XOFF]+hdmi_w/2+3, 
         board_w+2*(wall+wall_pad)-fo-5-1],
      y=[-wall, board_d+2*wall_pad+2*wall])
  {
    translate([x,y, lower_case_t-5])
      cube([5, wall, 5+upper_case_t]);
  }
}
