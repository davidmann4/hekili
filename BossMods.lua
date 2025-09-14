local addon, ns = ...

local Hekili = _G.Hekili
if not Hekili then return end

-- Basic Boss Mod (DBM / BigWigs) timer harvesting for add spawn prediction.
-- This is a lightweight subset of WeakAuras' BossMods handler, tailored for Hekili's needs.

Hekili.BossMods = Hekili.BossMods or {}
local BM = Hekili.BossMods

BM.bars = BM.bars or {}   -- [id] = { message/text, spellId, expires, duration, paused, remaining }
BM.sources = BM.sources or {} -- Optional source info.
BM.scheduled = BM.scheduled or {} -- Array of { t, id, instanceKey, text, spellId, offset, encounterId }

local function Now() return GetTime() end

-- Build a stable per-instance key: id:startTime
local function InstanceKey( id, start )
    return tostring( id ) .. ":" .. format( '%.2f', start or 0 )
end

-- Purge scheduled events that are in the past (keep a tiny grace to avoid churn).
local function PurgeScheduled()
    local now = Now()
    local i = 1
    while i <= #BM.scheduled do
        if BM.scheduled[i].t <= now - 0.25 then
            table.remove( BM.scheduled, i )
        else
            i = i + 1
        end
    end
end

-- Try to compile encounter filters; returns compiled array or nil.
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

-- Purge expired bars.  We optionally retain bars for up to `retain` seconds after
-- they expire so we can still apply positive offsets (e.g., bar ends then adds
-- spawn 5s later).  Negative offsets don't need retention since the adjusted
-- event occurs before the bar expires.
local function PurgeExpired( retain )
    retain = retain or 0
    if retain < 0 then retain = 0 end
    local now = Now()
    for id, bar in pairs( BM.bars ) do
        if not bar.paused then
            -- Keep until (expires + retain) has passed.
            if bar.expires + retain <= now then
                BM.bars[ id ] = nil
            end
        else
            if ( bar.remaining or 0 ) <= 0 then
                BM.bars[ id ] = nil
            end
        end
    end
end

function BM:Reset()
    wipe( self.bars )
    wipe( self.scheduled )
end

-- After enhancement: filters compiled to { kind = 'id'|'text', value=..., offset=seconds }
function BM:GetNextMatching( filters )
    if not filters or #filters == 0 then return nil end

    -- Determine the maximum positive offset so we can retain expired bars just long enough
    -- to allow their offset-adjusted events to elapse naturally.
    local maxPosOffset = 0
    for i = 1, #filters do
        local o = filters[i].offset or 0
        if o > maxPosOffset then maxPosOffset = o end
    end

    PurgeExpired( maxPosOffset )

    local now = Now()
    local best

    for id, bar in pairs( self.bars ) do
        local baseRemaining = bar.paused and ( bar.remaining or ( bar.expires - now ) ) or ( bar.expires - now )
        -- Skip bars that are older than the maximum positive offset window (no longer informative).
        if baseRemaining > -maxPosOffset then
            -- If this is a freshly restarted bar and we have a clone tail (id:timestamp) for the previous instance,
            -- make sure we don't immediately favor the new long bar over the tail whose adjusted event is still pending.
            -- We'll detect clones by searching for id .. ':' prefixes; if any clone yields an adjusted time <= 0, we can clamp at 0.
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
                        -- Event time has passed (or is now); clamp at 0.
                        if not best or 0 < best then best = 0 end
                    end
                    break
                end
            end
        end
    end
    return best
end

function BM:GetNextAddSpawn( encounterID )
    if not encounterID or encounterID == 0 then return nil end
    local profile = Hekili.DB and Hekili.DB.profile
    if not profile then return nil end
    local e = profile.raidEvents and profile.raidEvents.adds and profile.raidEvents.adds.encounters and profile.raidEvents.adds.encounters[ encounterID ]
    if not e then return nil end
    local filters = CompileFilters( e )
    if not filters or #filters == 0 then return nil end

    -- Prefer scheduled events over scanning live bars; this makes offsets robust across restarts.
    PurgeScheduled()
    local now = Now()
    local best
    for i = 1, #BM.scheduled do
        local ev = BM.scheduled[i]
        if tonumber( ev.encounterId ) == tonumber( encounterID ) then
            local remain = ev.t - now
            if remain <= 0 then
                best = 0
                break
            end
            if not best or remain < best then best = remain end
        end
    end
    if best ~= nil then return best end

    -- Fallback to scanning bars if nothing is scheduled yet (e.g., reload mid-fight).
    return self:GetNextMatching( filters )
end

-- Schedule events for a given bar instance if it matches encounter filters.
local function ScheduleForBar( id, bar )
    local profile = Hekili.DB and Hekili.DB.profile
    if not profile then return end
    local encounters = profile.raidEvents and profile.raidEvents.adds and profile.raidEvents.adds.encounters
    if type( encounters ) ~= 'table' then return end

    local text = ( bar.message or bar.text or "" ):lower()
    local spellId = bar.spellId and tonumber( bar.spellId ) or nil

    for encId, e in pairs( encounters ) do
        local filters = CompileFilters( e )
        if filters and #filters > 0 then
            for _, f in ipairs( filters ) do
                local match
                if f.kind == 'id' then
                    match = ( spellId == f.value )
                else
                    match = ( f.value ~= '' and text:find( f.value, 1, true ) ~= nil )
                end
                if match then
                    local t = ( bar.expires or Now() ) + ( f.offset or 0 )
                    BM.scheduled[ #BM.scheduled + 1 ] = {
                        t = t,
                        id = id,
                        instanceKey = bar.instanceKey,
                        text = bar.message or bar.text,
                        spellId = spellId,
                        offset = f.offset or 0,
                        encounterId = encId,
                    }
                    break -- only first matching token per bar for this encounter
                end
            end
        end
    end
end

-- If a bar instance updates (duration/elapsed), update corresponding scheduled time(s).
local function RescheduleForBar( bar )
    if not bar or not bar.instanceKey then return end
    for i = 1, #BM.scheduled do
        local ev = BM.scheduled[i]
        if ev.instanceKey == bar.instanceKey then
            ev.t = ( bar.expires or Now() ) + ( ev.offset or 0 )
        end
    end
end

-- DBM Integration
local function InitDBM()
    if not DBM or BM.DBMInitialized then return end
    BM.DBMInitialized = true
    DBM:RegisterCallback( "DBM_TimerBegin", function( _, timerId, msg, duration, icon, timerType, spellId, dbmType, _, _, _, _, timerCount )
        -- replaced by shared handler below
    end ) -- kept temporarily for backward compatibility; immediately overridden below.
    -- Unified handler for both DBM_TimerBegin and DBM_TimerStart to avoid duplicated logic.
    local function HandleDBMTimer( eventName, timerId, msg, duration, icon, timerType, spellId, dbmType, _a, _b, _c, _d, timerCount )
        if not timerId then return end
        local now = Now()
        local existing = BM.bars[ timerId ]
        if existing and not existing.paused then
            -- Clone previous instance so its offset tail can finish, even if the new bar starts right before/at expiry.
            local cloneId = tostring( timerId ) .. ":" .. format( '%.2f', existing.expires )
            if not BM.bars[ cloneId ] then
                local clone = {}
                for k, v in pairs( existing ) do clone[ k ] = v end
                BM.bars[ cloneId ] = clone
            end
        end
        BM.bars[ timerId ] = BM.bars[ timerId ] or {}
        local bar = BM.bars[ timerId ]
        bar.message = msg
        bar.text = msg
        bar.duration = duration
        bar.start = now
        bar.expires = now + ( duration or 0 )
        bar.icon = icon
        bar.timerType = timerType
        -- Preserve existing spellId if new one is nil (older callback variants sometimes omit).
        bar.spellId = spellId and tostring( spellId ) or bar.spellId
        -- If a count is provided (TimerBegin) use it; otherwise ensure at least 1.
        bar.count = timerCount or bar.count or 1
        bar.paused = false
        bar.remaining = nil
        bar.instanceKey = InstanceKey( timerId, bar.start )

        ScheduleForBar( timerId, bar )
    end

    -- Re-register both events with the unified handler (overrides earlier TimerBegin registration above).
    for _, evt in ipairs( { "DBM_TimerBegin", "DBM_TimerStart" } ) do
        DBM:RegisterCallback( evt, HandleDBMTimer )
    end
    DBM:RegisterCallback( "DBM_TimerStop", function( _, timerId )
        if timerId and BM.bars[ timerId ] then
            local bar = BM.bars[ timerId ]
            if bar and bar.instanceKey then
                -- Remove scheduled events for this bar instance only.
                local i = 1
                while i <= #BM.scheduled do
                    if BM.scheduled[i].instanceKey == bar.instanceKey then table.remove( BM.scheduled, i ) else i = i + 1 end
                end
            end
            BM.bars[ timerId ] = nil
        end
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
            if not bar.start then bar.start = bar.expires - total end
            if not bar.instanceKey then bar.instanceKey = InstanceKey( timerId, bar.start ) end
            RescheduleForBar( bar )
        end
    end )
end

-- BigWigs Integration
local function InitBigWigs()
    if not BigWigsLoader or BM.BigWigsInitialized then return end
    BM.BigWigsInitialized = true
    -- BigWigs_StartBar(event, module, key, text, time, icon)
    BigWigsLoader.RegisterMessage( BM, "BigWigs_StartBar", function( _, module, key, text, time, icon )
        if not text then return end
        local id = key or text
        local now = Now()
        local existing = BM.bars[ id ]
        if existing and not existing.paused then
            -- Clone previous instance so its offset tail can finish, even if the new bar starts right before/at expiry.
            local cloneId = tostring( id ) .. ":" .. format( '%.2f', existing.expires )
            if not BM.bars[ cloneId ] then
                local clone = {}
                for k, v in pairs( existing ) do clone[ k ] = v end
                BM.bars[ cloneId ] = clone
            end
        end
        BM.bars[ id ] = BM.bars[ id ] or {}
        local bar = BM.bars[ id ]
        bar.text = text
        bar.message = text
        bar.duration = time
        bar.start = now
        bar.expires = now + ( time or 0 )
        bar.icon = icon
        local nkey = tonumber( key )
        bar.spellId = nkey and tostring( nkey ) or bar.spellId
        bar.count = 1
        bar.paused = false
        bar.remaining = nil
        bar.instanceKey = InstanceKey( id, bar.start )

        ScheduleForBar( id, bar )
    end )
    BigWigsLoader.RegisterMessage( BM, "BigWigs_StopBar", function( _, module, key )
        if key and BM.bars[ key ] then
            local bar = BM.bars[ key ]
            if bar and bar.instanceKey then
                local i = 1
                while i <= #BM.scheduled do
                    if BM.scheduled[i].instanceKey == bar.instanceKey then table.remove( BM.scheduled, i ) else i = i + 1 end
                end
            end
            BM.bars[ key ] = nil
        end
    end )
    BigWigsLoader.RegisterMessage( BM, "BigWigs_PauseBar", function( _, module, key )
        local bar = key and BM.bars[ key ]
        if bar and not bar.paused then
            bar.paused = true
            bar.remaining = bar.expires - Now()
        end
    end )
    BigWigsLoader.RegisterMessage( BM, "BigWigs_ResumeBar", function( _, module, key )
        local bar = key and BM.bars[ key ]
        if bar and bar.paused then
            bar.paused = false
            if bar.remaining and bar.remaining > 0 then
                bar.expires = Now() + bar.remaining
            end
            bar.remaining = nil
            RescheduleForBar( bar )
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
