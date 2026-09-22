// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_6_variant_line.scad (Parametric 1969 Multi-Variant Production Line)
// Core Principle: One Unified Chassis Framework Modulating Across 6 Stamping Shapes
// ====================================================================================

$fn = 120; // Structural CNC alignment resolution

// --- Master Production Variant Selectors ---
// 1 = Base Coupe, 2 = Rally Sport (RS), 3 = Super Sport (SS), 
// 4 = Z28 Trans-Am, 5 = COPO Drag Special, 6 = Z11 Pace Car Convertible
BODY_VARIANT_INDEX = 5; 

// --- 6-Variant Dimensional Parameter Lookups ---
// Performance tuned using modern aerodynamic and track geometry knowledge
variant_names   = ["BASE_COUPE", "RS_HIDEAWAY", "SS_BIG_BLOCK", "Z28_ROAD_RACE", "COPO_STRIP_MONSTER", "PACE_CAR_CONV"];
fender_flare_mm = [0.0, 10.0, 15.0, 25.0, 45.0, 12.0];    // COPO gets maximum widebody tire tub flare
rear_downforce_n =;        // Aerodynamic downforce tuning profiles
mount_offset_y   = [0.0, 12.5, -5.0, 20.0, 35.5, -15.0];  // Varied mounting hole alignments

// --- Unified Structural Chassis Constants ---
inch_to_mm       = 25.4;
base_track_rear  = 65.50 * inch_to_mm;
base_track_front = 63.80 * inch_to_mm;
frame_length     = 114.3 * inch_to_mm;

module print_production_manifest() {
    echo("=======================================================================");
    echo(str("  CHEVROLET FACTORY STAMPING LINE INTEGRATION ACTIVE: ", variant_names[BODY_VARIANT_INDEX-1]));
    echo(str("  -> Applied Widebody Flare Extension: ", fender_flare_mm[BODY_VARIANT_INDEX-1], " mm"));
    echo(str("  -> Target Aerodynamic Downforce Parameter: ", rear_downforce_n[BODY_VARIANT_INDEX-1], " Newtons"));
    echo("=======================================================================");
}

module unified_chassis_rails() {
    // Heavy-duty structural box rails that remain constant regardless of variant
    color("DimGrey") {
        translate([-300, -frame_length/2, -100]) cube([50, frame_length, 100]);
        translate([ 250, -frame_length/2, -100]) cube([50, frame_length, 100]);
    }
}

module variant_specific_body_mounts() {
    // Dynamically shifts mounting locations depending on which 1969 body style is active
    active_offset = mount_offset_y[BODY_VARIANT_INDEX-1];
    active_flare  = fender_flare_mm[BODY_VARIANT_INDEX-1];
    
    color("Gold") {
        // Front Clip Mating Interfaces
        translate([-350 - active_flare, frame_length/3 + active_offset, 0]) cube([60, 40, 20]);
        translate([ 290 + active_flare, frame_length/3 + active_offset, 0]) cube([60, 40, 20]);
        
        // Rear Wheel Tub Mating Interfaces (Ensures Pirelli wide tires don't scrape inner sheet metal)
        translate([-350 - active_flare, -frame_length/3 + active_offset, -20]) cube([60, 40, 20]);
        translate([ 290 + active_flare, -frame_length/3 + active_offset, -20]) cube([60, 40, 20]);
    }
}

// --- Compile Active Shell Frame Config ---
print_production_manifest();
union() {
    unified_chassis_rails();
    variant_specific_body_mounts();
}
