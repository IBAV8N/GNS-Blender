function C90_electrics()
----- PROP AMPS -------------------------------------------------------------------------
--function C90_prop_amps()
	math.randomseed(os.clock() * 0.001)
	local voltage = math.max(simDR_bus_volts[0], simDR_bus_volts[1])
	local ampLoad_L1 = C90_rescale(0, 19, 1, 23, simDR_prop_ice_per_engine[0])
	local ampLoad_R1 = C90_rescale(0, 19, 1, 23, simDR_prop_ice_per_engine[1])
	local ampLoad_prec = math.random()
	local ampLoad_L = ampLoad_L1 + ampLoad_prec
	local ampLoad_R = ampLoad_R1 + ampLoad_prec
	local prop_heat_fail_L = C90_ternary(simDR_prop_deice_heat_left_fail >= 6, 0, 1)
	local prop_heat_fail_R = C90_ternary(simDR_prop_deice_heat_right_fail >= 6, 0, 1)
	local prop_amps_L = C90_rescale(0, 0, 24, ampLoad_L, (voltage * simDR_prop_heat[0] * prop_heat_fail_L))
	local prop_amps_R = C90_rescale(0, 0, 24, ampLoad_R, (voltage * simDR_prop_heat[1] * prop_heat_fail_R))
	local C90_elec_prop_amps = prop_amps_L + prop_amps_R

	simDR_plugin_bus_load_amps[0] = C90_elec_prop_amps
	C90DR_electrical_prop_amps_gauge_needle_pos = C90_set_animation_position(C90DR_electrical_prop_amps_gauge_needle_pos, C90_elec_prop_amps, 0, 30, 1)

    gen1_live = C90_ternary(simDR_generator1_amps > 0 and simDR_engine_running[0] == 1, 1, 0)
    gen2_live = C90_ternary(simDR_generator2_amps > 0 and simDR_engine_running[1] == 1, 1, 0)
    local cross_tie_live = C90_ternary(C90DR_electrical_cross_tie_switch_pos < 0, 0, 1)


    --OVERHEAD VOLTAGE METER    --IBAV8N, Jan5-21                                                        
    local voltage_gauge_target
    if C90DR_volt_bus_sel_dial == 0 then                                            --EXT PWR
        voltage_gauge_target = simDR_gpu_on * 28.2
    elseif C90DR_volt_bus_sel_dial == 1 then                                        --CTR
        voltage_gauge_target = C90DR_ctr_bus_voltage
    elseif C90DR_volt_bus_sel_dial == 2 then                                        --GEN LEFT
        voltage_gauge_target = gen1_live * (27.92 + C90DR_electrical_gen1_switch_pos * 0.23)
    elseif C90DR_volt_bus_sel_dial == 3 then                                        --GEN RIGHT
        voltage_gauge_target = gen2_live * (28.11 + C90DR_electrical_gen2_switch_pos * 0.24)
    elseif C90DR_volt_bus_sel_dial == 4 then                                        --TPL FED
        voltage_gauge_target = C90DR_tpl_fed_bus_voltage
    elseif C90DR_volt_bus_sel_dial == 5 then                                        --BAT
        voltage_gauge_target = simDR_actual_volts[0]
    end
    C90DR_electrical_voltage_gauge = C90_set_animation_position(C90DR_electrical_voltage_gauge, voltage_gauge_target, 0, 30, 9)

    --AC VOLTAGE METER                                                                  --IBAV8N, Feb28-22, ac volt meter is useful now
    local ac_voltage_gauge_target
    local inverter_0_online = C90_ternary(simDR_inverter_0_fail == 6, 0, 1) * C90DR_gen_bus_voltage_L
    local inverter_1_online = C90_ternary(simDR_inverter_1_fail == 6, 0, 1) * C90DR_gen_bus_voltage_R
    if C90_ternary(math.max(inverter_0_online, inverter_1_online, C90DR_ctr_bus_voltage) > 0, 1, 0)
        * math.max(simDR_inverter_on[0], simDR_inverter_on[1]) > 0 then
            ac_voltage_gauge_target = 1
    else ac_voltage_gauge_target = 0
    end
    C90DR_electrical_ac_voltage_gauge = C90_set_animation_position(C90DR_electrical_ac_voltage_gauge, ac_voltage_gauge_target, 0, 1, 9)

    --FUEL PANEL L&R NEEDLES        --IBAV8N, Dec20-21, added to smooth fuel gauge needle drop                                       
    if math.max(power, C90_ternary(C90DR_tpl_fed_bus_voltage > 0, 1, 0)) > 0 then
        C90DR_fuel_needle_left = C90_set_animation_position(C90DR_fuel_needle_left, simDR_fuel_level_indicated_left, 0, 660, 4)
        C90DR_fuel_needle_right = C90_set_animation_position(C90DR_fuel_needle_right, simDR_fuel_level_indicated_right, 0, 660, 4)
    else
        C90DR_fuel_needle_left = C90_set_animation_position(C90DR_fuel_needle_left, 0, 0, 660, 4)
        C90DR_fuel_needle_right = C90_set_animation_position(C90DR_fuel_needle_right, 0, 0, 660, 4)
    end

    -- BUS LOGIC                                                                    --IBAV8N
    simDR_battery_1 = C90DR_ovh_emerg                                                   --EMERGENCY LTS
    simDR_battery_2 = (1 - power) * C90DR_avionics_grd_pwr_comm_switch_pos              --GROUND COMM PWR
--  simDR_battery_3                                                                     --EFIS AUX
    simDR_battery_4 = math.max(simDR_fuel_pump_on_L, simDR_fuel_pump_on_R)              --IBAV8N, Aug24-23, BOOST PUMPS HOT BUS
    C90DR_battery_tie = C90DR_battery_tpl_sense * simDR_battery_on
    simDR_cross_tie = math.max(C90DR_gen_tie_L, C90DR_gen_tie_R, simDR_gpu_on) * cross_tie_live
    C90DR_gen_tie_L = math.max(
        C90DR_gen_ctr_sense_L * cross_tie_live * math.max(C90DR_man_close, gen1_live, C90DR_starter_relay_L)
        )
    C90DR_gen_tie_R = math.max(
        C90DR_gen_ctr_sense_R * cross_tie_live * math.max(C90DR_man_close, gen2_live, C90DR_starter_relay_R)
        )
    C90DR_gen_bus_voltage_L = math.max(
        gen1_live * (27.92 + C90DR_electrical_gen1_switch_pos * 0.23),
        (gen2_live - gen1_live) * C90DR_gen_tie_L * C90DR_gen_tie_R * C90DR_gen_bus_voltage_R,
        simDR_actual_volts[0] * C90DR_gen_tie_L * C90DR_battery_tie * simDR_battery_on
        )
    C90DR_gen_bus_voltage_R = math.max(
        gen2_live * (28.11 + C90DR_electrical_gen2_switch_pos * 0.24),
        (gen1_live - gen2_live) * C90DR_gen_tie_L * C90DR_gen_tie_R * C90DR_gen_bus_voltage_L,
        simDR_actual_volts[0] * C90DR_gen_tie_R * C90DR_battery_tie * simDR_battery_on
        )
    C90DR_ctr_bus_voltage = math.max(
        C90DR_gen_bus_voltage_L * C90DR_gen_tie_L,
        C90DR_gen_bus_voltage_R * C90DR_gen_tie_R,
        simDR_actual_volts[0] * C90DR_battery_tie * simDR_battery_on,
        simDR_gpu_on * 28.2
        )
    C90DR_tpl_fed_bus_voltage = math.max(
        C90DR_gen_bus_voltage_L * C90DR_gen_tpl_sense_L,
        C90DR_gen_bus_voltage_R * C90DR_gen_tpl_sense_R,
        simDR_actual_volts[0] * C90DR_battery_tie * simDR_battery_on,
        power * 28.2 * C90DR_battery_tie
        )

    --ELECTRIC TRIM
    simDR_electric_trim = C90DR_fltctrl_elev_trim_control_switch_pos * C90_ternary(C90DR_tpl_fed_bus_voltage > 0, 1, 0)
end

    --AVIONICS LOGIC
function GNS_GTN_avionics_power()
    local eadi
    local ehsi
    simDR_battery_3 = math.max(C90_ternary(power == 0 and C90DR_avionics_EFIS_aux_pwr_on_switch_pos == 1, 1, 0), C90_ternary(C90DR_avionics_EFIS_aux_pwr_on_switch_pos == -1, 1, 0)) --EFIS AUX
    simDR_avionics_power_on = math.max(C90_ternary(C90DR_avionics_grd_pwr_comm_switch_pos == 1 and power == 0, 1, 0), math.max(simDR_battery_3, power) * C90DR_avionics_on_sw_pos)
    eadi = math.max(power * simDR_avionics_power_on, simDR_battery_3) * C90DR_avionics_EFIS_power_switch_pos * C90DR_avionics_EFIS_eadi_brightness
    ehsi = math.max(power * simDR_avionics_power_on, simDR_battery_3) * C90DR_avionics_EFIS_power_switch_pos * C90DR_avionics_EFIS_ehsi_brightness
    simDR_adf2_power = simDR_adf1_power                                     --IBAV8N, Aug 21-22, the plane needs 2 adfs for the EFIS brg_ptr2 function to work correctly.
    simDR_adf2_frequency = simDR_adf_frequency                              --IBAV8N, Aug 21-22 """"
    simDR_autopilot_fd_mode = (C90DR_avionics_EFIS_fd_switch_pos * simDR_avionics_power_on) + simDR_autopilot_servos_on     --IBAV8N, Nov16-23 adding FD to persistence

    --OVERHEAD POWER LOGIC
    local ovhd_power = math.max(power, C90_ternary(C90DR_gen_bus_voltage_L > 0, 1, 0)) * C90DR_ovh_master --IBAV8N, Aug23-23, L gen powers instr lts
    simDR_wiper_speed = power * C90_ternary(C90DR_wiper_knob_pos > 0, 1 + C90DR_wiper_knob_pos, 0)
    simDR_generic_lights_switch[0] = math.max(power, C90_ternary(C90DR_tpl_fed_bus_voltage > 0, 1, 0)) * C90DR_ovh_flood
    simDR_switch_panel_brightness_ratio[1] = C90_ternary(C90DR_tpl_fed_bus_voltage > 0, 1, 0) * C90DR_ovh_indirect --IBAV8N, Aug23-23, tpl-fed bus
    simDR_switch_instr_brightness_ratio[2] = math.max(C90DR_ovh_emerg, ovhd_power * C90DR_ovh_pilot_flt)
    simDR_switch_instr_brightness_ratio[3] = math.max(C90DR_ovh_emerg, ovhd_power * C90DR_ovh_pilot_gyro)
    simDR_switch_instr_brightness_ratio[4] = math.max(C90DR_ovh_emerg, ovhd_power * C90DR_ovh_eng_instru)
    simDR_switch_instr_brightness_ratio[14] = math.max(C90DR_ovh_emerg, ovhd_power * C90DR_ovh_avion_pnl)
    simDR_switch_instr_brightness_ratio[6] = math.max(C90DR_ovh_emerg, ovhd_power * C90DR_ovh_sub_pnl)
    simDR_switch_instr_brightness_ratio[7] = math.max(C90DR_ovh_emerg, ovhd_power * C90DR_ovh_side_pnl)
    simDR_switch_instr_brightness_ratio[8] = math.max(C90DR_ovh_emerg, ovhd_power * C90DR_ovh_copilot_gyro)
    simDR_switch_instr_brightness_ratio[9] = math.max(C90DR_ovh_emerg, ovhd_power * C90DR_ovh_copilot_flt)

    if eadi == 0 then
        simDR_switch_instr_brightness_ratio[11] = 0
    elseif simDR_switch_instr_brightness_ratio[11] == 0 then
        if is_timer_scheduled(startup_eadi) == false then
            run_after_time(startup_eadi, 1)
        end
    else simDR_switch_instr_brightness_ratio[11] = eadi
    end

    if ehsi == 0 then
        simDR_switch_instr_brightness_ratio[12] = 0
    elseif simDR_switch_instr_brightness_ratio[12] == 0 then
        if is_timer_scheduled(startup_ehsi) == false then
            run_after_time(startup_ehsi, 1.75)
        end
    else simDR_switch_instr_brightness_ratio[12] = ehsi
    end

    if simDR_acf_descrip == "C90B EVO GNS" then
        --local gps530_power
        --local gps430_power
        gps530_power = math.max(power, C90_ternary(C90DR_gen_bus_voltage_L > 0, 1, 0)) * simDR_avionics_power_on * C90DR_avionics_gps_power_switch_pos --IBAV8N, Aug23-23, gens can power GNS
        gps430_power = math.max(power, C90_ternary(C90DR_gen_bus_voltage_R > 0, 1, 0)) * simDR_avionics_power_on * C90DR_avionics_gps_power_switch_pos

        if simDR_gps530_power < gps530_power then
            if is_timer_scheduled(gps530) == false then
                run_after_time(gps530, 1)
            end
        else simDR_gps530_power = gps530_power
        end

        if simDR_gps430_power < gps430_power then
            if is_timer_scheduled(gps430) == false then
                run_after_time(gps430, 1.3)
            end
        else simDR_gps430_power = gps430_power
        end
    end
end

function G1000_avionics_power()          --IMC SEPT10-23
    simDR_battery_3 = C90_ternary(power == 0 and C90DR_avionics_EFIS_aux_pwr_on_switch_pos == 1, 1, 0) --standby on
    simDR_avionics_power_on = math.max(simDR_battery_3, power) * C90DR_avionics_on_sw_pos
    --OVERHEAD POWER LOGIC
    local ovhd_power = math.max(power, C90_ternary(C90DR_gen_bus_voltage_L > 0, 1, 0)) * C90DR_ovh_master --IBAV8N, Aug23-23, L gen powers instr lts
    simDR_wiper_speed = power * C90_ternary(C90DR_wiper_knob_pos > 0, 1 + C90DR_wiper_knob_pos, 0)
    simDR_generic_lights_switch[0] = math.max(power, C90_ternary(C90DR_tpl_fed_bus_voltage > 0, 1, 0)) * C90DR_ovh_flood
    simDR_switch_panel_brightness_ratio[1] = C90_ternary(C90DR_tpl_fed_bus_voltage > 0, 1, 0) * C90DR_ovh_indirect --IBAV8N, Aug23-23, tpl-fed bus
    simDR_switch_instr_brightness_ratio[2] = C90DR_ovh_pilot_flt                                            --Pilot's PFD
    simDR_switch_instr_brightness_ratio[3] = math.max(C90DR_ovh_emerg, ovhd_power * C90DR_ovh_pilot_gyro)   --Standby instruments
    simDR_switch_instr_brightness_ratio[4] = C90DR_ovh_eng_instru                                           --MFD
    simDR_switch_instr_brightness_ratio[14] = math.max(C90DR_ovh_emerg, ovhd_power * C90DR_ovh_avion_pnl)   --INOP
    simDR_switch_instr_brightness_ratio[6] = math.max(C90DR_ovh_emerg, ovhd_power * C90DR_ovh_sub_pnl)      --Overhead and subpanels
    simDR_switch_instr_brightness_ratio[7] = math.max(C90DR_ovh_emerg, ovhd_power * C90DR_ovh_side_pnl)     --Sidepanels
    simDR_switch_instr_brightness_ratio[8] = math.max(C90DR_ovh_emerg, ovhd_power * C90DR_ovh_copilot_gyro) --Clock lighting
    simDR_switch_instr_brightness_ratio[9] = C90DR_ovh_copilot_flt                                          --Copilot's PFD
    --ANTI-ICE FOR STANDBY INSTRUMENTS
    simDR_pitot_heat_on_standby = simDR_pitot_heat_right                                --IBAV8N, Oct10-23, would make the right switch standby,  but that could affect future PFD changes from LR
    simDR_static_heat_on_standby = simDR_pitot_heat_right                               --IBAV8N, Oct17-23
    --G1000 DISPLAYS ON/OFF
    --imc_pfd1_on = C90_ternary((C90DR_ctr_bus_voltage > 10) or (C90DR_tpl_fed_bus_voltage > 10) or simDR_battery_3 == 1, 1, 0)-- pfd1 is supplied by the center bus and the triple-fed bus #1
--IBAV8N - using ctr bus allows ext pwr to light PFD1 bezel and no other lights are visible
    imc_pfd2_on = C90_ternary(C90DR_tpl_fed_bus_voltage > 10 or simDR_battery_3 == 1, 1, 0)--pfd2 is supplied by the triple-fed bus #3
    imc_pfd1_on = imc_pfd2_on
    imc_mfd_on = imc_pfd2_on--mfd is supplied by triple fed bus #2
    --RADIO PANEL AUDIO CONTROLS
    if simDR_avionics_power_on == 0 then                   --IBAV8N, Sept23-23, disable com1 tx @ pwr off, avionics off
        simDR_audio_com_selection   = 6
        simDR_audio_marker_enabled  = 1
        simDR_radio_marker_sens     = 1
        simDR_audio_selection_nav1  = 0
        simDR_audio_selection_nav2  = 0
        simDR_audio_dme_enabled	    = 0
        simDR_audio_selection_adf1  = 0
    end
    --STANDBY ALTIMETER
    local hund_dec = math.floor(simDR_altitude_ft_stby%100)/100
    local hund_int = math.floor(math.floor(simDR_altitude_ft_stby%1000)/100)
    local thou_dec = math.floor(simDR_altitude_ft_stby%1000)/1000
    local thou_int = math.floor(math.floor(simDR_altitude_ft_stby%100000)/1000)
    imcDR_altitude_ft_stby_thous    = C90_ternary(thou_dec < 0.98, thou_int, thou_int + (thou_dec - 0.98) * 50)
    imcDR_altitude_ft_stby_hunds    = C90_ternary(hund_dec < 0.8, hund_int, hund_int + (hund_dec - 0.8) * 5)
    imcDR_altitude_ft_stby_tens     = math.floor(simDR_altitude_ft_stby%100 * 100) / 2000 + math.modf(imcDR_altitude_ft_stby_hunds) % 2 * 5
    --GARMIN LIGHTING
    --local center_on = (C90DR_ctr_bus_voltage > 10) or (simDR_battery_3 == 1)
    local triple_on = (C90DR_tpl_fed_bus_voltage > 10) or (simDR_battery_3 == 1)

    function powered_device_light_level(power_source, level)      --IMC
        if power_source then return level else return 0 end
    end
    -- GFC710 - No1 triple fed  AP Panel
    imcDR_light_level_GFC710 = powered_device_light_level(triple_on == true, simDR_switch_instr_brightness_ratio[4])
    -- GCU479 - No3 triple fed  Keyboard
    imcDR_light_level_GCU479 = powered_device_light_level(triple_on == true, simDR_switch_instr_brightness_ratio[4])
    -- GMA1347's - No1 Avionics L&R Radio Panels
    imcDR_light_level_GMA1347_L = powered_device_light_level(simDR_avionics_power_on == 1, simDR_switch_instr_brightness_ratio[2])
    imcDR_light_level_GMA1347_R = powered_device_light_level(simDR_avionics_power_on == 1, simDR_switch_instr_brightness_ratio[9])
    -- PFD/MFD bezels - PFD1 Triple 1/Center PFD2 Triple 3 MFD Triple No2
    imcDR_light_level_PFD1 = powered_device_light_level(imc_pfd1_on == 1, simDR_switch_instr_brightness_ratio[2])
    imcDR_light_level_PFD2 = powered_device_light_level(imc_pfd2_on == 1, simDR_switch_instr_brightness_ratio[9])
    imcDR_light_level_MFD = powered_device_light_level(imc_mfd_on == 1, simDR_switch_instr_brightness_ratio[4])
end

-- BOOT/STARTUP SEQUENCE EFIS POWER
function startup_eadi()
	simDR_switch_instr_brightness_ratio[11] = C90DR_avionics_EFIS_eadi_brightness
	--run_after_time(startup_ehsi,0.75)
end

function startup_ehsi()
	simDR_switch_instr_brightness_ratio[12] = C90DR_avionics_EFIS_ehsi_brightness
	if C90DR_avionics_EFIS_map_mode_sel_dial_pos == 3 or C90DR_avionics_EFIS_map_mode_sel_dial_pos == 4 then
		radaron = 0
		simDR_weather_alpha	= 0
		run_at_interval(weatheralpha, 0.15)
	end
end

-- BOOT/STARTUP SEQUENCE GNS POWER
function gps530()
	simDR_gps530_power = 1
end

function gps430()
	simDR_gps430_power = 1
end

local full = 1008
local bat1 = full
local bat2 = full
local bat4 = full

--EQUALIZE BATTERY LEVELS
function one_battery()		--IBAV8N, Aug29-23
    local hot_bus_1 = (bat1 - simDR_battery_charge[1]) * C90DR_ovh_emerg
    local hot_bus_2 = (bat2 - simDR_battery_charge[2]) * C90DR_avionics_grd_pwr_comm_switch_pos
  --local hot_bus_3              --DOESN'T EXIST, AS BATTERY 3 IS REAL AND CHARGES LIKE BATTERY 1
    local hot_bus_4 = (bat4 - simDR_battery_charge[4]) * (1 - power) * math.max(simDR_fuel_pump_on_L, simDR_fuel_pump_on_R)
    local hot_bus_total = hot_bus_1 + hot_bus_2 + hot_bus_4

    if simDR_gpu_on == 1 or gen1_live == 1 or gen2_live == 1 then
        simDR_battery_charge[1] = full      --Emergency lights
        simDR_battery_charge[2] = full      --Ground Comm
        simDR_battery_charge[4] = full      --Fuel boost pumps
    else
        simDR_battery_charge[0] = simDR_battery_charge[0] - hot_bus_total
    end
    bat1 = simDR_battery_charge[1]
    bat2 = simDR_battery_charge[2]
    bat4 = simDR_battery_charge[4]
end

-- GENERATOR DISCONNECT WHEN AMPS OVERLOAD
function overload()
	if simDR_cross_tie == 1 then
		if simDR_generator1_amps > 250 then
		    simCMD_generator_1_off:once()
		    C90DR_gen_ctr_sense_L = 0
		end
		if simDR_generator2_amps > 250 then
		    simCMD_generator_2_off:once()
		    C90DR_gen_ctr_sense_R = 0
		end
    end
end
