members={}
first_launch = true
runout_treshhold = 0.8 -- when the buff should be counted as running out

function fbh_init()
    if UnitInRaid("player") then
        if first_launch then 
            fbh_initmembers()
            my_name, my_rank, my_subgroup, my_level, my_class, my_fileName, my_zone_backup, my_online, my_isDead, my_role, my_isML, my_combatRole = GetRaidRosterInfo(UnitInRaid("player"))
            my_zone = GetZoneText()
            first_launch = false
            print("fbh_port initalized")
        end
    else
        print("you are not in raid")
    end
end

function fbh_initmembers()
    for i = 1, 8 do
        members[i] = 0
    end
end

function fbh_countmembers()
    fbh_init()
    fbh_initmembers()
    if IsInRaid() then
        for i = 1, MAX_RAID_MEMBERS do  
            local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(i)
            if name then
                if name ~= my_name then 
                    if subgroup < 8 then
                        if members[subgroup] then
                            members[subgroup] = members[subgroup] + 1
                        else
                            members[subgroup] = 1
                        end
                    end
                end
            end
        end
    end
end

function fbh_sort()
    fbh_init()
    fbh_countmembers()
    print("sorting new")
    for i= 1, MAX_RAID_MEMBERS do
        local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(i)
        if name then
            if subgroup < 7 then
                has_ony = fbh_check_for_spell(name,22888,0)
                has_zg = fbh_check_for_spell(name,24425,0)
                has_sf = fbh_check_for_spell(name,15366,0)
                has_dm_s = fbh_check_for_spell(name,22820,0)
                has_dm_f = fbh_check_for_spell(name,22817,0)
                has_dm_m = fbh_check_for_spell(name,22818,0)
                --print("Player: "..name.." Worldbuffs: ".." Ony: "..tostring(has_ony).." ZG: "..tostring(has_zg).." SF: "..tostring(has_sf).."DM Buffs:".." Slip: ostring(has_dm_s).." Fengus: "..tostring(has_dm_f).." Moldar: "..tostring(has_dm_m))
                if zone == my_zone or zone == my_zone_backup then --ony/zg/sf
                    if has_ony and has_zg and has_sf then
                        SetRaidSubgroup(i,6)
                    elseif has_ony or has_zg then --ony/zg
                        SetRaidSubgroup(i,5)
                    else
                        SetRaidSubgroup(i,4)
                    end
                else 
                    if subgroup == 3 then
                        break
                    end
                    if has_dm_f and has_dm_s and has_dm_m then
                        SetRaidSubgroup(i,3)
                    end
                    if subgroup > 3 then
                        if members[1] < members[2] then
                            SetRaidSubgroup(i,1)
                        elseif members[2] < members[1] then
                            SetRaidSubgroup(i,2)
                        end
                    end
                end
            end
        end
    end        
end
