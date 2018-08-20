// ----------------------------------------------------------
// Functions to create rounded boxes and endcaps
//
//          width (x)
// 	   +---------+
//	   |         |
//	   |         | height (y)
//	   |         |
//	   +---------+
//
// The length is in the z-direction.
// ----------------------------------------------------------

// Default the number of faces to make it smooth.
$fn = 150;


// ==================================================================================================
// Solid Box with the edges rounded
// If the radius is not set, then no rounding of the edges is done and a rectangular box is created.
// ==================================================================================================
module rounded_solid_box(width, height, length, radius=0.0)
{
  diameter = 2*radius;
  minkowski() {
    cube(size=[width-diameter, height-diameter, length]);
    cylinder(r=radius, h=0.01);
  }
}

// ==================================================================================================
// Rounded Hollow Rectangle (no bottom)
//              <------------- Width -------------->
//	^	+----------------------------------+
//	|	|         Thickness ^              |
//		|                   v              |
//	H	|     +----------------------+     |
//	E	|     |                      |     |
//	I	|     |    Hollow Center     |     |
//	G	|     |                      |     |
//	H	|     |                      |     |
//	T	|     +----------------------+     |
//		|                                  |
//	|	|                                  |
//	v	+----------------------------------+
//
// Lenght is in z direction.
// ==================================================================================================
module rounded_hollow_box(width, height, length, thickness, cornerRadius) {
  difference() {
    rounded_solid_box(width, height, length, cornerRadius); 
    translate([thickness/2, thickness/2, -thickness]) {
        rounded_solid_box(width-thickness, height-thickness, length+thickness*2, cornerRadius); 
    }
  } 
}

// ==================================================================================================
// Rounded Hollow Box with bottom
// One end of box is closed off with same thickness as rest of box.
// ==================================================================================================
module rounded_hollow_box_with_bottom(width, height, length, wallThickness, cornerRadius) {
  bottomWallThickness = wallThickness;  // Allow to change later independently
  
  difference() {
    rounded_solid_box(width, height, length, cornerRadius); 
    translate([wallThickness/2, wallThickness/2, bottomWallThickness]) {
        rounded_solid_box(width-wallThickness, height-wallThickness, length+0.01, cornerRadius); 
    }
  }
}

// ==================================================================================================
// Rounded Box Lid (to close off box)
// The lid can be made thicker by adjusting the additional thickness parameter.
// ==================================================================================================
module rounded_flat_box_lid (width, height, wallThickness, cornerRadius, additionalThickness=0.0) {
  tolerance = 0.125;   // On each edge.  Total is 0.25mm ~ 10 mils
  union() {
    rounded_solid_box(width, height, (wallThickness+additionalThickness)/2, cornerRadius);
    translate([wallThickness/2+tolerance, wallThickness/2+tolerance, (wallThickness+additionalThickness)/2])
      rounded_solid_box(width-wallThickness-2*tolerance, height-wallThickness-2*tolerance, (wallThickness+additionalThickness)/2, cornerRadius);
  }
}

// ==================================================================================================
// Inner Box Gasket (lid with hollow center)
// The gasket can be made thicker by adjusting the additional thickness parameter.
// ==================================================================================================
module rounded_box_gasket (width, height, wallThickness, cornerRadius, additionalThickness=0.0) {
   tolerance = 0.125;   // On each edge.  Total is 0.25mm ~ 10 mils

   innerWallThickness = 3*wallThickness;
  
   // Remove a slightly smaller box from the rounded_flat_box_lid
   difference() {
       rounded_flat_box_lid (width, height, wallThickness, cornerRadius, additionalThickness);

       // A large (lengthwise) solid box that is to be removed.
       translate([innerWallThickness/2, innerWallThickness/2, -(wallThickness+additionalThickness)*5/2])
           rounded_solid_box(width-innerWallThickness, height-innerWallThickness, (wallThickness+additionalThickness)*5, cornerRadius);
  }
}


// ==================================================================================================
// Rounded Sloped Box Lid (to close off box)
// One side is thicker than the other
// The lid can be made thicker by adjusting the additional thickness parameter.
// ==================================================================================================
module rounded_sloped_flat_box_lid (width, height, wallThickness, cornerRadius, additionalThickness=0.0, angle=0.0) {

  thickness = (wallThickness+additionalThickness)/2;
  
  difference(){
        // Tilt the lid
	rotate([-angle, 0, 0]) rounded_flat_box_lid(width, height, wallThickness, cornerRadius, additionalThickness);

        // Huge Plane that is flat
	translate([-width*2.5,-height*2.5,-thickness*10])cube([width*5, height*5, thickness*10]);
  }			       
}


// ==================================================================================================
// Sloped Inner Box Gasket (lid with hollow center)
// Gasket with one side larger than the other
// The gasket can be made thicker by adjusting the additional thickness parameter.
// ==================================================================================================
module rounded_sloped_box_gasket (width, height, wallThickness, cornerRadius, additionalThickness=0.0, angle=0) {

  thickness = (wallThickness+additionalThickness)/2;
  
  difference(){
        // Tilt the gasket
	rotate([-angle, 0, 0]) rounded_box_gasket(width, height, wallThickness, cornerRadius, additionalThickness);

        // Huge Plane that is flat
	translate([-width*2.5,-height*2.5,-thickness*10])cube([width*5, height*5, thickness*10]);
  }			       

}



// ==================================================================================================
// Until documentation is added here is how to create the objects
// ==================================================================================================
//rounded_solid_box(55, 55, 100, 5);
//rounded_hollow_box(55, 55, 100, 1.5, 5);
//rounded_hollow_box_with_bottom(55, 55, 100, 1.5, 5);
//rounded_flat_box_lid(55, 55, 1.5, 5, 6.0);
//rounded_box_gasket(55, 55, 1.5, 5, 6.0);
//rounded_sloped_flat_box_lid(55, 55, 1.5, 5, 10.0, 4);
//rounded_sloped_box_gasket(55, 55, 1.5, 5, 10.0, 4);
