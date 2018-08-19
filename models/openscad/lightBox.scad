include <rBox.scad>

// Measurements of the the lightbox.
// Box Dimensions (mm)
measuredInnerWidth    =  55.0;
measuredOuterWidth    =  58.0;    // +0.3mm --- varies
measuredWallThickness =   1.5;
measuredLength        = 176.0;

measuredCornerRadius  =   5.0;    // A Guess --- looks about right for the rounding of edges 


// Model values
lightBox_endcap_offset = -measuredWallThickness/2.0;

// The light box is a simple hollow rectangle.  
module lightBox_model() {
rounded_hollow_box(
	width=measuredInnerWidth, 
	length=measuredInnerWidth, 
	height=measuredLength,
	thickness=measuredWallThickness,
	cornerRadius=measuredCornerRadius
	);
}

module lightBox_endcap() {
rounded_box_endcap_extra(
    width=measuredInnerWidth,
	length=measuredInnerWidth,
	wallThickness=measuredWallThickness,
	cornerRadius=measuredCornerRadius,
	additionalThickness=6.0
	);
}

module lightBox_wedge() {
lightBox_endcap();
translate([measureedInnerWidth/2.0, measuredInnerWidth/2.0, -40])
    cube([measuredInnerWidth, measuredInnerWidth, 4]);
}