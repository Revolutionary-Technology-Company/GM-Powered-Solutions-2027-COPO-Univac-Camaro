// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: bose_acoustic_enclosures.scad (Bose High-Efficiency Alert Matrix)
// Core Partner: Bose Automotive Custom Flight & Performance Acoustics Division
// Center Origin (0,0,0) = Geometric Center of the Transducer Mounting Flange Face
// ====================================================================================

$fn = 100; // CNC injection-tooling path optimization resolution

// --- Bose Mechanical Parameter Constants (mm) ---
inch_to_mm          = 25.4;
transducer_core_dia = 90.00;           // Tuned Bose 3.5-inch Neodymium midrange array
enclosure_depth     = 55.00;           // Optimized rear acoustic air-compression cavity
mount_flange_thick  = 4.00;            // Vibration-resistant rigid mounting collar
fastener_circle_dia = 102.00;          // Radial bolt circle diameter for speaker tabs

module bose_dash_pod() {
    // Rigid protective acoustic housing block designed to press-fit into the OtterBox dash beam
    color("DimGrey") {
        difference() {
            // Main cylindrical acoustic speaker housing cup
            cylinder(d=transducer_core_dia + 16, h=enclosure_depth, center=false);
            
            // Tuned internal air chamber volume box (Eliminates acoustic cancelation waves)
            translate([0, 0, mount_flange_thick])
                cylinder(d=transducer_core_dia, h=enclosure_depth);
                
            // Rear wire pass-through channel for the shielded low-voltage audio trunk
            translate([0, 0, -1])
                cylinder(d=16.0, h=mount_flange_thick + 2);
        }
    }
}

module integrated_mounting_flange() {
    // Horizontal mounting collar ear layout with pre-cut structural fastener through-holes
    color("Silver") {
        difference() {
            // Flat outer mounting rim ring ring
            translate([0, 0, enclosure_depth - mount_flange_thick])
                cylinder(d=fastener_circle_dia + 14, h=mount_flange_thick);
            
            // Clear inner bore matching the speaker cone swing throat
            translate([0, 0, enclosure_depth - mount_flange_thick - 1])
                cylinder(d=transducer_core_dia + 2, h=mount_flange_thick + 2);
            
            // 4-Point Symmetric Fastener Bolt Hole Layout (M4 hardware studs)
            for (i = [0 : 3]) {
                angle = i * 90;
                translate([cos(angle) * (fastener_circle_dia / 2), sin(angle) * (fastener_circle_dia / 2), enclosure_depth - mount_flange_thick - 1])
                    cylinder(d=4.5, h=mount_flange_thick + 2);
            }
        }
    }
}

// --- Composite Acoustic Module Instantiation ---
union() {
    bose_dash_pod();
    integrated_mounting_flange();
}
