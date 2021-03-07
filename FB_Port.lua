members={}
first_launch = true
runout_treshhold = 0.8 -- when the buff should be counted as running out

function fbh_init()
	if UnitInRaid("player") then
		if first_launch then 
			fbh_initmembers()
			my_name, my_rank, my_subgroup, my_level, my_class, my_fileName,my_zone_backup, my_online, my_isDead, my_role, my_isML, my_combatRole= GetRaidRosterInfo(UnitInRaid("player"))
			my_zone=GetZoneText()
			first_launch=false
			print("fbh_port initalized")
			end
	else
	print("you are not in raid")
	end
end

function fbh_initmembers()
 for i=1,8 do
	members[i]=0
 end
end
function fbh_countmembers()
fbh_init()
fbh_initmembers()
	if IsInRaid() then
		for i=1,40 do  
			local name, rank, subgroup, level, class, fileName,zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(i);
				if name then
					if name~=my_name then 
						if subgroup<8 then
							if members[subgroup] then
								members[subgroup]=members[subgroup]+1;
							else
								members[subgroup]=1;
							end
						end
					end
		end
		end
	end
end

function fbh_port_msg()
fbh_init();
fbh_countmembers();
  if(UnitExists("target")) then
	local name, rank, subgroup, level, class, fileName,zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(UnitInRaid(fbh_targetName()));
	--local my_name, my_rank, my_subgroup, my_level, my_class, my_fileName,my_zone, my_online, my_isDead, my_role, my_isML, my_combatRole = GetRaidRosterInfo(UnitInRaid("player"));
	
		if my_zone==zone or zone==my_zone_backup then
			SendChatMessage("Du bist schon in "..zone..", wenn du dennoch einen Port willst sag Bescheid.","WHISPER",nil,name)
			print("dont port");
		else
			SendChatMessage(zone.." goto "..my_zone,"WHISPER",nil,name);
			SendChatMessage("Port auf "..name.." Bitte klicken!","RAID_WARNING",nil,name);
			if members[3]<5 then
				SetRaidSubgroup(UnitInRaid("target"), 3);
			else
				SetRaidSubgroup(UnitInRaid("target"), 2);
			end
		end
  
	end	
end
--[[
function fbh_sort()
fbh_init();
fbh_countmembers()
print("sorting");
	for i=1,40 do  
			local name, rank, subgroup, level, class, fileName,zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(i);
				if name then
					if subgroup<7 then
							if zone==my_zone or zone==my_zone_backup then
								for g=4,6 do
									if members[g]<5 then
										SetRaidSubgroup(i,g)
										break
									end
								end
							else 
								for g=1,2 do
									if subgroup==3 then
										break;
									end
									if members[g]<5 then
										SetRaidSubgroup(i,g)
										break
									end
								end
							end
						
					end
				end
	end			
end
]]--
function fbh_sort_new()
fbh_init();
fbh_countmembers()
print("sorting new");
	for i=1,40 do  
			local name, rank, subgroup, level, class, fileName,zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(i);
				if name then
					if subgroup<7 then
					has_ony=fbh_check_for_spell(name,22888,0)
					has_zg=fbh_check_for_spell(name,24425,0)
					has_sf=fbh_check_for_spell(name,15366,0)
					has_dm_s=fbh_check_for_spell(name,22820,0)
					has_dm_f=fbh_check_for_spell(name,22817,0)
					has_dm_m=fbh_check_for_spell(name,22818,0)
					print("Player: "..name.." Worldbuffs: ".." Ony: "..tostring(has_ony).." ZG: "..tostring(has_zg).." SF: "..tostring(has_sf).."DM Buffs:".." Slip: "..tostring(has_dm_s).." Fengus: "..tostring(has_dm_f).." Moldar: "..tostring(has_dm_m))
							if zone==my_zone or zone==my_zone_backup then --ony/zg/sf
								if has_ony and has_zg and has_sf then
								SetRaidSubgroup(i,6)
								elseif  has_ony or has_zg then --ony/zg
								SetRaidSubgroup(i,5)
								else
								SetRaidSubgroup(i,4)
								end
				else 
					if subgroup==3 then
						break;
					end
					if has_dm_f and has_dm_s and has_dm_m then
						SetRaidSubgroup(i,3)
					end
					if subgroup>3 then
						if members[1]<members[2] then
							SetRaidSubgroup(i,1)
						elseif members[2]<members[1] then
							SetRaidSubgroup(i,2)
						end
					end
				end
									
			end
						
		end
				
	end			
end

function fbh_check_for_spell(checkPlayer,checkSpellID,treshhold)-- return false if buff is running out or not exiting
for i=1,40 do
name,_, _,debuffType,duration,expirationTime , _,_, _, spellId,_ = UnitBuff(checkPlayer,i)
if name then 
	if spellId==checkSpellID then
	runout=((GetTime()-expirationTime))
	runout_str=format("%.2f",runout)
	duration_str=format("%.2f",duration)
	--print(name.."=".."exptime= "..expirationTime..":"..runout.."/"..duration.."s")
		if runout<duration*treshhold then
			return false
			else
			return true
		end
	end
end
end
return false
end

function fbh_info_msg()
fbh_init()
if IsInRaid() then
		for i=1,40 do  
			local name, rank, subgroup, level, class, fileName,zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(i);
			if name then 
				if subgroup==8  then
					if role=="MAINTANK" then
						 bezahler= name
					elseif role=="MAINASSIST" then
						 porter=name
					end
				end
			end
			
		end
if bezahler then
		SendChatMessage("Buchung und Bezahlung bei "..bezahler.."!","RAID_WARNING",nil,name);
end
if porter then
		SendChatMessage("Portal bei "..porter.."!","RAID_WARNING",nil,name);
end
end
end


function fbh_test()
fbh_init()
print("test")
end