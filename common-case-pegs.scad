include <defaults.scad>;
use <fillets.scad>;

// module upper_case_pegs(){
//   tols=tolerances();
//   fo=tols[FILLET_INNER]+wall;
//   wall_pad=tols[WALL_PAD];
  
//   board=board();
//   board_w=board[W];
  
//   lower_case_t=post_base_t+wall;
//   upper_case_t=max_lid_t()-board[T];

//   for(x=[fo+1, board_w+2*(wall+wall_pad)-fo-5-1],
//       y=[-wall, board_d+2*wall_pad+2*wall])
//   {
//     translate([x,y, lower_case_t-5])
//       cube([5, wall, 5+upper_case_t]);
//   }
// }

module upper_case_pegs(){
  tols=tolerances();
  fo=tols[FILLET_INNER]+wall;

  wall=wall();
  wall_pad=tols[WALL_PAD];
  
  board=board();
  board_w=board[W];
  board_d=board[D];
  board_t=board[T];
  
  post_t=post_base_t()-board_t;

  total_case_t=max_lid_t()+wall+post_t;
  lower_case_t=post_base_t()+wall;
  upper_case_t=max_lid_t()-board()[T];

  difference(){
    translate([-wall,-wall,0])
      fillet_box([board_w+4*wall+2*wall_pad, 
                  board_d+4*wall+2*wall_pad, 
                  total_case_t], fo+wall);

    translate([0,0,-0.01])
    fillet_box([board_w+2*wall+2*wall_pad, 
                board_d+2*wall+2*wall_pad, 
                200], fo);

    for(y=[-wall-0.01, board_d+2*wall+2*wall_pad-0.01]){
      translate([wall+wall_pad+5, y, -0.01])
        cube([board_w-10, wall+0.02, 200]);
    }

    for(x=[-wall-0.01, board_w+2*wall+2*wall_pad-0.01]){
      translate([x-wall/2, wall+wall_pad+1.5, -0.01])
        cube([2*wall, board_d-3, 200]);
    }
  }
}

