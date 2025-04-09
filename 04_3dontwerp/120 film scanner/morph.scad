steps = 50;
width = 100;
depth = 150;
height = 50;
radius = 60;
thickness = 2;
eps = 0.01;
$fn = 200;
    
module cube_to_cylinder(width,depth,height,radius) {
    hull(){
        translate([-width/2,-depth/2,0])
        cube([width,depth,eps]);
        translate([0,0,height-eps])
        cylinder(h = eps, r = radius);
    }
}

difference() {
    cube_to_cylinder(width,depth,height,radius);
    translate([0,0,-eps/2])
    cube_to_cylinder(width-thickness,depth-thickness,height+eps,radius-thickness);
}