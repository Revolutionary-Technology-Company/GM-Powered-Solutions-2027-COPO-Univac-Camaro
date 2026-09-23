// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_wiring_busbars.scad (Post-Body Dual-Harness Routing Architecture)
// Core Objective: Structural separation of 800V DC Busbars and 12V Avionics Loom
// Center Origin (0,0,0) = Firewall Centerpoint Pass-Through Axis
// ====================================================================================

$fn = 100; // High-precision CNC routing and extrusion resolution

// --- Physical Routing Constants (mm) ---
inch_to_mm         = 25.4;
frame_rail_length  = 114.3 * inch_to_mm; // 2903.22 mm longitudinal span
busbar_thickness   = 5.00;               // 5mm thick solid copper bar cross-section
busbar_width       = 30.00;              // 30mm width handling ultra-high launch current
harness_loom_dia   = 40.00;              // Shielded 12V low-voltage cockpit data trunk

module high_voltage_800v_busbars() {
    echo("EXTRUDING SOLID COUPLED 800V DC COPPER PROPULSION BUSBARS");
    // Positioned along the left lower chassis frame channel beneath the aluminum skid plate
    color("Orange") { // Aviation-standard orange protective high-voltage shielding wrap
        for (offset = [-45, 0]) {
            translate([-250, -frame_rail_length/2 + 200, -105 + offset])
                difference() {
                    // Solid copper power bar element
                    cube([busbar_width, frame_rail_length - 400, busbar_thickness]);
                    // Built-in mounting eyelets to bolt straight to the battery box contactor lugs
                    translate([busbar_width/2, 20, -1]) cylinder(d=8.5, h=10);
                    translate([busbar_width/2, frame_rail_length - 420, -1]) cylinder(d=8.5, h=10);
                }
        }
    }
}

module low_voltage_12v_cockpit_harness() {
    echo("ROUTING FLEXIBLE 12V LOW-VOLTAGE AVIONICS DATA LOOM");
    // Positioned along the right upper chassis rail, safely isolated from high-voltage fields
    color("Black") {
        translate([250, -frame_rail_length/2 + 400, 30])
            rotate([-90, 0, 0])
                difference() {
                    // Flexible braided nylon outer wire harness shielding sleeve
                    cylinder(d=harness_loom_dia, h=frame_rail_length - 600);
                    // Hollow internal volume core bundle space clearing custom pinned wires
                    cylinder(d=harness_loom_dia - 6, h=frame_rail_length - 598);
                }
    }
}

module firewall_grommet_mating_rings() {
    // Models the physical landing collars locking into your natural tree-rubber grommets
    for (side = [-1, 1]) {
        scale([side, 1, 1])
            translate([180, 0, 50])
                color("Silver")
                    difference() {
                        cylinder(d=75, h=12, center=true);
                        cylinder(d=65, h=14, center=true); // Direct wire portal clearance
                    }
    }
}

// --- Composite Electrical Routing System Instantiation ---
union() {
    high_voltage_800v_busbars();
    low_voltage_12v_cockpit_harness();
    firewall_grommet_mating_rings();
}
