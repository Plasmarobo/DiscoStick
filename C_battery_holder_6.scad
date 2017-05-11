holder_outer_diameter=35;
battery_positive_diameter=6.5;
battery_diameter=25;
battery_len=50;
battery_positive_len=2;
battery_positive_div=1;
battery_count=2;
connector_len=2;
$fn=100;
cell_len = (battery_len + battery_positive_len);
inner_len = cell_len * battery_count;
outer_len = inner_len + (connector_len * 2);

 module prism(l, w, h){
       polyhedron(
               points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
               faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
       );
};
       
module cantilever(x,y,z,s) {
    CANTILEVER_LENGTH=15*s;
    CANTILEVER_HEIGHT=7*s;
    CANTILEVER_WIDTH=5*s;
    CANTILEVER_DEPTH=7*s;
    CANTILEVER_TAB=2*s;
    CANTILEVER_BASE_HEIGHT=5*s;
    CANTILEVER_BASE_FACTOR=2;
    cantilever_base = CANTILEVER_BASE_FACTOR * CANTILEVER_HEIGHT;
    translate([x-(CANTILEVER_WIDTH/2),y-(CANTILEVER_HEIGHT/2), z]){
        cube([CANTILEVER_WIDTH,CANTILEVER_HEIGHT,CANTILEVER_LENGTH + CANTILEVER_BASE_HEIGHT]);
        translate([CANTILEVER_WIDTH,CANTILEVER_HEIGHT,CANTILEVER_LENGTH+CANTILEVER_BASE_HEIGHT]){
            rotate([90,180,90]) {
              prism(CANTILEVER_HEIGHT, CANTILEVER_DEPTH, CANTILEVER_TAB);
            };
        };
    };
    FLARE_DIAMETER=cantilever_base - CANTILEVER_WIDTH;
    translate([x-(cantilever_base/2), y-(CANTILEVER_HEIGHT/2), z]) {
        difference() {
            cube([cantilever_base, CANTILEVER_HEIGHT, CANTILEVER_BASE_HEIGHT]);
            union() {
                translate([0,CANTILEVER_HEIGHT+1,CANTILEVER_BASE_HEIGHT]){
                    rotate([90,0,0]){
                        cylinder(h=CANTILEVER_HEIGHT+2, d=FLARE_DIAMETER, center=false);
                    };
                };
                translate([cantilever_base,CANTILEVER_HEIGHT+1,CANTILEVER_BASE_HEIGHT]){
                    rotate([90,0,0]){
                        cylinder(h=CANTILEVER_HEIGHT+2, d=FLARE_DIAMETER, center=false);
                    };
                };
            };
        };
    };
};

module battery(x,y,z) {
     union() {
        translate([x,y,z + battery_len-0.1]) {
            cylinder($fn=100, h=battery_positive_len, d=battery_positive_diameter, center=false);
        }
        translate([x,y,z-battery_positive_div]) {
            cylinder($fn=100, h=battery_len+battery_positive_div, d=battery_diameter, center=false);
        }
        translate([x-(battery_diameter/2),y,z-battery_positive_div]) {
            cube([battery_diameter, battery_diameter*3,cell_len+battery_positive_div], center=false);
        }
    };
};

cantilever(0,0,0,1);
