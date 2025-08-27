local addon, ns = ...

local Hekili = _G.Hekili
if not Hekili then return end

-- Basic Boss Mod (DBM / BigWigs) timer harvesting for add spawn prediction.
-- This is a lightweight subset of WeakAuras' BossMods handler, tailored for Hekili's needs.

Hekili.BossMods = Hekili.BossMods or {}
local BM = Hekili.BossMods

BM.bars = BM.bars or {}   -- [id] = { message/text, spellId, expires, duration, paused, remaining }
BM.sources = BM.sources or {} -- Optional source info.

local function Now() return GetTime() end

local function PurgeExpired()
    local now = Now()
    for id, bar in pairs( BM.bars ) do
        if ( not bar.paused and bar.expires <= now ) or ( bar.paused and ( bar.remaining or 0 ) <= 0 ) then
            BM.bars[ id ] = nil
        end
    end
end

function BM:Reset()
    wipe( self.bars )
end

-- After enhancement: filters compiled to { kind = 'id'|'text', value=..., offset=seconds }
function BM:GetNextMatching( filters )
    if not filters or #filters == 0 then return nil end
    PurgeExpired()
    local now = Now()
    local best
    for id, bar in pairs( self.bars ) do
        local baseRemaining = bar.paused and ( bar.remaining or ( bar.expires - now ) ) or ( bar.expires - now )
        if baseRemaining > -30 then
            local text = ( bar.message or bar.text or "" ):lower()
            local spellId = bar.spellId and tonumber( bar.spellId ) or nil
            for _, f in ipairs( filters ) do
                local match
                if f.kind == 'id' then
                    match = ( spellId == f.value )
                else
                    match = ( f.value ~= '' and text:find( f.value, 1, true ) ~= nil )
                end
                if match then
                    local remaining = baseRemaining + ( f.offset or 0 )
                    if remaining > 0 then
                        if not best or remaining < best then best = remaining end
                    else
                        if not best or 0 < best then best = 0 end
                    end
                    break
                end
            end
        end
    end
    return best
end

-- Compile filters from encounter profile data (cached).
local function CompileFilters( encounterData )
    if not encounterData then return nil end
    local raw = encounterData.filters
    if type( raw ) ~= 'string' or raw == '' then return nil end
    if encounterData._compiledFilters and encounterData._compiledSource == raw then
        return encounterData._compiledFilters
    end
    local compiled = {}
    for line in raw:gmatch( '[^\n]+' ) do
        for token in line:gmatch( '[^,]+' ) do
            local s = strtrim( token )
            if s ~= '' then
                local base, sign, off = s:match( '^(.-)([+-])(%d+)$' )
                local offset = 0
                if base and off then
                    s = strtrim( base )
                    if sign == '+' then offset = tonumber( off ) or 0 else offset = -( tonumber( off ) or 0 ) end
                end
                if s ~= '' then
                    local n = tonumber( s )
                    if n then
                        compiled[ #compiled + 1 ] = { kind = 'id', value = n, offset = offset }
                    else
                        compiled[ #compiled + 1 ] = { kind = 'text', value = s:lower(), offset = offset }
                    end
                end
            end
        end
    end
    encounterData._compiledFilters = compiled
    encounterData._compiledSource = raw
    return compiled
end

function BM:GetNextAddSpawn( encounterID )
    if not encounterID or encounterID == 0 then return nil end
    local profile = Hekili.DB and Hekili.DB.profile
    if not profile then return nil end
    local e = profile.raidEvents and profile.raidEvents.adds and profile.raidEvents.adds.encounters and profile.raidEvents.adds.encounters[ encounterID ]
    if not e then return nil end
    local filters = CompileFilters( e )
    if not filters or #filters == 0 then return nil end
    return self:GetNextMatching( filters )
end

-- DBM Integration
local function InitDBM()
    if not DBM or BM.DBMInitialized then return end
    BM.DBMInitialized = true
    DBM:RegisterCallback( "DBM_TimerBegin", function( _, timerId, msg, duration, icon, timerType, spellId, dbmType, _, _, _, _, timerCount )
        if not timerId then return end
        BM.bars[ timerId ] = BM.bars[ timerId ] or {}
        local bar = BM.bars[ timerId ]
        bar.message = msg
        bar.text = msg
        bar.duration = duration
        bar.expires = Now() + ( duration or 0 )
        bar.icon = icon
        bar.timerType = timerType
        bar.spellId = spellId and tostring( spellId )
        bar.count = timerCount
        bar.paused = false
        bar.remaining = nil
    end )
    DBM:RegisterCallback( "DBM_TimerStop", function( _, timerId )
        if timerId and BM.bars[ timerId ] then BM.bars[ timerId ] = nil end
    end )
    DBM:RegisterCallback( "DBM_TimerPause", function( _, timerId )
        local bar = timerId and BM.bars[ timerId ]
        if bar and not bar.paused then
            bar.paused = true
            bar.remaining = bar.expires - Now()
        end
    end )
    DBM:RegisterCallback( "DBM_TimerResume", function( _, timerId )
        local bar = timerId and BM.bars[ timerId ]
        if bar and bar.paused then
            bar.paused = false
            if bar.remaining and bar.remaining > 0 then
                bar.expires = Now() + bar.remaining
            end
            bar.remaining = nil
        end
    end )
    DBM:RegisterCallback( "DBM_TimerUpdate", function( _, timerId, elapsed, total )
        local bar = timerId and BM.bars[ timerId ]
        if bar and not bar.paused then
            bar.duration = total
            bar.expires = Now() + ( total - elapsed )
        end
    end )
end

-- BigWigs Integration
local function InitBigWigs()
    if not BigWigsLoader or BM.BigWigsInitialized then return end
    BM.BigWigsInitialized = true
    BigWigsLoader.RegisterMessage( BM, "BigWigs_StartBar", function( _, addon, spellId, duration, _, text, count, icon )
        if not text then return end
        BM.bars[ text ] = BM.bars[ text ] or {}
        local bar = BM.bars[ text ]
        bar.text = text
        bar.message = text
        bar.duration = duration
        bar.expires = Now() + ( duration or 0 )
        bar.icon = icon
        bar.spellId = spellId and tostring( spellId )
        bar.count = count
        bar.paused = false
        bar.remaining = nil
    end )
    BigWigsLoader.RegisterMessage( BM, "BigWigs_StopBar", function( _, addon, text )
        if text and BM.bars[ text ] then BM.bars[ text ] = nil end
    end )
    BigWigsLoader.RegisterMessage( BM, "BigWigs_PauseBar", function( _, addon, text )
        local bar = text and BM.bars[ text ]
        if bar and not bar.paused then
            bar.paused = true
            bar.remaining = bar.expires - Now()
        end
    end )
    BigWigsLoader.RegisterMessage( BM, "BigWigs_ResumeBar", function( _, addon, text )
        local bar = text and BM.bars[ text ]
        if bar and bar.paused then
            bar.paused = false
            if bar.remaining and bar.remaining > 0 then
                bar.expires = Now() + bar.remaining
            end
            bar.remaining = nil
        end
    end )
end

function BM:Initialize()
    InitDBM()
    InitBigWigs()
end

-- Try to initialize after PLAYER_LOGIN; also handle if mods load later.
local f = CreateFrame( "Frame" )
f:RegisterEvent( "PLAYER_LOGIN" )
f:RegisterEvent( "ADDON_LOADED" )
f:RegisterEvent( "ENCOUNTER_START" )
f:RegisterEvent( "ENCOUNTER_END" )
f:SetScript( "OnEvent", function( self, event, ... )
    if event == "PLAYER_LOGIN" or event == "ADDON_LOADED" then
        C_Timer.After( 2, function() BM:Initialize() end ) -- delay a bit to let boss mods load.
    elseif event == "ENCOUNTER_START" then
        -- Fresh encounter; clear stale bars from previous fight.
        BM:Reset()
    elseif event == "ENCOUNTER_END" then
        BM:Reset()
    end
end )
