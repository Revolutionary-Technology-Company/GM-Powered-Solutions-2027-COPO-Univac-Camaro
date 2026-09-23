#!/usr/bin/env python3
# ==============================================================================
# REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
# Module: led_dash_driver.py (1969 Analog-Style Custom LED Cluster Driver)
# Reference Architecture: Teletank Master 32-Bit Control Register Format
# ==============================================================================

class CopoCustomLEDDashDriver:
    def __init__(self):
        # Operational gauge limits mapping maximum mechanical gauge arcs
        self.MAX_NEEDLE_ANGLE_DEG = 270.0
        self.MAX_SCALE_RPM        = 12000
        self.MAX_SCALE_MPH        = 250
        self.FIXED_POINT_SCALER   = 100

    def compute_gauge_vectors(self, live_motor_rpm: int, live_vehicle_mph: float, system_fault_active: bool) -> dict:
        """
        Calculates needle stepper motor command angles and multi-segment LED 
        backlighting states while maintaining zero calculation tracking drift.
        """
        # Calculate mechanical needle pointer deflection angles (0 to 270 degree sweeps)
        rpm_angle = (live_motor_rpm * self.MAX_NEEDLE_ANGLE_DEG) / self.MAX_SCALE_RPM
        mph_angle = (live_vehicle_mph * self.MAX_NEEDLE_ANGLE_DEG) / self.MAX_SCALE_MPH
        
        # Clamp needle arcs safely within maximum mechanical travel boundaries
        clamped_rpm_angle = max(0.0, min(self.MAX_NEEDLE_ANGLE_DEG, rpm_angle))
        clamped_mph_angle = max(0.0, min(self.MAX_NEEDLE_ANGLE_DEG, mph_angle))

        # Determine light-pipe segment alert color parameters based on systemic health
        led_color_mode_hex = 0x11 # 0x11 = Standard Bright White illumination scheme
        dial_status = "INSTRUMENTATION_RAILS_NOMINAL"
        
        if system_fault_active:
            led_color_mode_hex = 0xEE # 0xEE = Flashing Emergency Crimson warning state
            dial_status = "CRITICAL_ALERT_DASH_FLASH_ENGAGED"
            
        # Unpack parameters into the un-truncated 108-bit tracking system configuration representation
        # Bits 72-107: LED Code | Bits 36-71: Tach Target | Bits 0-35: Speedo Target
        rpm_steps = int(clamped_rpm_angle * self.FIXED_POINT_SCALER)
        mph_steps = int(clamped_mph_angle * self.FIXED_POINT_SCALER)
        stacked_word = (led_color_mode_hex << 72) | (rpm_steps << 36) | mph_steps
        
        # Compute the 36-bit Univac word representation to update the display mainframe loop
        univac_display_word = (led_color_mode_hex << 24) | ((rpm_steps // 100) << 12) | (mph_steps // 100)
        
        return {
            "DIAL_FACE_ILLUMINATION_STATUS": dial_status,
            "SPEEDOMETER_NEEDLE_ANGLE": round(clamped_mph_angle, 2),
            "TACHOMETER_NEEDLE_ANGLE": round(clamped_rpm_angle, 2),
            "UNIVAC_IX_36BIT_WORD": f"0x{univac_display_word & 0x7FFFFFFFF:09X}"
        }

if __name__ == "__main__":
    cluster_driver = CopoCustomLEDDashDriver()
    print("=======================================================================")
    print("UNIVAC-IX 1969 CUSTOM LED CHASSIS INSTRUMENTATION CONTROLLER RUNNING")
    print("=======================================================================")
    
    # Simulation: Car accelerates hard down the course lane (8500 RPM, 142 MPH) under safe conditions
    current_rpm   = 8520
    current_speed = 142.5
    is_faulted    = False
    
    command_block = cluster_driver.compute_gauge_vectors(current_rpm, current_speed, is_faulted)
    print(f"[POWERTRAIN SENSE] Engine: {current_rpm} RPM | Speedometer: {current_speed} MPH")
    print(f"[GAUGE POINTER VECTORS] Speedo Needle: {command_block['SPEEDOMETER_NEEDLE_ANGLE']} Deg | Tach Needle: {command_block['TACHOMETER_NEEDLE_ANGLE']} Deg")
    print(f"[LIGHT PIPE BACKLIGHTING]: {command_block['DIAL_FACE_ILLUMINATION_STATUS']}")
    print(f"[MAINFRAME PACKET STREAM]: Serializing Word to Dash: {command_block['UNIVAC_IX_36BIT_WORD']}")
    print("=======================================================================")
