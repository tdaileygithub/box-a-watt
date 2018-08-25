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

additionalThickness   =  15.0; 

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
        width=measuredInnerWidth+.5,              // Tweak
        height=measuredInnerWidth+.5,             // Tweak
        wallThickness=measuredWallThickness+3.0,  // Tweak
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
      import("../stl/camera_1_3.stl");
}

module camera_standoffs(standoffRadius, standoffHeight) {
       // The camera mounts are in a rectangle centered 12.5mm x 21.0mm spacing
      union() {
          translate([ 0,   0,   standoffHeight/2]) cylinder(r=standoffRadius, h=standoffHeight, center=true);
          translate([ 0,  12.5, standoffHeight/2]) cylinder(r=standoffRadius, h=standoffHeight, center=true);
          translate([21,   0,   standoffHeight/2]) cylinder(r=standoffRadius, h=standoffHeight, center=true);
          translate([21,  12.5, standoffHeight/2]) cylinder(r=standoffRadius, h=standoffHeight, center=true);
          }
}


module lightBox_camera_mount(plateThickness=4.0) {
       tolerance = 2.5;  // Make it easy to place

       camera_cable_width = 16.5;
       camera_cable_thickness = 0.15;
       camera_cable_width_opening = 25.0;  // Make as wide as camera
       camera_cable_thickness_opening = camera_cable_thickness + 1.5;

       standoffHeight = 5;

       difference() {
           union() {
                   cube([measuredInnerWidth-tolerance, measuredInnerWidth-tolerance, plateThickness]);

                   // Make a bar to hold the backlight in place
                   translate([4,2,plateThickness])backLight_holder_bar();

                   // Put the camera standoffs in place
                   translate([27,30,plateThickness]) camera_standoffs(standoffRadius=2, standoffHeight=standoffHeight);
           }
      
           // --------------------------------------------------
           // The following items are subtracted from the design
           // --------------------------------------------------

           // Remove the section for the Camera Cable Slit
           translate([50,5,-plateThickness*2.5])
               rotate([0,0,90])
                   cube([camera_cable_thickness_opening, camera_cable_width_opening, plateThickness*5]); // Cut this out of board


           // make holes for the BackLight power and ground wires
           translate([12,53, -plateThickness*0.5])cylinder(h= plateThickness*5, r=1.0);
           translate([ 8,53, -plateThickness*0.5])cylinder(h= plateThickness*5, r=1.0);

           // Make holes for camera mount
           translate([27,30,-100]) camera_standoffs(standoffRadius=1, standoffHeight=200);
      }


      // ----------------------------------------------------
      // Show the images of the camera and the backlight
      // but do not use them in building the working object
      // ----------------------------------------------------
      %translate([25,20, plateThickness + standoffHeight + 0.5]) camera_module_import();
      %translate([4,2,plateThickness]) backLight();
}

