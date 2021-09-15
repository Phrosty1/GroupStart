-- test comment
-- For menu & data
GroupStart = {}
GroupStart.savedVars = {}
GroupStart.globalSavedVars = {}

local ADDON_NAME = "GroupStart"
GroupStart.name = "GroupStart"
GroupStart.partyList = {"@Samantha.C", "@Tommy.C", "@Jenniami", "@Phrosty1"}
GroupStart.doInvite = false
GroupStart.inviteDelay = 2000
GroupStart.doInviteStagger = true
GroupStart.dungeons = {
	[184] = {fullname="Dungeon: Vaults of Madness",     shortnames={"VM", "VOM"}},
	[185] = {fullname="Dungeon: Selene's Web",          shortnames={"SW"}},
	[186] = {fullname="Dungeon: Blackheart Haven",      shortnames={"BH"}},
	[187] = {fullname="Dungeon: Blessed Crucible",      shortnames={"BLCR"}},
	[188] = {fullname="Dungeon: Tempest Island",        shortnames={"TI"}},
	[192] = {fullname="Dungeon: Arx Corinium",          shortnames={"AC"}},
	[195] = {fullname="Dungeon: Direfrost Keep",        shortnames={"DK"}},
	[196] = {fullname="Dungeon: Volenfell",             shortnames={"VF"}},
	[236] = {fullname="Dungeon: Imperial City Prison",  shortnames={"ICP"}},
	[247] = {fullname="Dungeon: White-Gold Tower",      shortnames={"WGT"}},
	[260] = {fullname="Dungeon: Ruins of Mazzatun",     shortnames={"RM"}},
	[261] = {fullname="Dungeon: Cradle of Shadows",     shortnames={"CS"}},
	[326] = {fullname="Dungeon: Bloodroot Forge",       shortnames={"BF"}},
	[332] = {fullname="Dungeon: Falkreath Hold",        shortnames={"FH"}},
	[341] = {fullname="Dungeon: Fang Lair",             shortnames={"FL"}},
	[363] = {fullname="Dungeon: Scalecaller Peak",      shortnames={"SCP"}},
	[370] = {fullname="Dungeon: March of Sacrifices",   shortnames={"MS"}},
	[391] = {fullname="Dungeon: Moongrave Fane",        shortnames={"MF", "MOONGRAVE"}},
	[371] = {fullname="Dungeon: Moon Hunter Keep",      shortnames={"MHK", "MOONHUNTER"}},
	[389] = {fullname="Dungeon: Frostvault",            shortnames={"FV"}},
	[390] = {fullname="Dungeon: Depths of Malatar",     shortnames={"DM"}},
	[398] = {fullname="Dungeon: Lair of Maarselok",     shortnames={"LM"}},
	[194] = {fullname="Dungeon: The Banished Cells I",  shortnames={"BC"}},
	[189] = {fullname="Dungeon: Wayrest Sewers I",      shortnames={"WS"}},
	[198] = {fullname="Dungeon: Darkshade Caverns I",   shortnames={"DC"}},
	[191] = {fullname="Dungeon: Elden Hollow I",        shortnames={"EH"}},
	[ 98] = {fullname="Dungeon: Fungal Grotto I",       shortnames={"FG"}},
	[193] = {fullname="Dungeon: Spindleclutch I",       shortnames={"SP"}},
	[197] = {fullname="Dungeon: City of Ash I",         shortnames={"CA", "COA"}},
	[190] = {fullname="Dungeon: Crypt of Hearts I",     shortnames={"CH", "COH"}},
	[230] = {fullname="Trial: Hel Ra Citadel",          shortnames={""}},
	[231] = {fullname="Trial: Aetherian Archive",       shortnames={""}},
	[232] = {fullname="Trial: Sanctum Ophidia",         shortnames={""}},
	[258] = {fullname="Trial: Maw of Lorkhaj",          shortnames={""}},
	[331] = {fullname="Trial: Halls of Fabrication",    shortnames={""}},
	[346] = {fullname="Trial: Asylum Sanctorium",       shortnames={""}},
	[364] = {fullname="Trial: Cloudrest",               shortnames={""}},
	[399] = {fullname="Trial: Sunspire",                shortnames={""}},
	[424] = {fullname="Dungeon: Icereach",              shortnames={"IR"}},
	[425] = {fullname="Dungeon: Unhallowed Grave",      shortnames={"UG"}},
	[435] = {fullname="Dungeon: Stone Garden",          shortnames={"SG"}},
	[436] = {fullname="Dungeon: Castle Thorn",          shortnames={"CT"}}}

GroupStart.dungeons2 = {
	[262] = {fullname="Dungeon: The Banished Cells II", shortnames={"BC"}},
	[263] = {fullname="Dungeon: Wayrest Sewers II",     shortnames={"WS"}},
	[264] = {fullname="Dungeon: Darkshade Caverns II",  shortnames={"DC"}},
	[265] = {fullname="Dungeon: Elden Hollow II",       shortnames={"EH"}},
	[266] = {fullname="Dungeon: Fungal Grotto II",      shortnames={"FG"}},
	[267] = {fullname="Dungeon: Spindleclutch II",      shortnames={"SP"}},
	[268] = {fullname="Dungeon: City of Ash II",        shortnames={"CA", "COA"}},
	[269] = {fullname="Dungeon: Crypt of Hearts II",    shortnames={"CH", "COH"}}}

local ms_time = GetGameTimeMilliseconds()
local function dmsg(txt)
	d((GetGameTimeMilliseconds() - ms_time) .. ") " .. txt)
	ms_time = GetGameTimeMilliseconds()
end

function Trim(s) return (s:gsub("^%s*(.-)%s*$", "%1")) end
function GroupStart.IsInList(list, item)
	for index, value in ipairs(list) do
		if value == item then return true end
	end
	return false
end

function GroupStart.OnGroupInviteReceived(eventCode, inviteCharacterName, inviterDisplayName)
	--d("OnGroupInviteReceived".." eventCode:"..eventCode.." inviteCharacterName:"..inviteCharacterName.." inviterDisplayName:"..inviterDisplayName)
	-- eventCode: 131191 inviteCharacterName: Hadara Hazelwood inviterDisplayName: @Samantha.C
	if GroupStart.IsInList (GroupStart.partyList, inviterDisplayName) then
        AcceptGroupInvite()
    end
end

function GroupStart.DeterminePlace(location)
	level = 1
	if string.find(location, "2") or string.find(location, "II") then
		location = string.gsub(location, "2", "")
		location = string.gsub(location, "II", "")
		level = 2
	elseif string.find(location, "1") then
		location = string.gsub(location, "1", "")
	end
	location = Trim(location)
	--dmsg("location:"..location.." level:"..level)
	upperLocation = string.upper(location)
	if level == 2 then -- shortname
		for nodeIndex, dungeon in pairs(GroupStart.dungeons2) do
			if GroupStart.IsInList (dungeon.shortnames, upperLocation) then
				return nodeIndex, dungeon
			end
		end
	else
		for nodeIndex, dungeon in pairs(GroupStart.dungeons) do
			if GroupStart.IsInList (dungeon.shortnames, upperLocation) then
				return nodeIndex, dungeon
			end
		end
	end
	if level == 2 then -- fullname
		for nodeIndex, dungeon in pairs(GroupStart.dungeons2) do
			if string.find(string.upper(dungeon.fullname), upperLocation) then
				return nodeIndex, dungeon
			end
		end
	else
		for nodeIndex, dungeon in pairs(GroupStart.dungeons) do
			if string.find(string.upper(dungeon.fullname), upperLocation) then
				return nodeIndex, dungeon
			end
		end
	end
	return false
end

function GroupStart.TravelToPlace(location)
	nodeIndex, dungeon = GroupStart.DeterminePlace(location)
	if nodeIndex then
		d("Traveling to "..dungeon.fullname)
		GroupStart.doInvite = true
		FastTravelToNode(nodeIndex)
	else
		d("Could not determine destination")
	end
end

-- EVENT_GROUP_INVITE_RESPONSE (number eventCode, string inviterName, GroupInviteResponse response, string inviterDisplayName)
function GroupStart.OnGroupInviteResponse(eventCode, inviterName, response, inviterDisplayName)
	d("--- OnGroupInviteResponse Begin")
	local responsemsg = {
		[GROUP_INVITE_RESPONSE_ACCEPTED] = "GROUP_INVITE_RESPONSE_ACCEPTED",
		[GROUP_INVITE_RESPONSE_ALREADY_GROUPED] = "GROUP_INVITE_RESPONSE_ALREADY_GROUPED",
		[GROUP_INVITE_RESPONSE_CANNOT_CREATE_GROUPS] = "GROUP_INVITE_RESPONSE_CANNOT_CREATE_GROUPS",
		[GROUP_INVITE_RESPONSE_CONSIDERING_OTHER] = "GROUP_INVITE_RESPONSE_CONSIDERING_OTHER",
		[GROUP_INVITE_RESPONSE_DECLINED] = "GROUP_INVITE_RESPONSE_DECLINED",
		[GROUP_INVITE_RESPONSE_GENERIC_JOIN_FAILURE] = "GROUP_INVITE_RESPONSE_GENERIC_JOIN_FAILURE",
		[GROUP_INVITE_RESPONSE_GROUP_FULL] = "GROUP_INVITE_RESPONSE_GROUP_FULL",
		[GROUP_INVITE_RESPONSE_IGNORED] = "GROUP_INVITE_RESPONSE_IGNORED",
		[GROUP_INVITE_RESPONSE_INVITED] = "GROUP_INVITE_RESPONSE_INVITED",
		[GROUP_INVITE_RESPONSE_IN_BATTLEGROUND] = "GROUP_INVITE_RESPONSE_IN_BATTLEGROUND",
		[GROUP_INVITE_RESPONSE_ONLY_LEADER_CAN_INVITE] = "GROUP_INVITE_RESPONSE_ONLY_LEADER_CAN_INVITE",
		[GROUP_INVITE_RESPONSE_OTHER_ALLIANCE] = "GROUP_INVITE_RESPONSE_OTHER_ALLIANCE",
		[GROUP_INVITE_RESPONSE_PLAYER_NOT_FOUND] = "GROUP_INVITE_RESPONSE_PLAYER_NOT_FOUND",
		[GROUP_INVITE_RESPONSE_REQUEST_FAIL_ALREADY_GROUPED] = "GROUP_INVITE_RESPONSE_REQUEST_FAIL_ALREADY_GROUPED",
		[GROUP_INVITE_RESPONSE_REQUEST_FAIL_GROUP_FULL] = "GROUP_INVITE_RESPONSE_REQUEST_FAIL_GROUP_FULL",
		[GROUP_INVITE_RESPONSE_SELF_INVITE] = "GROUP_INVITE_RESPONSE_SELF_INVITE"}
	d("eventCode: "..tostring(eventCode))
	d("inviterName: "..tostring(inviterName))
	d("response: "..tostring(response))
	d("responsemsg: "..tostring(responsemsg[response]))
	d("inviterDisplayName: "..tostring(inviterDisplayName))
	-- GroupStart.UnitInfo(inviterDisplayName)
	if not GroupStart.doInviteStagger then 
		if response == GROUP_INVITE_RESPONSE_ACCEPTED then
			GroupStart.InviteGroupNextMember()
		else
			zo_callLater(function() GroupStart.InviteGroupNextMember() end, GroupStart.inviteDelay)
		end
	end
	d("--- OnGroupInviteResponse End")
end

function GroupStart.InviteGroupStagger()
	dmsg("InviteGroupStagger")
	user = GetDisplayName()
	local delaymultiplier = 0
	d("IsUnitGrouped: "..tostring(IsUnitGrouped("player")))
	d("IsUnitGroupLeader: "..tostring(IsUnitGroupLeader("player")))
	if IsUnitGrouped("player") and not IsUnitGroupLeader("player") then return end
	local numFriends = GetNumFriends()
	for j = 0, numFriends do
		local invitee, note, playerStatus, secsSinceLogoff = GetFriendInfo(j)
		local inList = GroupStart.IsInList (GroupStart.partyList, invitee)
		local inGroup = IsPlayerInGroup(invitee)
		if inList then
			d("--- Friend : "..tostring(invitee).."  status : "..tostring(playerStatus).."  inGroup : "..tostring(inGroup))
			if playerStatus == PLAYER_STATUS_ONLINE then
				if not inGroup then
					zo_callLater(function() GroupInviteByName(invitee) end, delaymultiplier * GroupStart.inviteDelay)
					delaymultiplier = delaymultiplier + 1
				end
			end
		end
	end
end

function GroupStart.InviteGroupNextMember()
	dmsg("Start InviteGroupNextMember")
	d("IsUnitGrouped: "..tostring(IsUnitGrouped("player")))
	d("IsUnitGroupLeader: "..tostring(IsUnitGroupLeader("player")))
	--d("GetGroupLeaderUnitTag: "..tostring(GetGroupLeaderUnitTag()))
	if IsUnitGrouped("player") and not IsUnitGroupLeader("player") then return end
	-- local countPendingGroupAccept = GetNumFriends()
	local numFriends = GetNumFriends()
	for j = 0, numFriends do
		local invitee, note, playerStatus, secsSinceLogoff = GetFriendInfo(j)
		local inList = GroupStart.IsInList (GroupStart.partyList, invitee)
		local inGroup = IsPlayerInGroup(invitee)
		if inList then
			d("--- Friend : "..tostring(invitee).."  status : "..tostring(playerStatus).."  inGroup : "..tostring(inGroup))
			if playerStatus == PLAYER_STATUS_ONLINE then
				if not inGroup then
					GroupInviteByName(invitee)
					return
				end
			end
		end
	end
end

function GroupStart.InviteGroupByMethod()
	if GroupStart.doInviteStagger then GroupStart.InviteGroupStagger() else GroupStart.InviteGroupNextMember() end
end

function GroupStart.onActivityFinderStatusChange (eventCode, result)
	if GroupStart.doInvite then
		EVENT_MANAGER:UnregisterForEvent(GroupStart.name, EVENT_ACTIVITY_FINDER_STATUS_UPDATE)
		GroupStart.doInvite = false
		if GroupStart.doInviteStagger then 
			zo_callLater(function() GroupStart.InviteGroupStagger() end, GroupStart.inviteDelay)
		else 
			zo_callLater(function() GroupStart.InviteGroupNextMember() end, GroupStart.inviteDelay)
		end
	end
end

function GroupStart.StartNormal(location)
	SetVeteranDifficulty(false)
	dmsg("Set to Normal")
	if Trim(location) == "" then
		GroupStart.InviteGroupByMethod()
	else
		GroupStart.TravelToPlace(location)
	end
end

function GroupStart.StartVeteran(location)
	SetVeteranDifficulty(true)
	dmsg("Set to Veteran")
	if Trim(location) == "" then
		GroupStart.InviteGroupByMethod()
	else
		GroupStart.TravelToPlace(location)
	end
end

function GroupStart.SetDelay(delay)
	GroupStart.inviteDelay = tonumber(delay)
	if not (GroupStart.inviteDelay ~= nil and GroupStart.inviteDelay > 0) then GroupStart.inviteDelay = 1000 end
	d("Delay set to "..tostring(GroupStart.inviteDelay))
end

function GroupStart.SetMethod(method)
	if method == "stagger" then
		GroupStart.doInviteStagger = true
		d("Method set to stagger")
	else
		GroupStart.doInviteStagger = false
		d("Method set to sequential")
	end
end

function GroupStart:Initialize()
    --self.sV = ZO_SavedVars:NewAccountWide("GroupStartSavedVariables", 8, nil, {})
    --zo_callLater(function() self:ExportAll() end,20*1000)
    --EVENT_MANAGER:RegisterForUpdate(self.name, 5*60*1000, function() self:ExportAll() end)
    --EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_ACTIVATED, function() self:ExportAll() end)
    --EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_DEACTIVATED, function() self:ExportAll() end)
	EVENT_MANAGER:RegisterForEvent(GroupStart.name, EVENT_GROUP_INVITE_RECEIVED, GroupStart.OnGroupInviteReceived)
	EVENT_MANAGER:UnregisterForEvent(GroupStart.name, EVENT_ACTIVITY_FINDER_STATUS_UPDATE)
	--EVENT_MANAGER:RegisterForEvent(GroupStart.name, EVENT_ACTIVITY_FINDER_STATUS_UPDATE, GroupStart.onActivityFinderStatusChange)
	SLASH_COMMANDS["/gsn"] = GroupStart.StartNormal
	SLASH_COMMANDS["/gsv"] = GroupStart.StartVeteran
	--SLASH_COMMANDS["/gst"] = function() GroupStart.doInvite = true GroupStart:InviteGroupNextMember() end
	SLASH_COMMANDS["/gstest"] = GroupStart.InviteGroupByMethod
	SLASH_COMMANDS["/gsd"] = GroupStart.SetDelay
	SLASH_COMMANDS["/gsmethod"] = GroupStart.SetMethod
	EVENT_MANAGER:RegisterForEvent(GroupStart.name, EVENT_ACTIVITY_FINDER_STATUS_UPDATE, GroupStart.onActivityFinderStatusChange)
	--EVENT_MANAGER:UnregisterForEvent(GroupStart.name, EVENT_ACTIVITY_FINDER_STATUS_UPDATE)
	--EVENT_MANAGER:RegisterForEvent(GroupStart.name, EVENT_GROUP_INVITE_RESPONSE, GroupStart.OnGroupInviteResponse)
	
	--EVENT_MANAGER:RegisterForEvent(GroupStart.name, EVENT_PLAYER_ACTIVATED, GroupStart.InviteGroupNextMember)
end

-- Then we create an event handler function which will be called when the "addon loaded" event
-- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
function GroupStart.OnAddOnLoaded(event, addonName)
    -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
    if addonName == GroupStart.name then
        GroupStart:Initialize()
    end
end

-- Finally, we'll register our event handler function to be called when the proper event occurs.
EVENT_MANAGER:RegisterForEvent(GroupStart.name, EVENT_ADD_ON_LOADED, GroupStart.OnAddOnLoaded)

