// ====================================================
// Model for the Lucklight KWB-R3912W/1W backlight
// ====================================================
//                         (+) 
//                          |  (-)
//                          |  | 
//                          |  |
//                          |  |
//              X1,Y2   +----------+ X2, Y2
//                     /            \
//                    /              \
//          X0,Y1    +----------------+ X3, Y1
//                   |                |
//                   |                |
//                   |                |
//                   |                |
//                   |                |
//                   |                |
//                   |                |
//                   |                |
//                   |                |
//                   |                |
//                   |                |
//                   +----------------+
//                   X0,Y0            X3,Y0
//

backLight_width1    = 11.9;
backLight_width2    = 11.9;
backLight_width3    =  7.5;  // 11.90 to 7.5
backLight_height1   =  1.0;
backLight_height2   = 38.7; 
backLight_height3   =  7.2;
backLight_thickness = 2.20;

backLight_pin_spacing = 2.54;
backLight_pin_radius  = 0.25;
backLight_neg_pin_len = 26.5;
backLight_pos_pin_len = backLight_neg_pin_len * 1.1;

backLight_X0 = 0;
backLight_X1 = (backLight_width1 - backLight_width3)/2.0;
backLight_X2 = (backLight_width1 - backLight_X1);
backLight_X3 = backLight_width1;

backLight_Y0  = 0;
backLight_Y1  = (backLight_height1 + backLight_height2);
backLight_Y2  = (backLight_height1 + backLight_height2 + backLight_height3);


module backLight_lightArea(){
linear_extrude(height=backLight_thickness)
   polygon(
       points = [
              [backLight_X0, backLight_Y0],
              [backLight_X3, backLight_Y0],
              [backLight_X3, backLight_Y1],
              [backLight_X2, backLight_Y2],
              [backLight_X1, backLight_Y2],
              [backLight_X0, backLight_Y1]
          ]
  );
}

module backLight() {
union(){
        backLight_lightArea();

        // Negative Terminal
        translate([backLight_X2-0.25*backLight_width3,backLight_Y2-1.0,backLight_thickness/2])
            rotate([-90,0,0])cylinder(h= 8.0, r=backLight_pin_radius);

        // Positive Terminal
        translate([backLight_X1+0.25*backLight_width3,backLight_Y2-1.0,backLight_thickness/2])
            rotate([-90,0,0])cylinder(h=10.0, r=backLight_pin_radius);
}
}


module backLight_holder_bar() {
tolerance = 1.0;   // On each edge.  Total is 2mm ~ 80 mils
barHeight = 3.0;
barEnd = 2.5;      // Thickness of bar on each end

difference() {
     // Solid cube in the shape of the holding bar
     translate([-barEnd, 0, 0]) cube([backLight_width1 + 2*barEnd, barHeight, backLight_thickness+2.5]);

     // Hole with slightly bigger dimensions of than lightbar (z axis is much bigger so ends are removed cleanly)
     translate([-tolerance, -barHeight*2.5, -tolerance])cube([backLight_width1+2*tolerance, barHeight*5, backLight_thickness+2*tolerance]);
    }
}

// Until documentation is written this is how to instantiate objects
//#backLight();
//backLight_holder_bar();