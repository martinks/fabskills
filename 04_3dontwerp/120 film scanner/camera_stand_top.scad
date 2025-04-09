// outer column
ocl = 90;    // inner length
ocw = 61;  // inner width
ocd = 2;     // wall thickness
och = 85;    // height

// inner column
icsep = 0.2; // separation between inner and outer column

// supports
sph = 36;   // height

// cylinder
cr = 32.5;
ch = 25;
cd = ocd;

// connection top-bottom
overlap = 5;

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


//projection(cut = true)
//rotate([90,90,0]) // side view
//translate([0,0,-50])

intersection() {
  
color(c=[0,0.65,0.65,1])    
    
    union(){
        
       // transition to base
        difference() {
            cube_to_cylinder(ocl+4*ocd,ocw+4*ocd,och-sph+overlap+eps,cr+ocd);
            translate([0,0,-eps/2])
            cube_to_cylinder(ocl,ocw,och-sph+2*eps+overlap,cr);
            translate([0,0,overlap/2-eps/2])
            cube([ocl+2*ocd+2*icsep,ocw+2*ocd+2*icsep,overlap+eps],center=true);
        }
         
        // cylinder
        translate([0,0,ch/2+och-sph+overlap])
        difference() {
            cylinder(h=ch+eps,r=cr+cd,center=true);
            cylinder(h=ch+2*eps,r=cr,center=true);
        }
        
       
    
    }
   

    
 
}


  
