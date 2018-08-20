include <rBox.scad>
include <backLight.scad>

// Measurements of the the lightbox.
// Box Dimensions (mm)
measuredInnerWidth    =  55.0;
measuredOuterWidth    =  58.0;    // +0.3mm --- varies
measuredWallThickness =   1.5;
measuredLength        = 176.0;

measuredCornerRadius  =   5.0;    // A Guess --- looks about right for the rounding of edges 

additionalThickness   =  10.0; 

// The light box is a simple hollow rectangle.  
module lightBox_model() {
rounded_hollow_box(
	width=measuredInnerWidth,
	height=measuredInnerWidth,
	length=measuredLength,
	thickness=measuredWallThickness,
	cornerRadius=measuredCornerRadius
	);
}


module lightBox_wedge(ange=0.0) {
    rounded_sloped_box_gasket(
        width=measuredInnerWidth,
	height=measuredInnerWidth,
	wallThickness=measuredWallThickness,
	cornerRadius=measuredCornerRadius,
	additionalThickness=additionalThickness,
	angle=angle
	);
}

module lightBox_camera_mount(plateThickness=4.0) {
       tolerance = 0.125;   // On each edge.  Total is 0.25mm ~ 10 mils

       camera_cable_width = 16.0 + tolerance;
       camera_cable_thickness = .5; // 0.15 + tolerance;
       
       difference() {
           cube([measuredInnerWidth-tolerance, measuredInnerWidth-tolerance, plateThickness]);

           // Camera Cable Slit
	   translate([20,20,-plateThickness*2.5])cube([camera_cable_thickness, camera_cable_width, plateThickness*5]); // Cut this out of board

           // BackLight pin holes
	  translate([12,53, -plateThickness*0.5])cylinder(h= plateThickness*5, r=0.7);
	  translate([ 8,53, -plateThickness*0.5])cylinder(h= plateThickness*5, r=0.7);
       }

      // Make a bar to hold the backlight in place
      translate([4,2,plateThickness])backLight_holder_bar();

      // Show the images of the camera and the backlight - but do not use them in building the working object
      %translate([25,15,plateThickness]) import("../camera_1_3.stl");
      %translate([4,2,plateThickness]) backLight();
}

