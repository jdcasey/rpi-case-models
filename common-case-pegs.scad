include <defaults.scad>;

module upper_case_pegs(){
  tols=tolerances();
  fo=tols[FILLET_INNER]+wall;
  wall_pad=tols[WALL_PAD];
  
  board=board();
  board_w=board[W];
  
  lower_case_t=post_base_t+wall;
  upper_case_t=max_lid_t()-board[T];

  for(x=[fo+1, board_w+2*(wall+wall_pad)-fo-5-1],
      y=[-wall, board_d+2*wall_pad+2*wall])
  {
    translate([x,y, lower_case_t-5])
      cube([5, wall, 5+upper_case_t]);
  }
}
