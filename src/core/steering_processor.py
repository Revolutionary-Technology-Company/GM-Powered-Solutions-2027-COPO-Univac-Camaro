#!/usr/bin/env python3
# ==============================================================================
# REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
# Module: steering_processor.py (Adaptive Ocular Steering Control Engine)
# ==============================================================================

import math

class OcularSteeringProcessor:
    def __init__(self):
        # Operational fixed point math limits mapping steering inputs
        self.FIXED_POINT_SCALER = 100000
        self.STRAIGHT_AHEAD_THRESHOLD_DEG = 2.0
        
    def analyze_driver_metrics(self, wheel_turn_deg: float, eye_vector_x: float, lateral_g: float) -> dict:
        """
        Processes look vectors alongside steering angles using direct integer transitions 
        to track driver style trends while maintaining zero computation drift.
        """
        # Scale values to fixed-point integers to avoid floating point truncation bugs
        turn_angle_fixed = int(wheel_turn_deg * self.FIXED_POINT_SCALER)
        eye_look_fixed   = int(eye_vector_x * self.FIXED_POINT_SCALER)
        
        # CORE DRIVER DIAGNOSTICS: Check look focus alignment against turn parameters
        # Evaluates if the driver's eyes are looking through the exit point of a corner
        is_focused = True
        warning_msg = "DRIVING_LINE_OPTIMAL"
        correction_code = 0x00
        
        if abs(wheel_turn_deg) > self.STRAIGHT_AHEAD_THRESHOLD_DEG and eye_vector_x == 0.0:
            # Driver is turning the wheel but staring straight at the hood rather than looking ahead
            is_focused = False
            warning_msg = "CORRECTION_TIP: LOOK THROUGH THE CORNER EXIT!"
            correction_code = 0x3E  // Custom Univac-IX screen flag ID
            
        # DYNAMIC ASSIST LOGIC: Increase assistance power at lower tracking speeds
        base_assist_current = 45 # Amps delivery ceiling
        if abs(lateral_g) > 1.2 and not is_focused:
            # High load situation with distracted gaze: ramp assist power to stabilize wheel controls
            base_assist_current = 65
            warning_msg = "SAFETY_WARNING: EYE ENVELOPE MISALIGNED DURING HIGH-G ENTRY"
            correction_code = 0x7F
            
        # Package metrics into our un-truncated 108-bit tracking data mask representation
        # Bits 72-107: Assist Current | Bits 36-71: Look Vector | Bits 0-35: Alert Index
        stacked_register_word = (base_assist_current << 72) | (abs(eye_look_fixed) << 36) | correction_code
        
        return {
            "ASSIST_AMPS_OUT": base_assist_current,
            "COCKPIT_ALERT_STRING": warning_msg,
            "UNIVAC_IX_36BIT_WORD": f"0x{(stacked_register_word >> 72) & 0x7FFFFFFFF:09X}"
        }

if __name__ == "__main__":
    processor = OcularSteeringProcessor()
    print("=======================================================================")
    print("UNIVAC-IX EYE-TRACKING COMPLIANT STEERING HUB RUNNING")
    print("=======================================================================")
    
    # Simulation: Hard corner entry with incorrect eye focus vector tracking
    steering_input_angle = 45.2   # Turning left into a track bend
    driver_eye_gaze_x    = 0.0    # Eyes are fixated dead center (distracted/panicked)
    measured_chassis_g   = 1.35   # High lateral force envelope
    
    profile = processor.analyze_driver_metrics(steering_input_angle, driver_eye_gaze_x, measured_chassis_g)
    
    print(f"[INPUT METRICS] Angle: {steering_input_angle} Deg | G-Force: {measured_chassis_g} Gs")
    print(f"[DASHBOARD OUTPUT]: {profile['COCKPIT_ALERT_STRING']}")
    print(f"[SERVO CURRENT]: Driving Assist Output set to: {profile['ASSIST_AMPS_OUT']} Amps")
    print(f"[MAINFRAME PACKET]: Serialized Code Stream Word: {profile['UNIVAC_IX_36BIT_WORD']}")
    print("=======================================================================")
