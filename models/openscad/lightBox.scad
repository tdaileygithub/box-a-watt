include <rBox.scad>

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

