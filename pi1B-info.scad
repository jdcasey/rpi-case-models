include <indexes.scad>;
include <defaults.scad>;
include <common-case-pegs.scad>;

// Taken from direct measurements

wall_pad = 0.25;

fi = 0.1; // inner fillet

bolt_d=3;
bolt_pad_d=6;

board_w=86;
board_d=56;
board_t=1.6;

bolts = [
  [24+bolt_d/2, 16.5+bolt_d/2],
  [24+bolt_d/2, 42+bolt_d/2],
  [79+bolt_d/2, 42+bolt_d/2],
  [79+bolt_d/2, 16.5+bolt_d/2],
];

// x-offset (midpoint), width, y-offset (midpoint), depth, z-offset (midpoint), height:

audio = [65.25, 8.5, board_d+2/2, 2, 2.99+8.5/2, 2+8.5];
audio_block = [65.25, 12, 43.25+12/2, 15, 10/2, 10];

rca = [40.5+12/2, 11, board_d-2+10/2, 10, 4.49+8.5/2, 5+8.5];
rca_block = [40.5+12/2, 12.5, 42.5+12/2, 12, 13/2, 13];

pwr = [6.75/2, 6.75, 3+9/2, 9, 3/2, 3.01];
hdmi = [37.5+15/2, 17, 12/2, 12, 7/2, 7.01];

eth_w=17.5;
usb_w=16;

eth = [board_w-eth_w/2-2, 22, 1.25+16/2, 18, 14.5/2, 14.5];
usb = [board_w-usb_w/2+4, usb_w, 23.5+15/2, 15.5, 16/2, 16];

header_w=35;
header_d=7;
header=[header_w/2+0.5, header_w, board_d-header_d/2+0.25, header_d, 8.5/2, 8.5];

cam = [59, 2.5, 1.5+18/2, 18, 5.75/2, 5.75];

sd_over=4;
sd=[-35/2+17.75, 18, 14+30.5/2, 30.5, -3.5/2, 3.5+board_t];

front_edge_wall=[
  hdmi
];

back_edge_wall=[
  rca,
  audio
];

right_edge_wall=[
  eth,
  usb
];

left_edge_wall=[
  pwr, sd
];

top_wall=[
  header, cam, eth, usb, audio, rca, rca_block
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

function max_lid_t()=usb[HEIGHT]-3*wall;

// module imprint(){
//   translate([35, 2, -2*wall-0.01])
//   scale([1.2,1.2,1.2])
//   rotate([0,0,90])
//   linear_extrude(height=10){
//     import("raspberry.dxf");
//   }
  
//   translate([3, 27, -2*wall-0.01])
//   rotate([0,0,0])
//   difference(){
//     linear_extrude(height=10){
//       text("1B");
//     }
    
//     translate([11.5,-1,-0.001])
//       cube([0.8,12,10.002]);
//   }
// }

module imprint(){
  // imprint_pi();
  imprint_pihole();
}

module imprint_pihole(){
  translate([35,8, -wall-0.01])
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
          text("1B", font="Liberation Sans", size=6);
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
        text("1B");
      }
      
      translate([11.5,-1,-0.001])
        cube([0.8,12,10.002]);
    }
  }
}

function max_comp_t()=eth[HEIGHT];