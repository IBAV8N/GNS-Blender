
local C90_reg_bleed_air_psi 			= {}
local C90_sea_level_inHg				= {}
local C90_reg_vacuum_inHg				= {}
local boot_counter                      = 0

-- PNEUMATIC PRESSURE ----------------------------------------------------------------
function C90_pneumatic_pressure()       --IBAV8N, Jun25-21, wing boots now affect the needle
	C90_reg_bleed_air_psi[1] = C90_rescale(0, 0, 58, 12, simDR_engine_N1_pct[0])
	if simDR_engine_N1_pct[0] > 58 then C90_reg_bleed_air_psi[1] = C90.iceRain.surface_deice_psid + C90_rescale(58, 12, 70, 18, simDR_engine_N1_pct[0]) end
	if simDR_engine_N1_pct[0] > 70 then C90_reg_bleed_air_psi[1] = C90.iceRain.surface_deice_psid + C90_rescale(70, 18, 80, 19, simDR_engine_N1_pct[0]) end
	C90_reg_bleed_air_psi[2] = C90_rescale(0, 0, 58, 12, simDR_engine_N1_pct[1])
	if simDR_engine_N1_pct[1] > 58 then C90_reg_bleed_air_psi[2] = C90.iceRain.surface_deice_psid + C90_rescale(58, 12, 70, 18, simDR_engine_N1_pct[1]) end
	if simDR_engine_N1_pct[1] > 70 then C90_reg_bleed_air_psi[2] = C90.iceRain.surface_deice_psid + C90_rescale(70, 18, 80, 19, simDR_engine_N1_pct[1]) end

	C90DR_pneumatic_pressure_gauge_psi_needle_pos = math.max(C90_reg_bleed_air_psi[1], C90_reg_bleed_air_psi[2])
--end

    -- GYRO SUCTION ----------------------------------------------------------------------

	local altitude_factor = C90_rescale(0, 1, 31000, 0.7288, simDR_altitude)
	C90_sea_level_inHg[1] = C90_rescale(0, 0, 19, 5.9, C90_reg_bleed_air_psi[1])
	C90_reg_vacuum_inHg[1] = C90_sea_level_inHg[1] * altitude_factor
	C90_sea_level_inHg[2] = C90_rescale(0, 0, 19, 5.9, C90_reg_bleed_air_psi[2])
	C90_reg_vacuum_inHg[2] = C90_sea_level_inHg[2] * altitude_factor
	C90DR_pneumatic_gyro_suction_gauge_inHg_needle_pos = math.max(C90_reg_vacuum_inHg[1], C90_reg_vacuum_inHg[2])

    if simDR_fuselage_ice == 0 then
        C90DR_icing_not_present = 1
    else
        C90DR_icing_not_present = 0
    end

end
--[[
----- WINDSHIELD ANTI-ICE ---------------------------------------------------------------
function C90_windshield_anti_ice() --IBAV8N Aug23-23 new XP12 drefs
    if math.abs(C90DR_iceRain_windshield_antiice_switch_pos_L) ~= simDR_windshield_heat_on_window_L then simCMD_window_heat_tog:once() end
    if math.abs(C90DR_iceRain_windshield_antiice_switch_pos_R) ~= simDR_windshield_heat_on_window_R then simCMD_window2_heat_tog:once() end
end
--]]

----- PROP DE-ICE -----------------------------------------------------------------------
function C90_prop_deice()
	if C90DR_iceRain_prop_deice_switch_pos == 0 then                -- OFF
		stop_timer(C90_prop_deice_cycle)
		simDR_prop_heat[0] = 0
		simDR_prop_heat[1] = 0
	elseif C90DR_iceRain_prop_deice_switch_pos == 1 then            -- ON
		if is_timer_scheduled(C90_prop_deice_cycle)	== false then
			run_timer(C90_prop_deice_cycle, 0, 90)
		end
	end
end

function C90_prop_deice_cycle()                                     --IBAV8N, Dec23, wasn't switching before
	simDR_prop_heat[1] = simDR_prop_heat[0]
	simDR_prop_heat[0] = 1 - simDR_prop_heat[1]
end

-- COMPASS INTERFERENCE WHEN WINDSHIELD HEATING IS ON
function compass()
	simDR_compass = math.random(0,360)
	if C90DR_iceRain_windshield_antiice_switch_pos_L == 0 and C90DR_iceRain_windshield_antiice_switch_pos_R == 0 then
		stop_timer(compass)
	end
end

-- MODIFIES PNEUMATIC NEEDLE
function pneum_needle_swing()
    if math.abs(C90.iceRain.surface_deice_psid - psid_target) > 0.001 then
        C90.iceRain.surface_deice_psid = C90_set_animation_position(C90.iceRain.surface_deice_psid, psid_target, -1, 0.5, 4)
    elseif math.abs(C90.iceRain.surface_deice_psid - psid_target) < 0.001 then
        psid_target = 0
        if psid_target == 0 and math.abs(C90.iceRain.surface_deice_psid) < 0.001 then
            stop_timer(pneum_needle_swing)
        end
    end
end

function inflate(dref, amount_per_second, maximum)
    return math.min(dref + math.abs(amount_per_second) * SIM_PERIOD, maximum)
end

function deflate(dref, amount_per_second, minimum)
    return math.max(dref - math.abs(amount_per_second) * SIM_PERIOD, minimum)
end

function C90_boots_icing_status()       --in the loop
	if C90DR_icing_not_present == 0 then		
		local fuselage_ice_level = 0    -- fuselage icing level (0->3) based on window[3] ice amount
		if simDR_fuselage_ice > 0 then		
			if simDR_fuselage_ice < 0.05 then
				fuselage_ice_level = 1
			elseif simDR_fuselage_ice <= 0.1 then
				fuselage_ice_level = 2
			else
				fuselage_ice_level = 3
			end
		end				
		C90DR_fuselage_icing_level = fuselage_ice_level
				
		if simDR_prop_is_disc[0] == 1 then                              -- left spinner
			C90DR_spinner_dynamic_icing_level[0] = 0
			C90DR_spinner_static_icing_level[0] = fuselage_ice_level
		else
			C90DR_spinner_dynamic_icing_level[0] = fuselage_ice_level
			C90DR_spinner_static_icing_level[0] = 0
		end
		if simDR_prop_is_disc[1] == 1 then                              -- right spinner
			C90DR_spinner_dynamic_icing_level[1] = 0
			C90DR_spinner_static_icing_level[1] = fuselage_ice_level
		else
			C90DR_spinner_dynamic_icing_level[1] = fuselage_ice_level
			C90DR_spinner_static_icing_level[1] = 0
		end

		local wing_icing = math.max(simDR_wing_ice_L, simDR_wing_ice_R) -- aero icing	
		if wing_icing < 0.01 then
			C90DR_aero_icing_wing_level = 0
		elseif wing_icing < 0.05 then
			C90DR_aero_icing_wing_level = 1
		elseif wing_icing < 0.1 then
			C90DR_aero_icing_wing_level = 2
		elseif wing_icing < 0.15 then
			C90DR_aero_icing_wing_level = 3
		elseif wing_icing < 0.25 then
			C90DR_aero_icing_wing_level = 4
		else
			C90DR_aero_icing_wing_level = 5
		end
		
		local empennage_icing = math.max(simDR_tail_ice_L, simDR_tail_ice_R)    --empennage icing
		if empennage_icing < 0.01 then
			C90DR_aero_icing_empennage_level = 0
		elseif empennage_icing < 0.05 then
			C90DR_aero_icing_empennage_level = 1
		elseif empennage_icing < 0.1 then
			C90DR_aero_icing_empennage_level = 2
		elseif empennage_icing < 0.15 then
			C90DR_aero_icing_empennage_level = 3
		elseif empennage_icing < 0.25 then
			C90DR_aero_icing_empennage_level = 4
		else
			C90DR_aero_icing_empennage_level = 5
		end
    else
        fuselage_ice_level = 0
        C90DR_fuselage_icing_level = 0
        C90DR_spinner_dynamic_icing_level[0] = 0
        C90DR_spinner_dynamic_icing_level[1] = 0
        C90DR_spinner_static_icing_level[0] = 0
        C90DR_spinner_static_icing_level[1] = 0
        C90DR_aero_icing_wing_level = 0
        C90DR_aero_icing_empennage_level = 0
	end  
    if C90.iceRain.current_action ~= 0 then     -- inflate or deflate the boots either manually or automatic cycling
        if is_timer_scheduled(pneum_needle_swing) == false then --run the needle function if it is not
	        run_at_interval(pneum_needle_swing, 0.01)
        end
        if C90.airCon.bleed_avail ~= 1 then     -- no bleed air available switch to the deflate mode, our only option!
            C90.iceRain.current_action = 3      -- then head to deflate
        end
        if C90.iceRain.current_action == 1 then -- single action
            if C90.iceRain.surface_deice_phase ~= 0 then    -- only used for single action
                surface_deice_cycle()
            else
                C90.iceRain.current_action = 0              -- done
            end
        end
        if C90.iceRain.current_action == 2 then     -- manual
            if surface_deice_inflate_all() == true then     -- inflate
                C90.iceRain.current_action = 0              -- done
            end
        end
        if C90.iceRain.current_action == 3 then    -- manual     
            if surface_deice_deflate_all() == true then     -- deflate
                C90.iceRain.current_action = 0              -- done
            end
        end
    end
end

function surface_deice_cycle()  -- single action only
    local wing_inflation = 0
    local tail_inflation = 0
    if C90.iceRain.surface_deice_phase == 1 then
        wing_inflation = inflate(C90DR_boot_inflation_wing[0], 0.1667, 1.0) -- inflate wing - 6 seconds
        if wing_inflation >= 1.0 then       -- inflation complete move to next phase
            C90.iceRain.surface_deice_phase = 2     -- go to empennage
        elseif wing_inflation > 0.5 then   -- clear the ice
            simDR_wing_ice_L = 0
            simDR_wing_ice_R = 0
        end
        psid_target = -1
    elseif C90.iceRain.surface_deice_phase == 2 then
        wing_inflation = deflate(C90DR_boot_inflation_wing[0], 0.5, 0.0)    -- channel bleed pressure to empennage, 2 secs to deflate wing boots
        tail_inflation = inflate(C90DR_boot_inflation_tailplane[0], 0.25, 1.0)  -- inflate tail - 4 seconds
        if tail_inflation >= 1.0 then
            C90.iceRain.surface_deice_phase = 3 -- begin tail deflation
        elseif tail_inflation > 0.5 then       -- clear the ice
            simDR_tail_ice_L = 0
            simDR_tail_ice_R = 0
        end
        psid_target = -1
    elseif C90.iceRain.surface_deice_phase == 3 then        -- deflate tail - 2 seconds
        tail_inflation = deflate(C90DR_boot_inflation_tailplane[0], 0.5, 0.0)
        if tail_inflation <= 0.0 then
            C90.iceRain.surface_deice_phase = 0     -- done!
        end
        psid_target = 0.5
    else
        psid_target = 0 
    end
    C90DR_boot_inflation_wing[0] = wing_inflation
    C90DR_boot_inflation_wing[1] = wing_inflation
    C90DR_boot_inflation_tailplane[0] = tail_inflation
    C90DR_boot_inflation_tailplane[1] = tail_inflation
    C90DR_boot_inflation_tailfin = tail_inflation
end

function surface_deice_inflate_all()        -- for manual function
    if C90.airCon.bleed_avail == 1 then
        local inflation = inflate(C90DR_boot_inflation_wing[0], 0.1667, 1.0) -- inflate - 6 seconds
        C90DR_boot_inflation_wing[0] = inflation
        C90DR_boot_inflation_wing[1] = inflation
        C90DR_boot_inflation_tailplane[0] = inflation
        C90DR_boot_inflation_tailplane[1] = inflation
        C90DR_boot_inflation_tailfin = inflation
        if inflation < 1 then
            psid_target = -1
        end
        if inflation >= 1.0 then
            --C90.iceRain.surface_deice_mode = 0
            psid_target = 0
            return true
        elseif inflation > 0.5 then        -- clear the ice
            simDR_wing_ice_L = 0
            simDR_wing_ice_R = 0
            simDR_tail_ice_L = 0
            simDR_tail_ice_R = 0
        end
    end
    return false
end

function surface_deice_deflate_all()
    local inflation = deflate(C90DR_boot_inflation_wing[0], 0.5, 0.0)
    C90DR_boot_inflation_wing[0] = inflation
    C90DR_boot_inflation_wing[1] = inflation
    C90DR_boot_inflation_tailplane[0] = inflation
    C90DR_boot_inflation_tailplane[1] = inflation
    C90DR_boot_inflation_tailfin = inflation
    if inflation > 0 then
        psid_target = 0.5
    end
    if inflation <= 0.0 then
        --C90.iceRain.surface_deice_mode = 0  -- done!
        psid_target = 0
        return true
    end
    return false
end
