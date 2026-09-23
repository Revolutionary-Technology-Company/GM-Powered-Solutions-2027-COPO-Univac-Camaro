// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_door_handles.scad (Authentic 1969 Handle & Latch Matrix)
// Core Objective: Structural casing for 1969 push-button exterior / pull-lever inner handles
// Center Origin (0,0,0) = Geometric Centerpoint of the Exterior Push-Button Mechanism
// ====================================================================================

$fn = 120; // High-fidelity CNC laser-cut and die-cast tooling path resolution

// --- 1969 Factory Mechanical Constants (mm) ---
inch_to_mm         = 25.4;
handle_length      = 6.50 * inch_to_mm;   // 165.1 mm original chrome handle length
push_button_dia    = 22.00;              // 1969 factory mechanical push cylinder
latch_block_depth  = 85.00;              // Depth of the internal claw-latch unit
cable_guide_bore   = 6.00;               // Clearance bore for high-tensile aircraft cables

// Production Configuration Selector
// 1 = Base/SS Street Spec (Pure Mechanical Latch), 2 = Tactical Police / NHRA Drag Spec (Solenoid Interlocked)
DOOR_LOCK_VARIANT = 2;

module exterior_chrome_handle_casing() {
    echo(str("COMPILING HISTORICAL 1969 DOOR HANDLE COMPONENT: ", (DOOR_LOCK_VARIANT == 2) ? "TACTICAL_SOLENOID_INTERLOCKED" : "PURE_MECHANICAL_STREET"));
    color("Chrome") { // High-polish mirror finish representation
        difference() {
            // Main rectangular exterior handle body casting strip
            cube([handle_length, 28, 14], center=true);
            
            // Left side recess pocket for the thumb push-button assembly
            translate([-handle_length/2 + 20, 0, 2])
                cylinder(d=push_button_dia + 1.5, h=20, center=true);
        }
    }
}

module internal_claw_latch_block() {
    // Mechanical rotor claw that locks onto the chassis B-pillar striker pin
    color("DimGrey") {
        translate([handle_length/2 + 30, -latch_block_depth/2 + 10, -10]) {
            difference() {
                cube([45, latch_block_depth, 60], center=true);
                // Striker pin entry jaw slot
                translate([0, latch_block_depth/2 - 20, 0])
                    cube([50, 25, 20], center=true);
                // Pre-drilled channel routing the low-friction inner aircraft actuator cables
                translate([-15, 0, 15])
                    rotate([90, 0, 0])
                        cylinder(d=cable_guide_bore, h=latch_block_depth + 2, center=true);
            }
        }
    }
}

module tactical_lock_actuator() {
    // High-speed, low-draw inline locking solenoid module used on Track/Police setups.
    // Physically blocks the handle linkage from releasing the claw latch while in motion.
    if (DOOR_LOCK_VARIANT == 2) {
        color("FireBrick") {
            translate([handle_length/2 + 15, -latch_block_depth - 10, -10]) {
                difference() {
                    cube([30, 45, 30], center=true);
                    // Center plunger locking deadbolt shaft channel
                    rotate([90, 0, 0])
                        cylinder(d=8.0, h=47, center=true);
                }
            }
        }
    }
}

// --- Composite Structural System Instantiation ---
union() {
    exterior_chrome_handle_casing();
    internal_claw_latch_block();
    tactical_lock_actuator();
}
