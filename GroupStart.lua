GroupStart = {}
local ADDON_NAME = "GroupStart"
local verbose = true
local function Log(...)
   if verbose and AnyAltLogger then AnyAltLogger:Log(ADDON_NAME, ...) end
end
local lstAlwaysAccept = {"@Samantha.C", "@Tommy.C", "@Jenniami", "@Phrosty1"}
local doDisbandBeforeInvites = true -- true false
local doSendInvitesWhenLeading = true -- true false
local playerDispName = GetUnitDisplayName("player")
local lstDungeonsByName = {}
local lstDungeonsByNode = {}
local lstBaseGameDungeonNodesByName, lstDLCDungeonNodesByName = {}, {}
local lstTravelSpotsByName, lstTravelSpotsByNode = {}, {}
local function BuildDestinationList()
   for i = 0, GetNumFastTravelNodes() do
      local isKnown, nodeName, normalizedX, normalizedY, icon, glowIcon, poiType, isShownInCurrentMap, linkedCollectibleIsLocked = GetFastTravelNodeInfo(i)
      if string.find(nodeName, "Dungeon:") or string.find(nodeName, "Trial:") then
         lstDungeonsByName[nodeName] = i
         lstDungeonsByName[string.upper(string.gsub(nodeName, " ", ""))] = i
         lstDungeonsByNode[i] = nodeName
      end
      if poiType > 0 and nodeName ~= "" then
         lstTravelSpotsByName[nodeName] = i
         lstTravelSpotsByName[string.upper(string.gsub(nodeName, " ", ""))] = i
         lstTravelSpotsByNode[i] = nodeName
      end
      --Log(i, isKnown, nodeName, normalizedX, normalizedY, icon, glowIcon, poiType, isShownInCurrentMap, linkedCollectibleIsLocked)
   end
   lstDungeonsByName["VM"]    = lstDungeonsByName["Dungeon: Vaults of Madness"]
   lstDungeonsByName["VOM"]   = lstDungeonsByName["Dungeon: Vaults of Madness"]
   lstDungeonsByName["SW"]    = lstDungeonsByName["Dungeon: Selene's Web"]
   lstDungeonsByName["BH"]    = lstDungeonsByName["Dungeon: Blackheart Haven"]
   lstDungeonsByName["BLCR"]  = lstDungeonsByName["Dungeon: Blessed Crucible"]
   lstDungeonsByName["TI"]    = lstDungeonsByName["Dungeon: Tempest Island"]
   lstDungeonsByName["AC"]    = lstDungeonsByName["Dungeon: Arx Corinium"]
   lstDungeonsByName["DK"]    = lstDungeonsByName["Dungeon: Direfrost Keep"]
   lstDungeonsByName["VF"]    = lstDungeonsByName["Dungeon: Volenfell"]
   lstDungeonsByName["ICP"]   = lstDungeonsByName["Dungeon: Imperial City Prison"]
   lstDungeonsByName["WGT"]   = lstDungeonsByName["Dungeon: White-Gold Tower"]
   lstDungeonsByName["RM"]    = lstDungeonsByName["Dungeon: Ruins of Mazzatun"]
   lstDungeonsByName["CS"]    = lstDungeonsByName["Dungeon: Cradle of Shadows"]
   lstDungeonsByName["BF"]    = lstDungeonsByName["Dungeon: Bloodroot Forge"]
   lstDungeonsByName["FH"]    = lstDungeonsByName["Dungeon: Falkreath Hold"]
   lstDungeonsByName["FL"]    = lstDungeonsByName["Dungeon: Fang Lair"]
   lstDungeonsByName["SCP"]   = lstDungeonsByName["Dungeon: Scalecaller Peak"]
   lstDungeonsByName["MS"]    = lstDungeonsByName["Dungeon: March of Sacrifices"]
   lstDungeonsByName["MF"]    = lstDungeonsByName["Dungeon: Moongrave Fane"]
   lstDungeonsByName["MHK"]   = lstDungeonsByName["Dungeon: Moon Hunter Keep"]
   lstDungeonsByName["FV"]    = lstDungeonsByName["Dungeon: Frostvault"]
   lstDungeonsByName["DM"]    = lstDungeonsByName["Dungeon: Depths of Malatar"]
   lstDungeonsByName["LM"]    = lstDungeonsByName["Dungeon: Lair of Maarselok"]
   lstDungeonsByName["BC"]    = lstDungeonsByName["Dungeon: The Banished Cells I"]
   lstDungeonsByName["WS"]    = lstDungeonsByName["Dungeon: Wayrest Sewers I"]
   lstDungeonsByName["DC"]    = lstDungeonsByName["Dungeon: Darkshade Caverns I"]
   lstDungeonsByName["EH"]    = lstDungeonsByName["Dungeon: Elden Hollow I"]
   lstDungeonsByName["FG"]    = lstDungeonsByName["Dungeon: Fungal Grotto I"]
   lstDungeonsByName["SC"]    = lstDungeonsByName["Dungeon: Spindleclutch I"]
   lstDungeonsByName["SP"]    = lstDungeonsByName["Dungeon: Spindleclutch I"]
   lstDungeonsByName["CA"]    = lstDungeonsByName["Dungeon: City of Ash I"]
   lstDungeonsByName["COA"]   = lstDungeonsByName["Dungeon: City of Ash I"]
   lstDungeonsByName["CH"]    = lstDungeonsByName["Dungeon: Crypt of Hearts I"]
   lstDungeonsByName["COH"]   = lstDungeonsByName["Dungeon: Crypt of Hearts I"]
   lstDungeonsByName["BC2"]   = lstDungeonsByName["Dungeon: The Banished Cells II"]
   lstDungeonsByName["WS2"]   = lstDungeonsByName["Dungeon: Wayrest Sewers II"]
   lstDungeonsByName["DC2"]   = lstDungeonsByName["Dungeon: Darkshade Caverns II"]
   lstDungeonsByName["EH2"]   = lstDungeonsByName["Dungeon: Elden Hollow II"]
   lstDungeonsByName["FG2"]   = lstDungeonsByName["Dungeon: Fungal Grotto II"]
   lstDungeonsByName["SC2"]   = lstDungeonsByName["Dungeon: Spindleclutch II"]
   lstDungeonsByName["SP2"]   = lstDungeonsByName["Dungeon: Spindleclutch II"]
   lstDungeonsByName["CA2"]   = lstDungeonsByName["Dungeon: City of Ash II"]
   lstDungeonsByName["COA2"]  = lstDungeonsByName["Dungeon: City of Ash II"]
   lstDungeonsByName["CH2"]   = lstDungeonsByName["Dungeon: Crypt of Hearts II"]
   lstDungeonsByName["COH2"]  = lstDungeonsByName["Dungeon: Crypt of Hearts II"]
   lstDungeonsByName["IR"]    = lstDungeonsByName["Dungeon: Icereach"]
   lstDungeonsByName["UG"]    = lstDungeonsByName["Dungeon: Unhallowed Grave"]
   lstDungeonsByName["SG"]    = lstDungeonsByName["Dungeon: Stone Garden"]
   lstDungeonsByName["CT"]    = lstDungeonsByName["Dungeon: Castle Thorn"]
   local lstBaseGameDungeonNames = {"Dungeon: Vaults of Madness", "Dungeon: Selene's Web", "Dungeon: Blackheart Haven", "Dungeon: Blessed Crucible", "Dungeon: Tempest Island", "Dungeon: Arx Corinium", "Dungeon: Direfrost Keep", "Dungeon: Volenfell", "Dungeon: The Banished Cells I", "Dungeon: Wayrest Sewers I", "Dungeon: Darkshade Caverns I", "Dungeon: Elden Hollow I", "Dungeon: Fungal Grotto I", "Dungeon: Spindleclutch I", "Dungeon: City of Ash I", "Dungeon: Crypt of Hearts I", "Dungeon: The Banished Cells II", "Dungeon: Wayrest Sewers II", "Dungeon: Darkshade Caverns II", "Dungeon: Elden Hollow II", "Dungeon: Fungal Grotto II", "Dungeon: Spindleclutch II", "Dungeon: City of Ash II", "Dungeon: Crypt of Hearts II"}
   for _, dungeonName in pairs(lstBaseGameDungeonNames) do
      local nodeFound = lstDungeonsByName[dungeonName]
      if nodeFound then lstBaseGameDungeonNodesByName[dungeonName] = nodeFound end
   end
   for dungeonName, dungeonNode in pairs(lstDungeonsByName) do
      if string.find(dungeonName, "Dungeon:") and not lstBaseGameDungeonNodesByName[dungeonName] then
         lstDLCDungeonNodesByName[dungeonName] = dungeonNode
      end
   end
end
local function GetFirstNodeFromList(lstNodes)
   for nodeIndex, _ in pairs(lstNodes) do
      return nodeIndex
   end
end
local function GetRandomNodeFromList(lstNodes)
   Log("GetRandomNodeFromList",lstNodes)
   local keyset = {}
   for k in pairs(lstNodes) do
      table.insert(keyset, k)
   end
   local cntOptions = #keyset
   Log("GetRandomNodeFromList","cntOptions",cntOptions,"keyset",keyset)
   local nodeIndex
   if cntOptions > 1 then
      local rnd = math.random(cntOptions)
      nodeIndex = keyset[rnd]
      d("Choosing from:")
      for k, v in ipairs(keyset) do
         d(tostring(k).." - "..tostring(lstDungeonsByNode[v]))
      end
      Log("GetRandomNodeFromList","rnd",rnd,"nodeIndex",nodeIndex)
   elseif cntOptions == 1 then
      nodeIndex = keyset[1]
   end
   return nodeIndex
end
local function FindNodesByName(txt, lstNodesFound)
   Log("FindNodesByName",txt)
   lstNodesFound = lstNodesFound or {}
   local preSep, postSep = txt:match("([^,]*),(.*)")
   Log("FindNodesByName","Sep",preSep,postSep)
   if preSep and postSep then
      txt = preSep
      lstNodesFound = FindNodesByName(postSep, lstNodesFound)
   end
   --
   txt = string.upper(txt or "")
   local nodeFound = lstDungeonsByName[txt]
   if nodeFound then lstNodesFound[nodeFound] = nodeFound return lstNodesFound end
   txt = string.gsub(txt, " ", "")
   nodeFound = lstDungeonsByName[txt]
   if nodeFound then lstNodesFound[nodeFound] = nodeFound return lstNodesFound end
   txt = string.gsub(txt, "1", "")
   nodeFound = lstDungeonsByName[txt]
   if nodeFound then lstNodesFound[nodeFound] = nodeFound return lstNodesFound end
   --
   if txt=="BASE" then --local lstBaseGameDungeonNodesByName, lstDLCDungeonNodesByName = {}, {}
      for dungeonName, nodeFound in pairs(lstBaseGameDungeonNodesByName) do
         lstNodesFound[nodeFound] = nodeFound
      end
      return lstNodesFound
   elseif txt=="DLC" then
      for dungeonName, nodeFound in pairs(lstDLCDungeonNodesByName) do
         lstNodesFound[nodeFound] = nodeFound
      end
      return lstNodesFound
   end
   --
   local level = 1
   if string.find(txt, "2") or string.find(txt, "II") then
      txt = string.gsub(txt, "2", "")
      txt = string.gsub(txt, "II", "")
      level = 2
   elseif string.find(txt, "1") then
      txt = string.gsub(txt, "1", "")
   end
   if level == 2 then
      for nodeName, nodeIndex in pairs(lstDungeonsByName) do
         if string.find(nodeName, "II") and string.find(nodeName, txt) then
            lstNodesFound[nodeIndex] = nodeIndex
         end
      end
   else
      for nodeName, nodeIndex in pairs(lstDungeonsByName) do
         if not string.find(nodeName, "II") and string.find(nodeName, txt) then
            lstNodesFound[nodeIndex] = nodeIndex
         end
      end
   end
   return lstNodesFound
end
local function OnGroupInviteReceived(eventCode, inviteCharacterName, inviterDisplayName)
   for _, autoAcceptPartyName in pairs(lstAlwaysAccept) do
      if autoAcceptPartyName == inviterDisplayName then
         AcceptGroupInvite()
      end
   end
end
local doSendInvitesWhenLanded = false
local lstPendingInvites = {}
local function GeneratePendingInvites()
   -- * JumpToGroupMember(*string* _characterOrDisplayName_)
   Log("GeneratePendingInvites",playerDispName,lstAlwaysAccept)
   lstPendingInvites = {}
   for _, autoAcceptPartyName in pairs(lstAlwaysAccept) do
      if not IsPlayerInGroup(autoAcceptPartyName) then -- * IsPlayerInGroup(*string* _characterOrDisplayName_) ** _Returns:_ *bool* _inGroup_
         lstPendingInvites[autoAcceptPartyName] = true
      end
   end
   lstPendingInvites[playerDispName] = nil
   local numFriends = GetNumFriends()
   for j = 0, numFriends do
      local invitee, note, playerStatus, secsSinceLogoff = GetFriendInfo(j)
      if lstPendingInvites[invitee] and not playerStatus == PLAYER_STATUS_ONLINE then lstPendingInvites[invitee] = nil end
      Log("GeneratePendingInvites","considering_friends_list",invitee, note, playerStatus, secsSinceLogoff, "lstPendingInvites[invitee]",lstPendingInvites[invitee])
   end
end
local function SendInvites()
   Log("SendInvites",lstPendingInvites)
   local txtRecipient = ""
   for invitee, _ in pairs(lstPendingInvites) do
      if IsPlayerInGroup(invitee) then lstPendingInvites[invitee] = nil else txtRecipient = invitee end
   end
   if lstPendingInvites[txtRecipient] then
      lstPendingInvites[txtRecipient] = nil
      Log("SendInvites","GroupInviteByName",txtRecipient)
      GroupInviteByName(txtRecipient)
      zo_callLater(SendInvites, 1000)
   end
end
function GroupStart.GenerateAndSendInvites()
   GeneratePendingInvites()
   SendInvites()
end
local function PlayerHasGroupControl()
   if IsUnitGrouped("player") and not IsUnitGroupLeader("player") then return false else return true end
end
-- local function OnLeavingZone(eventCode, result)
--    Log("OnLeavingZone",result)
--    if doSendInvitesWhenLanded then
--       doSendInvitesWhenLanded = false
--       if PlayerHasGroupControl() then
--          GeneratePendingInvites()
--          SendInvites()
--       end
--    end
-- end
local function StartSendingActualInvites()
   Log("StartSendingActualInvites")
   if doSendInvitesWhenLanded then
      doSendInvitesWhenLanded = false
      if PlayerHasGroupControl() then
         GeneratePendingInvites()
         SendInvites()
      end
   end
end
local function FindAndTravel(location)
   Log("FindAndTravel",location)
   local destNodeIndex, destNodeName = GetRandomNodeFromList(FindNodesByName(location))
   local destNodeName = lstDungeonsByNode[destNodeIndex]
   if destNodeIndex then
      d("Traveling to "..destNodeName)
      if doSendInvitesWhenLeading then doSendInvitesWhenLanded = true end
      if doDisbandBeforeInvites and IsUnitGrouped("player") and PlayerHasGroupControl() then
         GroupDisband()
         zo_callLater(function() FastTravelToNode(destNodeIndex) end, 500)
      else
         FastTravelToNode(destNodeIndex)
      end
   else
      Log("Could not determine destination")
      d("Could not determine destination")
   end
end
local function StartNormal(location)
   Log("StartNormal",location)
   if PlayerHasGroupControl() then SetVeteranDifficulty(false) end
   FindAndTravel(location)
end
local function StartVeteran(location)
   Log("StartVeteran",location)
   if PlayerHasGroupControl() then SetVeteranDifficulty(true) end
   FindAndTravel(location)
end
local function FindAnyNodesByName(txt, lstNodesFound)
   Log("FindAnyNodesByName",txt)
   lstNodesFound = lstNodesFound or {}
   local preSep, postSep = txt:match("([^,]*),(.*)")
   Log("FindAnyNodesByName","Sep",preSep,postSep)
   if preSep and postSep then
      txt = preSep
      lstNodesFound = FindAnyNodesByName(postSep, lstNodesFound)
   end

   txt = string.upper(txt or "")
   local nodeFound = lstTravelSpotsByName[txt]
   if nodeFound then lstNodesFound[nodeFound] = nodeFound return lstNodesFound end
   txt = string.gsub(txt, " ", "")
   nodeFound = lstTravelSpotsByName[txt]
   if nodeFound then lstNodesFound[nodeFound] = nodeFound return lstNodesFound end
   txt = string.gsub(txt, "1", "")
   nodeFound = lstTravelSpotsByName[txt]
   if nodeFound then lstNodesFound[nodeFound] = nodeFound return lstNodesFound end
   for nodeName, nodeIndex in pairs(lstTravelSpotsByName) do
      if not string.find(nodeName, "II") and string.find(nodeName, txt) then
         lstNodesFound[nodeIndex] = nodeIndex
      end
   end
   return lstNodesFound
end
local function FindAnyAndTravel(location)
   Log("FindAnyAndTravel",location)
   local destNodeIndex, destNodeName = GetRandomNodeFromList(FindAnyNodesByName(location))
   local destNodeName = lstTravelSpotsByNode[destNodeIndex]
   if destNodeIndex then
      d("Traveling to "..destNodeName)
      --if doSendInvitesWhenLeading then doSendInvitesWhenLanded = true end
      if doDisbandBeforeInvites and IsUnitGrouped("player") and PlayerHasGroupControl() then
         GroupDisband()
         zo_callLater(function() FastTravelToNode(destNodeIndex) end, 500)
      else
         FastTravelToNode(destNodeIndex)
      end
   else
      Log("Could not determine destination")
      d("Could not determine destination")
   end
end
local function StartAny(location)
   Log("StartAny",location)
   FindAnyAndTravel(location)
end

function GroupStart:Initialize()
   BuildDestinationList()
   EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_GROUP_INVITE_RECEIVED, OnGroupInviteReceived)
   EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ACTIVITY_FINDER_STATUS_UPDATE, function(eventCode, status)
         if status == ACTIVITY_FINDER_STATUS_READY_CHECK and HasLFGReadyCheckNotification() then
            AcceptLFGReadyCheckNotification()
         end
      end)
   --EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_PREPARE_FOR_JUMP, OnLeavingZone) -- Last event fired when leaving zone... but still not late enough.
   --EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_PREPARE_FOR_JUMP, function() zo_callLater(OnLeavingZone, 3000) end) -- Last event fired when leaving zone
   EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ZONE_CHANGED, StartSendingActualInvites)
   EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_PLAYER_ACTIVATED, StartSendingActualInvites)

   SLASH_COMMANDS["/gsn"] = StartNormal
   SLASH_COMMANDS["/gsv"] = StartVeteran
   SLASH_COMMANDS["/gsa"] = StartAny
   SLASH_COMMANDS["/gstoggledisband"] = function() if doDisbandBeforeInvites then doDisbandBeforeInvites = false else doDisbandBeforeInvites = true end d("DisbandBeforeInvites set to:"..tostring(doDisbandBeforeInvites)) end
   SLASH_COMMANDS["/gstoggleinvites"] = function() if doSendInvitesWhenLeading then doSendInvitesWhenLeading = false else doSendInvitesWhenLeading = true end d("SendInvitesWhenLeading set to:"..tostring(doSendInvitesWhenLeading)) end
end

-- Then we create an event handler function which will be called when the "addon loaded" event
-- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
function GroupStart.OnAddOnLoaded(event, addonName)
    if addonName == ADDON_NAME then GroupStart:Initialize() end
end

-- Finally, we'll register our event handler function to be called when the proper event occurs.
EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, GroupStart.OnAddOnLoaded)
