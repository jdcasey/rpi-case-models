include <indexes.scad>;
use <fillets.scad>;

// TODO: Select which board type. Each -info.scad contains
// coordinates for each component to be cut out of the case.

use <pi0-info.scad>;
// use <pi1B-info.scad>;
// use <pi3B+-info.scad>;
// use <pi3A+-info.scad>;

// case sizes
board_w=board()[W];
board_d=board()[D];
board_t=board()[T];

wall=wall();
post_t=post_base_t()-board()[T];

avg_lid_t=max_lid_t();
max_comp_t=max_comp_t();

total_case_t=avg_lid_t+wall+post_t;
lower_case_t=post_t+wall+board_t;
upper_case_t=total_case_t-lower_case_t;

wall_pad=tolerances()[WALL_PAD];
fi=tolerances()[FILLET_INNER];
fo=fi+wall;
bolt_d=tolerances()[BOLT_D];
bolt_pad_d=bolt_d*2;

cut_projection=20;

module board_blank_flex(h=total_case_t){
  union(){
    difference(){
      fillet_box([board_w+2*wall+2*wall_pad, 
                  board_d+2*wall+2*wall_pad, 
                  wall], fo);
      
      children();
    }

    difference(){
      fillet_box([board_w+2*wall+2*wall_pad, 
                  board_d+2*wall+2*wall_pad, 
                  h], fo);
      
      translate([wall, wall, -0.01])
        fillet_box([board_w+2*wall_pad, 
                    board_d+2*wall_pad, 
                    h-wall+0.02], fi);
    }
  }
}

module board_vent_grid(){
    hd=8;
    interhd=10;

    for(xn=[1:9], yn=[1:6]){
      xoff = (yn % 2) == 1 ? 0 : -4;
      translate([xoff+xn*interhd-interhd/4, 
                 yn*interhd-interhd/2, -0.01])
        cylinder(d=hd, h=wall+0.02, $fn=20);
    }
}

module bolt_pads(h=wall){
  intersection(){
    translate([wall+wall_pad,wall+wall_pad,0])
    difference(){
      for(xy=bolts()){
        translate([xy[0], xy[1], 0])
        {
          cylinder(d=3*bolt_pad_d, h=wall, $fn=40);

            cylinder(d=bolt_pad_d, h=h, $fn=40);
        }
      }

      for(xy=bolts()){
        translate([xy[0], xy[1], wall])
          cylinder(d=bolt_d, h=h+0.02, $fn=40);
      }
    }
    
    fillet_box([board_w+2*(wall+wall_pad),
                board_d+2*(wall+wall_pad),
                h], fo);
  }
}

module front_edge_wall_cuts(){
  for(mod = front()){
    translate([mod[XOFF]-mod[WIDTH]/2, 
               -wall-wall_pad-cut_projection+mod[YOFF]-0.01, 
               -board_t+mod[ZOFF]-mod[HEIGHT]/2])
      cube([mod[WIDTH], 
            mod[DEPTH]+cut_projection+0.02, 
            mod[HEIGHT]+board_t]);
  }
}

module back_edge_wall_cuts(){
  for(mod = back()){
    translate([mod[XOFF]-mod[WIDTH]/2, 
               board_d-0.01, -board_t+mod[ZOFF]-mod[HEIGHT]/2])
      cube([mod[WIDTH], 
            wall+wall_pad+cut_projection+0.02, 
            mod[HEIGHT]+board_t]);
  }
}

module right_edge_wall_cuts(){
  for(mod = right()){
    translate([mod[XOFF]-mod[WIDTH]/2,
               mod[YOFF]-mod[DEPTH]/2, 
               -board_t+mod[ZOFF]-mod[HEIGHT]/2])
      cube([mod[WIDTH]+wall+wall_pad+cut_projection+0.02, mod[DEPTH], mod[HEIGHT]+board_t]);
  }
}

module left_edge_wall_cuts(){
  for(mod = left()){
    translate([-wall-wall_pad-cut_projection-0.01,
               mod[YOFF]-mod[DEPTH]/2, 
               -board_t+mod[ZOFF]-mod[HEIGHT]/2])
      cube([mod[WIDTH]+wall+wall_pad+cut_projection+0.02, 
            mod[DEPTH], 
            mod[HEIGHT]+board_t]);
  }
}

module wall_cuts(){
  translate([wall+wall_pad, 
             wall+wall_pad, 
             wall+lower_case_t-board_t])
  {
    front_edge_wall_cuts();
    back_edge_wall_cuts();
    left_edge_wall_cuts();
    right_edge_wall_cuts();
  }
}

module top_cuts(){
  for(mod=top()){
    translate([mod[XOFF]-mod[WIDTH]/2,
               mod[YOFF]-mod[DEPTH]/2,
               -wall-wall_pad-0.01])
      cube([mod[WIDTH], mod[DEPTH], wall+wall_pad+cut_projection+0.02]);
  }
  
  imprint();
}

module case_block(){
  t = total_case_t;
  difference(){
    union(){
      board_blank_flex(t){
        children();
      }
      bolt_pads(post_t);
    }
    
    translate([wall+wall_pad, 
               wall+wall_pad, 
               wall+lower_case_t-board_t])
    {
      left_edge_wall_cuts();
      right_edge_wall_cuts();
      front_edge_wall_cuts();
      back_edge_wall_cuts();
    }
    
    translate([wall+wall_pad,
               wall+wall_pad,
               t])
      top_cuts();
  }
}

module lower_case(){
  intersection(){
    case_block(){
      children();
    }

    cube([board_w+2*(wall+wall_pad),
          board_d+2*(wall+wall_pad),
          lower_case_t]);
  }
}

module lower_case_with_vents(){
  lower_case(){
    board_vent_grid();
  }
}

module upper_case(){
  translate([0,0,total_case_t])
  rotate([180,0,0])
  union(){
    intersection(){
      case_block();

      translate([0,0,lower_case_t])
        cube([board_w+2*(wall+wall_pad),
              board_d+2*(wall+wall_pad),
              upper_case_t]);
    }
    
    difference(){
      upper_case_pegs();

      translate([0,0,-0.01])
      union(){
        linear_extrude(height=total_case_t+0.2){
          projection(cut=true)
          translate([0,0,-total_case_t+0.1])
            wall_cuts();
        }

        linear_extrude(height=lower_case_t+board_t){
          projection(cut=true)
          translate([0,0,-upper_case_t+0.1])
            wall_cuts();
        }

        linear_extrude(height=lower_case_t+2*board_t+0.1){
          projection(cut=true)
          translate([0,0,-upper_case_t-board_t-0.01])
            wall_cuts();
        }
      }
    }
  }
}


lower_case_with_vents();

translate([0,-5,0])
upper_case();

//case_block();
