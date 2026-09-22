// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_headlight_housing.scad (Authentic 1969 7" LED Conversion Shell)
// Target Specs: H6024/H6014 Historical Blueprinting / Pure Glass Outer Lens Envelope
// Center Origin (0,0,0) = Geometric Center of the Bulb H4 Socket Mounting Flange
// ====================================================================================

$fn = 120; // High-precision injection tool rendering depth

// --- 1969 Sealed Beam Dimensional Parameters (mm) ---
inch_to_mm         = 25.4;
headlight_outer_d  = 7.00 * inch_to_mm;   // Exactly 177.8 mm historical diameter
glass_lens_thickness= 4.50;               // Authentic heavy clear glass front plate
acrylic_rebound_t  = 3.00;                // Acrylic inner alignment structural cup
h4_socket_diameter = 38.50;               // Standard H4/9003 bulb base locking collar ring

module authentic_glass_lens_dome() {
    // Models the exact radius curvature profile of the historical 1969 clear glass front lens
    color("LightBlue", 0.3) { // High transparency visualization render
        difference() {
            translate([0, 0, 45])
                scale([1, 1, 0.35])
                    sphere(d=headlight_outer_d);
            translate([0, 0, 45])
                scale([1, 1, 0.35])
                    sphere(d=headlight_outer_d - (2 * glass_lens_thickness));
            // Section slice to form a clean flat mounting perimeter seal boundary flange
            translate([0, 0, 20])
                cube([200, 200, 50], center=true);
        }
    }
}

module acrylic_inner_reflector_housing() {
    // The internal rear structural parabolic backing cup molded from clear high-temp acrylic
    color("White", 0.6) {
        difference() {
            // Main reflector parabolic back boundary envelope
            cylinder(d1=h4_socket_diameter + 15, d2=headlight_outer_d, h=46, center=false);
            translate([0, 0, -1])
                cylinder(d1=h4_socket_diameter, d2=headlight_outer_d - 4, h=48, center=false);
                
            // Pre-machined locking index slots for the modern H4 LED 3-tab base collar
            for (angle = [0, 120, 240]) {
                rotate([0, 0, angle])
                    translate([h4_socket_diameter/2, 0, 5])
                        cube([6, 4, 12], center=true);
            }
        }
    }
}

module historical_mounting_ears() {
    // Three structural alignment tabs positioned at 120-degree intervals.
    // Screws directly into the 1969 chrome trim buckets and bucket adjusters.
    for (i = [0 : 2]) {
        rotate([0, 0, i * 120])
            translate([headlight_outer_d/2 + 6, 0, 25]) {
                color("Silver") {
                    difference() {
                        cube([6, 15, 10], center=true);
                        // Clears standard 1969 headlight spring adjustment adjustment hardware
                        rotate([0, 90, 0])
                            cylinder(d=4.2, h=10, center=true);
                    }
                }
            }
    }
}

// --- Composite Light Fixture System Instantiation ---
union() {
    authentic_glass_lens_dome();
    acrylic_inner_reflector_housing();
    historical_mounting_ears();
}
