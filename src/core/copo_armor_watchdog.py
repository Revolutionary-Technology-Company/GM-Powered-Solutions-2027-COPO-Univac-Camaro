#!/usr/bin/env python3
# ==============================================================================
# REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
# Module: src/core/copo_armor_watchdog.py (COPO Underbody Condensation Governor)
# Reference Architecture: Teletank Master 32-Bit Control Register Format
// ==============================================================================

class RTCopoArmorWatchdog:
    def __init__(self):
        # Native 16 discrete voltage intervals mapping moisture saturation curves [INDEX]
        self.HEX_VOLTAGE_STAGES = [0.0, 0.0625, 0.125, 0.1875, 0.25, 0.3125, 0.375, 0.4375,
                                   0.5, 0.5625, 0.625, 0.6875, 0.75, 0.8125, 0.875, 1.0]
        self.VAPOR_CEILING_INDEX = 11 # Approx 68% relative humidity threshold parameter

    def map_sensor_volts_to_hex(self, line_volts: float) -> int:
        """
        Bypasses binary tracking overhead by mapping raw analog feedback loops
        directly to the closest 16-state hexadecimal index value.
        """
        clamped_input = max(0.0, min(1.0, line_volts))
        closest_index = min(range(len(self.HEX_VOLTAGE_STAGES)),
                            key=lambda i: abs(self.HEX_VOLTAGE_STAGES[i] - clamped_input))
        return closest_index

    def evaluate_armor_vapor(self, front_sensor_v: float, rear_sensor_v: float) -> dict:
        """
        Coordinates environmental weatherproofing metrics across the 108-bit register ring.
        Ramps active enclosure blowers if fluid condensation loops [INDEX].
        """
        front_idx = self.map_sensor_volts_to_hex(front_sensor_v)
        rear_idx  = self.map_sensor_volts_to_hex(rear_sensor_v)
        
        peak_saturation_idx = max(front_idx, rear_idx)
        
        purge_fans_on       = False
        armor_safety_status = "COPO_UNDERBELLY_PANEL_DRY_NOMINAL"
        univac_status_code  = 0x000
        
        # Core environmental scupper verification rules
        if peak_saturation_idx >= self.VAPOR_CEILING_INDEX:
            # Condensation registered over threshold: force fan operation to vent internal air channels [INDEX]
            purge_fans_on       = True
            armor_safety_status = "MOISTURE GRADIENT INTERCEPTED: INITIALIZING ACTIVE VENTILATION PURGE"
            univac_status_code  = 0x1E4 # Specific thermal fan status display indicator code [INDEX]
            
        # Pack statistics inside the un-truncated 108-bit tracking system register configuration [INDEX]
        # Bits 72-107: Fan Command | Bits 36-71: Peak Saturation | Bits 0-35: Alert Index
        fan_bit = 1 if purge_fans_on else 0
        stacked_word = (fan_bit << 72) | (peak_saturation_idx << 36) | univac_status_code
        
        return {
            "FORCE_VAULT_BLOWERS": purge_fans_on,
            "ARMOR_SAFETY_LOG": armor_safety_status,
            "UNIVAC_IX_36BIT_WORD": f"0x{(stacked_word >> 72) & 0x7FFFFFFFF:09X}"
        }

if __name__ == "__main__":
    watchdog = RTCopoArmorWatchdog()
    print("=======================================================================")
    print("UNIVAC-IX COPO UNDERBODY VAPOR RECEPTACLE MONITOR OPERATIONAL")
    print("=======================================================================")
    
    # Simulation: Hard tracking sprint splits high humidity tracks, loading the rear scupper sensor [INDEX]
    mock_front_v = 0.1875  # Front section remains clear
    mock_rear_v  = 0.6875  # Rear moisture tracks up into the 11th hex step boundary index [INDEX]
    
    report_frame = watchdog.evaluate_armor_vapor(mock_front_v, mock_rear_v)
    print(f"[DATA SENSE] Front Vapor Index: {watchdog.map_sensor_volts_to_hex(mock_front_v)} | Rear Vapor Index: {watchdog.map_sensor_volts_to_hex(mock_rear_v)}")
    print(f"[ARMOR SAFETY EXECUTIVE]: {report_frame['ARMOR_SAFETY_LOG']}")
    print(f"[FORCE EXHAUST PURGE]: Engage Vault Centrifugal Blowers: {report_frame['FORCE_VAULT_BLOWERS']}")
    print(f"[MAINFRAME PACKET STREAM]: Serializing Word: {report_frame['UNIVAC_IX_36BIT_WORD']}")
    print("=======================================================================")
