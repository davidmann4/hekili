-- Events.lua
-- June 2014

local addon, ns = ...
local Hekili = _G[ addon ]

local class = Hekili.Class
local state = Hekili.State
local TTD = ns.TTD

local formatKey = ns.formatKey
local FindUnitBuffByID, FindUnitDebuffByID = ns.FindUnitBuffByID, ns.FindUnitDebuffByID
local getSpecializationInfo = ns.getSpecializationInfo
local getSpecializationKey = ns.getSpecializationKey
local GroupMembers = ns.GroupMembers

local abs = math.abs
local lower, match, upper = string.lower, string.match, string.upper
local string_format = string.format
local insert, remove, sort, unpack, wipe = table.insert, table.remove, table.sort, table.unpack, table.wipe

local GetItemInfo = ns.CachedGetItemInfo
local RC = LibStub( "LibRangeCheck-2.0" )


-- Abandoning AceEvent in favor of darkend's solution from:
-- http://andydote.co.uk/2014/11/23/good-design-in-warcraft-addons.html
-- This should be a bit friendlier for our modules.

local events = CreateFrame( "Frame" )
Hekili:ProfileFrame( "GeneralEvents", events )

local handlers = {}
local unitEvents = CreateFrame( "Frame" )
Hekili:ProfileFrame( "UnitEvents", unitEvents )

local unitHandlers = {}
local itemCallbacks = {}
local activeDisplays = {}


function Hekili:GetActiveDisplays()
    return activeDisplays
end


local handlerCount = {}
Hekili.ECount = handlerCount

function ns.StartEventHandler()
    events:SetScript( "OnEvent", function( self, event, ... )
        local eventHandlers = handlers[ event ]

        if not eventHandlers then return end

        for i, handler in pairs( eventHandlers ) do
            handler( event, ... )
            handlerCount[ event .. "_" .. i ] = ( handlerCount[ event .. "_" .. i ] or 0 ) + 1
        end
    end )

    unitEvents:SetScript( "OnEvent", function( self, event, ... )
        local eventHandlers = unitHandlers[ event ]

        if not eventHandlers then return end

        for i, handler in pairs( eventHandlers ) do
            handler( event, ... )
            handlerCount[ event .. "_U" .. i ] = ( handlerCount[ event .. "_U" .. i ] or 0 ) + 1
        end
    end )

    events:SetScript( "OnUpdate", function( self, elapsed )
        Hekili.freshFrame = true
    end )

    Hekili:RunItemCallbacks()
end


function ns.StopEventHandler()
    events:SetScript( "OnEvent", nil )
    unitEvents:SetScript( "OnEvent", nil )

    events:SetScript( "OnUpdate", nil )
end


ns.RegisterEvent = function( event, handler )

    handlers[ event ] = handlers[ event ] or {}
    insert( handlers[ event ], handler )

    events:RegisterEvent( event )

    Hekili:ProfileCPU( event .. "_" .. #handlers[event], handler )

end
local RegisterEvent = ns.RegisterEvent


ns.UnregisterEvent = function( event, handler )
    local hands = handlers[ event ]

    if not hands then return end

    for i = #hands, 1, -1 do
        if hands[i] == handler then
            remove( hands, i )
        end
    end

    if #hands == 0 then events:UnregisterEvent( event ) end
end
local UnregisterEvent = ns.UnregisterEvent


-- For our purposes, all UnitEvents are player/target oriented.
ns.RegisterUnitEvent = function( event, handler )

    unitHandlers[ event ] = unitHandlers[ event ] or {}
    insert( unitHandlers[ event ], handler )

    unitEvents:RegisterUnitEvent( event, 'player', 'target' )

    Hekili:ProfileCPU( event .. "_U" .. #unitHandlers[event], handler )

end
local RegisterUnitEvent = ns.RegisterUnitEvent


function ns.UnregisterUnitEvent( event, handler )
    local hands = unitHandlers[ event ]

    if not hands then return end

    for i = #hands, 1, -1 do
        if hands[i] == handler then
            remove( hands, i )
        end
    end
end


ns.FeignEvent = function( event, ... )
    local eventHandlers = handlers[ event ]

    if not eventHandlers then return end

    for i, handler in pairs( eventHandlers ) do
        handler( event, ... )
    end
end


do
    local updatedEquippedItem = false

    local function CheckForEquipmentUpdates()
        if updatedEquippedItem then
            updatedEquippedItem = false
            ns.updateGear()
        end
    end

    RegisterEvent( "GET_ITEM_INFO_RECEIVED", function( event, itemID, success )
        local callbacks = itemCallbacks[ itemID ]

        if callbacks then
            for i, func in ipairs( callbacks ) do
                func( success )
                callbacks[ i ] = nil
            end

            if state.set_bonus[ itemID ] > 0 then
                updatedEquippedItem = true
                C_Timer.After( 0.5, CheckForEquipmentUpdates )
            end

            itemCallbacks[ itemID ] = nil
        end
    end )
end

function Hekili:ContinueOnItemLoad( itemID, func )
    local callbacks = itemCallbacks[ itemID ] or {}
    insert( callbacks, func )
    itemCallbacks[ itemID ] = callbacks

    C_Item.RequestLoadItemDataByID( itemID )
end

function Hekili:RunItemCallbacks()
    for item, callbacks in pairs( itemCallbacks ) do
        for i = #callbacks, 1, -1 do
            if callbacks[ i ]( true ) then remove( callbacks, i ) end
        end

        if #callbacks == 0 then
            itemCallbacks[ item ] = nil
        end
    end
end


RegisterEvent( "DISPLAY_SIZE_CHANGED", function () Hekili:BuildUI() end )


do    
    local itemAuditComplete = false

    local auditItemNames = function ()
        local failure = false

        for key, ability in pairs( class.abilities ) do
            if ability.recheck_name then
                local name, link = GetItemInfo( ability.item )

                if name then
                    ability.name = name
                    ability.texture = nil
                    ability.link = link
                    ability.elem.name = name
                    ability.elem.texture = select( 10, GetItemInfo( ability.item ) )

                    class.abilities[ name ] = ability
                    ability.recheck_name = nil
                else
                    failure = true
                end
            end
        end

        if failure then
            C_Timer.After( 1, ns.auditItemNames )
        else
            ns.ReadKeybindings()
            ns.updateGear()
            itemAuditComplete = true
        end
    end
end


local OnFirstEntrance
OnFirstEntrance = function ()
    Hekili.PLAYER_ENTERING_WORLD = true
    Hekili:SpecializationChanged()
    Hekili:RestoreDefaults()

    ns.checkImports()
    ns.updateGear()

    if state.combat == 0 and InCombatLockdown() then
        state.combat = GetTime() - 0.01
        Hekili:UpdateDisplayVisibility()
    end

    Hekili:BuildUI()
    UnregisterEvent( "PLAYER_ENTERING_WORLD", OnFirstEntrance )
end
RegisterEvent( "PLAYER_ENTERING_WORLD", OnFirstEntrance )


do
    local pendingChange = false

    local updateSpells
    
    updateSpells = function()
        if InCombatLockdown() then
            C_Timer.After( 10, updateSpells )
            return
        end

        if pendingChange then
            for k, v in pairs( class.abilities ) do
                if v.autoTexture then
                    v.texture = GetSpellTexture( v.id )
                end
            end
            pendingChange = false
        end
    end

    RegisterEvent( "SPELLS_CHANGED", function ()
        pendingChange = true
        updateSpells()
    end )
end



-- ACTIVE_TALENT_GROUP_CHANGED fires 2x on talent swap.  Uggh, why?
do
    local lastChange = 0

    RegisterEvent( "ACTIVE_TALENT_GROUP_CHANGED", function ( event, from, to )
        local now = GetTime()
        if now - lastChange > 4 then
            Hekili:SpecializationChanged()
            Hekili:ForceUpdate( event )
            lastChange = now
        end
    end )
end


-- Hide when going into the barbershop.
RegisterEvent( "BARBER_SHOP_OPEN", function ()
    Hekili.Barber = true
end )

RegisterEvent( "BARBER_SHOP_CLOSE", function ()
    Hekili.Barber = false
end )


-- Update visibility when getting on/off a taxi.
RegisterEvent( "PLAYER_CONTROL_LOST", function ()
    Hekili:After( 0.1, Hekili.UpdateDisplayVisibility, Hekili )
end )

RegisterEvent( "PLAYER_CONTROL_GAINED", function ()
    Hekili:After( 0.1, Hekili.UpdateDisplayVisibility, Hekili )
end )


function ns.updateTalents()

    for k, _ in pairs( state.talent ) do
        state.talent[ k ].enabled = false
    end

    -- local specGroup = GetSpecialization()

    for k, v in pairs( class.talents ) do
        local _, name, _, enabled, _, sID, _, _, _, _, known = GetTalentInfoByID( v, 1 )

        if not name then
            -- We probably used a spellID.
            enabled = IsPlayerSpell( v )
        end

        enabled = enabled or known

        if rawget( state.talent, k ) then
            state.talent[ k ].enabled = enabled
        else
            state.talent[ k ] = { enabled = enabled }
        end
    end

    for k, _ in pairs( state.pvptalent ) do
        state.pvptalent[ k ]._enabled = false
    end

    for k, v in pairs( class.pvptalents ) do
        local _, name, _, enabled, _, sID, _, _, _, known = GetPvpTalentInfoByID( v, 1 )

        if not name then
            enabled = IsPlayerSpell( v )
        end

        enabled = enabled or known

        if rawget( state.pvptalent, k ) then
            state.pvptalent[ k ]._enabled = enabled
        else
            state.pvptalent[ k ] = {
                _enabled = enabled
            }
        end
    end

end


-- TBD:  Consider making `boss' a check to see whether the current unit is a boss# unit instead.
RegisterEvent( "ENCOUNTER_START", function ( _, id, name, difficulty )
    state.encounterID = id
    state.encounterName = name
    state.encounterDifficulty = difficulty
end )

RegisterEvent( "ENCOUNTER_END", function ()
    state.encounterID = 0
    state.encounterName = "None"
    state.encounterDifficulty = 0
end )


do
    local loc = ItemLocation.CreateEmpty()

    local GetAllTierInfoByItemID = C_AzeriteEmpoweredItem.GetAllTierInfoByItemID
    local GetAllTierInfo = C_AzeriteEmpoweredItem.GetAllTierInfo
    local GetPowerInfo = C_AzeriteEmpoweredItem.GetPowerInfo
    local IsAzeriteEmpoweredItemByID = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID
    local IsPowerSelected = C_AzeriteEmpoweredItem.IsPowerSelected

    local MAX_INV_SLOTS = 19

    function ns.updatePowers()
        local p = state.azerite

        for k, v in pairs( p ) do
            v.rank = 0
        end

        if next( class.powers ) == nil then
            C_Timer.After( 3, ns.updatePowers )
            return
        end

        for slot = 1, MAX_INV_SLOTS do
            local id = GetInventoryItemID( "player", slot )

            if id and IsAzeriteEmpoweredItemByID( id ) then
                loc:SetEquipmentSlot( slot )
                local tiers = GetAllTierInfo( loc )

                for tier, tierInfo in ipairs( tiers ) do
                    for _, power in ipairs( tierInfo.azeritePowerIDs ) do
                        local pInfo = GetPowerInfo( power )

                        if IsPowerSelected( loc, power ) then
                            local name = class.powers[ pInfo.spellID ]
                            if not name then
                                Hekili:Error( "Missing Azerite Power info for #" .. pInfo.spellID .. ": " .. GetSpellInfo( pInfo.spellID ) .. "." )
                            else
                                p[ name ] = rawget( p, name ) or { rank = 0 }
                                p[ name ].rank = p[ name ].rank + 1
                            end
                        end
                    end
                end
            end
        end

        loc:Clear()
    end

    Hekili:ProfileCPU( "updatePowers", ns.updatePowers )


    -- Essences
    local AE = C_AzeriteEssence
    local GetMilestoneEssence, GetEssenceInfo = AE.GetMilestoneEssence, AE.GetEssenceInfo
    local milestones = { 115, 116, 117, 119 }

    local essenceKeys = {
        [2]  = "azeroths_undying_gift",
        [3]  = "sphere_of_suppression",
        [4]  = "worldvein_resonance",
        [5]  = "essence_of_the_focusing_iris",
        [6]  = "purification_protocol",
        [7]  = "anima_of_life_and_death",
        [12] = "the_crucible_of_flame",
        [13] = "nullification_dynamo",
        [14] = "condensed_lifeforce",
        [15] = "ripple_in_space",
        [16] = "unwavering_ward",
        [17] = "everrising_tide",
        [18] = "artifice_of_time",
        [19] = "well_of_existence",
        [20] = "lifebinders_invocation",
        [21] = "vitality_conduit",
        [22] = "vision_of_perfection",
        [23] = "blood_of_the_enemy",
        [24] = "spirit_of_preservation",
        [25] = "aegis_of_the_deep",
        [27] = "memory_of_lucid_dreams",
        [28] = "the_unbound_force",
        [32] = "conflict_and_strife",
        [33] = "touch_of_the_everlasting",
        [34] = "strength_of_the_warden",
        [35] = "breath_of_the_dying",
        [36] = "spark_of_inspiration",
        [37] = "the_formless_void"
    }

    local essenceMajors = {
        -- everrising_tide = "",
        -- lifebinders_invocation = "",
        -- touch_of_the_everlasting = "",
        -- vision_of_perfection = "",
        -- vitality_conduit = "",
        -- well_of_existence = "",
        -- conflict_and_strife = "",
        aegis_of_the_deep = "aegis_of_the_deep",
        anima_of_life_and_death = "anima_of_death",
        artifice_of_time = "standstill",
        azeroths_undying_gift = "azeroths_undying_gift",
        blood_of_the_enemy = "blood_of_the_enemy",
        breath_of_the_dying = "reaping_flames",
        condensed_lifeforce = "guardian_of_azeroth",
        essence_of_the_focusing_iris = "focused_azerite_beam",
        memory_of_lucid_dreams = "memory_of_lucid_dreams",
        nullification_dynamo = "empowered_null_barrier",
        purification_protocol = "purifying_blast",
        ripple_in_space = "ripple_in_space",
        spark_of_inspiration = "moment_of_glory",
        sphere_of_suppression = "suppressing_pulse",
        spirit_of_preservation = "spirit_of_preservation",
        strength_of_the_warden = "vigilant_protector",
        the_crucible_of_flame = "concentrated_flame",
        the_formless_void = "replica_of_knowledge",
        the_unbound_force = "the_unbound_force",
        unwavering_ward = "guardian_shell",
        worldvein_resonance = "worldvein_resonance",
    }

    for _, key in pairs( essenceKeys ) do
        state.essence[ key ] = { rank = 0, major = false }
    end


    function ns.updateEssences()
        local e = state.essence

        for k, v in pairs( e ) do
            v.rank = 0
        end

        class.active_essence = nil

        if state.equipped[ 158075 ] then
            for i, ms in ipairs( milestones ) do
                local essence = GetMilestoneEssence( ms )

                if essence then
                    local info = GetEssenceInfo( essence )

                    if info then
                        local key = essenceKeys[ info.ID ]
                        
                        e[ key ].rank = info.rank
                        e[ key ].minor = true
                        
                        if i == 1 then                            
                            e[ key ].major = true
                            class.active_essence = essenceMajors[ key ]
                        end
                    end
                end
            end
        end
    end

    ns.updateEssences()
end


do
    local gearInitialized = false

    function Hekili:UpdateUseItems()
        local itemList = class.itemPack.lists.items
        wipe( itemList )

        if #state.items > 0 then
            for i, item in ipairs( state.items ) do
                if not self:IsItemScripted( item ) then
                    insert( itemList, {
                        action = item,
                        enabled = true,
                        criteria = "( ! settings.boss || boss ) & " ..
                            "( settings.targetMin = 0 || active_enemies >= settings.targetMin ) & " ..
                            "( settings.targetMax = 0 || active_enemies <= settings.targetMax )"
                    } )
                end
            end
        end
                
        class.essence_unscripted = ( class.active_essence and not self:IsEssenceScripted( class.active_essence ) ) or false

        self:LoadItemScripts()
    end


--[[ Corruption Effects:
    bonus_id={ 6537 }, stats={ 100% Cor [25.0000] }, effects={ Twilight Devastation (id=318276, index=2, type=equip) }
    bonus_id={ 6538 }, stats={ 100% Cor [50.0000] }, effects={ Twilight Devastation (id=318477, index=2, type=equip) }
    bonus_id={ 6539 }, stats={ 100% Cor [75.0000] }, effects={ Twilight Devastation (id=318478, index=2, type=equip) }
    bonus_id={ 6540 }, stats={ 100% Cor [15.0000] }, effects={ Void Ritual (id=318286, index=2, type=equip) }
    bonus_id={ 6541 }, stats={ 100% Cor [35.0000] }, effects={ Void Ritual (id=318479, index=2, type=equip) }
    bonus_id={ 6542 }, stats={ 100% Cor [66.0000] }, effects={ Void Ritual (id=318480, index=2, type=equip) }
    bonus_id={ 6543 }, stats={ 100% Cor [10.0000] }, effects={ Twisted Appendage (id=318481, index=2, type=equip) }
    bonus_id={ 6544 }, stats={ 100% Cor [35.0000] }, effects={ Twisted Appendage (id=318482, index=2, type=equip) }
    bonus_id={ 6545 }, stats={ 100% Cor [66.0000] }, effects={ Twisted Appendage (id=318483, index=2, type=equip) }
    bonus_id={ 6546 }, stats={ 100% Cor [15.0000] }, effects={ Glimpse of Clarity (id=318239, index=2, type=equip) }
    bonus_id={ 6547 }, stats={ 100% Cor [12.0000] }, effects={ Ineffable Truth (id=318303, index=2, type=equip) }
    bonus_id={ 6548 }, stats={ 100% Cor [30.0000] }, effects={ Ineffable Truth (id=318484, index=2, type=equip) }
    bonus_id={ 6549 }, stats={ 100% Cor [25.0000] }, effects={ Echoing Void (id=318280, index=2, type=equip) }
    bonus_id={ 6550 }, stats={ 100% Cor [35.0000] }, effects={ Echoing Void (id=318485, index=2, type=equip) }
    bonus_id={ 6551 }, stats={ 100% Cor [60.0000] }, effects={ Echoing Void (id=318486, index=2, type=equip) }
    bonus_id={ 6552 }, stats={ 100% Cor [20.0000] }, effects={ Infinite Stars (id=318274, index=2, type=equip) }
    bonus_id={ 6553 }, stats={ 100% Cor [50.0000] }, effects={ Infinite Stars (id=318487, index=2, type=equip) }
    bonus_id={ 6554 }, stats={ 100% Cor [75.0000] }, effects={ Infinite Stars (id=318488, index=2, type=equip) }
    bonus_id={ 6555 }, stats={ 100% Cor [15.0000] }, effects={ Racing Pulse (id=318266, index=2, type=equip) }
    bonus_id={ 6556 }, stats={ 100% Cor [15.0000] }, effects={ Deadly Momentum (id=318268, index=2, type=equip) }
    bonus_id={ 6557 }, stats={ 100% Cor [15.0000] }, effects={ Honed Mind (id=318269, index=2, type=equip) }
    bonus_id={ 6558 }, stats={ 100% Cor [15.0000] }, effects={ Surging Vitality (id=318270, index=2, type=equip) }
    bonus_id={ 6559 }, stats={ 100% Cor [20.0000] }, effects={ Racing Pulse (id=318492, index=2, type=equip) }
    bonus_id={ 6560 }, stats={ 100% Cor [35.0000] }, effects={ Racing Pulse (id=318496, index=2, type=equip) }
    bonus_id={ 6561 }, stats={ 100% Cor [20.0000] }, effects={ Deadly Momentum (id=318493, index=2, type=equip) }
    bonus_id={ 6562 }, stats={ 100% Cor [35.0000] }, effects={ Deadly Momentum (id=318497, index=2, type=equip) }
    bonus_id={ 6563 }, stats={ 100% Cor [20.0000] }, effects={ Honed Mind (id=318494, index=2, type=equip) }
    bonus_id={ 6564 }, stats={ 100% Cor [35.0000] }, effects={ Honed Mind (id=318498, index=2, type=equip) }
    bonus_id={ 6565 }, stats={ 100% Cor [20.0000] }, effects={ Surging Vitality (id=318495, index=2, type=equip) }
    bonus_id={ 6566 }, stats={ 100% Cor [35.0000] }, effects={ Surging Vitality (id=318499, index=2, type=equip) }
    bonus_id={ 6567 }, stats={ 100% Cor [35.0000] }, effects={ Devour Vitality (id=318294, index=2, type=equip) }
    bonus_id={ 6568 }, stats={ 100% Cor [25.0000] }, effects={ Whispered Truths (id=316780, index=2, type=equip) }
    bonus_id={ 6569 }, stats={ 100% Cor [25.0000] }, effects={ Lash of the Void (id=317290, index=2, type=equip) }
    bonus_id={ 6570 }, stats={ 100% Cor [20.0000] }, effects={ Flash of Insight (id=318299, index=2, type=equip) }
    bonus_id={ 6571 }, stats={ 100% Cor [30.0000] }, effects={ Searing Flames (id=318293, index=2, type=equip) }
    bonus_id={ 6572 }, stats={ 100% Cor [50.0000] }, effects={ Obsidian Skin (id=316651, index=2, type=equip) }
    bonus_id={ 6573 }, stats={ 100% Cor [15.0000] }, effects={ Gushing Wound (id=318272, index=2, type=equip) } ]]

    local shadowlegendaries = {
        -- Mage/Arcane
        [6831] = { "expanded_potential", 1, 62 }, -- 327489
        [6832] = { "disciplinary_command", 1, 62 }, -- 327365
        [6834] = { "temporal_warp", 1, 62 }, -- 327351
        [6926] = { "arcane_infinity", 1, 62 }, -- 332769
        [6927] = { "arcane_bombardment", 1, 62 }, -- 332892
        [6928] = { "siphon_storm", 1, 62 }, -- 332928
        [6936] = { "triune_ward", 1, 62 }, -- 333373
        [6937] = { "grisly_icicle", 1, 62 }, -- 333393
        [7100] = { "echo_of_eonar", 1, 62 }, -- 338477
        [7101] = { "judgment_of_the_arbiter", 1, 62 }, -- 339344
        [7102] = { "norgannons_sagacity", 1, 62 }, -- 339340
        [7103] = { "sephuzs_proclamation", 1, 62 }, -- 339348
        [7104] = { "stable_phantasma_lure", 1, 62 }, -- 339351
        [7105] = { "third_eye_of_the_jailer", 1, 62 }, -- 339058
        [7106] = { "vitality_sacrifice", 1, 62 }, -- 338743
        [7159] = { "maw_rattle", 1, 62 }, -- 340197

        -- Mage/Fire
        [6931] = { "fevered_incantation", 1, 63 }, -- 333030
        [6932] = { "firestorm", 1, 63 }, -- 333097
        [6933] = { "molten_skyfall", 1, 63 }, -- 333167
        [6934] = { "sun_kings_blessing", 1, 63 }, -- 333313

        -- Mage/Frost
        [6823] = { "slick_ice", 1, 64 }, -- 327508
        [6828] = { "cold_front", 1, 64 }, -- 327284
        [6829] = { "freezing_winds", 1, 64 }, -- 327364
        [6830] = { "glacial_fragments", 1, 64 }, -- 327492

        -- Paladin/Holy
        [7053] = { "uthers_guard", 1, 65 }, -- 337600
        [7054] = { "liadrins_fury_reborn", 1, 65 }, -- 337638
        [7055] = { "of_dusk_and_dawn", 1, 65 }, -- 337746
        [7056] = { "the_magistrates_judgment", 1, 65 }, -- 337681
        [7057] = { "shadowbreaker_dawn_of_the_sun", 1, 65 }, -- 337812
        [7058] = { "inflorescence_of_the_sunwell", 1, 65 }, -- 337777
        [7059] = { "shock_barrier", 1, 65 }, -- 337825
        [7128] = { "maraads_dying_breath", 1, 65 }, -- 234848

        -- Paladin/Protection
        [7060] = { "holy_avengers_engraved_sigil", 1, 66 }, -- 337831
        [7061] = { "the_ardent_protectors_sanctum", 1, 66 }, -- 337838
        [7062] = { "bulwark_of_righteous_fury", 1, 66 }, -- 337847
        [7063] = { "reign_of_endless_kings", 1, 66 }, -- 337850

        -- Paladin/Retribution
        [7064] = { "final_verdict", 1, 70 }, -- 337247
        [7065] = { "badge_of_the_mad_paragon", 1, 70 }, -- 337594
        [7066] = { "relentless_inquisitor", 1, 70 }, -- 337297
        [7067] = { "tempest_of_the_lightbringer", 1, 70 }, -- 337257

        -- Warrior/Arms
        [6960] = { "battlelord", 1, 71 }, -- 335274
        [6961] = { "exploiter", 1, 71 }, -- 335451
        [6962] = { "enduring_blow", 1, 71 }, -- 335458
        [6970] = { "unhinged", 1, 71 }, -- 335282

        -- Warrior/Fury
        [6955] = { "leaper", 1, 72 }, -- 335214
        [6958] = { "misshapen_mirror", 1, 72 }, -- 335253
        [6959] = { "signet_of_tormented_kings", 1, 72 }, -- 335266
        [6963] = { "cadence_of_fujieda", 1, 72 }, -- 335555
        [6964] = { "deathmaker", 1, 72 }, -- 335567
        [6965] = { "reckless_defense", 1, 72 }, -- 335582
        [6966] = { "will_of_the_berserker", 1, 72 }, -- 335594
        [6971] = { "seismic_reverberation", 1, 72 }, -- 335758

        -- Warrior/Protection
        [6956] = { "thunderlord", 1, 73 }, -- 335229
        [6957] = { "the_wall", 1, 73 }, -- 335239
        [6967] = { "unbreakable_will", 1, 73 }, -- 335629
        [6969] = { "reprisal", 1, 73 }, -- 335718

        -- Druid/Balance
        [7084] = { "oath_of_the_elder_druid", 1, 102 }, -- 338608
        [7085] = { "circle_of_life_and_death", 1, 102 }, -- 338657
        [7086] = { "draught_of_deep_focus", 1, 102 }, -- 338658
        [7087] = { "oneths_clear_vision", 1, 102 }, -- 338661
        [7088] = { "primordial_arcanic_pulsar", 1, 102 }, -- 338668
        [7107] = { "balance_of_all_things", 1, 102 }, -- 339942
        [7108] = { "timeworn_dreambinder", 1, 102 }, -- 339949
        [7110] = { "lycaras_fleeting_glimpse", 1, 102 }, -- 340059

        -- Druid/Feral
        [7089] = { "cateye_curio", 1, 103 }, -- 339144
        [7090] = { "eye_of_fearful_symmetry", 1, 103 }, -- 339141
        [7091] = { "apex_predators_craving", 1, 103 }, -- 339139
        [7109] = { "frenzyband", 1, 103 }, -- 340053

        -- Druid/Guardian
        [7092] = { "luffainfused_embrace", 1, 104 }, -- 339060
        [7093] = { "the_natural_orders_will", 1, 104 }, -- 339063
        [7094] = { "ursocs_lingering_spirit", 1, 104 }, -- 339056
        [7095] = { "legacy_of_the_sleeper", 1, 104 }, -- 339062

        -- Druid/Restoration
        [7096] = { "memory_of_the_mother_tree", 1, 105 }, -- 339064
        [7097] = { "the_dark_titans_lesson", 1, 105 }, -- 338831
        [7098] = { "verdant_infusion", 1, 105 }, -- 338829
        [7099] = { "vision_of_unending_growth", 1, 105 }, -- 338832

        -- Death Knight/Blood
        [6940] = { "bryndaors_might", 1, 250 }, -- 334501
        [6941] = { "crimson_rune_weapon", 1, 250 }, -- 334525
        [6942] = { "vampiric_aura", 1, 250 }, -- 334547
        [6943] = { "gorefiends_domination", 1, 250 }, -- 334580
        [6947] = { "deaths_embrace", 1, 250 }, -- 334728
        [6948] = { "grip_of_the_everlasting", 1, 250 }, -- 334724
        [6953] = { "superstrain", 1, 250 }, -- 334974
        [6954] = { "phearomones", 1, 250 }, -- 335177

        -- Death Knight/Frost
        [6944] = { "koltiras_favor", 1, 251 }, -- 334583
        [6945] = { "biting_cold", 1, 251 }, -- 334678
        [6946] = { "absolute_zero", 1, 251 }, -- 334692
        [7160] = { "rage_of_the_frozen_champion", 1, 251 }, -- 341724

        -- Death Knight/Unholy
        [6949] = { "reanimated_shambler", 1, 252 }, -- 334836
        [6950] = { "frenzied_monstrosity", 1, 252 }, -- 334888
        [6951] = { "deaths_certainty", 1, 252 }, -- 334898
        [6952] = { "deadliest_coil", 1, 252 }, -- 334949

        -- Hunter/Beast Mastery
        [7003] = { "call_of_the_wild", 1, 253 }, -- 336742
        [7004] = { "nessingwarys_trapping_apparatus", 1, 253 }, -- 336743
        [7005] = { "soulforge_embers", 1, 253 }, -- 336745
        [7006] = { "craven_strategem", 1, 253 }, -- 336747
        [7007] = { "dire_command", 1, 253 }, -- 336819
        [7008] = { "flamewakers_cobra_sting", 1, 253 }, -- 336822
        [7009] = { "qapla_eredun_war_order", 1, 253 }, -- 336830
        [7010] = { "rylakstalkers_piercing_fangs", 1, 253 }, -- 336844

        -- Hunter/Marksmanship
        [7011] = { "eagletalons_true_focus", 1, 254 }, -- 336849
        [7012] = { "surging_shots", 1, 254 }, -- 336867
        [7013] = { "serpentstalkers_trickery", 1, 254 }, -- 336870
        [7014] = { "secrets_of_the_unblinking_vigil", 1, 254 }, -- 336878

        -- Hunter/Survival
        [7015] = { "wildfire_cluster", 1, 255 }, -- 336895
        [7016] = { "rylakstalkers_confounding_strikes", 1, 255 }, -- 336901
        [7017] = { "latent_poison_injectors", 1, 255 }, -- 336902
        [7018] = { "butchers_bone_fragments", 1, 255 }, -- 336907

        -- Priest/Discipline
        [6976] = { "the_penitent_one", 1, 256 }, -- 336011
        [6978] = { "crystalline_reflection", 1, 256 }, -- 336507
        [6979] = { "kiss_of_death", 1, 256 }, -- 336133
        [6980] = { "clarity_of_mind", 1, 256 }, -- 336067

        -- Priest/Holy
        [6973] = { "divine_image", 1, 257 }, -- 336400
        [6974] = { "flash_concentration", 1, 257 }, -- 336266
        [6977] = { "harmonious_apparatus", 1, 257 }, -- 336314
        [6984] = { "xanshi_return_of_archbishop_benedictus", 1, 257 }, -- 337477

        -- Priest/Shadow
        [6972] = { "vault_of_heavens", 1, 258 }, -- 336470
        [6975] = { "cauterizing_shadows", 1, 258 }, -- 336370
        [6981] = { "painbreaker_psalm", 1, 258 }, -- 336165
        [6982] = { "shadowflame_prism", 1, 258 }, -- 336143
        [6983] = { "eternal_call_to_the_void", 1, 258 }, -- 336214
        [7002] = { "twins_of_the_sun_priestess", 1, 258 }, -- 336897
        [7161] = { "measured_contemplation", 1, 258 }, -- 341804
        [7162] = { "talbadars_stratagem", 1, 258 }, -- 342415

        -- Rogue/Assassination
        [7111] = { "mark_of_the_master_assassin", 1, 259 }, -- 340076
        [7112] = { "tiny_toxic_blades", 1, 259 }, -- 340078
        [7113] = { "essence_of_bloodfang", 1, 259 }, -- 340079
        [7114] = { "invigorating_shadowdust", 1, 259 }, -- 340080
        [7115] = { "dashing_scoundrel", 1, 259 }, -- 340081
        [7116] = { "doomblade", 1, 259 }, -- 340082
        [7117] = { "zoldyck_insignia", 1, 259 }, -- 340083
        [7118] = { "dustwalkers_patch", 1, 259 }, -- 340084

        -- Rogue/Outlaw
        [7119] = { "greenskins_wickers", 1, 260 }, -- 340085
        [7120] = { "guile_charm", 1, 260 }, -- 340086
        [7121] = { "celerity", 1, 260 }, -- 340087
        [7122] = { "concealed_blunderbuss", 1, 260 }, -- 340088

        -- Rogue/Subtlety
        [7123] = { "finality", 1, 261 }, -- 340089
        [7124] = { "akaaris_soul_fragment", 1, 261 }, -- 340090
        [7125] = { "the_rotten", 1, 261 }, -- 340091
        [7126] = { "deathly_shadows", 1, 261 }, -- 340092

        -- Shaman/Elemental
        [6985] = { "ancestral_reminder", 1, 262 }, -- 336741
        [6986] = { "deeptremor_stone", 1, 262 }, -- 336739
        [6987] = { "deeply_rooted_elements", 1, 262 }, -- 336738
        [6988] = { "chains_of_devastation", 1, 262 }, -- 336735
        [6989] = { "skybreakers_fiery_demise", 1, 262 }, -- 336734
        [6990] = { "elemental_equilibrium", 1, 262 }, -- 336730
        [6991] = { "echoes_of_great_sundering", 1, 262 }, -- 336215
        [6992] = { "windspeakers_lava_resurgence", 1, 262 }, -- 336063

        -- Shaman/Enhancement
        [6993] = { "doom_winds", 1, 263 }, -- 335902
        [6994] = { "legacy_of_the_frost_witch", 1, 263 }, -- 335899
        [6995] = { "witch_doctors_wolf_bones", 1, 263 }, -- 335897
        [6996] = { "primal_lava_actuators", 1, 263 }, -- 335895

        -- Shaman/Restoration
        [6997] = { "jonats_natural_focus", 1, 264 }, -- 335893
        [6998] = { "spiritwalkers_tidal_totem", 1, 264 }, -- 335891
        [6999] = { "primal_tide_core", 1, 264 }, -- 335889
        [7000] = { "earthen_harmony", 1, 264 }, -- 335886

        -- Warlock/Affliction
        [7025] = { "wilfreds_sigil_of_superior_summoning", 1, 265 }, -- 337020
        [7026] = { "claw_of_endereth", 1, 265 }, -- 337038
        [7027] = { "mark_of_borrowed_power", 1, 265 }, -- 337057
        [7028] = { "pillars_of_the_dark_portal", 1, 265 }, -- 337065
        [7029] = { "perpetual_agony_of_azjaqir", 1, 265 }, -- 337106
        [7030] = { "sacrolashs_dark_strike", 1, 265 }, -- 337111
        [7031] = { "malefic_wrath", 1, 265 }, -- 337122
        [7032] = { "wrath_of_consumption", 1, 265 }, -- 337128

        -- Warlock/Demonology
        [7033] = { "implosive_potential", 1, 266 }, -- 337135
        [7034] = { "grim_inquisitors_dread_calling", 1, 266 }, -- 337141
        [7035] = { "forces_of_the_horned_nightmare", 1, 266 }, -- 337146
        [7036] = { "balespiders_burning_core", 1, 266 }, -- 337159

        -- Warlock/Destruction
        [7037] = { "odr_shawl_of_the_ymirjar", 1, 267 }, -- 337163
        [7038] = { "cinders_of_the_azjaqir", 1, 267 }, -- 337166
        [7039] = { "madness_of_the_azjaqir", 1, 267 }, -- 337169
        [7040] = { "embers_of_the_diabolic_raiment", 1, 267 }, -- 337272

        -- Monk/Brewmaster
        [7076] = { "charred_passions", 1, 268 }, -- 338138
        [7077] = { "stormstouts_last_keg", 1, 268 }, -- 337288
        [7078] = { "celestial_infusion", 1, 268 }, -- 337290
        [7079] = { "shaohaos_might", 1, 268 }, -- 337570
        [7080] = { "swiftsure_wraps", 1, 268 }, -- 337294
        [7081] = { "fatal_touch", 1, 268 }, -- 337296
        [7082] = { "invokers_delight", 1, 268 }, -- 337298
        [7184] = { "escape_from_reality", 1, 268 }, -- 0

        -- Monk/Windwalker
        [7068] = { "keefers_skyreach", 1, 269 }, -- 337334
        [7069] = { "last_emperors_capacitor", 1, 269 }, -- 337292
        [7070] = { "xuens_treasure", 1, 269 }, -- 337481
        [7071] = { "jade_ignition", 1, 269 }, -- 337483

        -- Monk/Mistweaver
        [7072] = { "tear_of_morning", 1, 270 }, -- 337473
        [7073] = { "yulons_whisper", 1, 270 }, -- 337225
        [7074] = { "clouded_focus", 1, 270 }, -- 337343
        [7075] = { "ancient_teachings_of_the_monastery", 1, 270 }, -- 337172

        -- Demon Hunter/Havoc
        [7041] = { "sigil_of_the_illidari", 1, 577 }, -- 337504
        [7042] = { "apexis_empowerment", 1, 577 }, -- 337532
        [7043] = { "darkglare_medallion", 1, 577 }, -- 337534
        [7044] = { "darkest_hour", 1, 577 }, -- 337539
        [7049] = { "inner_demons", 1, 577 }, -- 337548
        [7050] = { "chaos_theory", 1, 577 }, -- 337551
        [7051] = { "erratic_fel_core", 1, 577 }, -- 337685
        [7052] = { "fel_bombardment", 1, 577 }, -- 337775

        -- Demon Hunter/Vengeance
        [7045] = { "spirit_of_the_darkness_flame", 1, 581 }, -- 337541
        [7046] = { "razelikhs_defilement", 1, 581 }, -- 337544
        [7047] = { "cloak_of_fel_flames", 1, 581 }, -- 337545
        [7048] = { "fiery_soul", 1, 581 }, -- 337547
    }

    local wasWearing = {}

    function ns.updateGear()
        if not Hekili.PLAYER_ENTERING_WORLD then return end

        for thing in pairs( state.set_bonus ) do
            state.set_bonus[ thing ] = 0
        end

        for thing in pairs( state.legendary ) do
            state.legendary[ thing ].rank = 0
        end

        wipe( wasWearing )

        for i, item in ipairs( state.items ) do
            wasWearing[i] = item
        end

        wipe( state.items )

        for set, items in pairs( class.gear ) do
            state.set_bonus[ set ] = 0
            for item, _ in pairs( items ) do
                if IsEquippedItem( GetItemInfo( item ) ) then
                    state.set_bonus[ set ] = state.set_bonus[ set ] + 1
                end
            end
        end

        local ItemBuffs = LibStub( "LibItemBuffs-1.0", true )
        local T1 = GetInventoryItemID( "player", 13 )

        if ItemBuffs and T1 then
            local t1buff = ItemBuffs:GetItemBuffs( T1 )

            if type(t1buff) == 'table' then t1buff = t1buff[1] end

            class.auras.trinket1 = class.auras[ t1buff ]
            state.trinket.t1.id = T1
        else
            state.trinket.t1.id = 0
        end

        local T2 = GetInventoryItemID( "player", 14 )

        if ItemBuffs and T2 then
            local t2buff = ItemBuffs:GetItemBuffs( T2 )

            if type(t2buff) == 'table' then t2buff = t2buff[1] end

            class.auras.trinket2 = class.auras[ t2buff ]
            state.trinket.t2.id = T2
        else
            state.trinket.t2.id = 0
        end

        for i = 1, 19 do
            local item = GetInventoryItemID( 'player', i )

            if item then
                state.set_bonus[ item ] = 1
                local key = GetItemInfo( item )
                if key then
                    key = formatKey( key )
                    state.set_bonus[ key ] = 1
                    gearInitialized = true
                end

                local link = GetInventoryItemLink( "player", i )
                local numBonuses = select( 14, string.split( ":", link ) )

                numBonuses = tonumber( numBonuses )
                if numBonuses and numBonuses > 0 then
                    for i = 15, 14 + numBonuses do
                        local bonusID = select( i, string.split( ":", link ) )
                        bonusID = tonumber( bonusID )

                        if shadowlegendaries[ bonusID ] then
                            local name, rank = shadowlegendaries[ bonusID ][ 1 ], shadowlegendaries[ bonusID ][ 2 ]

                            state.legendary[ name ] = rawget( state.legendary, name ) or { rank = 0 }
                            state.legendary[ name ].rank = state.legendary[ name ].rank + rank
                        end
                    end
                end

                local usable = class.itemMap[ item ]
                if usable then insert( state.items, usable ) end
            end
        end

        -- Improve Pocket-Sized Computronic Device.
        if state.equipped.pocketsized_computation_device then
            local tName = GetItemInfo( 167555 )
            local redName, redLink = GetItemGem( tName, 1 )
            
            if redName and redLink then                
                local redID = tonumber( redLink:match("item:(%d+)") )
                local action = class.itemMap[ redID ]

                if action then
                    state.set_bonus[ action ] = 1
                    state.set_bonus[ redID ] = 1
                    class.abilities.pocketsized_computation_device = class.abilities[ action ]
                    class.abilities[ tName ] = class.abilities[ action ]
                    insert( state.items, action )
                end
            else
                class.abilities.pocketsized_computation_device = class.abilities.inactive_red_punchcard
                class.abilities[ tName ] = class.abilities.inactive_red_punchcard
            end
        end

        ns.updatePowers()
        ns.updateTalents()

        local lastEssence = class.active_essence
        ns.updateEssences()

        local sameItems = #wasWearing == #state.items

        if sameItems then
            for i = 1, #state.items do
                if wasWearing[i] ~= state.items[i] then
                    sameItems = false
                    break
                end
            end
        end

        if not sameItems or class.active_essence ~= lastEssence then
            Hekili:UpdateUseItems()
        end

        if not gearInitialized then
            C_Timer.After( 3, ns.updateGear )
        else
            ns.ReadKeybindings()
        end

    end
end


RegisterEvent( "PLAYER_EQUIPMENT_CHANGED", function()
    ns.updateGear()
end )


RegisterEvent( "PLAYER_TALENT_UPDATE", function()
    ns.updateTalents()
end )


-- Update Azerite Essence Data.
do
    local azeriteEvents = {
        "AZERITE_ESSENCE_UPDATE",
        "AZERITE_ESSENCE_MILESTONE_UNLOCKED",
        "AZERITE_ESSENCE_FORGE_CLOSE",
        "AZERITE_ESSENCE_CHANGED",
        "AZERITE_ESSENCE_ACTIVATED",
        "AZERITE_ESSENCE_ACTIVATION_FAILED"
    }

    local function UpdateEssences()
        local lastEssence = class.active_essence
        ns.updateEssences()

        if class.active_essence ~= lastEssence then
            Hekili:UpdateUseItems()
        end
    end

    for i, event in pairs( azeriteEvents ) do
        RegisterEvent( event, UpdateEssences )
    end
end


RegisterEvent( "PLAYER_REGEN_DISABLED", function( event )
    state.combat = GetTime() - 0.01

    Hekili.HasSnapped = false -- some would disagree.
    Hekili:ForceUpdate( event ) -- Force update on entering combat since OOC refresh can be very slow (0.5s).
end )


RegisterEvent( "PLAYER_REGEN_ENABLED", function ()
    state.combat = 0

    state.swings.mh_actual = 0
    state.swings.oh_actual = 0

    Hekili.HasSnapped = false -- allows the addon to autosnapshot again if preference is set.
    Hekili:ReleaseHolds( true )
end )


local dynamic_keys = setmetatable( {}, {
    __index = function( t, k, v )
        local name = GetSpellInfo( k )
        local key = name and formatKey( name ) or k
        t[k] = key
        return t[k]
    end
} )


ns.castsOff = { 'no_action', 'no_action', 'no_action', 'no_action', 'no_action' }
ns.castsOn = { 'no_action', 'no_action', 'no_action', 'no_action', 'no_action' }
ns.castsAll = { 'no_action', 'no_action', 'no_action', 'no_action', 'no_action' }

local castsOn, castsOff, castsAll = ns.castsOn, ns.castsOff, ns.castsAll


function state:AddToHistory( spellID, destGUID )
    local ability = class.abilities[ spellID ]
    local key = ability and ability.key or dynamic_keys[ spellID ]

    local now = GetTime()
    local player = self.player

    player.lastcast = key
    player.casttime = now

    if ability and not ability.essence then
        local history = self.prev.history
        insert( history, 1, key )
        history[6] = nil

        if ability.gcd ~= "off" then
            history = self.prev_gcd.history
            player.lastgcd = key
            player.lastgcdtime = now
        else
            history = self.prev_off_gcd.history
            player.lastoffgcd = key
            player.lastoffgcdtime = now
        end
        insert( history, 1, key )
        history[6] = nil

        ability.realCast = now
        ability.realUnit = destGUID
    end
end


local lowLevelWarned = false

-- Need to make caching system.
RegisterUnitEvent( "UNIT_SPELLCAST_SUCCEEDED", function( event, unit, _, spellID )
    if UnitIsUnit( unit, "player" ) then
        if lowLevelWarned == false and UnitLevel( "player" ) < 50 then
            Hekili:Notify( "Hekili is designed for current content.\nUse below level 50 at your own risk.", 5 )
            lowLevelWarned = true
        end

        local ability = class.abilities[ spellID ]

        if ability and state.holds[ ability.key ] then
            Hekili:RemoveHold( ability.key, true )
        end
    end
    -- Hekili:ForceUpdate( event )
end )

RegisterUnitEvent( "UNIT_SPELLCAST_DELAYED", function( event, unit, _, spellID )
    if UnitIsUnit( unit, "player" ) then
        local ability = class.abilities[ spellID ]
        
        if ability then
            local action = ability.key

            local target = select( 5, state:GetEventInfo( action, nil, nil, "CAST_FINISH", nil, true ) )

            state:RemoveSpellEvent( action, true, "CAST_FINISH" )
            state:RemoveSpellEvent( action, true, "PROJECTILE_IMPACT", true )

            local _, _, _, start, finish = UnitCastingInfo( "player" )
            if start and finish then
                state:QueueEvent( action, start / 1000, finish / 1000, "CAST_FINISH", target, true )

                if ability.isProjectile then
                    local travel

                    if ability.flightTime then
                        travel = flightTime
 
                    elseif target then
                        local unit = Hekili:GetUnitByGUID( target ) or Hekili:GetNameplateUnitForGUID( target ) or "target"

                        if unit then
                            local minR, maxR = RC:GetRange( unit )
                            travel = 0.5 * ( minR + maxR ) / ability.velocity
                        end
                    end

                    if not travel then travel = state.target.distance / ability.velocity end

                    state:QueueEvent( ability.key, finish / 1000, travel, "PROJECTILE_IMPACT", target, true )
                end
            end

            Hekili:ForceUpdate( event )
        end
    end
end )


RegisterEvent( "UNIT_SPELLCAST_SENT", function (self, event, unit, target, castID, spellID)
    state.cast_target = UnitGUID( target )
end )


local power_tick_data = {
    focus_avg = 0.10,
    focus_ticks = 1,

    energy_avg = 0.10,
    energy_ticks = 1,
}


local spell_names = setmetatable( {}, {
    __index = function( t, k )
        t[ k ] = GetSpellInfo( k )
        return t[ k ]
    end
} )


local lastPowerUpdate = 0

local function UNIT_POWER_FREQUENT( event, unit, power )

    if not UnitIsUnit( unit, "player" ) then return end

    if power == "FOCUS" and rawget( state, "focus" ) then
        local now = GetTime()
        local elapsed = now - ( state.focus.last_tick or 0 )

        elapsed = elapsed > power_tick_data.focus_avg * 1.5 and power_tick_data.focus_avg or elapsed

        if elapsed > 0.075 then
            power_tick_data.focus_avg = ( elapsed + ( power_tick_data.focus_avg * power_tick_data.focus_ticks ) ) / ( power_tick_data.focus_ticks + 1 )
            power_tick_data.focus_ticks = power_tick_data.focus_ticks + 1
            state.focus.last_tick = now
        end

    elseif power == "ENERGY" and rawget( state, "energy" ) then
        local now = GetTime()
        local elapsed = min( 0.12, now - ( state.energy.last_tick or 0 ) )

        elapsed = elapsed > power_tick_data.energy_avg * 1.5 and power_tick_data.energy_avg or elapsed

        if elapsed > 0.075 then
            power_tick_data.energy_avg = ( elapsed + ( power_tick_data.energy_avg * power_tick_data.energy_ticks ) ) / ( power_tick_data.energy_ticks + 1 )
            power_tick_data.energy_ticks = power_tick_data.energy_ticks + 1
            state.energy.last_tick = now
        end

    end

    if GetTime() - lastPowerUpdate > 0.1 then
        Hekili:ForceUpdate( event )
        lastPowerUpdate = GetTime()
    end
end
Hekili:ProfileCPU( "UNIT_POWER_UPDATE", UNIT_POWER_FREQUENT )

RegisterUnitEvent( "UNIT_POWER_UPDATE", UNIT_POWER_FREQUENT )


local autoAuraKey = setmetatable( {}, {
    __index = function( t, k )
        local name = GetSpellInfo( k )

        if not name then return end

        local key = formatKey( name )

        if class.auras[ key ] then
            local i = 1

            while ( true ) do 
                local new = key .. '_' .. i

                if not class.auras[ new ] then
                    key = new
                    break
                end

                i = i + 1
            end
        end

        -- Store the aura and save the key if we can.
        if ns.addAura then
            ns.addAura( key, k, 'name', name )
            t[k] = key
        end

        return t[k]
    end
} )


RegisterUnitEvent( "UNIT_AURA", function( event, unit )
    if UnitIsUnit( unit, 'player' ) then
        Hekili.ScrapeUnitAuras( "player" )

    elseif UnitIsUnit( unit, "target" ) and state.target.updated then
        Hekili.ScrapeUnitAuras( "target" )
        state.target.updated = false
    
    end
end )


RegisterEvent( "PLAYER_TARGET_CHANGED", function( event )
    Hekili.ScrapeUnitAuras( "target", true )
    state.target.updated = false

    Hekili:ForceUpdate( event, true )
end )


RegisterEvent( "PLAYER_STARTED_MOVING", function( event )
    Hekili:ForceUpdate( event )
end )
RegisterEvent( "PLAYER_STOPPED_MOVING", function( event )
    Hekili:ForceUpdate( event )
end )



local cast_events = {
    SPELL_CAST_START        = true,
    SPELL_CAST_FAILED       = true,
    SPELL_CAST_SUCCESS      = true,
    SPELL_DAMAGE            = true,
}


local aura_events = {
    SPELL_AURA_APPLIED      = true,
    SPELL_AURA_APPLIED_DOSE = true,
    SPELL_AURA_REFRESH      = true,
    SPELL_AURA_REMOVED      = true,
    SPELL_AURA_REMOVED_DOSE = true,
    SPELL_AURA_BROKEN       = true,
    SPELL_AURA_BROKEN_SPELL = true,
    SPELL_CAST_SUCCESS      = true -- it appears you can refresh stacking buffs w/o a SPELL_AURA_x event.
}


local dmg_events = {
    SPELL_DAMAGE            = true,
    SPELL_MISSED            = true,
    SPELL_PERIODIC_DAMAGE   = true,
    SPELL_PERIODIC_MISSED   = true,
    SWING_DAMAGE            = true,
    SWING_MISSED            = true,
    RANGE_DAMAGE            = true,
    RANGE_MISSED            = true,
    ENVIRONMENTAL_DAMAGE    = true,
    ENVIRONMENTAL_MISSED    = true
}


local death_events = {
    UNIT_DIED               = true,
    UNIT_DESTROYED          = true,
    UNIT_DISSIPATES         = true,
    PARTY_KILL              = true,
    SPELL_INSTAKILL         = true,
}

local dmg_filtered = {
    [280705] = true, -- Laser Matrix.
}


local function IsActuallyFriend( unit )
    if not IsInGroup() then return false end
    if not UnitIsPlayer( unit ) then return false end
    if UnitInRaid( unit ) or UnitInParty( unit ) then return true end
    return false
end



-- Use dots/debuffs to count active targets.
-- Track dot power (until 6.0) for snapshotting.
-- Note that this was ported from an unreleased version of Hekili, and is currently only counting damaged enemies.
local function CLEU_HANDLER( event, _, subtype, _, sourceGUID, sourceName, _, _, destGUID, destName, destFlags, _, spellID, spellName, school, amount, interrupt, a, b, c, d, offhand, multistrike, ... )

    if death_events[ subtype ] then
        if ns.isTarget( destGUID ) then
            ns.eliminateUnit( destGUID, true )
            Hekili:ForceUpdate( subtype )
        elseif ns.isMinion( destGUID ) then
            local npcid = destGUID:match("(%d+)-%x-$")
            npcid = npcid and tonumber( npcid )
    
            if npcid == state.pet.guardian_of_azeroth.id then
                state.pet.guardian_of_azeroth.summonTime = 0
            end
            ns.updateMinion( destGUID )
        end
        return
    end

    local time = GetTime()

    if subtype == 'SPELL_SUMMON' and sourceGUID == state.GUID then
        -- Guardian of Azeroth check.
        -- ID is 152396.
        local npcid = destGUID:match("(%d+)-%x-$")
        npcid = npcid and tonumber( npcid )

        if npcid == state.pet.guardian_of_azeroth.id then
            state.pet.guardian_of_azeroth.summonTime = time
        end
            
        ns.updateMinion( destGUID, time )
        return
    end

    local hostile = ( bit.band( destFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY ) == 0 ) and not IsActuallyFriend( destName )

    if dmg_events[ subtype ] and destGUID == state.GUID then
        local damage, damageType

        if subtype:sub( 1, 13 ) == "ENVIRONMENTAL" then
            damageType = 1

            if subtype:sub(-7) == "_DAMAGE" then
                damage = spellName
            
            elseif spellName == "ABSORB" then
                damage = amount
            
            end
        
        elseif subtype:sub( 1, 5 ) == "SWING" then
            damageType = 1

            if subtype == "SWING_DAMAGE" then
                damage = spellID

            else
                if spellID == "ABSORB" then
                    damage = interrupt
                end
            
            end

        else -- SPELL_x
            if subtype:find( "_MISSED" ) then
                if amount == "ABSORB" then
                    damage = a
                    damageType = school or 1
                end

            else
                damage = amount
                damageType = school

            end

        end


        if damage and damage > 0 then
            ns.storeDamage( time, damage, bit.band( damageType, 0x1 ) == 1 )
        end
    end

    if sourceGUID ~= state.GUID and not ( state.role.tank and destGUID == state.GUID ) and not ns.isMinion( sourceGUID ) then
        return
    end

    if sourceGUID == state.GUID then
        if cast_events[ subtype ] then
            local ability = class.abilities[ spellID ]

            if ability then
                if subtype == "SPELL_CAST_START" then
                    local _, _, _, start, finish = UnitCastingInfo( "player" )

                    if start then
                        state:QueueEvent( ability.key, start / 1000, finish / 1000, "CAST_FINISH", destGUID, true )
                    end

                    if ability.isProjectile then
                        local travel

                        if ability.flightTime then
                            travel = flightTime
                        
                        elseif destGUID then
                            local unit = Hekili:GetUnitByGUID( destGUID ) or Hekili:GetNameplateUnitForGUID( destGUID ) or "target"

                            if unit then
                                local _, maxR = RC:GetRange( unit )
                                travel = maxR / ability.velocity
                            end
                        end

                        if not travel then travel = state.target.distance / ability.velocity end

                        state:QueueEvent( ability.key, finish / 1000, travel, "PROJECTILE_IMPACT", destGUID, true )
                    end

                elseif subtype == "SPELL_CAST_FAILED" then
                    state:RemoveSpellEvent( ability.key, true, "CAST_FINISH" ) -- remove next cast finish.
                    state:RemoveSpellEvent( ability.key, true, "PROJECTILE_IMPACT", true ) -- remove last impact.

                elseif subtype == "SPELL_CAST_SUCCESS" then
                    state:RemoveSpellEvent( ability.key, true, "CAST_FINISH" ) -- remove next cast finish.

                    if ability.isProjectile then
                        local travel

                        if ability.flightTime then
                            travel = ability.flightTime
                        
                        elseif destGUID then
                            local unit = Hekili:GetUnitByGUID( destGUID ) or Hekili:GetNameplateUnitForGUID( destGUID ) or "target"

                            if unit then
                                local _, maxR = RC:GetRange( unit )
                                travel = maxR / ability.velocity
                            end
                        end

                        if not travel then travel = state.target.distance / ability.velocity end

                        state:QueueEvent( ability.key, time, travel, "PROJECTILE_IMPACT", destGUID, true )
                    end

                    state:AddToHistory( ability.key, destGUID )

                end
            end

            local gcdStart = GetSpellCooldown( 61304 )
            if state.gcd.lastStart ~= gcdStart then
                state.gcd.lastStart = max( state.gcd.lastStart, gcdStart )
            end            

            Hekili:ForceUpdate( subtype )

        elseif subtype == "SPELL_DAMAGE" then
            -- Could be an impact.
            local ability = class.abilities[ spellID ]

            if ability then
                if state:RemoveSpellEvent( ability.key, true, "PROJECTILE_IMPACT" ) then
                    Hekili:ForceUpdate( "PROJECTILE_IMPACT", true )
                end
            end
        end
    end

    if state.role.tank and state.GUID == destGUID and subtype:sub(1,5) == 'SWING' and not IsActuallyFriend( sourceName ) then
        ns.updateTarget( sourceGUID, time, true )

    elseif subtype:sub( 1, 5 ) == 'SWING' and not multistrike then
        if subtype == 'SWING_MISSED' then offhand = spellName end

        local sw = state.swings

        if offhand and time > sw.oh_actual and sw.oh_speed then
            sw.oh_actual = time
            sw.oh_speed = select( 2, UnitAttackSpeed( 'player' ) ) or sw.oh_speed
            sw.oh_projected = sw.oh_actual + sw.oh_speed

        elseif not offhand and time > sw.mh_actual then
            sw.mh_actual = time
            sw.mh_speed = UnitAttackSpeed( 'player' ) or sw.mh_speed
            sw.mh_projected = sw.mh_actual + sw.mh_speed

        end

    -- Player/Minion Event
    elseif sourceGUID == state.GUID or ns.isMinion( sourceGUID ) or ( sourceGUID == destGUID and sourceGUID == UnitGUID( 'target' ) ) then

        if aura_events[ subtype ] then
            if subtype == "SPELL_CAST_SUCCESS" or state.GUID == destGUID then 
                state.player.updated = true
                if class.abilities[ spellID ] or class.auras[ spellID ] then Hekili:ForceUpdate( subtype, true ) end
            end

            if UnitGUID( 'target' ) == destGUID then
                state.target.updated = true
                if class.auras[ spellID ] then Hekili:ForceUpdate( subtype ) end
            end
        end

        local aura = class.auras and class.auras[ spellID ]

        if aura then            
            if hostile and sourceGUID ~= destGUID and not aura.friendly then
                -- Aura Tracking
                if subtype == 'SPELL_AURA_APPLIED' or subtype == 'SPELL_AURA_REFRESH' or subtype == 'SPELL_AURA_APPLIED_DOSE' then
                    ns.trackDebuff( spellID, destGUID, time, true )
                    ns.updateTarget( destGUID, time, sourceGUID == state.GUID )

                    if spellID == 48108 or spellID == 48107 then
                        Hekili:ForceUpdate( "SPELL_AURA_SUPER", true )
                    end

                elseif subtype == 'SPELL_PERIODIC_DAMAGE' or subtype == 'SPELL_PERIODIC_MISSED' then
                    ns.trackDebuff( spellID, destGUID, time )
                    if Hekili.currentSpecOpts and Hekili.currentSpecOpts.damageDots then
                        ns.updateTarget( destGUID, time, sourceGUID == state.GUID )
                    end

                elseif destGUID and subtype == 'SPELL_AURA_REMOVED' or subtype == 'SPELL_AURA_BROKEN' or subtype == 'SPELL_AURA_BROKEN_SPELL' then
                    ns.trackDebuff( spellID, destGUID )

                end

            elseif sourceGUID == state.GUID and aura.friendly then -- friendly effects
                if subtype == 'SPELL_AURA_APPLIED'  or subtype == 'SPELL_AURA_REFRESH' or subtype == 'SPELL_AURA_APPLIED_DOSE' then
                    ns.trackDebuff( spellID, destGUID, time, subtype == 'SPELL_AURA_APPLIED' )

                elseif subtype == 'SPELL_PERIODIC_HEAL' or subtype == 'SPELL_PERIODIC_MISSED' then
                    ns.trackDebuff( spellID, destGUID, time )

                elseif destGUID and subtype == 'SPELL_AURA_REMOVED' or subtype == 'SPELL_AURA_BROKEN' or subtype == 'SPELL_AURA_BROKEN_SPELL' then
                    ns.trackDebuff( spellID, destGUID )

                end

            end

        end

        local action = class.abilities[ spellID ]

        if hostile and dmg_events[ subtype ] and not dmg_filtered[ spellID ] then
            -- Don't wipe overkill targets in rested areas (it is likely a dummy).
            -- Interrupt is actually overkill.
            if not IsResting( "player" ) and ( ( ( subtype == "SPELL_DAMAGE" or subtype == "SPELL_PERIODIC_DAMAGE" ) and interrupt > 0 ) or ( subtype == "SWING_DAMAGE" and spellName > 0 ) ) and ns.isTarget( destGUID ) then
                ns.eliminateUnit( destGUID, true )
                Hekili:ForceUpdate( "SPELL_DAMAGE_OVERKILL" )
            elseif not ( subtype == "SPELL_MISSED" and amount == "IMMUNE" ) then
                ns.updateTarget( destGUID, time, sourceGUID == state.GUID )
            end
        end
    end

    -- This is dumb.  Just let modules used the event handler.
    ns.callHook( "COMBAT_LOG_EVENT_UNFILTERED", event, nil, subtype, nil, sourceGUID, sourceName, nil, nil, destGUID, destName, destFlags, nil, spellID, spellName, nil, amount, interrupt, a, b, c, d, offhand, multistrike, ... )

end
Hekili:ProfileCPU( "CLEU_HANDLER", CLEU_HANDLER )
RegisterEvent( "COMBAT_LOG_EVENT_UNFILTERED", function ( event ) CLEU_HANDLER( event, CombatLogGetCurrentEventInfo() ) end )


local function UNIT_COMBAT( event, unit, action, _, amount )
    if unit ~= 'player' then return end

    if amount > 0 and action == 'HEAL' then
        ns.storeHealing( GetTime(), amount )
    end
end
Hekili:ProfileCPU( "UNIT_COMBAT", UNIT_COMBAT )
RegisterUnitEvent( "UNIT_COMBAT", UNIT_COMBAT )


local keys = ns.hotkeys
Hekili.KeybindInfo = keys
local updatedKeys = {}

local bindingSubs = {
    ["CTRL%-"] = "C",
    ["ALT%-"] = "A",
    ["SHIFT%-"] = "S",
    ["STRG%-"] = "ST",
    ["%s+"] = "",
    ["NUMPAD"] = "N",
    ["PLUS"] = "+",
    ["MINUS"] = "-",
    ["MULTIPLY"] = "*",
    ["DIVIDE"] = "/",
    ["BUTTON"] = "M",
    ["DOWN"] = "Dn",
    ["UP"] = "Up",
    ["MOUSEWHEEL"] = "Mw",
    ["BACKSPACE"] = "BkSp",
    ["DECIMAL"] = ".",
    ["CAPSLOCK"] = "CAPS",
}

local function improvedGetBindingText( binding )
    if not binding then return "" end

    for k, v in pairs( bindingSubs ) do
        binding = binding:gsub( k, v )
    end

    return binding
end


local itemToAbility = {
    [5512]   = "healthstone",
    [177278] = "phial_of_serenity"
}


local function StoreKeybindInfo( page, key, aType, id, console )

    if not key then return end

    local ability

    if aType == "spell" then
        ability = class.abilities[ id ] and class.abilities[ id ].key

    elseif aType == "macro" then
        local sID = GetMacroSpell( id ) or GetMacroItem( id )
        ability = sID and class.abilities[ sID ] and class.abilities[ sID ].key

    elseif aType == "item" then
        ability = GetItemInfo( id )
        ability = class.abilities[ ability ] and class.abilities[ ability ].key

        if not ability then
            if itemToAbility[ id ] then
                ability = itemToAbility[ id ]
            else
                for k, v in pairs( class.potions ) do
                    if v.item == id then
                        ability = "potion"
                        break
                    end
                end
            end
        end

    end

    if ability then
        keys[ ability ] = keys[ ability ] or {
            lower = {},
            upper = {},
            console = {}
        }

        if console == "cPort" then
            local newKey = key:gsub( ":%d+:%d+:0:0", ":0:0:0:0" )
            keys[ ability ].console[ page ] = newKey
        else
            keys[ ability ].upper[ page ] = improvedGetBindingText( key )
            keys[ ability ].lower[ page ] = lower( keys[ ability ].upper[ page ] )
        end
        updatedKeys[ ability ] = true

        if ability.bind then
            local bind = ability.bind

            if type( bind ) == 'table' then
                for _, b in ipairs( bind ) do
                    keys[ b ] = keys[ b ] or {
                        lower = {},
                        upper = {},
                        console = {}
                    }

                    keys[ b ].lower[ page ] = keys[ ability ].lower[ page ]
                    keys[ b ].upper[ page ] = keys[ ability ].upper[ page ]
                    keys[ b ].console[ page ] = keys[ ability ].console[ page ]
        
                    updatedKeys[ b ] = true
                end
            else
                keys[ bind ] = keys[ bind ] or {
                    lower = {},
                    upper = {},
                    console = {}
                }

                keys[ bind ].lower[ page ] = keys[ ability ].lower[ page ]
                keys[ bind ].upper[ page ] = keys[ ability ].upper[ page ]
                keys[ bind ].console[ page ] = keys[ ability ].console[ page ]

                updatedKeys[ bind ] = true
            end
        end
    end
end        



local defaultBarMap = {
    WARRIOR = {
        { bonus = 1, bar = 7 },
        { bonus = 2, bar = 8 },
    },
    ROGUE = {
        { bonus = 1, bar = 7 },
        { bonus = 2, bar = 7 },
        { bonus = 3, bar = 7 },
    },
    DRUID = {
        { bonus = 1, stealth = false, bar = 7 },
        { bonus = 1, stealth = true,  bar = 8 },
        { bonus = 2, bar = 8 },
        { bonus = 3, bar = 9 },
        { bonus = 4, bar = 10 },
    },
    MONK = {
        { bonus = 1, bar = 7 },
        { bonus = 2, bar = 8 },
        { bonus = 3, bar = 9 },
    },
    PRIEST = {
        { bonus = 1, bar = 7 },
    },
}



local function ReadKeybindings()

    for k, v in pairs( keys ) do
        wipe( v.upper )
        wipe( v.lower )
    end

    -- Bartender4 support (Original from tanichan, rewritten for action bar paging by konstantinkoeppe).
    if _G["Bartender4"] then
        for actionBarNumber = 1, 10 do
            for keyNumber = 1, 12 do
                local actionBarButtonId = (actionBarNumber - 1) * 12 + keyNumber
                local bindingKeyName = "ACTIONBUTTON" .. keyNumber

                -- Action bar 1 and 7+ use bindings of action bar 1
                if actionBarNumber > 1 and actionBarNumber <= 6 then
                    bindingKeyName = "CLICK BT4Button" .. actionBarButtonId .. ":LeftButton"
                end

                StoreKeybindInfo( actionBarNumber, GetBindingKey( bindingKeyName ), GetActionInfo( actionBarButtonId ) )
            end
        end
    else
        for i = 1, 12 do
            StoreKeybindInfo( 1, GetBindingKey( "ACTIONBUTTON" .. i ), GetActionInfo( i ) )
        end

        for i = 13, 24 do
            StoreKeybindInfo( 2, GetBindingKey( "ACTIONBUTTON" .. i - 12 ), GetActionInfo( i ) )
        end

        for i = 25, 36 do
            StoreKeybindInfo( 3, GetBindingKey( "MULTIACTIONBAR3BUTTON" .. i - 24 ), GetActionInfo( i ) )
        end

        for i = 37, 48 do
            StoreKeybindInfo( 4, GetBindingKey( "MULTIACTIONBAR4BUTTON" .. i - 36 ), GetActionInfo( i ) )
        end

        for i = 49, 60 do
            StoreKeybindInfo( 5, GetBindingKey( "MULTIACTIONBAR2BUTTON" .. i - 48 ), GetActionInfo( i ) )
        end

        for i = 61, 72 do
            StoreKeybindInfo( 6, GetBindingKey( "MULTIACTIONBAR1BUTTON" .. i - 60 ), GetActionInfo( i ) )
        end

        for i = 72, 119 do
            StoreKeybindInfo( 7 + floor( ( i - 72 ) / 12 ), GetBindingKey( "ACTIONBUTTON" .. 1 + ( i - 72 ) % 12 ), GetActionInfo( i + 1 ) )
        end
    end

    if _G.ConsolePort then
        for i = 1, 120 do
            local bind = ConsolePort:GetActionBinding(i)

            if bind then
                local action, id = GetActionInfo( i )
                local key, mod = ConsolePort:GetCurrentBindingOwner(bind)
                StoreKeybindInfo( math.ceil( i / 12 ), ConsolePort:GetFormattedButtonCombination( key, mod ), action, id, "cPort" )
            end
        end
    end 

    for k, v in pairs( keys ) do
        local ability = class.abilities[ k ]

        if ability and ability.bind then
            if type( ability.bind ) == 'table' then
                for _, b in ipairs( ability.bind ) do
                    for page, value in pairs( v.lower ) do
                        keys[ b ] = keys[ b ] or {
                            lower = {},
                            upper = {},
                            console = {}
                        }
                        keys[ b ].lower[ page ] = value
                        keys[ b ].upper[ page ] = v.upper[ page ]
                        keys[ b ].console[ page ] = v.console[ page ]
                    end
                end
            else
                for page, value in pairs( v.lower ) do
                    keys[ ability.bind ] = keys[ ability.bind ] or {
                        lower = {},
                        upper = {},
                        console = {}
                    }
                    keys[ ability.bind ].lower[ page ] = value
                    keys[ ability.bind ].upper[ page ] = v.upper[ page ]
                    keys[ ability.bind ].console[ page ] = v.console[ page ]
                end
            end
        end
    end

end    
ns.ReadKeybindings = ReadKeybindings


RegisterEvent( "UPDATE_BINDINGS", ReadKeybindings )
RegisterEvent( "PLAYER_ENTERING_WORLD", ReadKeybindings )
RegisterEvent( "ACTIONBAR_SLOT_CHANGED", ReadKeybindings )
RegisterEvent( "ACTIONBAR_SHOWGRID", ReadKeybindings )
RegisterEvent( "ACTIONBAR_HIDEGRID", ReadKeybindings )
RegisterEvent( "ACTIONBAR_PAGE_CHANGED", ReadKeybindings )
RegisterEvent( "ACTIONBAR_UPDATE_STATE", ReadKeybindings )
RegisterEvent( "SPELL_UPDATE_ICON", ReadKeybindings )
RegisterEvent( "SPELLS_CHANGED", ReadKeybindings )

RegisterEvent( "UPDATE_SHAPESHIFT_FORM", function ( event )
    ReadKeybindings()
    Hekili:ForceUpdate( event )
end )
-- RegisterUnitEvent( "PLAYER_SPECIALIZATION_CHANGED", ReadKeybindings )
-- RegisterUnitEvent( "PLAYER_EQUIPMENT_CHANGED", ReadKeybindings )


if select( 2, UnitClass( "player" ) ) == "DRUID" then
    function Hekili:GetBindingForAction( key, display )
        if not key then return "" end

        local ability = class.abilities[ key ]

        local override = state.spec.id
        local overrideType = ability and ability.item and "items" or "abilities"

        override = override and self.DB.profile.specs[ override ]
        override = override and override[ overrideType ][ key ]
        override = override and override.keybind

        if override and override ~= "" then
            return override
        end

        if not keys[ key ] then return "" end

        local caps, console = true, false
        if display then
            caps = not display.keybindings.lowercase
            console = ConsolePort ~= nil and display.keybindings.cPortOverride
        end

        local db = console and keys[ key ].console or ( caps and keys[ key ].upper or keys[ key ].lower )

        local output

        if state.prowling then
            output = db[ 8 ] or db[ 7 ] or db[ 2 ] or db[ 3 ] or db[ 4 ] or db[ 5 ] or db[ 6 ] or db[ 9 ] or db[ 10 ] or db[ 1 ] or ""

        elseif state.buff.cat_form.up then
            output = db[ 7 ] or db[ 8 ] or db[ 2 ] or db[ 3 ] or db[ 4 ] or db[ 5 ] or db[ 6 ] or db[ 9 ] or db[ 10 ] or db[ 1 ] or ""

        elseif state.buff.bear_form.up then
            output = db[ 9 ] or db[ 3 ] or db[ 4 ] or db[ 5 ] or db[ 6 ] or db[ 2 ] or db [ 7 ] or db[ 8 ] or db[ 10 ] or db[ 1 ] or ""

        elseif state.buff.moonkin_form.up then
            output = db[ 10 ] or db[ 2 ] or db[ 3 ] or db[ 4 ] or db[ 5 ] or db[ 6 ] or db[ 7 ] or db[ 8 ] or db[ 9 ] or db[ 1 ] or ""

        else
            output = db[ 1 ] or db[ 2 ] or db[ 3 ] or db[ 4 ] or db[ 5 ] or db[ 6 ] or db[ 7 ] or db[ 8 ] or db[ 9 ] or db[ 10 ] or ""
        end

        if output ~= "" and console then
            local size = output:match( "Icons(%d%d)" )
            size = tonumber(size)
    
            if size then
                local margin = floor( size * display.keybindings.cPortZoom * 0.5 )
                output = output:gsub( ":0|t", ":0:" .. size .. ":" .. size .. ":" .. margin .. ":" .. ( size - margin ) .. ":" .. margin .. ":" .. ( size - margin ) .. "|t" )
            end
        end

        return output
    end
elseif select( 2, UnitClass( "player" ) ) == "ROGUE" then
    function Hekili:GetBindingForAction( key, display )
        if not key then return "" end

        local ability = class.abilities[ key ]

        local override = state.spec.id
        local overrideType = ability and ability.item and "items" or "abilities"

        override = override and self.DB.profile.specs[ override ]
        override = override and override[ overrideType ][ key ]
        override = override and override.keybind

        if override and override ~= "" then
            return override
        end

        if not keys[ key ] then return "" end

        local caps, console = true, false
        if display then
            caps = not display.keybindings.lowercase
            console = ConsolePort ~= nil and display.keybindings.cPortOverride
        end

        local db = console and keys[ key ].console or ( caps and keys[ key ].upper or keys[ key ].lower )

        local output

        if state.stealthed.all then
            output = db[ 7 ] or db[ 8 ] or db[ 1 ] or db[ 2 ] or db[ 3 ] or db[ 4 ] or db[ 5 ] or db[ 6 ] or db[ 9 ] or db[ 10 ] or ""

        else
            output = db[ 1 ] or db[ 2 ] or db[ 3 ] or db[ 4 ] or db[ 5 ] or db[ 6 ] or db[ 7 ] or db[ 8 ] or db[ 9 ] or db[ 10 ] or ""
        
        end

        if output ~= "" and console then
            local size = output:match( "Icons(%d%d)" )
            size = tonumber(size)
    
            if size then
                local margin = floor( size * display.keybindings.cPortZoom * 0.5 )
                output = output:gsub( ":0|t", ":0:" .. size .. ":" .. size .. ":" .. margin .. ":" .. ( size - margin ) .. ":" .. margin .. ":" .. ( size - margin ) .. "|t" )
            end
        end

        return output
    end

else
    function Hekili:GetBindingForAction( key, display )
        if not key then return "" end

        local ability = class.abilities[ key ]

        local override = state.spec.id
        local overrideType = ability and ability.item and "items" or "abilities"

        override = override and self.DB.profile.specs[ override ]
        override = override and override[ overrideType ][ key ]
        override = override and override.keybind

        if override and override ~= "" then
            return override
        end

        if not keys[ key ] then return "" end

        local caps, console = true, false
        if display then
            caps = not display.keybindings.lowercase
            console = ConsolePort ~= nil and display.keybindings.cPortOverride
        end
        
        local db = console and keys[ key ].console or ( caps and keys[ key ].upper or keys[ key ].lower )

        local output = db[ 1 ] or db[ 2 ] or db[ 3 ] or db[ 4 ] or db[ 5 ] or db[ 6 ] or db[ 7 ] or db[ 8 ] or db[ 9 ] or db[ 10 ] or ""

        if output ~= "" and console then
            local size = output:match( "Icons(%d%d)" )
            size = tonumber(size)
    
            if size then
                local margin = floor( size * display.keybindings.cPortZoom * 0.5 )
                output = output:gsub( ":0:0:0:0|t", ":0:0:0:0:" .. size .. ":" .. size .. ":" .. margin .. ":" .. ( size - margin ) .. ":" .. margin .. ":" .. ( size - margin ) .. "|t" )
            end
        end

        return output        
    end

end
