test_frm_ice = find_dataref("sim/flightmodel/failures/frm_ice")
test_frm_ice2 = find_dataref("sim/flightmodel/failures/frm_ice2")
test_tail_ice = find_dataref("sim/flightmodel/failures/tail_ice")
test_tail_ice2 = find_dataref("sim/flightmodel/failures/tail_ice2")
test_window_0 = find_dataref("sim/flightmodel/failures/window_ice_per_window[0]")
test_window_1 = find_dataref("sim/flightmodel/failures/window_ice_per_window[1]")
test_window_2 = find_dataref("sim/flightmodel/failures/window_ice_per_window[2]")
test_window_3 = find_dataref("sim/flightmodel/failures/window_ice_per_window[3]")
test_prop_ice_L = find_dataref("sim/flightmodel/failures/prop_ice_per_engine[0]")
test_prop_ice_R = find_dataref("sim/flightmodel/failures/prop_ice_per_engine[1]")
test_zulu_time_sec = find_dataref("sim/time/zulu_time_sec")
test_m_empty = find_dataref("sim/aircraft/weight/acf_m_empty")      --empty weight
test_m_fuel_total = find_dataref("sim/flightmodel/weight/m_fuel_total")  --fuel weight
test_m_fixed = find_dataref("sim/flightmodel/weight/m_fixed")       --payload weight
test_m_total = find_dataref("sim/flightmodel/weight/m_total")       --total weight, with ice

local ice_reset = -0.05
local ice_time_elapsed = test_zulu_time_sec

function report_ice()
    if test_window_3 < 0.5001 then
        if test_window_3 + ice_reset > 0 then
            ice_reset = ice_reset - 0.05
            print_results()
        end
    end
end

function print_results()
    print("                                     QQQ - Elapsed time: "..test_zulu_time_sec - ice_time_elapsed.. " total seconds")
    print("                                     Ice weight: "..test_m_total - test_m_empty - test_m_fuel_total - test_m_fixed.." Kg")
    print("                                     Frame, wing ice ratio, Left: "..test_frm_ice.." Right: "..test_frm_ice2)
    print("                                     Tail ice, Left: "..test_tail_ice.." Right: "..test_tail_ice2)
    print("                                     Windscreen, Left: "..test_window_0.." Right: "..test_window_1)
    print("                                     Prop ice, Left: "..test_prop_ice_L.." Right: "..test_prop_ice_R)
end

function C90_imc_add_ice_CMDhandler(phase)
    if phase == 0 then
        test_frm_ice = test_frm_ice + 0.05
        test_frm_ice2 = test_frm_ice2 + 0.05
        test_tail_ice = test_tail_ice + 0.05
        test_tail_ice2 = test_tail_ice2 + 0.05
        --test_window_0 =
        --test_window_1 =
        --test_window_2 =
        test_window_3 = test_window_3 + 0.05
        --test_prop_ice_L =
        --test_prop_ice_R =
        if simDR_oat_degf <= 32 then
            C90CMD_iceRain_engine_antiice_sel_switch_L_up:once()
            C90CMD_iceRain_engine_antiice_sel_switch_R_up:once()
            C90CMD_iceRain_windshield_antiice_switch_up_L:once()
            C90CMD_iceRain_windshield_antiice_switch_up_R:once()
            C90CMD_iceRain_prop_deice_switch_up:once()
        end
    end
end

function C90_imc_rmv_ice_CMDhandler(phase)
    if phase == 0 then
        test_frm_ice = math.max(0, test_frm_ice - 0.05)
        test_frm_ice2 = math.max(0, test_frm_ice2 - 0.05)
        test_tail_ice = math.max(0, test_tail_ice - 0.05)
        test_tail_ice2 = math.max(0, test_tail_ice2 - 0.05)
        --test_window_0 = 
        --test_window_1 = 
        --test_window_2 = 
        test_window_3 = math.max(0, test_window_3 - 0.05)
        --test_prop_ice_L = 
        --test_prop_ice_R = 
    end
end

C90CMD_imc_add_ice		        = create_command("laminar/imc/testing/add_ice", "Add ice", C90_imc_add_ice_CMDhandler)
C90CMD_imc_rmv_ice		        = create_command("laminar/imc/testing/rmv_ice", "Remove ice", C90_imc_rmv_ice_CMDhandler)
