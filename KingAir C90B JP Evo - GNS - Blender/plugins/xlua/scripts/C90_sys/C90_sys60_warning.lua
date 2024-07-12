C90DR_warning_array			    = {}
C90DR_warning_status		    = {}
C90DR_caution_array			    = {}
C90DR_caution_status		    = {}

local C90_warn_alt_alert_flash  = 0
local caution                   = 0
local warning                   = 0
local lastAlertMode             = 0
local gear_warn_light           = 0     --IBAV8N, Aug30-23, make gear warning work correctly, this will light the handle

-- BATTERY AMP CHECK -----------------------------------------------------------------
function C90_battery_amp_check()
	if simDR_battery_amps[0] > 7 then
		C90.warning.battery_charge = 1
	end
end

-- EXTENDED MASTER WARNING & MASTER CAUTION ANNUNCIATIONS
function master_warning()
    local warning_trigger = 0
    local warning_array_test_trigger = 0
    local warning_status_test_trigger = 0
    if C90DR_electrical_annun_test_on == 0 then
        if warning == 0 then
            for i = 0, 12 do
                warning_array_test_trigger = C90DR_warning_array[i]
                warning_status_test_trigger = C90DR_warning_status[i]
                if warning_status_test_trigger > warning_array_test_trigger then C90DR_warning_status[i] = 0
                elseif warning_array_test_trigger > warning_status_test_trigger then warning_trigger = 1 break end
            end
            warning = warning_trigger
            simDR_master_warning_plugin = warning
        elseif is_timer_scheduled(warningflash) == false then
            run_at_interval(warningflash, 0.125)
        end
    else stop_timer(warningflash)
        C90DR_lighting_annun_master_warning = 1
    end
end

function warningflash()
    local warning_array_test_reset = 0
    local warning_status_test_reset = 0
	if simDR_master_warning == 0 then
        C90DR_lighting_annun_master_warning = 0
        simDR_master_warning_plugin = 0
        for i = 0, 12 do
            warning_array_test_reset = C90DR_warning_array[i]
            warning_status_test_reset = C90DR_warning_status[i]
            if warning_status_test_reset ~= warning_array_test_reset then C90DR_warning_status[i] = warning_array_test_reset
            elseif warning_status_test_reset == warning_array_test_reset and i == 12 then break end
        end
        warning = 0
		stop_timer(warningflash)
    else C90DR_lighting_annun_master_warning = 1 - C90DR_lighting_annun_master_warning
	end
end

function master_caution()
    local caution_trigger = 0
    local caution_array_test_trigger = 0
    local caution_status_test_trigger = 0
    if C90DR_electrical_annun_test_on == 0 then
        if caution == 0 then
            for i = 0, 19 do
                caution_array_test_trigger = C90DR_caution_array[i]
                caution_status_test_trigger = C90DR_caution_status[i]
                if caution_status_test_trigger > caution_array_test_trigger then C90DR_caution_status[i] = 0
                elseif caution_array_test_trigger > caution_status_test_trigger then caution_trigger = 1 break end
            end
            caution = caution_trigger
            simDR_master_caution_plugin = caution
        elseif is_timer_scheduled(cautionflash) == false then
            run_at_interval(cautionflash, 0.125)
        end
    else stop_timer(cautionflash)
        C90DR_lighting_annun_master_caution = 1
    end
end

function cautionflash()
    local caution_array_test_reset = 0
    local caution_status_test_reset = 0
	if simDR_master_caution == 0 then
        C90DR_lighting_annun_master_caution = 0
        simDR_master_caution_plugin = 0
        for i = 0, 19 do
            caution_array_test_reset = C90DR_caution_array[i]
            caution_status_test_reset = C90DR_caution_status[i]
            if caution_status_test_reset ~= caution_array_test_reset then C90DR_caution_status[i] = caution_array_test_reset
            elseif caution_status_test_reset == caution_array_test_reset and i == 19 then break end
        end
        caution = 0
		stop_timer(cautionflash)
    else C90DR_lighting_annun_master_caution = 1 - C90DR_lighting_annun_master_caution
	end
end

-- WARNING, CAUTION, AND ADVISORY ANNUNCIATORS ---------------------------------------
function C90_warning_annunciators()
	if math.max(power, C90_ternary(C90DR_gen_bus_voltage_L > 0, 1, 0)) > 0 then --IBAV8N, Aug23-23, L gen can provide power

        master_caution()
        master_warning()

        --GEAR HANDLE WARNING                                                                           --IBAV8N, Aug30-23
        C90DR_warning_gear_handle = C90_ternary(
            (simDR_gear_deploy_ratio[0] ~= 0 and simDR_gear_deploy_ratio[0] ~= 1)
            or (simDR_gear_deploy_ratio[1] ~= 0 and simDR_gear_deploy_ratio[1] ~= 1)
            or (simDR_gear_deploy_ratio[2] ~= 0 and simDR_gear_deploy_ratio[2] ~= 1)
            or C90DR_landing_gear_handle_light_test == 1
            or simDR_gear1_fail == 6
            or simDR_gear2_fail == 6
            or simDR_gear3_fail == 6
            or gear_warn_light == 1, 1, 0)

        --GEAR HORN WARNING                                                                           --IBAV8N, Aug30-23
        C90_gear_horn()

        --AUTOPILOT DISCONNECT
        C90DR_warning_array[12] = simDR_annun_ap_disco                                                  --IBAV8N, Feb13

        --PILOT OXYGEN
        C90.warning.pilot_oxygen        = C90DR_avionics_mic_sel_switch_pos_pilot                       --@IBAV8N, Jan15
		C90DR_caution_array[17] = C90.warning.pilot_oxygen

        --COPILOT OXYGEN
        C90.warning.copilot_oxygen      = C90DR_avionics_mic_sel_switch_pos_copilot                     --@IBAV8N, Jan15
		C90DR_caution_array[18] = C90.warning.copilot_oxygen

        --RADAR                                                                                             --@IBAV8N, Jan15
        C90.warning.radar               =  C90_ternary((C90DR_avionics_EFIS_map_mode_sel_dial_pos > 2 and C90DR_gear_handle == 1) and simDR_efis1_fail == 0, 1, 0)
		C90DR_caution_array[19] = C90.warning.radar

		-- FUEL PRESS L
		C90.warning.fuel_press_L 		= C90_ternary(simDR_fuel_pressure_psi[0] < 10, 1, 0) -- ok
        C90DR_warning_array[0] = C90.warning.fuel_press_L

		-- FUEL PRES R
		C90.warning.fuel_press_R 		= C90_ternary(simDR_fuel_pressure_psi[1] < 10, 1, 0) -- ok
		C90DR_warning_array[11] = C90.warning.fuel_press_R

		-- OIL PRESS L
		C90.warning.oil_press_L 		= C90_ternary(simDR_oil_pressure_psi[0] < 40, 1, 0) -- ok
		C90DR_warning_array[1] = C90.warning.oil_press_L

		-- OIL PRESS R
		C90.warning.oil_press_R 		= C90_ternary(simDR_oil_pressure_psi[1] < 40, 1, 0) -- ok
		C90DR_warning_array[10] = C90.warning.oil_press_R

		-- INVERTER
		    C90.warning.inverter 			= C90_ternary(simDR_inverter_on[1] == 0 and simDR_inverter_on[0] == 0 and simDR_acf_descrip ~= "C90B - G1000, Blackhawk", 1, 0)
		C90DR_warning_array[3] = C90.warning.inverter

		-- AUTOPILOT FAIL
		C90.warning.ap_fail 			= C90_ternary(simDR_ap_computer_fail == 6, 1, 0)
		C90DR_warning_array[4] = C90.warning.ap_fail

		--AUTOPILOT TRIM FAIL
		C90.warning.ap_trim_fail 		= C90_ternary(simDR_ap_servo_fail > 0, 1, 0)
		C90DR_warning_array[5] = C90.warning.ap_trim_fail

		-- CABIN ALTITUDE HI
		C90.warning.cabin_alt_hi 		= simDR_annun_cabin_alt_hi
		C90DR_warning_array[6] = C90.warning.cabin_alt_hi

		-- CABIN DOOR
		C90.warning.cabin_door 			= C90_ternary(simDR_door_open_ratio[0] > 0.1, 1, 0)         --IBAV8N, Apr8-22, won't trigger MW if user tests the door
		C90DR_warning_array[7] = C90.warning.cabin_door

		-- L BLEED AIR (originally BAGGAGE DOOR)
		C90.warning.baggage_door 		= C90_ternary(simDR_bleed_valve_left == 0 or simDR_bleed_valve_right == 0, 1, 0)
		C90DR_warning_array[8] = C90.warning.baggage_door

		-- ENGINE FIRE L
		C90.warning.engine_fire_L		= simDR_annun_engine_fire[0]
		C90DR_warning_array[2] = C90.warning.engine_fire_L

		-- ENGINE FIRE R
		C90.warning.engine_fire_R		= simDR_annun_engine_fire[1]
		C90DR_warning_array[9] = C90.warning.engine_fire_R

		-- DC GEN L
		C90.warning.dc_gen_L 			= C90_ternary(simDR_annun_generator_off[0] > 0 or simDR_engine_running[0] == 0, 1, 0)
		C90DR_caution_array[0] = C90.warning.dc_gen_L

		-- DC GEN R
		C90.warning.dc_gen_R 			= C90_ternary(simDR_annun_generator_off[1] > 0 or simDR_engine_running[1] == 0, 1, 0)
		C90DR_caution_array[12] = C90.warning.dc_gen_R

		-- NO FUEL XFR L
		C90.warning.no_fuel_xfr_L 		= simDR_annun_fuel_transfer[0]
		C90DR_caution_array[1] = C90.warning.no_fuel_xfr_L

		-- NO FUEL XFR R
		C90.warning.no_fuel_xfr_R 		= simDR_annun_fuel_transfer[1]
		C90DR_caution_array[11] = C90.warning.no_fuel_xfr_R

		-- RVS NOT READY
		C90.warning.rvs_not_ready 		= C90_ternary(
            (((simDR_prop_rot_speed_actuator[0] < 220 or simDR_prop_rot_speed_actuator[1] < 220) and simDR_acf_descrip ~= "C90B - G1000, Blackhawk")
            or ((simDR_prop_rot_speed_actuator[0] < 195 or simDR_prop_rot_speed_actuator[1] < 195) and simDR_acf_descrip == "C90B - G1000, Blackhawk"))
            and simDR_gear_deploy_ratio[0] > 0.95 and simDR_gear_deploy_ratio[1] > 0.95 and simDR_gear_deploy_ratio[2] > 0.95
            , 1, 0)
		C90DR_caution_array[2] = C90.warning.rvs_not_ready

		-- CHIP DETECT L
		C90.warning.chip_detect_L 		= simDR_annun_chip_detected[0]
		C90DR_caution_array[3] = C90.warning.chip_detect_L

		-- CHIP DETECT R
		C90.warning.chip_detect_R 		= simDR_annun_chip_detected[1]
		C90DR_caution_array[10] = C90.warning.chip_detect_R

		-- ENGINE ICE FAIL L
		C90.warning.eng_ice_fail_L 		= simDR_annun_ice_vane_fail[0]
		C90DR_caution_array[4] = C90.warning.eng_ice_fail_L

		-- ENGINE ICE FAIL R
		C90.warning.eng_ice_fail_R 		= simDR_annun_ice_vane_fail[1]
		C90DR_caution_array[5] = C90.warning.eng_ice_fail_R

		-- GEN TIE OPEN L
		C90.warning.gen_tie_open_L		= C90_ternary((
											simDR_cross_tie == 0 or
											C90DR_gen_tie_L == 0
											), 1, 0)
		C90DR_caution_array[6] = C90.warning.gen_tie_open_L

		-- GEN TIE OPEN R
		C90.warning.gen_tie_open_R		= C90_ternary((
											simDR_cross_tie == 0 or
											C90DR_gen_tie_R == 0
											), 1, 0)
		C90DR_caution_array[8] = C90.warning.gen_tie_open_R

		-- BAT TIE OPEN
		C90.warning.bat_tie_open		= C90_ternary((
		                                    C90DR_battery_tie == 0 or
		                                    simDR_battery_on == 0
		                                    ), 1, 0)	--@IBAV8N, Apr24
		C90DR_caution_array[7] = C90.warning.bat_tie_open

		-- PITCH TRIM OFF
		C90.warning.pitch_trim_off 		= 1 - simDR_electric_trim
		C90DR_caution_array[9] = C90.warning.pitch_trim_off

		-- IGNITION ON L
		C90.warning.ignition_on_L 		= math.max(C90_ternary(simDR_torque1 < 542 and simDR_auto_ignite_on[0] > 0, 1, 0), simDR_annun_igniter_on[0])       --IBAV8N, Nov18-23, auto switches must be on when t<400ft-lbs

		-- IGNITION ON R
		C90.warning.ignition_on_R 		= math.max(C90_ternary(simDR_torque2 < 542 and simDR_auto_ignite_on[1] > 0, 1, 0), simDR_annun_igniter_on[1])       --IBAV8N, Nov18-23, auto switches must be on when t<400ft-lbs

		-- AUTOFEATHER L
		C90.warning.autofeather_L 		= simDR_annun_autofeather_arm[0]

		-- AUTOFEATHER R
		C90.warning.autofeather_R 		= simDR_annun_autofeather_arm[1]

		-- ENGINE ANTI-ICE L
		C90.warning.engine_antiice_L	= simDR_annun_ice_vane_extend[0]

		-- ENGINE ANTI-ICE R
		C90.warning.engine_antiice_R	= simDR_annun_ice_vane_extend[1]

		-- MAN TIES CLOSE
		C90.warning.man_ties_close 		= C90DR_man_close--@IBAV8N, Jan25

		-- FUEL CROSSFEED
		C90.warning.fuel_crossfeed 		= simDR_annun_fuel_crossfeed
		C90DR_caution_array[13] = C90.warning.fuel_crossfeed

		-- HYD FLUID LO
		C90.warning.hyd_fluid_lo 		= C90_ternary(simDR_hyd_fluid_ratio < 0.2 or C90DR_engine_hydraulic_fluid_test == 1, 1, 0) --IBAV8N, Feb28
		C90DR_caution_array[14] = C90.warning.hyd_fluid_lo


		-- BATTERY CHARGE (CHARGE RATE EXCEEDS 7 AMPS FOR > 6 SECONDS)

		if simDR_battery_amps[0] > 7 then
			if is_timer_scheduled(C90_battery_amp_check) == false then
				run_after_time(C90_battery_amp_check, 6)
			end
		else
			if is_timer_scheduled(C90_battery_amp_check) == true then
				stop_timer(C90_battery_amp_check)
			end
			C90.warning.battery_charge = 0
		end

        --C90.warning.battery_charge = C90_ternary(simDR_battery_amps[0] > 4.5, 1, 0)         --IBAV8N testing 3.5 too low, try 4.5
        C90DR_caution_array[15] = C90.warning.battery_charge

		-- EXT POWER
		C90.warning.ext_power 			= C90_ternary(simDR_gpu_on > 0 and simDR_battery_on > 0, 1, 0)
        C90DR_caution_array[16] = C90.warning.ext_power

		-- LDG/TAXI LIGHT
		C90.warning.ldg_taxi_light 		= C90_ternary(((simDR_landing_light_switch[0] == 1 or simDR_landing_light_switch[1] == 1)
											and (simDR_gear_deploy_ratio[0] < 0.05 and simDR_gear_deploy_ratio[1] < 0.05 and  simDR_gear_deploy_ratio[2] < 0.05))
											, 1, 0)
	else
		C90.warning.pilot_oxygen        = 0 --@IBAV8N, Jan15
        C90.warning.copilot_oxygen      = 0 --@IBAV8N, Jan15
        C90.warning.radar               = 0 --@IBAV8N, Jan15
		C90.warning.fuel_press_L 		= 0
		C90.warning.fuel_press_R 		= 0
		C90.warning.oil_press_L 		= 0
		C90.warning.oil_press_R 		= 0
		C90.warning.inverter 			= 0
		C90.warning.ap_fail 			= 0
		C90.warning.ap_trim_fail 		= 0
		C90.warning.cabin_alt_hi 		= 0
		C90.warning.cabin_door 			= 0
		C90.warning.baggage_door 		= 0
		C90.warning.engine_fire_L		= 0
		C90.warning.engine_fire_R		= 0
		C90.warning.dc_gen_L 			= 0
		C90.warning.dc_gen_R 			= 0
		C90.warning.no_fuel_xfr_L 		= 0
		C90.warning.no_fuel_xfr_R 		= 0
		C90.warning.rvs_not_ready 		= 0
		C90.warning.chip_detect_L 		= 0
		C90.warning.chip_detect_R 		= 0
		C90.warning.eng_ice_fail_L 		= 0
		C90.warning.eng_ice_fail_R 		= 0
		C90.warning.gen_tie_open_L		= 0
		C90.warning.gen_tie_open_R		= 0
		C90.warning.bat_tie_open		= 0
		C90.warning.pitch_trim_off 		= 0
		C90.warning.ignition_on_L 		= 0
		C90.warning.ignition_on_R 		= 0
		C90.warning.autofeather_L 		= 0
		C90.warning.autofeather_R 		= 0
		C90.warning.engine_antiice_L	= 0
		C90.warning.engine_antiice_R	= 0
		C90.warning.man_ties_close 		= 0
		C90.warning.fuel_crossfeed 		= 0
		C90.warning.hyd_fluid_lo 		= 0
		C90.warning.battery_charge 		= 0
		C90.warning.ext_power 			= 0
		C90.warning.ldg_taxi_light 		= 0

        for i = 0, 12 do                        --IBAV8N, May5
            C90DR_warning_array[i] = 0
        end

        for i = 0, 19 do                        --IBAV8N, May5
            C90DR_caution_array[i] = 0
        end
	end
end


----- EFIS AUX -----------------------------------------------------------------------------
function C90_warning_EFIS_aux()                             --IBAV8N, Aug28-22, all new code
    efis_aux_trigger = simDR_battery_3 * math.max(0, C90DR_avionics_EFIS_aux_pwr_on_switch_pos)
    if efis_aux_trigger > efis_aux_silence then
        C90DR_warning_EFIS_aux_horn_on = 1
    elseif efis_aux_silence > efis_aux_trigger then
        efis_aux_silence = efis_aux_trigger
    else
        C90DR_warning_EFIS_aux_horn_on = 0
    end
end

----- ALTITUDE ALERT --------------------------------------------------------------------
function C90_warning_alt_alert_flash()
	C90_warn_alt_alert_flash = 1 - C90_warn_alt_alert_flash
end

function C90_warning_altitude_alert()

	if C90.pre80.alert == 0 then													-- OFF
		if is_timer_scheduled(C90_warning_alt_alert_flash) == true then
 			stop_timer(C90_warning_alt_alert_flash)
 		end
		C90.warning.alt_alert = 0	-- OFF

	elseif C90.pre80.alert == 1 then												-- ACQUISTION ARMED MODE
		if is_timer_scheduled(C90_warning_alt_alert_flash) == true then
 			stop_timer(C90_warning_alt_alert_flash)
 		end
		C90.warning.alt_alert = 1	-- SOLID LIGHT

	elseif C90.pre80.alert == 2 then												-- ACQUISTION MODE _OR_ DEVIATION ARMED MODE
		if is_timer_scheduled(C90_warning_alt_alert_flash) == false then
			run_timer(C90_warning_alt_alert_flash, 0, 0.5)
		end
		C90.warning.alt_alert = C90_warn_alt_alert_flash	-- FLASHING LIGHT

	end

	if C90.warning.alt_alert ~= lastAlertMode then
		lastAlertMode = C90.warning.alt_alert
	end
end

----- GEAR HORN ALERT --------------------------------------------------------------------
function C90_gear_horn()
    if C90DR_gear_handle < 1 and simDR_engine_N1_pct[0] < 68 and simDR_engine_N1_pct[1] < 68 then
        gear_warn_light = 1
        C90DR_gear_horn = 1 - gear_warn_muted
    elseif C90DR_gear_handle < 1 and simDR_flaprqst == 1 then
        gear_warn_light = 1 
        C90DR_gear_horn = 1
    else
        gear_warn_muted = 0
        gear_warn_light = 0
        C90DR_gear_horn = 0
    end
end
