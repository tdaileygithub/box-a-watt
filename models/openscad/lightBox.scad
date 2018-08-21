include <rBox.scad>
include <backLight.scad>

// Measurements of the the lightbox.
// Box Dimensions (mm)
measuredInnerWidth    =  55.0;
measuredOuterWidth    =  58.0;    // +0.3mm --- varies
measuredWallThickness =   1.5;
measuredLength        = 176.0;

// For curved edges use a small radius (or 0).
// This amount is shaved off each edge and the part prints smaller.
measuredCornerRadius  =   0.5;

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


module camera_module_import() {
      // Orient the camera correctly and place edge at 0,0.
      // This module wraps this position and orientation so that future
      // transforms on the camera are on the correctly oriented part instead
      // of the original stl model.
      %translate([0,25,0]) rotate([0,0,-90]) import("../stl/camera_1_3.stl");
}

module lightBox_camera_mount(plateThickness=4.0) {
       tolerance = 2.0;  // Make it easy to place

       camera_cable_width = 16.5;
       camera_cable_thickness = 0.15;
       camera_cable_width_opening = 25.0;  // Make as wide as camera
       camera_cable_thickness_opening = camera_cable_thickness + tolerance;

       difference() {
           cube([measuredInnerWidth-tolerance, measuredInnerWidth-tolerance, plateThickness]);

           // Camera Cable Slit
	   translate([20,15,-plateThickness*2.5])cube([camera_cable_thickness_opening, camera_cable_width_opening, plateThickness*5]); // Cut this out of board

           // BackLight pin holes
	  translate([12,53, -plateThickness*0.5])cylinder(h= plateThickness*5, r=1.0);
	  translate([ 8,53, -plateThickness*0.5])cylinder(h= plateThickness*5, r=1.0);
       }

      // Make a bar to hold the backlight in place
      translate([4,2,plateThickness])backLight_holder_bar();

      // Show the images of the camera and the backlight - but do not use them in building the working object
      translate([25,15,plateThickness]) camera_module_import();
      %translate([4,2,plateThickness]) backLight();
}

