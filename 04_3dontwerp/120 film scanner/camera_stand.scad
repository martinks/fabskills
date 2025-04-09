// base
bl = 120;   // width
bw = 120;    // length
bh = 3;     // height
bb = 2;     // border
bcs = 5;    // cell size
bcd = 2;    // cell wall thickness

// outer column
ocl = 90;    // inner length
ocw = 61;  // inner width
ocd = 2;     // wall thickness
och = 85;    // height

// inner column
icsep = 0.2; // separation between inner and outer column
icl = ocl-2*icsep;  // outer length
icw = ocw-2*icsep;  // outer width
icd = 1.5;   // wall thickness
ich = 35;    // height
icg = 1;     // vertical gap

// supports
sph = 36;   // height
spl = 6;    // length
spw = 25;   // width

// gap
gl = 86;    // length
gw = 58;    // width
gt = bh;    // taper width

// slit
sw = 61;  // width
sh = 5;     // height

// slide holes
shri = 8;   // inner radius
shro = 10;  // outer radius
shg = 3;    // height from base
shdh = 5;   // height difference between cylinders

// cylinder
cr = 32.5;
ch = 25;
cd = ocd;

// cone
cch = 100;


eps = 0.01;
$fn = 200;

//projection(cut = true)
//rotate([90,90,0]) // side view
//translate([0,0,-50])

module hc_column(length, cell_size, wall_thickness) {
        no_of_cells = floor(length / (cell_size + wall_thickness)) ;

        for (i = [0 : no_of_cells]) {
                translate([0,(i * (cell_size + wall_thickness)),0])
                         circle($fn = 6, r = cell_size * (sqrt(3)/3));
        }
}



module honeycomb (length, width, height, cell_size, wall_thickness) {
        no_of_rows = floor(1.2 * length / (cell_size +
wall_thickness)) ;

        tr_mod = cell_size + wall_thickness;
        tr_x = sqrt(3)/2 * tr_mod;
        tr_y = tr_mod / 2;
        off_x = -1 * wall_thickness / 2;
        off_y = wall_thickness / 2;
        linear_extrude(height = height, center = true, convexity = 10,
twist = 0, slices = 1)
                difference(){
                        square([length, width]);
                        for (i = [0 : no_of_rows]) {
                                translate([i * tr_x + off_x, (i % 2) *
tr_y + off_y,0])
                                        hc_column(width, cell_size,
wall_thickness);
                        }
                }
}


module support(spl,spw,sph,bh) {
    difference(){
        translate([0,-eps,0])
        cube([spl,spw+eps,sph+bh]);
        translate([0,0,bh])
        scale([1,1,sph/spw])
        translate([-eps/2,spw,spw])
        rotate([0,90,0])
        cylinder(h=spl+eps,r=spw);
    }
}


module cube_to_cylinder(width,depth,height,radius) {
    hull(){
        translate([-width/2,-depth/2,0])
        cube([width,depth,eps]);
        translate([0,0,height-eps])
        cylinder(h = eps, r = radius);
    }
}



intersection() {
  
color(c=[0,0.65,0.65,1])    
union() {
    
   // cube([36,24,5],center=true);
    
    // base
    translate([0,0,bh/2]) {
        
        union(){
        difference() {  
            cube([ocl+2*ocd+bb,ocw+2*ocd+bb,bh],center=true);
            cube([gl,gw,bh+eps],center=true);
            polyhedron(points=[   // taper
            [-gl/2-gt,-gw/2-gt,-bh/2-eps],   //0
            [gl/2+gt,-gw/2-gt,-bh/2-eps],    //1
            [gl/2+gt,gw/2+gt,-bh/2-eps],     //2
            [-gl/2-gt,gw/2+gt,-bh/2-eps],    //3
            [-gl/2,-gw/2,bh/2],           //4
            [gl/2,-gw/2,bh/2],            //5
            [gl/2,gw/2,bh/2],             //6
            [-gl/2,gw/2,bh/2]],
            faces=[
            [0,1,2,3],  // bottom
            [4,5,1,0],  // front
            [7,6,5,4],  // top
            [5,6,2,1],  // right
            [6,7,3,2],  // back
            [7,4,0,3]]); // left
        }
        difference() {
            translate([-bl/2,-bw/2,0]) 
            honeycomb(bl, bw, bh, bcs, bcd);
            cube([ocl+2*ocd+bb-eps,ocw+2*ocd+bb-eps,bh+eps],center=true);
        }
        difference() {
            cube([bl,bw,bh],center=true);
            cube([bl-bb,bw-bb,bh+bb+eps],center=true);
        }
}
    }
    
    // outer column
    translate([0,0,bh+sph/2-eps])
    difference() {
        cube([ocl+2*ocd,ocw+2*ocd,sph],center=true);
        cube([ocl,ocw,sph+eps],center=true);
        // remove cone
        translate([0,0,och/2-cch/2])
        cylinder(h=cch+eps,r1=0,r2=cr,center=true);
        
        // slit
        translate([0,0,-(och-sh)/2]) { 
            cube([ocl+2*ocd+eps,sw-eps,sh+eps],center=true);
        }
        
        // slide holes
        hull(){
            translate([0,ocw/2+ocd/2,-sph/2+shro+shg])
            rotate([90,0,0])
            cylinder(h=ocd+eps,r1=shro,r2=shri,center=true);
            translate([0,ocw/2+ocd/2,-sph/2+shro+shg+shdh])
            rotate([90,0,0])
            cylinder(h=ocd+eps,r1=shro,r2=shri,center=true);
        }
                
        hull(){
            translate([0,-ocw/2-ocd/2,-sph/2+shro+shg])
            rotate([90,0,0])
            cylinder(h=ocd+eps,r1=shri,r2=shro,center=true);
            translate([0,-ocw/2-ocd/2,-sph/2+shro+shg+shdh])
            rotate([90,0,0])
            cylinder(h=ocd+eps,r1=shri,r2=shro,center=true);
        }       
    }
    
    // support
    translate([ocd+ocl/2-spl,ocd+ocw/2,0])
    support(spl,spw,sph,bh);
    translate([-ocd-ocl/2,ocd+ocw/2,0])
    support(spl,spw,sph,bh);
    
    mirror([0,1,0]) {
        translate([ocd+ocl/2-spl,ocd+ocw/2,0])
        support(spl,spw,sph,bh);
        translate([-ocd-ocl/2,ocd+ocw/2,0])
        support(spl,spw,sph,bh);
    }
    // cylinder
    translate([0,0,ch/2+bh+och])
    difference() {
        cylinder(h=ch+eps,r=cr+cd,center=true);
        cylinder(h=ch+2*eps,r=cr,center=true);
    }
    
   translate([0,0,bh+sph-eps/2])
    difference() {
        cube_to_cylinder(ocl+2*ocd,ocw+2*ocd,och-sph+eps,cr+ocd);
        translate([0,0,-eps/2])
        cube_to_cylinder(ocl,ocw,och-sph+2*eps,cr);
    }
   

    
 
}
}

  
