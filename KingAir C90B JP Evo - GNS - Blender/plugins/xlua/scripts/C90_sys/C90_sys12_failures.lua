----- GEAR ----------------------------------


function nose_gear_fail_retract()
    if simDR_airspeed > 167 and simDR_gear_deploy_ratio[0] > 0 then
        if simDR_gear1_fail ~= 6 then simDR_gear1_fail = math.random(6, math.ceil(9 + (30 / (simDR_airspeed - 166)))) end
        if simDR_gear1_fail == 6 then
            print("C90B_EVO: FAILURE: Nose Gear Retraction. Observe maximum retraction speed.")
            stop_timer(nose_gear_fail_retract)
        end
    else stop_timer(nose_gear_fail_retract)
    end
end

function left_main_gear_fail_retract()
    if simDR_airspeed > 167 and simDR_gear_deploy_ratio[1] > 0 then
        if simDR_gear2_fail ~= 6 then simDR_gear2_fail = math.random(6, math.ceil(9 + (30 / (simDR_airspeed - 166)))) end
        if simDR_gear2_fail == 6 then
            print("C90B_EVO: FAILURE: Left Main Gear Retraction. Observe maximum retraction speed.")
            stop_timer(left_main_gear_fail_retract)
        end
    else stop_timer(left_main_gear_fail_retract)
    end
end

function right_main_gear_fail_retract()
    if simDR_airspeed > 167 and simDR_gear_deploy_ratio[2] > 0 then
        if simDR_gear3_fail ~= 6 then simDR_gear3_fail = math.random(6, math.ceil(9 + (30 / (simDR_airspeed - 166)))) end
        if simDR_gear3_fail == 6 then
            print("C90B_EVO: FAILURE: Right Main Gear Retraction. Observe maximum retraction speed.")
            stop_timer(right_main_gear_fail_retract)
        end
    else stop_timer(right_main_gear_fail_retract)
    end
end

-- GEAR EXCEED AIRSPEED: EXTEND                                     --IBAV8N, May26-21, New failure code, Dec14 added log msgs
function gear_check_down()
	if C90DR_gear_handle == 1 and simDR_airspeed > 187 then
	    if is_timer_scheduled(nose_gear_fail_extend) == false then run_at_interval(nose_gear_fail_extend, 1) end
	    if is_timer_scheduled(left_main_gear_fail_extend) == false then run_at_interval(left_main_gear_fail_extend, 1) end
	    if is_timer_scheduled(right_main_gear_fail_extend) == false then run_at_interval(right_main_gear_fail_extend, 1) end
    end
    stop_timer(gear_check_down)
end

function nose_gear_fail_extend()
    if simDR_airspeed > 187 and simDR_gear_deploy_ratio[0] > 0 then
        if simDR_gear1_fail ~= 6 then simDR_gear1_fail = math.random(6, math.ceil(9 + (45 / (simDR_airspeed - 186)))) end
        if simDR_gear1_fail == 6 then
            print("C90B_EVO: FAILURE: Nose Gear Extension. Observe maximum retraction speed.")
            stop_timer(nose_gear_fail_extend)
         end
    else stop_timer(nose_gear_fail_extend)
    end
end

function left_main_gear_fail_extend()
    if simDR_airspeed > 187 and simDR_gear_deploy_ratio[1] > 0 then
        if simDR_gear2_fail ~= 6 then simDR_gear2_fail = math.random(6, math.ceil(9 + (45 / (simDR_airspeed - 186)))) end
        if simDR_gear2_fail == 6 then
            print("C90B_EVO: FAILURE: Left Main Gear Extension. Observe maximum retraction speed.")
            stop_timer(left_main_gear_fail_extend)
        end
    else stop_timer(left_main_gear_fail_extend)
    end
end

function right_main_gear_fail_extend()
    if simDR_airspeed > 187 and simDR_gear_deploy_ratio[2] > 0 then
        if simDR_gear3_fail ~= 6 then simDR_gear3_fail = math.random(6, math.ceil(9 + (45 / (simDR_airspeed - 186)))) end
        if simDR_gear3_fail == 6 then
            print("C90B_EVO: FAILURE: Right Main Gear Extension. Observe maximum retraction speed.")
            stop_timer(right_main_gear_fail_extend)
        end
    else stop_timer(right_main_gear_fail_extend)
    end
end

----- FLAPS ----------------------------------

-- CHECK FLAPS/AIRSPEED             IBAV8N, Dec14-21, now logs msgs
function flaps()
    if simDR_airspeed > 156 then
        if simDR_flaps_left_bind_fail ~= 6 and simDR_flaps_right_bind_fail ~= 6 then
            if simDR_flaps1 > 0 then
                if is_timer_scheduled(flaps1_fail) == false then run_at_interval(flaps1_fail, 1) end
            end
            if simDR_flaps2 > 0 then
                if is_timer_scheduled(flaps2_fail) == false then run_at_interval(flaps2_fail, 1) end
            end
        end
    end
end

function flaps_actuator_fail()
    simDR_flap_actuator_fail = 6
end

function flaps1_fail()
    if simDR_airspeed > 156 and simDR_flaps1 > 0 then
        if simDR_flaps_left_bind_fail ~= 6 then
            if simDR_flaps_left_gone_fail == 6 then simDR_flaps_left_bind_fail = 6
            elseif simDR_flaps1 > 42 then simDR_flaps_left_bind_fail = math.random(6, math.ceil(9 + (75 / (simDR_airspeed - 155))))
            elseif simDR_airspeed > 195 then simDR_flaps_left_bind_fail = math.random(6, math.ceil(9 + (45 / (simDR_airspeed - 194))))
            end
        end
        if simDR_flaps_left_bind_fail == 6 then
            print("C90B_EVO: FAILURE: Left Flap Linkage Damaged. Observe maximum extension speed.")
            run_after_time(flaps_actuator_fail, 3)
            stop_timer(flaps2_fail)
            stop_timer(flaps1_fail)
        end
    else stop_timer(flaps1_fail)
    end
end

function flaps2_fail()
    if simDR_airspeed > 156 and simDR_flaps2 > 0 then
        if simDR_flaps_right_bind_fail ~= 6 then
            if simDR_flaps_right_gone_fail == 6 then simDR_flaps_right_bind_fail = 6
            elseif simDR_flaps2 > 42 then simDR_flaps_right_bind_fail = math.random(6, math.ceil(9 + (75 / (simDR_airspeed - 155))))
            elseif simDR_airspeed > 195 then simDR_flaps_right_bind_fail = math.random(6, math.ceil(9 + (45 / (simDR_airspeed - 194))))
            end
        end
        if simDR_flaps_right_bind_fail == 6 then
            print("C90B_EVO: FAILURE: Right Flap Linkage Damaged. Observe maximum extension speed.")
            run_after_time(flaps_actuator_fail, 2.9)
            stop_timer(flaps1_fail)
            stop_timer(flaps2_fail)
        end
    else stop_timer(flaps2_fail)
    end
end

----- AVIONICS ----------------------------------
function avionics_surge()
    if simDR_avionics_power_on * power == 1 then		--IBAV8N, Jan25-22
        if simDR_gps530_power == 1 then
            if simDR_gps530_fail ~= 6 then
                simDR_gps530_fail = math.random(6, 12 - (2 * simDR_gpu_on))
                if simDR_gps530_fail == 6 then print("C90B_EVO: FAILURE: GNS530 failed, turn off Avionics Master switch when engaging starter.")
                end
            end
        end
        if simDR_gps430_power == 1 then
            if simDR_gps430_fail ~= 6 then
                simDR_gps430_fail = math.random(6, 12 - (2 * simDR_gpu_on))
                if simDR_gps430_fail == 6 then print("C90B_EVO: FAILURE: GNS430 failed, turn off Avionics Master switch when engaging starter.")
                end
            end
        end
        if simDR_com1_power == 1 then
            if simDR_com1_fail ~= 6 then
                simDR_com1_fail = math.random(6, 18 - (2 * simDR_gpu_on))
                if simDR_com1_fail == 6 then print("C90B_EVO: FAILURE: COM1 radio failed, turn off Avionics Master switch when engaging starter.")
                end
            end
        end
        if simDR_com2_power == 1 then
            if simDR_com2_fail ~= 6 then
                simDR_com2_fail = math.random(6, 18 - (2 * simDR_gpu_on))
                if simDR_com2_fail == 6 then print("C90B_EVO: FAILURE: COM2 radio failed, turn off Avionics Master switch when engaging starter.")
                end
            end
        end
        if simDR_nav1_power == 1 then
            if simDR_nav1_fail ~= 6 then
                simDR_nav1_fail = math.random(6, 18 - (2 * simDR_gpu_on))
                if simDR_nav1_fail == 6 then print("C90B_EVO: FAILURE: NAV1 radio failed, turn off Avionics Master switch when engaging starter.")
                end
            end
        end
        if simDR_nav2_power == 1 then
            if simDR_nav2_fail ~= 6 then
                simDR_nav2_fail = math.random(6, 18 - (2 * simDR_gpu_on))
                if simDR_nav2_fail == 6 then print("C90B_EVO: FAILURE: NAV2 radio failed, turn off Avionics Master switch when engaging starter.")
                end
            end
        end
        if simDR_adf1_power == 1 then
            if simDR_adf1_fail ~= 6 then
                simDR_adf1_fail = math.random(6, 18 - (2 * simDR_gpu_on))
                if simDR_adf1_fail == 6 then print("C90B_EVO: FAILURE: ADF failed, turn off Avionics Master switch when engaging starter.")
                end
            end
        end
    end
    beaconfail()
    stop_timer(avionics_surge)
end

----- STARTERS ------------------------------------------------------------
-- ENGINE STARTING FAILURE SCAN          --IBAV8N, Dec16-21, new code?
function starter1_active()
	if simDR_starter0_fail ~= 6 then
        if C90DR_powerplant_ign_start_switch_pos_L ~= 0 then
            stop_timer(starter1_cooling)
		    starter1_count = starter1_count + 1
        else
            run_at_interval(starter1_cooling, 5)
            stop_timer(starter1_active)
        end
    else print("C90B_EVO: FAILURE: Failed Left Starter.  Do not crank for > 30 seconds, allow 1 minute to cool between start attempts") stop_timer(starter1_active)
	end
	if starter1_count > 40 then
		simDR_starter0_fail = math.random(6, 11)
	end
	if simDR_engine0_itt > 1090 and simDR_engine0_fail ~= 6 then                --IBAV8N, hung start test
	    simDR_hungstart0_fail = 6
	    if is_timer_scheduled(engine0hung) == false then
	        run_at_interval(engine0hung, 1)
	    end
    end
end

function starter2_active()
	if simDR_starter1_fail ~= 6 then
        if C90DR_powerplant_ign_start_switch_pos_R ~= 0 then
            stop_timer(starter2_cooling)
		    starter2_count = starter2_count + 1
        else
            run_at_interval(starter2_cooling, 5)
            stop_timer(starter2_active)
        end
    else print("C90B_EVO: FAILURE: Failed Right Starter.  Do not crank for > 30 seconds, allow 1 minute to cool between start attempts") stop_timer(starter2_active)
	end
	if starter2_count > 40 then
		simDR_starter1_fail = math.random(6, 11)
	end
    if simDR_engine1_itt > 1090 and simDR_engine1_fail ~= 6 then                --IBAV8N, hung start test
	    simDR_hungstart1_fail = 6
	    if is_timer_scheduled(engine1hung) == false then
	        run_at_interval(engine1hung, 1)
	    end
    end
end

function starter1_cooling()
    starter1_count = starter1_count - 5
    if starter1_count < 5 then
        starter1_count = 0
        stop_timer(starter1_cooling)
    end
end

function starter2_cooling()
    starter2_count = starter2_count - 5
    if starter2_count < 5 then
        starter2_count = 0
        stop_timer(starter2_cooling)
    end
end

function engine0hung()
    hung0 = hung0 + 1
    if simDR_mixture_ratio0 > 0.3 then
        hung0fail = hung0fail + 1
    else hung0fail = 0
    end
    if hung0fail > 5 then
        simDR_engine0_fail = 6
        simDR_hungstart0_fail = 0
        hung0fail = 0
        hung0 = 0
        print("C90B_EVO: FAILURE: Hung Start Left Engine")
        stop_timer(engine0hung)
    end
    if (C90DR_powerplant_ign_start_switch_pos_L == -1 and starter1_count > 27)
        or hung0 > 180 then
        simDR_hungstart0_fail = 0
        hung0fail = 0
        hung0 = 0
        stop_timer(engine0hung)
    end
end

function engine1hung()
    hung1 = hung1 + 1
    if simDR_mixture_ratio1 > 0.3 then
        hung1fail = hung1fail + 1
    else hung1fail = 0
    end
    if hung1 > 5 then
        simDR_engine1_fail = 6
        simDR_hungstart1_fail = 0
        hung1fail = 0
        hung1 = 0
        print("C90B_EVO: FAILURE: Hung Start Right Engine")
        stop_timer(engine1hung)
    end
    if (C90DR_powerplant_ign_start_switch_pos_R == -1 and starter2_count > 27)
        or hung1 > 180 then
        simDR_hungstart1_fail = 0
        hung1fail = 0
        hung1 = 0
        stop_timer(engine1hung)
    end
end

-- ENGINE RUNNING FAILURE SCAN          --IBAV8N, Dec16-21, new code
function eng_fail()
    if simDR_gear_on_ground[1] == 1 and simDR_engine_running[0] == 1 and simDR_engine_antiice_left == 0 then    --FOD LEFT
        if is_timer_scheduled(fod_left) == false then
            run_at_interval(fod_left, 1)
        end
    else stop_timer(fod_left)
    end
    if simDR_gear_on_ground[2] == 1 and simDR_engine_running[1] == 1 and simDR_engine_antiice_right == 0 then   --FOD RIGHT
        if is_timer_scheduled(fod_right) == false then
            run_at_interval(fod_right, 1)
        end
    else stop_timer(fod_right)
    end
    if simDR_torque1 > 1900 then                                    --if L torque over 1400 ftlbs
        if is_timer_scheduled(overtorque0) == false then            --check if random failure generator is running
            run_at_interval(overtorque0, 1)                         --if not, schedule for every second
        end
    end
    if simDR_torque2 > 1900 then                                    --if R torque over 1400 ftlbs
        if is_timer_scheduled(overtorque1) == false then            --check if random failure generator is running
            run_at_interval(overtorque1, 1)                         --if not, schedule for every second
        end
    end
    if simDR_starter1_running == 0 then                              --L over itt
        if simDR_engine0_itt > 725 and simDR_torque1 > 100 then     --IBAV8N, Jan10-22, test this for airborn restarts
            if is_timer_scheduled(over_itt0) == false then
                run_at_interval(over_itt0, 1)
            end
        end
    end
    if simDR_starter2_running == 0 then                              --R over itt
        if simDR_engine1_itt > 725 and simDR_torque2 > 100 then
            if is_timer_scheduled(over_itt1) == false then
                run_at_interval(over_itt1, 1)
            end
        end
    end
end

--ENGINE RUNNING FAILURE ROUTINES
function fod_left()
    if simDR_engine_antiice_left == 0 then
        if simDR_ongrass_left == 1 or simDR_onnoisy_left == 1 then
            print("C90B_EVO: Warning: Left Engine foreign object damage risk")
        end
        if simDR_engine0_fail ~= 6 then
            simDR_engine0_fail = math.random(6, (14406 - math.max((12594 * simDR_ongrass_left), (13494 * simDR_onnoisy_left)))) end          --IBAV8N, Feb3-22, now just bad luck, testing
        if simDR_engine0_fail == 6 then
            print("C90B_EVO: FAILURE: Left engine foreign object damage, turn on engine anti-ice when wheels are on gravel/grass")
            if is_timer_scheduled(engine0fire) == false then run_at_interval(engine0fire, 1) end
            stop_timer(fod_left)
        end
    end
end

function fod_right()
    if simDR_engine_antiice_right == 0 then
        if simDR_ongrass_right == 1 or simDR_onnoisy_right == 1 then
            print("C90B_EVO: Warning: Right Engine foreign object damage risk")
        end
        if simDR_engine1_fail ~= 6 then
            simDR_engine1_fail = math.random(6, (14406 - math.max((12954 * simDR_ongrass_right), (13494 * simDR_onnoisy_right)))) end          --IBAV8N, Feb3-22, now just bad luck, testing
        if simDR_engine1_fail == 6 then
            print("C90B_EVO: FAILURE: Right engine foreign object damage, turn on engine anti-ice when wheels are on gravel/grass")
            if is_timer_scheduled(engine1fire) == false then run_at_interval(engine1fire, 1) end
            stop_timer(fod_right)
        end
    end
end

function overtorque0()
    if simDR_torque1 > 1900 then
        print("C90B_EVO: Warning: Left Engine over-torque")
        if simDR_propshaft0_fail ~= 6 then simDR_propshaft0_fail = math.random(6, math.ceil(36 / ((0.00352 * simDR_torque1) - 6.63519))) end --fail within 10 minutes @1400ftlbs, 30 sec max torque
        if simDR_propshaft0_fail == 6 then print("C90B_EVO: FAILURE: Left propeller over-torque") end
    else stop_timer(overtorque0)
    end
end

function overtorque1()
    if simDR_torque2 > 1900 then
        print("C90B_EVO: Warning: Right Engine over-torque")
        if simDR_propshaft1_fail ~= 6 then simDR_propshaft1_fail = math.random(6, math.ceil(36 / ((0.00352 * simDR_torque2) - 6.63519))) end --fail within 10 minutes @1400ftlbs, 30 sec max torque
        if simDR_propshaft1_fail == 6 then print("C90B_EVO: FAILURE: Right propeller over-torque") end
    else stop_timer(overtorque1)
    end
end

function over_itt0()
    if simDR_engine0_itt > 725 then
        print("C90B_EVO: Warning: Left Engine ITT High")
        if simDR_engine0_fail ~= 6 then simDR_engine0_fail = math.random(6, math.ceil(11 / ((0.0036233 * simDR_engine0_itt) - 2.6234))) end --fail itt over 725 ~ 280s, 1000 in 5s
        if simDR_engine0_fail == 6 then
            print("C90B_EVO: FAILURE: Left engine ITT over redline")
            if is_timer_scheduled(engine0fire) == false then run_at_interval(engine0fire, 1) end
            stop_timer(over_itt0)
        end
    else stop_timer(over_itt0)
    end
end

function over_itt1()
    if simDR_engine1_itt > 725 then
        print("C90B_EVO: Warning: Right Engine ITT High")
        if simDR_engine1_fail ~= 6 then simDR_engine1_fail = math.random(6, math.ceil(11 / ((0.0036233 * simDR_engine1_itt) - 2.6234))) end  --fail itt over 725 ~ 280s, 1000 in 5s
        if simDR_engine1_fail == 6 then
            print("C90B_EVO: FAILURE: Right engine ITT over redline")
            if is_timer_scheduled(engine1fire) == false then run_at_interval(engine1fire, 1) end
            stop_timer(over_itt1)
        end
    else stop_timer(over_itt1)
    end
end

function engine0fire()
    if simDR_engine0_fail == 6 and simDR_mixture_ratio0 > 0.1 then                                                                          --if L engine failed and mixture over 0.1
        if simDR_engfir0_fail ~= 6 then simDR_engfir0_fail = math.random(6, 36) end
        if simDR_engfir0_fail == 6 then
            print("C90B_EVO: Left Engine Fire: Set fuel to cutoff, turn off left firewall fuel switch")
            if is_timer_scheduled(stop_engine0fire) == false then run_at_interval(stop_engine0fire, 1) end
            if is_timer_scheduled(cpt_smoke) == false then run_at_interval(cpt_smoke, 1) end
            stop_timer(engine0fire)
        end
    else stop_timer(engine0fire)
    end
end

function engine1fire()
    if simDR_engine1_fail == 6 and simDR_mixture_ratio1 > 0.1 then                                                                          --if R engine failed and mixture over 0.1
        if simDR_engfir1_fail ~= 6 then simDR_engfir1_fail = math.random(6, 36) end
        if simDR_engfir1_fail == 6 then
            print("C90B_EVO: Right Engine Fire: Set fuel to cutoff, turn off right firewall fuel switch")
            if is_timer_scheduled(stop_engine1fire) == false then run_at_interval(stop_engine1fire, 1) end
            if is_timer_scheduled(cpt_smoke) == false then run_at_interval(cpt_smoke, 1) end
            stop_timer(engine1fire)
        end
    else stop_timer(engine1fire)
    end
end

function stop_engine0fire()
    local ref1 = 0
    if simDR_engfir0_fail == 6 and simDR_mixture_ratio0 < 0.1 then
        ref1 = math.random(1, (34 / 1 + simDR_fuel_firewall_vlv_L))
        if ref1 == 1 then
            simDR_engfir0_fail = 0
            print("C90B_EVO: Left Engine Fire Extinguished")
            stop_timer(stop_engine0fire)
        end
    end
end

function stop_engine1fire()
    local ref2 = 0
    if simDR_engfir1_fail == 6 and simDR_mixture_ratio1 < 0.1 then
        ref2 = math.random(1, (44 / 1 + simDR_fuel_firewall_vlv_R))
        if ref2 == 1 then
            simDR_engfir1_fail = 0
            print("C90B_EVO: Right Engine Fire Extinguished")
            stop_timer(stop_engine1fire)
        end
    end
end

function cpt_smoke()
    if simDR_smoke_cpit_fail ~= 6 then
        if (simDR_engfir0_fail == 6 and C90DR_pneumatic_bleed_air_switch_pos_L == 1) or
            (simDR_engfir1_fail == 6 and C90DR_pneumatic_bleed_air_switch_pos_R == 1) then                      --if either eng on fire and its bleed on
            simDR_smoke_cpit_fail = math.random(6, 26)                                                          --make cockpit smoke
        end
    else
        print("C90B_EVO: Cockpit Smoke: Turn off failed engine's bleed, set cabin fan to maximum")
        if is_timer_scheduled(stop_cpt_smoke) == false then run_at_interval(stop_cpt_smoke, 1) end
        stop_timer(cpt_smoke)
    end
end

function stop_cpt_smoke()
    local rsm = 0
    if simDR_smoke_cpit_fail == 6 and ((simDR_engine0_fail == 6 and C90DR_pneumatic_bleed_air_switch_pos_L == 0)
        or (simDR_engine1_fail == 6 and C90DR_pneumatic_bleed_air_switch_pos_R == 0)) then                      --if either eng on fire and its bleed on
        rsm = math.random(1, (30 / 1 + (2 * simDR_fan_setting)))
        if rsm == 1 then
            simDR_smoke_cpit_fail = 0
            print("C90B_EVO: Cockpit Smoke cleared. Good Job!")
            stop_timer(cpt_smoke)
        end
    end
end

-- WINDSHIELD HEAT FAIL LEFT --IBAV8N Aug23-23 new XP12 drefs
function windshieldfail_L()
	if simDR_airspeed < 40 and simDR_windshield_heat_on_window_L == 1 and simDR_fuselage_ice == 0 then windshield_L = windshield_L + 1
		if windshield_L == 300 then
			simDR_windshield_heat_fail = 6
			stop_timer(windshieldfail_L)
        end
    end
end

-- WINDSHIELD HEAT FAIL RIGHT
function windshieldfail_R()
	if simDR_airspeed < 40 and simDR_windshield_heat_on_window_R == 1 and simDR_fuselage_ice == 0 then windshield_R = windshield_R + 1
		if windshield_R == 300 then
			simDR_windshield_heat_fail_cop = 6
			stop_timer(windshieldfail_R)
        end
    end
end


-- PROP DEICE HEAT OVERHEATING
function propdeice()
	if C90DR_iceRain_prop_deice_switch_pos == 1 and simDR_prop_rpm_left < 150 then
		prop_left = prop_left + 1
		if prop_left > 300 then
			simDR_prop_deice_heat_left_fail = 6
		end
	end
	if C90DR_iceRain_prop_deice_switch_pos == 1 and simDR_prop_rpm_right < 150 then
		prop_right = prop_right + 1
		if prop_right > 300 then
			simDR_prop_deice_heat_right_fail = 6
		end
	end
	if simDR_prop_rpm_left > 150 then
		prop_left = 0
	end
	if simDR_prop_rpm_right > 150 then
		prop_right = 0
	end
	if C90DR_iceRain_prop_deice_switch_pos == 0 then
         stop_timer(propdeice)
    end
end

-- BEACON FAILURE
function beaconfail()
    if (C90DR_avionics_mkr_audio_bkn1_switch_pos_pilot == 1 and simDR_nav1_fail ~= 6) or
        (C90DR_avionics_mkr_audio_bkn2_switch_pos_pilot == 1 and simDR_nav2_fail ~= 6) then
        simDR_audio_selected_mkr = 1
    else simDR_audio_selected_mkr = 0
    end
    stop_timer(beaconfail)
end
