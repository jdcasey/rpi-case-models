include <indexes.scad>;
include <defaults.scad>;
include <common-case-pegs.scad>;

// Taken from direct measurements

wall_pad=1.5;
bolt_d=2.75;
fi=3.5;

board_w=65;
board_d=56;
board_t=1.6;

hoff=3.5;
bolts=[
  [hoff, hoff],
  [board_w-hoff, hoff],
  [hoff, board_d-hoff],
  [board_w-hoff, board_d-hoff]
];

//[x_min, y_min, z_min, width, depth, thickness]
// x-offset (midpoint), width, y-offset (midpoint), depth, z-offset (midpoint), height:

sd_w=13;
sd_d=14;
sd_t=3.5;

sd = [sd_w/2, sd_w, 22+sd_d/2, sd_d, -sd_t/2, sd_t+board_t];

pow_w=8;
pow_d=7.5;
pow_t=3;

power=[6.6+pow_w/2, pow_w, 
       pow_d/2, pow_d, 
       pow_t/2, pow_t]; // power

hdmi_w=16.5;
hdmi_d=12;
hdmi_t=7.001;

hdmi=[24.5+hdmi_w/2, hdmi_w, 
      hdmi_d/2, hdmi_d, 
      hdmi_t/2, hdmi_t]; // hdmi

audio_w=8;
audio_d=15;
audio_t=7;

audio=[board_w-16+audio_w/2, audio_w, 
       audio_d/2, audio_d, 
       audio_t/2, audio_t]; // audio

usb_w=11;
usb_d=14;
usb_t=7.5;

usb=[board_w-9.5+usb_w/2, usb_w, 
     24.5+usb_d/2, usb_d, 
     usb_t/2, usb_t]; // USB

header_w=53;
header_d=6.5;
header_t=8.5;

header=[7+header_w/2, header_w, 
        board_d-7.5+header_d/2, header_d, 
        header_t/2, header_t]; // GPIO


cam_w=2;
cam_d=17.75;
cam_t=5.75;

cam=[44+cam_w/2, cam_w, 
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
  usb
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
function max_comp_t()=header[HEIGHT];
function max_lid_t()=header[HEIGHT]+wall+0.2;

module imprint(){
  // imprint_pi();
  // imprint_pihole();
  imprint_octo();
}

module imprint_pihole(){
  translate([35, 12, -wall-0.01])
  {
    translate([5, -5, 0])
    scale([1.75,1.75,1])
    rotate([0,0,90])
    linear_extrude(height=10){
      import("pihole.dxf");
    }

    translate([-27, 20, -wall])
    rotate([0,0,0])
    difference(){
      union(){
        linear_extrude(height=10){
          text("Pi-hole", font="Liberation Sans:style=Italic", size=10);
        }
        
        translate([43,6,0])
        linear_extrude(height=10){
          text("3A+", font="Liberation Sans", size=6);
        }
      }
      
      translate([4.5,-1,-0.001])
        cube([0.8,15,10.002]);
      
      translate([27.5,-1,-0.001])
        cube([0.8,15,10.002]);

      translate([38,-1,-0.001])
        cube([0.8,15,10.002]);

      translate([50,-1,-0.001])
        cube([0.4,15,10.002]);
    }
  }
}

module imprint_pi(){
  translate([38, 8, -2*wall-0.01])
  {
    scale([1.2,1.2,1.2])
    rotate([0,0,90])
    linear_extrude(height=10){
      import("raspberry.dxf");
    }
    
    translate([-33, 25, 0])
    rotate([0,0,0])
    difference(){
      linear_extrude(height=10){
        text("3A+");
      }
      
      translate([11.5,-1,-0.001])
        cube([0.8,12,10.002]);
    }
  }
}

module imprint_octo(){
  translate([38, -1, -2*wall-0.01])
  {
    scale([0.1,0.1,1.2])
    rotate([0,0,90])
    linear_extrude(height=10){
      import("octopus-pi.dxf");
    }
    
    translate([-30, 38, 0])
    rotate([0,0,0])
    difference(){
      linear_extrude(height=10){
        text("3A+");
      }
      
      translate([11.5,-1,-0.001])
        cube([0.8,12,10.002]);
    }
  }
}

// module imprint(){
//   translate([38, 2, -2*wall-0.01])
//   scale([1.2,1.2,1.2])
//   rotate([0,0,90])
//   linear_extrude(height=10){
//     import("raspberry.dxf");
//   }
  
//   translate([5, 27, -2*wall-0.01])
//   rotate([0,0,0])
//   difference(){
//     linear_extrude(height=10){
//       text("3A+");
//     }
    
//     translate([11.5,-1,-0.001])
//       cube([0.8,12,10.002]);
//   }
// }

