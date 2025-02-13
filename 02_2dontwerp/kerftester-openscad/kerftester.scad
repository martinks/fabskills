// simple kerf fit tester
// render (and then export to svg)
//
n = 10;         // number of cuts
base = 2.6;     // smallest curve
spacing = 12;   // space between the cuts
kerf = 0.05;    // kerf increment
kerftester();
module kerftester(){
projection(){    
difference(){
    cube([spacing+n*(spacing),20,3]);
    for(i=[0:1:n]){
    translate([spacing+i*spacing,10,-0.01]){
        cube([base+i*kerf,16,3.5]);
        translate([0,-5,0])linear_extrude(4,convexity = 10)text(str(base+i*kerf),size=3);       
            }
        }
    }
// and for assembling 10 bits of 10mm for kerf sizing
    for(i=[0:1:n-1]){
    translate([spacing/2+i*spacing,10,-0.01]){
            translate([0,-28,0])cube([10,15,3]);
            translate([spacing/2-2,-20,0])cube([2,15,3]);
            }
        }
    }
}

