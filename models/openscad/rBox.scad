// -------------------------------
// Rounded Box and endcaps
// -------------------------------

// Default the number of faces to make it smooth
$fn = 150;


// ==================================================================================================
// Solid Box with the edges rounded
// ==================================================================================================
module rounded_solid_box(width, length, height, radius)
{
  diameter = 2*radius;
  minkowski() {
    cube(size=[width-diameter, length-diameter, height]);
    cylinder(r=radius, h=0.01);
  }
}

// ==================================================================================================
// Rounded Hollow Box (no bottom)
// ==================================================================================================
module rounded_hollow_box(width, length, height, thickness, cornerRadius) {
  difference() {
    rounded_solid_box(width, length, height, cornerRadius); 
    translate([thickness/2, thickness/2, -thickness]) {
      rounded_solid_box(width-thickness, length-thickness, height+thickness*2, cornerRadius); 
    }
  } 
}

// ==================================================================================================
// Rounded Hollow Box with bottom
// ==================================================================================================
module rounded_hollow_box_with_bottom(width, length, height, thickness, cornerRadius) {
  bottomThickness = thickness;  // Allow to change later independently
  
  difference() {
    rounded_solid_box(width, length, height, cornerRadius); 
    translate([thickness/2, thickness/2, bottomThickness]) {
      rounded_solid_box(width-thickness, length-thickness, height+0.01, cornerRadius); 
    }
  }
}

// ==================================================================================================
// Box Endcap
// ==================================================================================================
module rounded_box_endcap(width, length, thickness, cornerRadius) {
  tolerance = 0.125;   // On each edge.  Total is 0.25mm ~ 10 mils
  union() {
    rounded_solid_box(width, length, thickness/2, cornerRadius);
    translate([thickness/2+tolerance, thickness/2+tolerance, thickness/2])
      rounded_solid_box(width-thickness-2*tolerance, length-thickness-2*tolerance, thickness/2, cornerRadius);
  }
}

// ==================================================================================================
// Box Endcap with extra thickness
// ==================================================================================================
module rounded_box_endcap_extra(width, length, wallThickness, cornerRadius, additionalThickness=0.0) {
  tolerance = 0.125;   // On each edge.  Total is 0.25mm ~ 10 mils
  union() {
    rounded_solid_box(width, length, (wallThickness+additionalThickness)/2, cornerRadius);
    translate([wallThickness/2+tolerance, wallThickness/2+tolerance, (wallThickness+additionalThickness)/2])
      rounded_solid_box(width-wallThickness-2*tolerance, length-wallThickness-2*tolerance, (wallThickness+additionalThickness)/2, cornerRadius);
  }
}
