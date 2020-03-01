module 3d_chamfer_box(dims, fillet){
  tb_cube=[dims[0]-2*fillet, dims[1]-2*fillet, fillet];
  lr_cube=[fillet, dims[1]-2*fillet, dims[2]-2*fillet];
  fb_cube=[dims[0]-2*fillet, fillet, dims[2]-2*fillet];
  hull(){
    for(x=[0, dims[0]-fillet]){
      translate([x,fillet, fillet])
        cube(lr_cube);
    }
    for(y=[0, dims[1]-fillet]){
      translate([fillet, y, fillet])
        cube(fb_cube);
    }
    for(z=[0, dims[2]-fillet]){
      translate([fillet, fillet, z])
        cube(tb_cube);
    }
  }
}

module 3d_fillet_box(dims, fillet, $fn=40){
  xmax = dims[0] - fillet > fillet ? dims[0]-fillet : fillet;
  ymax = dims[1] - fillet > fillet ? dims[1]-fillet : fillet;
  zmax = dims[2] - fillet > fillet ? dims[2]-fillet : fillet;
  hull(){
    for(x=[fillet, xmax],
        y=[fillet, ymax])
    {
      translate([x,y,fillet])
        sphere(r=fillet, $fn=$fn);

      translate([x,y,zmax])
        sphere(r=fillet, $fn=$fn);
    }
  }
}

module chamfer_box(dims, fillet){
  lr_cube=[fillet, dims[1]-2*fillet, dims[2]];
  fb_cube=[dims[0]-2*fillet, fillet, dims[2]];
  hull(){
    for(x=[0, dims[0]-fillet]){
      translate([x,fillet, 0])
        cube(lr_cube);
    }
    for(y=[0, dims[1]-fillet]){
      translate([fillet, y, 0])
        cube(fb_cube);
    }
  }
}

module fillet_box(dims, fillet, $fn=60){
  xmax = dims[0] - fillet > fillet ? dims[0]-fillet : fillet;
  ymax = dims[1] - fillet > fillet ? dims[1]-fillet : fillet;
  hull(){
    for(x=[fillet, xmax],
        y=[fillet, ymax])
    {
      translate([x,y,0])
        cylinder(r=fillet, h=dims[2], $fn=$fn);
    }
  }
}

module inner_fillet(height, fillet){
  intersection(){
    difference(){
      cube([2*fillet, 2*fillet, height]);
      translate([fillet, fillet, -0.001])
        cylinder(r=fillet, h=height+0.002, $fn=80);
    }
    
    cube([fillet, fillet, height]);
  }
}

//chamfer_box([30,30,30],4);
//3d_chamfer_box([30,30,30],4);
