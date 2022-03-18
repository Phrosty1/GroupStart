GroupStart = {}
local ADDON_NAME = "GroupStart"
local lstAlwaysAccept = {"@Samantha.C", "@Tommy.C", "@Jenniami", "@Phrosty1"}
local lstDungeonsByName = {}
local lstDungeonsByNode = {}
local function BuildDestinationList()
   for i = 0, GetNumFastTravelNodes() do
      local isKnown, nodeName, normalizedX, normalizedY, icon, glowIcon, poiType, isShownInCurrentMap, linkedCollectibleIsLocked = GetFastTravelNodeInfo(i)
      if string.find(nodeName, "Dungeon:") or string.find(nodeName, "Trial:") then
         lstDungeonsByName[nodeName] = i
         lstDungeonsByName[string.upper(string.gsub(string.gsub(string.gsub(nodeName, "Dungeon:", ""), "Trial:", ""), " ", ""))] = i
         lstDungeonsByNode[i] = nodeName
      end
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
   lstDungeonsByName["SP2"]   = lstDungeonsByName["Dungeon: Spindleclutch II"]
   lstDungeonsByName["CA2"]   = lstDungeonsByName["Dungeon: City of Ash II"]
   lstDungeonsByName["COA2"]  = lstDungeonsByName["Dungeon: City of Ash II"]
   lstDungeonsByName["CH2"]   = lstDungeonsByName["Dungeon: Crypt of Hearts II"]
   lstDungeonsByName["COH2"]  = lstDungeonsByName["Dungeon: Crypt of Hearts II"]
   lstDungeonsByName["IR"]    = lstDungeonsByName["Dungeon: Icereach"]
   lstDungeonsByName["UG"]    = lstDungeonsByName["Dungeon: Unhallowed Grave"]
   lstDungeonsByName["SG"]    = lstDungeonsByName["Dungeon: Stone Garden"]
   lstDungeonsByName["CT"]    = lstDungeonsByName["Dungeon: Castle Thorn"]
end
local function GetFirstNodeFromList(lstNodes)
   for nodeIndex, _ in pairs(lstNodes) do
      return nodeIndex
   end
end
local function GetRandomNodeFromList(lstNodes)
   local keyset = {}
   for k in pairs(lstNodes) do
      table.insert(keyset, k)
   end
   local cntOptions = #keyset
   if cntOptions > 0 then
      local nodeIndex = keyset[math.random(cntOptions)]
      d("Choosing from:")
      for k, v in ipairs(keyset) do
         d(tostring(k).." - "..tostring(lstDungeonsByNode[v]))
      end
   end
   return nodeIndex
end
local function FindNodesByName(txt)
   txt = string.upper(txt or "")
   local nodeFound = lstDungeonsByName[txt]
   if nodeFound then return {[nodeFound] = nodeFound} end
   txt = string.gsub(txt, " ", "")
   nodeFound = lstDungeonsByName[txt]
   if nodeFound then return {[nodeFound] = nodeFound} end
   txt = string.gsub(txt, "1", "")
   nodeFound = lstDungeonsByName[txt]
   if nodeFound then return {[nodeFound] = nodeFound} end
   local level = 1
   if string.find(txt, "2") or string.find(txt, "II") then
      txt = string.gsub(txt, "2", "")
      txt = string.gsub(txt, "II", "")
      level = 2
   elseif string.find(txt, "1") then
      txt = string.gsub(txt, "1", "")
   end
   local retval = {}
   if level == 2 then
      for nodeName, nodeIndex in pairs(lstDungeonsByName) do
         if string.find(nodeName, "II") and string.find(nodeName, txt) then
            retval[nodeIndex] = nodeIndex
         end
      end
   else
      for nodeName, nodeIndex in pairs(lstDungeonsByName) do
         if not string.find(nodeName, "II") and string.find(nodeName, txt) then
            retval[nodeIndex] = nodeIndex
         end
      end
   end
   return retval
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
   lstPendingInvites = {}
   for _, autoAcceptPartyName in pairs(lstAlwaysAccept) do
      if not IsPlayerInGroup(autoAcceptPartyName) then -- * IsPlayerInGroup(*string* _characterOrDisplayName_) ** _Returns:_ *bool* _inGroup_
         lstPendingInvites[autoAcceptPartyName] = true
      end
   end
   local numFriends = GetNumFriends()
   for j = 0, numFriends do
      local invitee, note, playerStatus, secsSinceLogoff = GetFriendInfo(j)
      if lstPendingInvites[invitee] and not playerStatus == PLAYER_STATUS_ONLINE then lstPendingInvites[invitee] = nil end
   end
end
local function SendInvites()
   local txtRecipient = ""
   for invitee, _ in pairs(lstPendingInvites) do
      if IsPlayerInGroup(invitee) then lstPendingInvites[invitee] = nil else txtRecipient = invitee end
   end
   if lstPendingInvites[txtRecipient] then
      lstPendingInvites[txtRecipient] = nil
      GroupInviteByName(txtRecipient)
      zo_callLater(SendInvites, 1000)
   end
end
local function PlayerHasGroupControl()
   if IsUnitGrouped("player") and not IsUnitGroupLeader("player") then return false else return true end
end
local function OnActivityFinderStatusChange(eventCode, result)
   if doSendInvitesWhenLanded then
      doSendInvitesWhenLanded = false
      if IsUnitGrouped("player") and not IsUnitGroupLeader("player") then return end
      GeneratePendingInvites()
      SendInvites()
   end
end
local function StartNormal(location)
   if PlayerHasGroupControl() then SetVeteranDifficulty(true) end
   local destNodeIndex, destNodeName = GetRandomNodeFromList(FindNodesByName(location))
   local destNodeName = lstDungeonsByNode[destNodeIndex]
   if destNodeIndex then
      d("Traveling to "..destNodeName)
      doSendInvitesWhenLanded = true
      FastTravelToNode(destNodeIndex)
   else
      d("Could not determine destination")
   end
end
local function StartVeteran(location)
   if PlayerHasGroupControl() then SetVeteranDifficulty(true) end
   local destNodeIndex, destNodeName = GetRandomNodeFromList(FindNodesByName(location))
   local destNodeName = lstDungeonsByNode[destNodeIndex]
   if destNodeIndex then
      d("Traveling to "..destNodeName)
      doSendInvitesWhenLanded = true
      FastTravelToNode(destNodeIndex)
   else
      d("Could not determine destination")
   end
end


function GroupStart:Initialize()
   EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_GROUP_INVITE_RECEIVED, OnGroupInviteReceived)
   EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ACTIVITY_FINDER_STATUS_UPDATE, OnActivityFinderStatusChange)
   SLASH_COMMANDS["/gsn"] = StartNormal
   SLASH_COMMANDS["/gsv"] = StartVeteran

end

-- Then we create an event handler function which will be called when the "addon loaded" event
-- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
function GroupStart.OnAddOnLoaded(event, addonName)
    if addonName == ADDON_NAME then GroupStart:Initialize() end
end

-- Finally, we'll register our event handler function to be called when the proper event occurs.
EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, GroupStart.OnAddOnLoaded)

