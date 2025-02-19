-- RogueAssassination.lua
-- July 2024

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State

local spec = Hekili:NewSpecialization( 259 )

-- Resources
spec:RegisterResource( Enum.PowerType.Energy )
spec:RegisterResource( Enum.PowerType.ComboPoints )

spec:RegisterTalents( {
    -- Rogue Talents
    acrobatic_strikes      = { 90752, 455143, 1 }, -- Auto-attacks increase auto-attack damage and movement speed by ${$s1/10}.1% for $455144d, stacking up to ${$s1/10*$455144u}%.
    airborne_irritant      = { 90741, 200733, 1 }, -- Blind has $s1% reduced cooldown, $s2% reduced duration, and applies to all nearby enemies.
    alacrity               = { 90751, 193539, 2 }, -- Your finishing moves have a $s2% chance per combo point to grant $193538s1% Haste for $193538d, stacking up to $193538u times.
    atrophic_poison        = { 90763, 381637, 1 }, -- Coats your weapons with a Non-Lethal Poison that lasts for $d. Each strike has a $h% chance of poisoning the enemy, reducing their damage by ${$392388s1*-1}.1% for $392388d.
    blackjack              = { 90686, 379005, 1 }, -- Enemies have $394119s1% reduced damage and healing for $394119d after Blind or Sap's effect on them ends.
    blind                  = { 90684, 2094  , 1 }, -- Blinds $?a200733[all enemies near ][]the target, causing $?a200733[them][it] to wander disoriented for $d. Damage will interrupt the effect. Limit 1.
    cheat_death            = { 90742, 31230 , 1 }, -- Fatal attacks instead reduce you to $s2% of your maximum health. For $45182d afterward, you take $45182s1% reduced damage. Cannot trigger more often than once per $45181d.
    cloak_of_shadows       = { 90697, 31224 , 1 }, -- Provides a moment of magic immunity, instantly removing all harmful spell effects. The cloak lingers, causing you to resist harmful spells for $d.
    cold_blood             = { 90748, 382245, 1 }, -- Increases the critical strike chance of your next damaging ability by $s1%.
    deadened_nerves        = { 90743, 231719, 1 }, -- Physical damage taken reduced by $s1%.; 
    deadly_precision       = { 90760, 381542, 1 }, -- Increases the critical strike chance of your attacks that generate combo points by $s1%.
    deeper_stratagem       = { 90750, 193531, 1 }, -- Gain $s1 additional max combo point.; Your finishing moves that consume more than $s3 combo points have increased effects, and your finishing moves deal $s4% increased damage.
    echoing_reprimand      = { 90639, 385616, 1 }, -- Deal $s1 Physical damage to an enemy, extracting their anima to Animacharge a combo point for $323558d.; Damaging finishing moves that consume the same number of combo points as your Animacharge function as if they consumed $s2 combo points.; Awards $s3 combo $lpoint:points;.; 
    elusiveness            = { 90742, 79008 , 1 }, -- Evasion also reduces damage taken by $s2%, and Feint also reduces non-area-of-effect damage taken by $s1%.
    evasion                = { 90764, 5277  , 1 }, -- Increases your dodge chance by ${$s1/2}% for $d.$?a344363[ Dodging an attack while Evasion is active will trigger Mastery: Main Gauche.][]
    featherfoot            = { 94563, 423683, 1 }, -- Sprint increases movement speed by an additional $s1% and has ${$s2/1000} sec increased duration.
    fleet_footed           = { 90762, 378813, 1 }, -- Movement speed increased by $s1%.
    gouge                  = { 90741, 1776  , 1 }, -- Gouges the eyes of an enemy target, incapacitating for $d. Damage will interrupt the effect.; Must be in front of your target.; Awards $s2 combo $lpoint:points;.
    graceful_guile         = { 94562, 423647, 1 }, -- Feint has $m1 additional $Lcharge:charges;.; 
    improved_ambush        = { 90692, 381620, 1 }, -- $?s185438[Shadowstrike][Ambush] generates $s1 additional combo point.
    improved_sprint        = { 90746, 231691, 1 }, -- Reduces the cooldown of Sprint by ${$m1/-1000} sec.
    improved_wound_poison  = { 90637, 319066, 1 }, -- Wound Poison can now stack $s1 additional times.
    iron_stomach           = { 90744, 193546, 1 }, -- Increases the healing you receive from Crimson Vial, healing potions, and healthstones by $s1%.
    leeching_poison        = { 90758, 280716, 1 }, -- Adds a Leeching effect to your Lethal poisons, granting you $108211s1% Leech.
    lethality              = { 90749, 382238, 2 }, -- Critical strike chance increased by $s1%. Critical strike damage bonus of your attacks that generate combo points increased by $s2%.
    master_poisoner        = { 90636, 378436, 1 }, -- Increases the non-damaging effects of your weapon poisons by $s1%.
    nimble_fingers         = { 90745, 378427, 1 }, -- Energy cost of Feint and Crimson Vial reduced by $s1.
    numbing_poison         = { 90763, 5761  , 1 }, -- Coats your weapons with a Non-Lethal Poison that lasts for $d. Each strike has a $5761h% chance of poisoning the enemy, clouding their mind and slowing their attack and casting speed by $5760s1% for $5760d.
    recuperator            = { 90640, 378996, 1 }, -- Slice and Dice heals you for up to $s1% of your maximum health per $426605t sec.
    resounding_clarity     = { 90638, 381622, 1 }, -- Echoing Reprimand Animacharges $m1 additional combo $Lpoint:points;.
    reverberation          = { 90638, 394332, 1 }, -- Echoing Reprimand's damage is increased by $s1%.
    rushed_setup           = { 90754, 378803, 1 }, -- The Energy costs of Kidney Shot, Cheap Shot, Sap, and Distract are reduced by $s1%.
    shadowheart            = { 101714, 455131, 1 }, -- Leech increased by $s1% while Stealthed.; 
    shadowrunner           = { 90687, 378807, 1 }, -- While Stealth or Shadow Dance is active, you move $s1% faster.
    shadowstep             = { 90695, 36554 , 1 }, -- Description not found.
    shiv                   = { 90740, 5938  , 1 }, -- Attack with your $?s319032[poisoned blades][off-hand], dealing $sw1 Physical damage, dispelling all enrage effects and applying a concentrated form of your $?a3408[Crippling Poison, reducing movement speed by $115196s1% for $115196d.]?a5761[Numbing Poison, reducing casting speed by $359078s1% for $359078d.][]$?(!a3408&!a5761)[active Non-Lethal poison.][]$?(a319032&a400783)[; Your Nature and Bleed ]?a319032[; Your Nature ]?a400783[; Your Bleed ][]$?(a400783|a319032)[damage done to the target is increased by $319504s1% for $319504d.][]$?a354124[ The target's healing received is reduced by $354124S1% for $319504d.][]; Awards $s3 combo $lpoint:points;.
    soothing_darkness      = { 90691, 393970, 1 }, -- You are healed for ${$393971s1*($393971d/$393971t)}% of your maximum health over $393971d after gaining Vanish or Shadow Dance.
    stillshroud            = { 94561, 423662, 1 }, -- Shroud of Concealment has $s1% reduced cooldown.; 
    subterfuge             = { 90688, 108208, 2 }, -- Abilities and combat benefits requiring Stealth remain active for ${$s2/1000} sec after Stealth breaks.
    superior_mixture       = { 94567, 423701, 1 }, -- Crippling Poison reduces movement speed by an additional $s1%.
    thistle_tea            = { 90756, 381623, 1 }, -- Restore $s1 Energy. Mastery increased by ${$s2*$mas}.1% for $d.
    tight_spender          = { 90692, 381621, 1 }, -- Energy cost of finishing moves reduced by $s1%.
    tricks_of_the_trade    = { 90686, 57934 , 1 }, -- $?s221622[Increases the target's damage by $221622m1%, and redirects][Redirects] all threat you cause to the targeted party or raid member, beginning with your next damaging attack within the next $d and lasting $59628d.
    unbreakable_stride     = { 90747, 400804, 1 }, -- Reduces the duration of movement slowing effects $s1%.
    vigor                  = { 90759, 14983 , 2 }, -- Increases your maximum Energy by $s1 and Energy regeneration by $s2%.
    virulent_poisons       = { 90760, 381543, 1 }, -- Increases the damage of your weapon poisons by $s1%.
    without_a_trace        = { 101713, 382513, 1 }, -- Vanish has $s1 additional $lcharge:charges;.

    -- Assassination Talents
    amplifying_poison      = { 90621, 381664, 1 }, -- Coats your weapons with a Lethal Poison that lasts for $d. Each strike has a $h% chance to poison the enemy, dealing $383414s1 Nature damage and applying Amplifying Poison for $383414d. Envenom can consume $s2 stacks of Amplifying Poison to deal $s1% increased damage. Max $383414u stacks.
    arterial_precision     = { 90784, 400783, 1 }, -- Shiv strikes ${$s2-1} additional nearby enemies and increases your Bleed damage done to affected targets by $s1% for $319504d.
    bait_and_switch        = { 95106, 457034, 1 }, -- Evasion reduces magical damage taken by $5277s3%. ; Cloak of Shadows reduces physical damage taken by $31224s3%.
    blindside              = { 90786, 328085, 1 }, -- Ambush and Mutilate have a $s1% chance to make your next Ambush free and usable without Stealth. Chance increased to $s2% if the target is under $s3% health.
    bloody_mess            = { 90625, 381626, 1 }, -- Garrote and Rupture damage increased by $s1%.
    caustic_spatter        = { 94556, 421975, 1 }, -- Using Mutilate on a target afflicted by your Rupture and Deadly Poison applies Caustic Spatter for $421976d. Limit 1.; Caustic Spatter causes $421976s1% of your Poison damage dealt to splash onto other nearby enemies, reduced beyond $421976s2 targets.
    chosens_revelry        = { 95138, 454300, 1 }, -- Leech increased by ${$s1/100}.1% for each time your Fatebound Coin has flipped the same face in a row.
    clear_the_witnesses    = { 95110, 457053, 1 }, -- Your next $?c1[Fan of Knives][Shuriken Storm] after applying Deathstalker's Mark deals an additional $457179s1 Plague damage and generates $457178s1 additional combo point.
    corrupt_the_blood      = { 95108, 457066, 1 }, -- Rupture deals an additional $457133s2 Plague damage each time it deals damage, stacking up to $457133u times. Rupture duration increased by ${$s1/1000} sec.
    crimson_tempest        = { 90632, 121411, 1 }, -- Finishing move that slashes all enemies within $A1 yards, causing victims to bleed. Lasts longer per combo point.; Deals extra damage when multiple enemies are afflicted, increasing by $s4% per target, up to ${$s4*5}%.; Deals reduced damage beyond $s3 targets.;    1 point  : ${$o1*4} over ${$d+(2*1)} sec;    2 points: ${$o1*5} over ${$d+(2*2)} sec;    3 points: ${$o1*6} over ${$d+(2*3)} sec;    4 points: ${$o1*7} over ${$d+(2*4)} sec;    5 points: ${$o1*8} over ${$d+(2*5)} sec$?s193531[;    6 points: ${$o1*9} over ${$d+(2*6)} sec][]
    darkest_night          = { 95142, 457058, 1 }, -- When you consume the final Deathstalker's Mark from a target or your target dies, gain $457280s1 Energy and your next $?c1[Envenom][Eviscerate] cast with maximum combo points is guaranteed to critically strike, deals $457280s2% additional damage, and applies $457280s3 stacks of Deathstalker's Mark to the target.
    dashing_scoundrel      = { 90766, 381797, 1 }, -- Envenom also increases the critical strike chance of your weapon poisons by $s1%, and their critical strikes generate $s2 Energy.
    deadly_poison          = { 90783, 2823  , 1 }, -- Coats your weapons with a Lethal Poison that lasts for $d. Each strike has a $h% chance to poison the enemy for ${$2818m1*$2818d/$2818t1} Nature damage over $2818d. Subsequent poison applications will instantly deal $113780s1 Nature damage.
    deal_fate              = { 95107, 454419, 1 }, -- $?a137037[Mutilate, Ambush, Fan of Knives][Sinister Strike]$?a383281[ and Ambush][] generate$?a137037[]$?a383281[] $454421s1 additional combo point $?a137037[when they trigger Seal Fate]?383281[when they strike an additional time][when they strike an additional time].
    deathmark              = { 90769, 360194, 1 }, -- Carve a deathmark into an enemy, dealing $o1 Bleed damage over $d. While marked your Garrote, Rupture, and Lethal poisons applied to the target are duplicated, dealing $?a134735[${100+$394331s1+$394331s3}%][${100+$394331s1}%] of normal damage.
    deaths_arrival         = { 95130, 454433, 1 }, -- $?a137037[Shadowstep][Grappling Hook] may be used a second time within $457333d, with no cooldown. 
    deathstalkers_mark     = { 95136, 457052, 1 }, -- $?c1[Ambush][Shadowstrike] from Stealth$?c3[ or Shadow Dance][] applies $s1 stacks of Deathstalker's Mark to your target. When you spend $s2 or more combo points on attacks against a Marked target you consume an application of Deathstalker's Mark, dealing $457157s1 Plague damage and increasing the damage of your next $?c1[Ambush or Mutilate]?s200758[Gloomblade or Shadowstrike][Backstab or Shadowstrike] by $457160s1%.; You may only have one target Marked at a time.
    delivered_doom         = { 95119, 454426, 1 }, -- Damage dealt when your Fatebound Coin flips tails is increased by $s1% if there are no other enemies near the target.
    destiny_defined        = { 95114, 454435, 1 }, -- $?a137037[Weapon poisons have $s1% increased application chance][Sinister Strike has $s2% increased chance to strike an additional time] and your Fatebound Coins flipped have an additional $s3% chance to match the same face as the last flip. 
    doomblade              = { 90777, 381673, 1 }, -- Mutilate deals an additional $s1% Bleed damage over ${$381672d+2} sec.
    double_jeopardy        = { 95129, 454430, 1 }, -- Your first Fatebound Coin flip after breaking Stealth flips two coins that are guaranteed to match the same face.
    dragontempered_blades  = { 94553, 381801, 1 }, -- You may apply $s1 additional Lethal and Non-Lethal Poison to your weapons, but they have $s2% less application chance.
    edge_case              = { 95139, 453457, 1 }, -- Activating $?a137036[Adrenaline Rush][Deathmark] causes your next Fatebound Coin flip to land on its edge, counting as both Heads and Tails.
    ethereal_cloak         = { 95106, 457022, 1 }, -- Cloak of Shadows duration increased by ${$s1/1000} sec.
    fatal_concoction       = { 90626, 392384, 1 }, -- Increases the damage of your weapon poisons by $s1%.
    fatal_intent           = { 95135, 461980, 1 }, -- Your damaging abilities against enemies above $M3% health have a very high chance to apply Fatal Intent. When an enemy falls below $M3% health, Fatal Intent inflicts ${$s1*(1+$@versadmg)} Plague damage per stack.
    fate_intertwined       = { 95120, 454429, 1 }, -- Fate Intertwined duplicates $s1% of $?a137037[Envenom][Dispatch] critical strike damage as Cosmic to $s2 additional nearby enemies. If there are no additional nearby targets, duplicate $s1% to the primary target instead.
    fateful_ending         = { 95127, 454428, 1 }, -- When your Fatebound Coin flips the same face for the seventh time in a row, keep the lucky coin to gain $452562s1% Agility until you leave combat for $s2 seconds. If you already have a lucky coin, it instead deals $461818s1 Cosmic damage to your target.
    flying_daggers         = { 94554, 381631, 1 }, -- Fan of Knives has its radius increased to $?a196924[${$196924s1+$s4}][$s4] yds, deals $s5% more damage, and an additional $s1% when striking $s2 or more targets.
    follow_the_blood       = { 95131, 457068, 1 }, -- $?s51723[Fan of Knives]$?s197835[Shuriken Storm] and $?s121411[Crimson Tempest]$?s319175[Black Powder] deal $s1% additional damage while $s2 or more enemies are afflicted with Rupture.
    hand_of_fate           = { 95125, 452536, 1 }, -- Flip a Fatebound Coin each time a finishing move consumes $s1 or more combo points. Heads increases the damage of your attacks by $456479s1%, lasting $452923d or until you flip Tails. Tails deals $452538s1 Cosmic damage to your target.; For each time the same face is flipped in a row, Heads increases damage by an additional $452923s1% and Tails increases its damage by $452917s1%.
    hunt_them_down         = { 95132, 457054, 1 }, -- Auto-attacks against Marked targets deal an additional $457193s1 Plague damage.
    improved_garrote       = { 90780, 381632, 1 }, -- Garrote deals $s1% increased damage and has no cooldown when used from Stealth and for $392401d after breaking Stealth.
    improved_poisons       = { 90634, 381624, 1 }, -- Increases the application chance of your weapon poisons by $s1%.
    improved_shiv          = { 90628, 319032, 1 }, -- Shiv now also increases your Nature damage done against the target by $319504s1% for $319504d.
    indiscriminate_carnage = { 90774, 381802, 1 }, -- Garrote and Rupture apply to ${$m1-1} additional nearby $Lenemy:enemies; when used from Stealth and for $385747d after breaking Stealth.
    inevitability          = { 95114, 454434, 1 }, -- Cold Blood now benefits the next two abilities but only applies to $?a137037[Envenom][Dispatch]. Fatebound Coins flipped by these abilities are guaranteed to match the same face as the last flip.
    inexorable_march       = { 95130, 454432, 1 }, -- You cannot be slowed below $s1% of normal movement speed while your Fatebound Coin flips have an active streak of at least $s2 flips matching the same face.
    intent_to_kill         = { 94555, 381630, 1 }, -- Shadowstep's cooldown is reduced by $s1% when used on a target afflicted by your Garrote.
    internal_bleeding      = { 94556, 381627, 1 }, -- Kidney Shot and Rupture also apply Internal Bleeding, dealing up to ${5*$154953o1} Bleed damage over $154953d, based on combo points spent.
    iron_wire              = { 94555, 196861, 1 }, -- Garrote silences the target for $s2 sec when used from Stealth.; Enemies silenced by Garrote deal $256148s1% reduced damage for $256148d.
    kingsbane              = { 94552, 385627, 1 }, -- Release a lethal poison from your weapons and inject it into your target, dealing $s2 Nature damage instantly and an additional $o4 Nature damage over $d. ; Each time you apply a Lethal Poison to a target affected by Kingsbane, Kingsbane damage increases by $394095s1%, up to ${$394095s1*$394095u}%.; Awards $s6 combo $lpoint:points;.
    lethal_dose            = { 90624, 381640, 2 }, -- Your weapon poisons, Nature damage over time, and Bleed abilities deal $s1% increased damage to targets for each weapon poison, Nature damage over time, and Bleed effect on them.
    lightweight_shiv       = { 90633, 394983, 1 }, -- Shiv deals $s2% increased damage and has $m1 additional $Lcharge:charges;.
    lingering_darkness     = { 95109, 457056, 1 }, -- After $?c1[Deathmark][Shadow Blades] expires, gain $457273d of $457273s1% increased $?c1[Nature][Shadow] damage.
    master_assassin        = { 90623, 255989, 1 }, -- Critical strike chance increased by $256735s1% while Stealthed and for $s1 sec after breaking Stealth.
    mean_streak            = { 95122, 453428, 1 }, -- Fatebound Coins flipped by $?a137036[Dispatch][Envenom] multiple times in a row are $s1% more likely to match the same face as the last flip.
    momentum_of_despair    = { 95131, 457067, 1 }, -- If you have critically struck with $?s51723[Fan of Knives]$?s197835[Shuriken Storm], increase the critical strike chance of $?s51723[Fan of Knives]$?s197835[Shuriken Storm] and $?s121411[Crimson Tempest]$?s319175[Black Powder] by $457115s1% for $457115d.
    path_of_blood          = { 94536, 423054, 1 }, -- Increases maximum Energy by $s1.
    poison_bomb            = { 90767, 255544, 2 }, -- Envenom has a $<chance>% chance per combo point spent to smash a vial of poison at the target's location, creating a pool of acidic death that deals ${$255546s1*$s2} Nature damage over $255545d to all enemies within it.
    rapid_injection        = { 94557, 455072, 1 }, -- Envenom deals $s1% increased damage while your Envenom buff is active.
    sanguine_blades        = { 90779, 200806, 1 }, -- While above $s1% of maximum Energy your Garrote, Rupture, and Crimson Tempest consume $s2 Energy to duplicate $s3% of any damage dealt.
    sanguine_stratagem     = { 94554, 457512, 1 }, -- Gain $s1 additional max combo point.; Your finishing moves that consume more than $s3 combo points have increased effects, and your finishing moves deal $s4% increased damage.
    scent_of_blood         = { 90775, 381799, 2 }, -- Each enemy afflicted by your Rupture increases your Agility by $S1%, up to a maximum of $394080u%.
    seal_fate              = { 90757, 14190 , 1 }, -- Critical strikes with attacks that generate combo points grant an additional combo point per critical strike.
    serrated_bone_spikes   = { 90622, 455352, 1 }, -- Prepare a Serrated Bone Spike every $s1 sec, stacking up to $455366u. Rupture spends a stack to embed a bone spike in its target.; $@spellicon385424 $@spellname385424:; Deals $385424s1 Physical damage and $394036s1 Bleed damage every $394036t1 sec until the target dies or leaves combat.; Refunds a stack when the target dies.; Awards 1 combo point plus 1 additional per active bone spike.
    shadewalker            = { 95123, 457057, 1 }, -- Each time you consume a stack of Deathstalker's Mark, reduce the cooldown of Shadowstep by ${$s1/-1000} sec.
    shroud_of_night        = { 95123, 457063, 1 }, -- Shroud of Concealment duration increased by ${$s1/1000} sec.
    shrouded_suffocation   = { 90776, 385478, 1 }, -- Garrote damage increased by $s1%. Garrote generates $s2 additional combo points when used from Stealth.
    singular_focus         = { 95117, 457055, 1 }, -- Damage dealt to targets other than your Marked target deals $s1% Plague damage to your Marked target.; 
    sudden_demise          = { 94551, 423136, 1 }, -- Bleed damage increased by $s1%.; Targets below $s3% health instantly bleed out and take fatal damage when the remaining Bleed damage you would deal to them exceeds $s2% of their remaining health.
    symbolic_victory       = { 95109, 457062, 1 }, -- $?a137037 [Shiv][Symbols of Death] additionally increases the damage of your next $?a137037 [Envenom][Eviscerate or Black Powder] by $s1%.
    systemic_failure       = { 90771, 381652, 1 }, -- Garrote increases the damage of Ambush and Mutilate on the target by $s1%.
    tempted_fate           = { 95138, 454286, 1 }, -- You have a chance equal to your critical strike chance to absorb $s1% of any damage taken, up to a maximum chance of $s2%.
    thrown_precision       = { 90630, 381629, 1 }, -- Fan of Knives has $s2% increased critical strike chance and its critical strikes always apply your weapon poisons.
    tiny_toxic_blade       = { 90770, 381800, 1 }, -- Shiv deals $s1% increased damage and no longer costs Energy.
    twist_the_knife        = { 90768, 381669, 1 }, -- Envenom duration increased by ${$s1/1000} sec.
    venomous_wounds        = { 90635, 79134 , 1 }, -- You regain $s2 Energy each time your Garrote or Rupture deal Bleed damage to a poisoned target.; If an enemy dies while afflicted by your Rupture, you regain energy based on its remaining duration.
    vicious_venoms         = { 90772, 381634, 2 }, -- Ambush and Mutilate cost $s2 more Energy and deal $s1% additional damage as Nature.
    zoldyck_recipe         = { 90785, 381798, 2 }, -- Your Poisons and Bleeds deal $s1% increased damage to targets below $s2% health.
} )

-- PvP Talents
spec:RegisterPvpTalents( {
    control_is_king    = 5530, -- (354406) Cheap Shot grants Slice and Dice for $s1 sec and Kidney Shot restores $s2 Energy per combo point spent.
    creeping_venom     = 141 , -- (354895) Your Envenom applies Creeping Venom, reducing the target's movement speed by $354896s1% for $354896d.  Creeping Venom is reapplied when the target moves. Max $354896u stacks.
    dagger_in_the_dark = 5550, -- (198675) Each second while Stealth is active, nearby enemies within $198688A1 yards take an additional $198688s1% damage from you for $198688d. Stacks up to $198688u times.
    death_from_above   = 3479, -- (269513) Finishing move that empowers your weapons with energy to performs a deadly attack.; You leap into the air and $?s32645[Envenom]?s2098[Dispatch][Eviscerate] your target on the way back down, with such force that it has a $269512s2% stronger effect.
    dismantle          = 5405, -- (207777) Disarm the enemy, preventing the use of any weapons or shield for $d.
    hemotoxin          = 830 , -- (354124) Shiv also reduces the target's healing received by $S1% for $319504d.
    maneuverability    = 3448, -- (197000) Sprint has $s1% reduced cooldown and $s2% reduced duration.
    smoke_bomb         = 3480, -- (212182) Creates a cloud of thick smoke in an $m2 yard radius around the Rogue for $d. Enemies are unable to target into or out of the smoke cloud. 
    system_shock       = 147 , -- (198145) Casting Envenom with at least 5 combo points on a target afflicted by your Garrote, Rupture, and lethal poison deals $198222s1 Nature damage, and reduces their movement speed by $198222m2% for $198222d.
    thick_as_thieves   = 5408, -- (221622) Tricks of the Trade now increases the friendly target's damage by $m1% for $59628d.
    veil_of_midnight   = 5517, -- (198952) Cloak of Shadows now also removes harmful physical effects.
} )

-- Auras
spec:RegisterAuras( {
    -- Auto-attack damage and movement speed increased by ${$W}.1%.
    acrobatic_strikes = {
        id = 455144,
        duration = 3.0,
        max_stack = 1,
    },
    -- Haste increased by $w1%.
    alacrity = {
        id = 193538,
        duration = 15.0,
        max_stack = 1,
    },
    -- Envenom consumes stacks to amplify its damage.
    amplifying_poison = {
        id = 383414,
        duration = 12.0,
        max_stack = 1,

        -- Affected by:
        -- envenom[32645] #6: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- virulent_poisons[381543] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- destiny_defined[454435] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- dragontempered_blades[381801] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -30.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- fatal_concoction[392384] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- improved_poisons[381624] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- shiv[319504] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },
    -- Damage reduced by ${$W1*-1}.1%.
    atrophic_poison = {
        id = 392388,
        duration = 10.0,
        max_stack = 1,

        -- Affected by:
        -- master_poisoner[378436] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- destiny_defined[454435] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- dragontempered_blades[381801] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -30.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- improved_poisons[381624] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
    },
    -- $w1% reduced damage and healing.
    blackjack = {
        id = 394119,
        duration = 6.0,
        max_stack = 1,
    },
    -- Disoriented.
    blind = {
        id = 2094,
        duration = 60.0,
        max_stack = 1,

        -- Affected by:
        -- airborne_irritant[200733] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- airborne_irritant[200733] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -70.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
    },
    -- $w1% of Poison damage taken from $@auracaster splashes onto other nearby enemies.
    caustic_spatter = {
        id = 421976,
        duration = 10.0,
        max_stack = 1,
    },
    -- Stunned.
    cheap_shot = {
        id = 1833,
        duration = 4.0,
        max_stack = 1,

        -- Affected by:
        -- rushed_setup[378803] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -20.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
    },
    -- All damage taken reduced by $s1%.
    cheating_death = {
        id = 45182,
        duration = 3.0,
        max_stack = 1,
    },
    -- Resisting all harmful spells.$?a457034[ Physical damage taken reduced by $w3%.][]
    cloak_of_shadows = {
        id = 31224,
        duration = 5.0,
        max_stack = 1,

        -- Affected by:
        -- ethereal_cloak[457022] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 2000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
    },
    -- Critical strike chance of your next damaging ability increased by $s1%.
    cold_blood = {
        id = 382245,
        duration = 3600,
        max_stack = 1,

        -- Affected by:
        -- inevitability[454434] #0: { 'type': APPLY_AURA, 'subtype': OVERRIDE_ACTIONBAR_SPELLS, 'spell': 456330, 'target': TARGET_UNIT_CASTER, }
    },
    -- $@auracaster's Rupture corrupts your blood, dealing $s2 Plague damage.
    corrupt_the_blood = {
        id = 457133,
        duration = 3600,
        max_stack = 1,
    },
    -- Movement slowed by $w1%. Moving while afflicted by Creeping Poison causes it to be reapplied.
    creeping_venom = {
        id = 354896,
        duration = 4.0,
        tick_time = 1.0,
        max_stack = 1,
    },
    -- Bleeding for $w1 damage every $t1 sec.
    crimson_tempest = {
        id = 121411,
        duration = 4.0,
        tick_time = 2.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- mastery_potent_assassin[76803] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_potent_assassin[76803] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- cold_blood[382245] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- deeper_stratagem[193531] #0: { 'type': APPLY_AURA, 'subtype': MOD_ADDITIONAL_POWER_COST, 'points': 1.0, 'value': 4, 'schools': ['fire'], 'target': TARGET_UNIT_CASTER, }
        -- deeper_stratagem[193531] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- deeper_stratagem[193531] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- tight_spender[381621] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -6.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- sanguine_stratagem[457512] #0: { 'type': APPLY_AURA, 'subtype': MOD_ADDITIONAL_POWER_COST, 'points': 1.0, 'value': 4, 'schools': ['fire'], 'target': TARGET_UNIT_CASTER, }
        -- sanguine_stratagem[457512] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- sanguine_stratagem[457512] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- sudden_demise[423136] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- momentum_of_despair[457115] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- shiv[319504] #2: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },
    -- Healing for ${$W1}.2% of maximum health every $t1 sec.
    crimson_vial = {
        id = 354494,
        duration = 4.0,
        max_stack = 1,

        -- Affected by:
        -- iron_stomach[193546] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- nimble_fingers[378427] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -10.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- drink_up_me_hearties[354425] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
    },
    -- Movement slowed by $w1%.
    crippling_poison = {
        id = 3409,
        duration = 12.0,
        max_stack = 1,

        -- Affected by:
        -- mastery_potent_assassin[76803] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_potent_assassin[76803] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- master_poisoner[378436] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- superior_mixture[423701] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'pvp_multiplier': 0.5, 'points': -10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- destiny_defined[454435] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- dragontempered_blades[381801] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -30.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- improved_poisons[381624] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
    },
    -- Being stalked by a rogue.; The rogue deals an additional $m1% damage.
    dagger_in_the_dark = {
        id = 198688,
        duration = 10.0,
        max_stack = 1,
    },
    -- Your next $?c1[Envenom][Eviscerate] cast with maximum combo points is guaranteed to critically strike, deal $w2% additional damage, and apply $w3 stacks of Deathstalker's Mark to the target.
    darkest_night = {
        id = 457280,
        duration = 30.0,
        max_stack = 1,
    },
    -- Each strike has a chance of causing the target to suffer Nature damage every $2818t1 sec for $2818d. Subsequent poison applications deal instant Nature damage.
    deadly_poison = {
        id = 2823,
        duration = 3600.0,
        max_stack = 1,

        -- Affected by:
        -- mastery_potent_assassin[76803] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_potent_assassin[76803] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- envenom[32645] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- envenom[32645] #6: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- virulent_poisons[381543] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- virulent_poisons[381543] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- destiny_defined[454435] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- dragontempered_blades[381801] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -30.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- fatal_concoction[392384] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fatal_concoction[392384] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- improved_poisons[381624] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- shiv[319504] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- toxic_blade[245389] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'pvp_multiplier': 0.666667, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },
    -- Bleeding for $w damage every $t sec. Duplicating $@auracaster's Garrote, Rupture, and Lethal poisons applied.
    deathmark = {
        id = 360194,
        duration = 16.0,
        tick_time = 2.0,
        max_stack = 1,

        -- Affected by:
        -- sudden_demise[423136] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shiv[319504] #2: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },
    -- Detecting traps.
    detect_traps = {
        id = 2836,
        duration = 0.0,
        max_stack = 1,
    },
    -- Detecting certain creatures.
    detection = {
        id = 56814,
        duration = 30.0,
        max_stack = 1,
    },
    -- Disarmed.
    dismantle = {
        id = 207777,
        duration = 5.0,
        max_stack = 1,
    },
    -- Rogue's second combo point is Animacharged. ; Damaging finishing moves using exactly 2 combo points deal damage as if 7 combo points are consumed.
    echoing_reprimand = {
        id = 323558,
        duration = 45.0,
        max_stack = 1,

        -- Affected by:
        -- reverberation[394332] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },
    -- Poison application chance increased by $s2%.$?a455072[ Envenom damage increased by $s3%.][]$?s340081[; Poison critical strikes generate $340426s1 Energy.][]$?a393724[ Poison damage increased by $w7%][]
    envenom = {
        id = 32645,
        duration = 0.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- mastery_potent_assassin[76803] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- envenom[32645] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- assassination_rogue[137037] #19: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #20: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- cold_blood[382245] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- deeper_stratagem[193531] #0: { 'type': APPLY_AURA, 'subtype': MOD_ADDITIONAL_POWER_COST, 'points': 1.0, 'value': 4, 'schools': ['fire'], 'target': TARGET_UNIT_CASTER, }
        -- deeper_stratagem[193531] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- tight_spender[381621] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -6.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- dashing_scoundrel[381797] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
        -- rapid_injection[455072] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
        -- sanguine_stratagem[457512] #0: { 'type': APPLY_AURA, 'subtype': MOD_ADDITIONAL_POWER_COST, 'points': 1.0, 'value': 4, 'schools': ['fire'], 'target': TARGET_UNIT_CASTER, }
        -- sanguine_stratagem[457512] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twist_the_knife[381669] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 2000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- symbolic_victory[457167] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shiv[319504] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- outlaw_rogue[137036] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- outlaw_rogue[137036] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- master_assassin[256735] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- death_from_above[269512] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- death_from_above[269512] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.375, 'points': 40.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- death_from_above[269512] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 500.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
        -- death_from_above[269512] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- toxic_blade[245389] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'pvp_multiplier': 0.666667, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },
    -- Dodge chance increased by ${$w1/2}%.$?a344363[ Dodging an attack while Evasion is active will trigger Mastery: Main Gauche.][]$?a457034[ Magical damage taken reduced by $w3%.][]
    evasion = {
        id = 5277,
        duration = 10.0,
        max_stack = 1,

        -- Affected by:
        -- elusiveness[79008] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'sp_bonus': 0.25, 'points': -20.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
    },
    -- Falling below $461980M~3% health will cause Fatal Intent to inflict ${$461980s1*(1+$@versadmg)} Plague damage.
    fatal_intent = {
        id = 461981,
        duration = 60.0,
        max_stack = 1,
    },
    -- Fatebound Coin (Heads) bonus.
    fatebound_coin_heads = {
        id = 456479,
        duration = 3600.0,
        max_stack = 1,
    },
    -- Damage taken from area-of-effect attacks reduced by $s1%$?$w2!=0[ and all other damage taken reduced by $w2%.; ][.]
    feint = {
        id = 1966,
        duration = 6.0,
        max_stack = 1,

        -- Affected by:
        -- elusiveness[79008] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'sp_bonus': 0.25, 'points': -20.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- graceful_guile[423647] #0: { 'type': APPLY_AURA, 'subtype': MOD_MAX_CHARGES, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
        -- nimble_fingers[378427] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -10.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
    },
    -- Suffering $w1 damage every $t1 seconds.
    garrote = {
        id = 703,
        duration = 18.0,
        tick_time = 2.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- mastery_potent_assassin[76803] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_potent_assassin[76803] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- assassination_rogue[137037] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- assassination_rogue[137037] #19: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #20: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- stealth[1784] #4: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
        -- deadly_precision[381542] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- lethality[382238] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- bloody_mess[381626] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shrouded_suffocation[385478] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- sudden_demise[423136] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- vanish[11327] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- shiv[319504] #2: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- outlaw_rogue[137036] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- outlaw_rogue[137036] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- improved_garrote[392401] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- indiscriminate_carnage[385747] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': CHAINED_TARGETS, }
        -- indiscriminate_carnage[385747] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_DISTANCE, }
        -- master_assassin[256735] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
    },
    -- Incapacitated.
    gouge = {
        id = 1776,
        duration = 4.0,
        max_stack = 1,

        -- Affected by:
        -- lethality[382238] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
    },
    -- Garrote deals $w2% increased damage and has no cooldown.
    improved_garrote = {
        id = 392401,
        duration = 6.0,
        max_stack = 1,
    },
    -- Garrote and Rupture apply to additional nearby enemies.
    indiscriminate_carnage = {
        id = 385747,
        duration = 6.0,
        max_stack = 1,
    },
    -- Suffering $w1 Nature damage every $t1 seconds.
    instant_poison = {
        id = 315585,
        duration = 0.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- envenom[32645] #6: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- virulent_poisons[381543] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- virulent_poisons[381543] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- destiny_defined[454435] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- dragontempered_blades[381801] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -30.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- fatal_concoction[392384] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fatal_concoction[392384] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- improved_poisons[381624] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- shiv[319504] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- toxic_blade[245389] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'pvp_multiplier': 0.666667, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },
    -- Suffering $w1 damage every $t1 sec.
    internal_bleeding = {
        id = 154953,
        duration = 6.0,
        tick_time = 1.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- mastery_potent_assassin[76803] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_potent_assassin[76803] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- deeper_stratagem[193531] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- sanguine_stratagem[457512] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- sudden_demise[423136] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shiv[319504] #2: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },
    -- Damage done reduced by $s1%.
    iron_wire = {
        id = 256148,
        duration = 8.0,
        max_stack = 1,
    },
    -- Stunned.
    kidney_shot = {
        id = 408,
        duration = 1.0,
        max_stack = 1,

        -- Affected by:
        -- rushed_setup[378803] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -20.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- tight_spender[381621] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -6.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- stunning_secret[426588] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- stunning_secret[426588] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
    },
    -- Kingsbane Damage increased by $s1%.
    kingsbane = {
        id = 192853,
        duration = 20.0,
        max_stack = 1,
    },
    -- Leech increased by $s1%.
    leeching_poison = {
        id = 108211,
        duration = 3600,
        max_stack = 1,

        -- Affected by:
        -- envenom[32645] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- envenom[32645] #6: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #23: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- master_poisoner[378436] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
    },
    -- All $?c1[Nature][Shadow] damage dealt increased by $w1%.
    lingering_darkness = {
        id = 457273,
        duration = 30.0,
        max_stack = 1,
    },
    -- Agility increased by $w1%.
    lucky_coin = {
        id = 452562,
        duration = 3600,
        max_stack = 1,
    },
    -- Critical strike chance increased by $w1%.
    master_assassin = {
        id = 256735,
        duration = 3600,
        max_stack = 1,
    },
    -- Critical strike chance of $?s51723[Fan of Knives]$?s197835[Shuriken Storm] and $?s121411[Crimson Tempest]$?s319175[Black Powder] increased by $w1%.
    momentum_of_despair = {
        id = 457115,
        duration = 12.0,
        max_stack = 1,
    },
    -- Bleeding for $w1 damage every $t sec.
    mutilated_flesh = {
        id = 340431,
        duration = 6.0,
        tick_time = 3.0,
        max_stack = 1,
    },
    -- Attack and casting speed slowed by $s1%.
    numbing_poison = {
        id = 5760,
        duration = 10.0,
        max_stack = 1,

        -- Affected by:
        -- master_poisoner[378436] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- master_poisoner[378436] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- virulent_poisons[381543] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- destiny_defined[454435] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- dragontempered_blades[381801] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -30.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- fatal_concoction[392384] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- improved_poisons[381624] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
    },
    -- Increases the critical strike rating of your next Mutilate by $w3.
    poisoned_wire = {
        id = 276083,
        duration = 30.0,
        max_stack = 1,

        -- Affected by:
        -- mastery_potent_assassin[76803] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shiv[319504] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- toxic_blade[245389] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'pvp_multiplier': 0.666667, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },
    -- Reduces healing received from critical heals by $w1%.$?$w2>0[; Damage taken increased by $w2.][]
    pvp_rules_enabled_hardcoded = {
        id = 134735,
        duration = 20.0,
        max_stack = 1,
    },
    -- Bleeding for $w1 damage every $t1 sec.
    rupture = {
        id = 1943,
        duration = 4.0,
        tick_time = 2.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- mastery_potent_assassin[76803] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_potent_assassin[76803] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- assassination_rogue[137037] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- assassination_rogue[137037] #19: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #20: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- assassination_rogue[137037] #24: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- deeper_stratagem[193531] #0: { 'type': APPLY_AURA, 'subtype': MOD_ADDITIONAL_POWER_COST, 'points': 1.0, 'value': 4, 'schools': ['fire'], 'target': TARGET_UNIT_CASTER, }
        -- deeper_stratagem[193531] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- tight_spender[381621] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -6.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- bloody_mess[381626] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- corrupt_the_blood[457066] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 3000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- sanguine_stratagem[457512] #0: { 'type': APPLY_AURA, 'subtype': MOD_ADDITIONAL_POWER_COST, 'points': 1.0, 'value': 4, 'schools': ['fire'], 'target': TARGET_UNIT_CASTER, }
        -- sanguine_stratagem[457512] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- sudden_demise[423136] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shiv[319504] #2: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- outlaw_rogue[137036] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- outlaw_rogue[137036] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- indiscriminate_carnage[385747] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': CHAINED_TARGETS, }
        -- indiscriminate_carnage[385747] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_DISTANCE, }
        -- master_assassin[256735] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
    },
    -- Incapacitated.$?$w2!=0[; Damage taken increased by $w2%.][]
    sap = {
        id = 6770,
        duration = 60.0,
        max_stack = 1,

        -- Affected by:
        -- rushed_setup[378803] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -20.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
    },
    -- Your Ruptures are increasing your Agility by $W1%.
    scent_of_blood = {
        id = 394080,
        duration = 24.0,
        max_stack = 1,
    },
    -- Prepared a Serrated Bone Spike.
    serrated_bone_spike = {
        id = 455366,
        duration = 3600,
        max_stack = 1,
    },
    -- Energy cost of abilities reduced by $w1%.
    shadow_focus = {
        id = 112942,
        duration = 3600,
        max_stack = 1,
    },
    -- Movement speed increased by $s2%.
    shadowstep = {
        id = 36554,
        duration = 2.0,
        max_stack = 1,

        -- Affected by:
        -- shadowstep[394932] #0: { 'type': APPLY_AURA, 'subtype': MOD_MAX_CHARGES, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
        -- shadowstep[394931] #0: { 'type': APPLY_AURA, 'subtype': MOD_MAX_CHARGES, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
    },
    -- $w1% increased Nature $?a400783[and Bleed ][]damage taken from $@auracaster.$?${$W2<0}[ Healing received reduced by $w2%.][]
    shiv = {
        id = 319504,
        duration = 8.0,
        max_stack = 1,

        -- Affected by:
        -- arterial_precision[400783] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
        -- hemotoxin[354124] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -30.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
    },
    -- Concealed in shadows.
    shroud_of_concealment = {
        id = 115834,
        duration = 3600,
        tick_time = 0.5,
        max_stack = 1,
    },
    -- Attack speed increased by $w1%.
    slice_and_dice = {
        id = 315496,
        duration = 6.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- deeper_stratagem[193531] #0: { 'type': APPLY_AURA, 'subtype': MOD_ADDITIONAL_POWER_COST, 'points': 1.0, 'value': 4, 'schools': ['fire'], 'target': TARGET_UNIT_CASTER, }
        -- tight_spender[381621] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -6.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- sanguine_stratagem[457512] #0: { 'type': APPLY_AURA, 'subtype': MOD_ADDITIONAL_POWER_COST, 'points': 1.0, 'value': 4, 'schools': ['fire'], 'target': TARGET_UNIT_CASTER, }
    },
    -- A smoke cloud interferes with targeting.
    smoke_bomb = {
        id = 212182,
        duration = 5.0,
        max_stack = 1,
    },
    -- Healing $w1% of max health every $t.
    soothing_darkness = {
        id = 393971,
        duration = 6.0,
        max_stack = 1,
    },
    -- Movement speed increased by $w1%.$?s245751[; Allows you to run over water.][]
    sprint = {
        id = 2983,
        duration = 8.0,
        tick_time = 0.25,
        max_stack = 1,

        -- Affected by:
        -- improved_sprint[231691] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -60000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- featherfoot[423683] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- featherfoot[423683] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 4000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- maneuverability[197000] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- maneuverability[197000] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
    },
    -- Stealthed.$?$w3!=0[; Movement speed increased by $w3%.][]
    stealth = {
        id = 1784,
        duration = 3600,
        max_stack = 1,

        -- Affected by:
        -- shadowheart[455131] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 2.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_4_VALUE, }
        -- shadowrunner[378807] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
        -- subterfuge[108208] #0: { 'type': APPLY_AURA, 'subtype': OVERRIDE_ACTIONBAR_SPELLS, 'trigger_spell': 1784, 'triggers': stealth, 'spell': 115191, 'value': 1784, 'schools': ['nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }
    },
    -- Damage of your next $?a137037 [Envenom][Eviscerate or Black Powder] is increased by $w1%.
    symbolic_victory = {
        id = 457167,
        duration = 12.0,
        max_stack = 1,
    },
    -- Movement speed reduced by $m2%.
    system_shock = {
        id = 198222,
        duration = 2.0,
        max_stack = 1,

        -- Affected by:
        -- mastery_potent_assassin[76803] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_potent_assassin[76803] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shiv[319504] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- toxic_blade[245389] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'pvp_multiplier': 0.666667, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },
    -- Mastery increased by ${$w2*$mas}.1%.
    thistle_tea = {
        id = 381623,
        duration = 6.0,
        pandemic = true,
        max_stack = 1,
    },
    -- $s1% increased damage taken from poisons from the casting Rogue.
    toxic_blade = {
        id = 245389,
        duration = 9.0,
        max_stack = 1,
    },
    -- All healing effects reduced by $w1%.
    toxic_shock = {
        id = 115195,
        duration = 6.0,
        max_stack = 1,

        -- Affected by:
        -- mastery_potent_assassin[76803] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_potent_assassin[76803] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- envenom[32645] #6: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- master_poisoner[378436] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- virulent_poisons[381543] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- destiny_defined[454435] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- dragontempered_blades[381801] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -30.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- fatal_concoction[392384] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- improved_poisons[381624] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- shiv[319504] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- toxic_blade[245389] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'pvp_multiplier': 0.666667, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },
    -- All threat transferred from the Rogue to the target.; $?s221622[Damage increased by $221622m1%.][]
    tricks_of_the_trade = {
        id = 59628,
        duration = 6.0,
        max_stack = 1,
    },
    -- Improved stealth.$?$w3!=0[; Movement speed increased by $w3%.][]$?$w4!=0[; Damage increased by $w4%.][]
    vanish = {
        id = 11327,
        duration = 3.0,
        max_stack = 1,

        -- Affected by:
        -- shadowheart[455131] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 2.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_4_VALUE, }
        -- shadowrunner[378807] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
        -- subterfuge[108208] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_5_VALUE, }
    },
    -- Healing effects reduced by $w2%.
    wound_poison = {
        id = 8680,
        duration = 12.0,
        max_stack = 1,

        -- Affected by:
        -- mastery_potent_assassin[76803] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_potent_assassin[76803] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- envenom[32645] #6: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- assassination_rogue[137037] #19: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #20: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- improved_wound_poison[319066] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 2.0, 'target': TARGET_UNIT_CASTER, 'modifies': MAX_STACKS, }
        -- master_poisoner[378436] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- virulent_poisons[381543] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- destiny_defined[454435] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- dragontempered_blades[381801] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -30.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- fatal_concoction[392384] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- improved_poisons[381624] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- shiv[319504] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- outlaw_rogue[137036] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- outlaw_rogue[137036] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- master_assassin[256735] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- toxic_blade[245389] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'pvp_multiplier': 0.666667, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },
} )

-- Abilities
spec:RegisterAbilities( {
    -- Ambush the target, causing $s1 Physical damage.$?s383281[; Has a $193315s3% chance to hit an additional time, making your next Pistol Shot half cost and double damage.][]; Awards $s2 combo $lpoint:points;$?s383281[ each time it strikes][].
    ambush = {
        id = 8676,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 50,
        spendType = 'energy',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'ap_bonus': 1.51228, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': ENERGIZE, 'subtype': NONE, 'points': 2.0, 'target': TARGET_UNIT_CASTER, 'resource': happiness, }

        -- Affected by:
        -- assassination_rogue[137037] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- assassination_rogue[137037] #19: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #20: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- garrote[703] #3: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- cold_blood[382245] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- deadly_precision[381542] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- improved_ambush[381620] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- lethality[382238] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- vicious_venoms[381634] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- outlaw_rogue[137036] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- outlaw_rogue[137036] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- outlaw_rogue[137036] #15: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- outlaw_rogue[137036] #16: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- master_assassin[256735] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
    },

    -- Coats your weapons with a Lethal Poison that lasts for $d. Each strike has a $h% chance to poison the enemy, dealing $383414s1 Nature damage and applying Amplifying Poison for $383414d. Envenom can consume $s2 stacks of Amplifying Poison to deal $s1% increased damage. Max $383414u stacks.
    amplifying_poison = {
        id = 381664,
        cast = 1.5,
        cooldown = 0.0,
        gcd = "global",

        talent = "amplifying_poison",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 35.0, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 10.0, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': PROC_TRIGGER_SPELL, 'trigger_spell': 383414, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- envenom[32645] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- envenom[32645] #6: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- virulent_poisons[381543] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- destiny_defined[454435] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- dragontempered_blades[381801] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -30.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- fatal_concoction[392384] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- improved_poisons[381624] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- shiv[319504] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },

    -- Blinds $?a200733[all enemies near ][]the target, causing $?a200733[them][it] to wander disoriented for $d. Damage will interrupt the effect. Limit 1.
    blind = {
        id = 2094,
        cast = 0.0,
        cooldown = 120.0,
        gcd = "global",

        talent = "blind",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_DECREASE_SPEED, 'points': -60.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_CONFUSE, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- airborne_irritant[200733] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- airborne_irritant[200733] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -70.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
    },

    -- Stuns the target for $d.; Awards $s2 combo $lpoint:points;.
    cheap_shot = {
        id = 1833,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 40,
        spendType = 'energy',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_STUN, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': ENERGIZE, 'subtype': NONE, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'resource': happiness, }

        -- Affected by:
        -- rushed_setup[378803] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -20.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
    },

    -- Provides a moment of magic immunity, instantly removing all harmful spell effects. The cloak lingers, causing you to resist harmful spells for $d.
    cloak_of_shadows = {
        id = 31224,
        cast = 0.0,
        cooldown = 120.0,
        gcd = "none",

        talent = "cloak_of_shadows",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_ATTACKER_SPELL_HIT_CHANCE, 'points': -200.0, 'value': 126, 'schools': ['holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 35729, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MOD_DAMAGE_PERCENT_TAKEN, 'points': -20.0, 'schools': ['physical'], 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- ethereal_cloak[457022] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 2000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
    },

    -- [212198] Drink an alchemical concoction that heals you for $o1% of your maximum health over $d.
    create_crimson_vial = {
        id = 212205,
        color = 'pvp_talent',
        cast = 1.5,
        cooldown = 0.0,
        gcd = "global",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': CREATE_ITEM, 'subtype': NONE, 'item_type': 137222, 'item': crimson_vial, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': UNKNOWN, 'subtype': NONE, 'points': 3.0, }
    },

    -- Finishing move that slashes all enemies within $A1 yards, causing victims to bleed. Lasts longer per combo point.; Deals extra damage when multiple enemies are afflicted, increasing by $s4% per target, up to ${$s4*5}%.; Deals reduced damage beyond $s3 targets.;    1 point  : ${$o1*4} over ${$d+(2*1)} sec;    2 points: ${$o1*5} over ${$d+(2*2)} sec;    3 points: ${$o1*6} over ${$d+(2*3)} sec;    4 points: ${$o1*7} over ${$d+(2*4)} sec;    5 points: ${$o1*8} over ${$d+(2*5)} sec$?s193531[;    6 points: ${$o1*9} over ${$d+(2*6)} sec][]
    crimson_tempest = {
        id = 121411,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 45,
        spendType = 'energy',

        spend = 1,
        spendType = 'happiness',

        talent = "crimson_tempest",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': PERIODIC_DAMAGE, 'tick_time': 2.0, 'mechanic': bleeding, 'ap_bonus': 0.198, 'radius': 10.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_SRC_AREA_ENEMY, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, 'variance': 0.05, 'radius': 10.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_SRC_AREA_ENEMY, }
        -- #2: { 'type': DUMMY, 'subtype': NONE, }
        -- #3: { 'type': DUMMY, 'subtype': NONE, 'radius': 10.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_SRC_AREA_ENEMY, }

        -- Affected by:
        -- mastery_potent_assassin[76803] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_potent_assassin[76803] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- cold_blood[382245] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- deeper_stratagem[193531] #0: { 'type': APPLY_AURA, 'subtype': MOD_ADDITIONAL_POWER_COST, 'points': 1.0, 'value': 4, 'schools': ['fire'], 'target': TARGET_UNIT_CASTER, }
        -- deeper_stratagem[193531] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- deeper_stratagem[193531] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- tight_spender[381621] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -6.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- sanguine_stratagem[457512] #0: { 'type': APPLY_AURA, 'subtype': MOD_ADDITIONAL_POWER_COST, 'points': 1.0, 'value': 4, 'schools': ['fire'], 'target': TARGET_UNIT_CASTER, }
        -- sanguine_stratagem[457512] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- sanguine_stratagem[457512] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- sudden_demise[423136] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- momentum_of_despair[457115] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- shiv[319504] #2: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },

    -- Drink an alchemical concoction that heals you for $?a354425&a193546[${$O1}.1][$o1]% of your maximum health over $d.
    crimson_vial = {
        id = 185311,
        cast = 0.0,
        cooldown = 30.0,
        gcd = "global",

        spend = 20,
        spendType = 'energy',

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': OBS_MOD_HEALTH, 'tick_time': 1.0, 'points': 5.0, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- iron_stomach[193546] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- nimble_fingers[378427] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -10.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- drink_up_me_hearties[354425] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
    },

    -- Coats your weapons with a Lethal Poison that lasts for $d. Each strike has a $h% chance to poison the enemy for ${$2818m1*$2818d/$2818t1} Nature damage over $2818d. Subsequent poison applications will instantly deal $113780s1 Nature damage.
    deadly_poison = {
        id = 2823,
        cast = 1.5,
        cooldown = 0.0,
        gcd = "global",

        talent = "deadly_poison",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': DUMMY, 'trigger_spell': 2818, 'triggers': deadly_poison, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- mastery_potent_assassin[76803] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_potent_assassin[76803] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- envenom[32645] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- envenom[32645] #6: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- virulent_poisons[381543] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- virulent_poisons[381543] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- destiny_defined[454435] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- dragontempered_blades[381801] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -30.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- fatal_concoction[392384] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- fatal_concoction[392384] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- improved_poisons[381624] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- shiv[319504] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- toxic_blade[245389] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'pvp_multiplier': 0.666667, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },

    -- Finishing move that empowers your weapons with energy to performs a deadly attack.; You leap into the air and $?s32645[Envenom]?s2098[Dispatch][Eviscerate] your target on the way back down, with such force that it has a $269512s2% stronger effect.
    death_from_above = {
        id = 269513,
        color = 'pvp_talent',
        cast = 0.0,
        cooldown = 30.0,
        gcd = "global",

        spend = 15,
        spendType = 'energy',

        spend = 1,
        spendType = 'happiness',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': IGNORE_HIT_DIRECTION, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': ALLOW_ONLY_ABILITY, 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 184963, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- deeper_stratagem[193531] #0: { 'type': APPLY_AURA, 'subtype': MOD_ADDITIONAL_POWER_COST, 'points': 1.0, 'value': 4, 'schools': ['fire'], 'target': TARGET_UNIT_CASTER, }
        -- deeper_stratagem[193531] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- tight_spender[381621] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -6.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- sanguine_stratagem[457512] #0: { 'type': APPLY_AURA, 'subtype': MOD_ADDITIONAL_POWER_COST, 'points': 1.0, 'value': 4, 'schools': ['fire'], 'target': TARGET_UNIT_CASTER, }
        -- sanguine_stratagem[457512] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },

    -- Carve a deathmark into an enemy, dealing $o1 Bleed damage over $d. While marked your Garrote, Rupture, and Lethal poisons applied to the target are duplicated, dealing $?a134735[${100+$394331s1+$394331s3}%][${100+$394331s1}%] of normal damage.
    deathmark = {
        id = 360194,
        cast = 0.0,
        cooldown = 120.0,
        gcd = "global",

        talent = "deathmark",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': PERIODIC_DAMAGE, 'tick_time': 2.0, 'mechanic': bleeding, 'ap_bonus': 0.4, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 394331, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- sudden_demise[423136] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shiv[319504] #2: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },

    -- Focus intently on trying to detect certain creatures.
    detection = {
        id = 56814,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_INVISIBILITY_DETECT, 'points': 100.0, 'value': 5, 'schools': ['physical', 'fire'], 'target': TARGET_UNIT_CASTER, }
    },

    -- Disarm the enemy, preventing the use of any weapons or shield for $d.
    dismantle = {
        id = 207777,
        color = 'pvp_talent',
        cast = 0.0,
        cooldown = 45.0,
        gcd = "global",

        spend = 15,
        spendType = 'energy',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_DISARM_RANGED, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_DISARM_OFFHAND, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MOD_DISARM, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #3: { 'type': APPLY_AURA, 'subtype': DUMMY, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },

    -- Throws a distraction, attracting the attention of all nearby monsters for $s1 seconds. Usable while stealthed.
    distract = {
        id = 1725,
        cast = 0.0,
        cooldown = 30.0,
        gcd = "global",

        spend = 30,
        spendType = 'energy',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': DISTRACT, 'subtype': NONE, 'points': 10.0, 'radius': 10.0, 'target': TARGET_UNIT_DEST_AREA_ENEMY, }

        -- Affected by:
        -- rushed_setup[378803] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -20.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
    },

    -- Deal $s1 Physical damage to an enemy, extracting their anima to Animacharge a combo point for $323558d.; Damaging finishing moves that consume the same number of combo points as your Animacharge function as if they consumed $s2 combo points.; Awards $s3 combo $lpoint:points;.; 
    echoing_reprimand = {
        id = 385616,
        cast = 0.0,
        cooldown = 45.0,
        gcd = "global",

        spend = 10,
        spendType = 'energy',

        talent = "echoing_reprimand",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'ap_bonus': 2.6, 'pvp_multiplier': 0.7, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, }
        -- #2: { 'type': ENERGIZE, 'subtype': NONE, 'points': 2.0, 'target': TARGET_UNIT_CASTER, 'resource': happiness, }
        -- #3: { 'type': ENERGIZE, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, 'resource': energy, }

        -- Affected by:
        -- reverberation[394332] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },

    -- Finishing move that drives your poisoned blades in deep, dealing instant Nature damage and increasing your poison application chance by $s2%. Damage and duration increased per combo point.;    1 point  : ${$m1*1} damage, 1 sec;    2 points: ${$m1*2} damage, 2 sec;    3 points: ${$m1*3} damage, 3 sec;    4 points: ${$m1*4} damage, 4 sec;    5 points: ${$m1*5} damage, 5 sec$?s193531[;    6 points: ${$m1*6} damage, 6 sec][]
    envenom = {
        id = 32645,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 35,
        spendType = 'energy',

        spend = 1,
        spendType = 'happiness',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'ap_bonus': 0.275, 'pvp_multiplier': 0.96, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': PROC_CHANCE, }
        -- #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- #4: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- #5: { 'type': APPLY_AURA, 'subtype': DUMMY, 'target': TARGET_UNIT_CASTER, }
        -- #6: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }

        -- Affected by:
        -- mastery_potent_assassin[76803] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- envenom[32645] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- assassination_rogue[137037] #19: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #20: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- cold_blood[382245] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- deeper_stratagem[193531] #0: { 'type': APPLY_AURA, 'subtype': MOD_ADDITIONAL_POWER_COST, 'points': 1.0, 'value': 4, 'schools': ['fire'], 'target': TARGET_UNIT_CASTER, }
        -- deeper_stratagem[193531] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- tight_spender[381621] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -6.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- dashing_scoundrel[381797] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
        -- rapid_injection[455072] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
        -- sanguine_stratagem[457512] #0: { 'type': APPLY_AURA, 'subtype': MOD_ADDITIONAL_POWER_COST, 'points': 1.0, 'value': 4, 'schools': ['fire'], 'target': TARGET_UNIT_CASTER, }
        -- sanguine_stratagem[457512] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twist_the_knife[381669] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 2000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- symbolic_victory[457167] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shiv[319504] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- outlaw_rogue[137036] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- outlaw_rogue[137036] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- master_assassin[256735] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- death_from_above[269512] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- death_from_above[269512] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.375, 'points': 40.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- death_from_above[269512] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 500.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
        -- death_from_above[269512] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- toxic_blade[245389] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'pvp_multiplier': 0.666667, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },

    -- Increases your dodge chance by ${$s1/2}% for $d.$?a344363[ Dodging an attack while Evasion is active will trigger Mastery: Main Gauche.][]
    evasion = {
        id = 5277,
        cast = 0.0,
        cooldown = 120.0,
        gcd = "none",

        talent = "evasion",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_DODGE_PERCENT, 'points': 200.0, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_DAMAGE_PERCENT_TAKEN, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MOD_DAMAGE_PERCENT_TAKEN, 'points': -20.0, 'schools': ['holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- elusiveness[79008] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'sp_bonus': 0.25, 'points': -20.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
    },

    -- Finishing move that disembowels the target, causing damage per combo point.$?s382511[ Targets with Find Weakness suffer an additional $382511s1% damage as Shadow.][];    1 point  : ${$m1*1} damage;    2 points: ${$m1*2} damage;    3 points: ${$m1*3} damage;    4 points: ${$m1*4} damage;    5 points: ${$m1*5} damage$?s193531|((s394320|s394321)&!s193531)[;    6 points: ${$m1*6} damage][]$?s193531&(s394320|s394321)[;    7 points: ${$m1*7} damage][]
    eviscerate = {
        id = 196819,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 35,
        spendType = 'energy',

        spend = 1,
        spendType = 'happiness',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'ap_bonus': 0.21, 'pvp_multiplier': 0.95, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- deeper_stratagem[193531] #0: { 'type': APPLY_AURA, 'subtype': MOD_ADDITIONAL_POWER_COST, 'points': 1.0, 'value': 4, 'schools': ['fire'], 'target': TARGET_UNIT_CASTER, }
        -- deeper_stratagem[193531] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- tight_spender[381621] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -6.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- sanguine_stratagem[457512] #0: { 'type': APPLY_AURA, 'subtype': MOD_ADDITIONAL_POWER_COST, 'points': 1.0, 'value': 4, 'schools': ['fire'], 'target': TARGET_UNIT_CASTER, }
        -- sanguine_stratagem[457512] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- symbolic_victory[457167] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- death_from_above[269512] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- death_from_above[269512] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.375, 'points': 40.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- death_from_above[269512] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 500.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
        -- death_from_above[269512] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
    },

    -- Sprays knives at all enemies within $A1 yards, dealing $s1 Physical damage and applying your active poisons at their normal rate. Deals reduced damage beyond $s3 targets.; Awards $s2 combo $lpoint:points;.
    fan_of_knives = {
        id = 51723,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 35,
        spendType = 'energy',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'ap_bonus': 0.583, 'variance': 0.05, 'radius': 10.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_SRC_AREA_ENEMY, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, }
        -- #2: { 'type': DUMMY, 'subtype': NONE, }

        -- Affected by:
        -- assassination_rogue[137037] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- assassination_rogue[137037] #19: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #20: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- cold_blood[382245] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- deadly_precision[381542] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- lethality[382238] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- flying_daggers[381631] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 2.0, 'target': TARGET_UNIT_CASTER, 'modifies': RADIUS, }
        -- flying_daggers[381631] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- thrown_precision[381629] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- thrown_precision[381629] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- momentum_of_despair[457115] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- outlaw_rogue[137036] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- outlaw_rogue[137036] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- master_assassin[256735] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
    },

    -- Performs an evasive maneuver, reducing damage taken from area-of-effect attacks by $s1% $?s79008[and all other damage taken by $s2% ][]for $d.
    feint = {
        id = 1966,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 35,
        spendType = 'energy',

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_AOE_DAMAGE_AVOIDANCE, 'points': -40.0, 'value': 127, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_DAMAGE_PERCENT_TAKEN, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': ENERGIZE, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, 'resource': happiness, }

        -- Affected by:
        -- elusiveness[79008] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'sp_bonus': 0.25, 'points': -20.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- graceful_guile[423647] #0: { 'type': APPLY_AURA, 'subtype': MOD_MAX_CHARGES, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
        -- nimble_fingers[378427] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -10.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
    },

    -- Garrote the enemy, causing $o1 Bleed damage over $d.$?a231719[ Silences the target for $1330d when used from Stealth.][]; Awards $s3 combo $lpoint:points;.
    garrote = {
        id = 703,
        cast = 0.0,
        cooldown = 6.0,
        gcd = "global",

        spend = 45,
        spendType = 'energy',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': PERIODIC_DAMAGE, 'tick_time': 2.0, 'mechanic': bleeding, 'ap_bonus': 0.26191, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #2: { 'type': ENERGIZE, 'subtype': NONE, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'resource': happiness, }
        -- #3: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- mastery_potent_assassin[76803] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_potent_assassin[76803] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- assassination_rogue[137037] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- assassination_rogue[137037] #19: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #20: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- stealth[1784] #4: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
        -- deadly_precision[381542] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- lethality[382238] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- bloody_mess[381626] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shrouded_suffocation[385478] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- sudden_demise[423136] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- vanish[11327] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- shiv[319504] #2: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- outlaw_rogue[137036] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- outlaw_rogue[137036] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- improved_garrote[392401] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- indiscriminate_carnage[385747] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': CHAINED_TARGETS, }
        -- indiscriminate_carnage[385747] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_DISTANCE, }
        -- master_assassin[256735] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
    },

    -- Gouges the eyes of an enemy target, incapacitating for $d. Damage will interrupt the effect.; Must be in front of your target.; Awards $s2 combo $lpoint:points;.
    gouge = {
        id = 1776,
        cast = 0.0,
        cooldown = 20.0,
        gcd = "global",

        spend = 25,
        spendType = 'energy',

        talent = "gouge",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_STUN, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': ENERGIZE, 'subtype': NONE, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'resource': happiness, }

        -- Affected by:
        -- lethality[382238] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
    },

    -- A quick kick that interrupts spellcasting and prevents any spell in that school from being cast for $d.
    kick = {
        id = 1766,
        cast = 0.0,
        cooldown = 15.0,
        gcd = "none",

        startsCombat = true,
        interrupt = true,

        -- Effects:
        -- #0: { 'type': INTERRUPT_CAST, 'subtype': NONE, 'mechanic': interrupted, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },

    -- Finishing move that stuns the target$?a426588[ and creates shadow clones to stun all other nearby enemies][]. Lasts longer per combo point, up to 5:;    1 point  : 2 seconds;    2 points: 3 seconds;    3 points: 4 seconds;    4 points: 5 seconds;    5 points: 6 seconds
    kidney_shot = {
        id = 408,
        cast = 0.0,
        cooldown = 20.0,
        gcd = "global",

        spend = 25,
        spendType = 'energy',

        spend = 1,
        spendType = 'happiness',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_STUN, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- rushed_setup[378803] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -20.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- tight_spender[381621] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -6.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- stunning_secret[426588] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- stunning_secret[426588] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
    },

    -- Release a lethal poison from your weapons and inject it into your target, dealing $s2 Nature damage instantly and an additional $o4 Nature damage over $d. ; Each time you apply a Lethal Poison to a target affected by Kingsbane, Kingsbane damage increases by $394095s1%, up to ${$394095s1*$394095u}%.; Awards $s6 combo $lpoint:points;.
    kingsbane = {
        id = 385627,
        cast = 0.0,
        cooldown = 60.0,
        gcd = "global",

        spend = 35,
        spendType = 'energy',

        talent = "kingsbane",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'ap_bonus': 1.309, 'pvp_multiplier': 0.68, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #2: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #3: { 'type': APPLY_AURA, 'subtype': PERIODIC_DAMAGE, 'tick_time': 2.0, 'ap_bonus': 0.22, 'pvp_multiplier': 0.92, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #4: { 'type': APPLY_AURA, 'subtype': PROC_TRIGGER_SPELL, 'trigger_spell': 394095, 'points': 5.0, 'target': TARGET_UNIT_CASTER, }
        -- #5: { 'type': ENERGIZE, 'subtype': NONE, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'resource': happiness, }

        -- Affected by:
        -- kingsbane[394095] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shiv[319504] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- kingsbane[192853] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- toxic_blade[245389] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'pvp_multiplier': 0.666667, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },

    -- Releases lethal poison within The Kingslayers and injects it into your target, dealing ${$222062sw1+$192760sw1} Nature damage instantly and an additional $o4 Nature damage over $d. ; Each time you apply a Lethal Poison to a target affected by Kingsbane, Kingsbane damage increases by $192853s1%.; Awards $s6 combo $lpoint:points;.
    kingsbane_192759 = {
        id = 192759,
        color = 'artifact',
        cast = 0.0,
        cooldown = 45.0,
        gcd = "global",

        spend = 35,
        spendType = 'energy',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 222062, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #2: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 192760, 'value': 50, 'schools': ['holy', 'frost', 'shadow'], 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #3: { 'type': APPLY_AURA, 'subtype': PERIODIC_DAMAGE, 'tick_time': 2.0, 'ap_bonus': 0.0756, 'points': 5.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #4: { 'type': APPLY_AURA, 'subtype': PROC_TRIGGER_SPELL, 'trigger_spell': 192853, 'points': 5.0, 'target': TARGET_UNIT_CASTER, }
        -- #5: { 'type': ENERGIZE, 'subtype': NONE, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'resource': happiness, }

        -- Affected by:
        -- mastery_potent_assassin[76803] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_potent_assassin[76803] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- cold_blood[382245] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- deadly_precision[381542] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- lethality[382238] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- kingsbane[394095] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shiv[319504] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- kingsbane[192853] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- toxic_blade[245389] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'pvp_multiplier': 0.666667, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        from = "affected_by_mastery",
    },

    -- Attack with both weapons, dealing a total of $<dmg> Physical damage.; Awards $s2 combo $lpoint:points;.
    mutilate = {
        id = 1329,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 50,
        spendType = 'energy',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': ENERGIZE, 'subtype': NONE, 'points': 2.0, 'target': TARGET_UNIT_CASTER, 'resource': happiness, }
        -- #2: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 5374, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #3: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 27576, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- assassination_rogue[137037] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- assassination_rogue[137037] #19: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #20: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- cold_blood[382245] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- lethality[382238] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- vicious_venoms[381634] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- outlaw_rogue[137036] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- outlaw_rogue[137036] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- master_assassin[256735] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
    },

    -- [381634] Ambush and Mutilate cost $s2 more Energy and deal $s1% additional damage as Nature.
    mutilate_385806 = {
        id = 385806,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'pvp_multiplier': 0.96, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- mastery_potent_assassin[76803] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        from = "affected_by_mastery",
    },

    -- Pick the target's pocket.
    pick_pocket = {
        id = 921,
        cast = 0.0,
        cooldown = 0.5,
        gcd = "none",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': PICKPOCKET, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ANY, }
    },

    -- Throws a poison-coated knife, dealing $s1 damage and applying your active Lethal and Non-Lethal Poisons.; Awards $s2 combo $lpoint:points;.
    poisoned_knife = {
        id = 185565,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 40,
        spendType = 'energy',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'ap_bonus': 0.176, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': ENERGIZE, 'subtype': NONE, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'resource': happiness, }

        -- Affected by:
        -- cold_blood[382245] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- deadly_precision[381542] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- lethality[382238] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
    },

    -- Finishing move that tears open the target, dealing Bleed damage over time. Lasts longer per combo point.;    1 point  : ${$o1*2} over 8 sec;    2 points: ${$o1*3} over 12 sec;    3 points: ${$o1*4} over 16 sec;    4 points: ${$o1*5} over 20 sec;    5 points: ${$o1*6} over 24 sec$?s193531|((s394320|s394321)&!s193531)[;    6 points: ${$o1*7} over 28 sec][]$?s193531&(s394320|s394321)[;    7 points: ${$o1*8} over 32 sec][]
    rupture = {
        id = 1943,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 25,
        spendType = 'energy',

        spend = 1,
        spendType = 'happiness',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': PERIODIC_DAMAGE, 'tick_time': 2.0, 'mechanic': bleeding, 'ap_bonus': 0.262416, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': PERIODIC_DUMMY, 'tick_time': 2.0, 'mechanic': bleeding, 'points': 1.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #2: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 199672, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #3: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 199672, 'value': 160, 'schools': ['shadow'], 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #4: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 199672, 'value': 500, 'schools': ['fire', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- mastery_potent_assassin[76803] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_potent_assassin[76803] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- assassination_rogue[137037] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- assassination_rogue[137037] #19: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #20: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- assassination_rogue[137037] #24: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- deeper_stratagem[193531] #0: { 'type': APPLY_AURA, 'subtype': MOD_ADDITIONAL_POWER_COST, 'points': 1.0, 'value': 4, 'schools': ['fire'], 'target': TARGET_UNIT_CASTER, }
        -- deeper_stratagem[193531] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- tight_spender[381621] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -6.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- bloody_mess[381626] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- corrupt_the_blood[457066] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 3000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- sanguine_stratagem[457512] #0: { 'type': APPLY_AURA, 'subtype': MOD_ADDITIONAL_POWER_COST, 'points': 1.0, 'value': 4, 'schools': ['fire'], 'target': TARGET_UNIT_CASTER, }
        -- sanguine_stratagem[457512] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- sudden_demise[423136] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shiv[319504] #2: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- outlaw_rogue[137036] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- outlaw_rogue[137036] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- indiscriminate_carnage[385747] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': CHAINED_TARGETS, }
        -- indiscriminate_carnage[385747] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_DISTANCE, }
        -- master_assassin[256735] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
    },

    -- Incapacitates a target not in combat for $d. Only works on Humanoids, Beasts, Demons, and Dragonkin. Damage will revive the target. Limit 1.
    sap = {
        id = 6770,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 35,
        spendType = 'energy',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_STUN, 'variance': 0.15, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- rushed_setup[378803] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -20.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
    },

    -- Step through the shadows to appear behind your target and gain $s2% increased movement speed for $d.$?s137035|s137037[; If you already know $@spellname36554, instead gain $394931s1 additional $Lcharge:charges; of $@spellname36554.][]
    shadowstep = {
        id = 36554,
        cast = 0.0,
        cooldown = 1.0,
        gcd = "none",

        talent = "shadowstep",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 36563, 'target': TARGET_UNIT_TARGET_ANY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_INCREASE_SPEED, 'points': 70.0, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_DEST_TARGET_ANY, }

        -- Affected by:
        -- shadowstep[394932] #0: { 'type': APPLY_AURA, 'subtype': MOD_MAX_CHARGES, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
        -- shadowstep[394931] #0: { 'type': APPLY_AURA, 'subtype': MOD_MAX_CHARGES, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
    },

    -- Attack with your $?s319032[poisoned blades][off-hand], dealing $sw1 Physical damage, dispelling all enrage effects and applying a concentrated form of your $?a3408[Crippling Poison, reducing movement speed by $115196s1% for $115196d.]?a5761[Numbing Poison, reducing casting speed by $359078s1% for $359078d.][]$?(!a3408&!a5761)[active Non-Lethal poison.][]$?(a319032&a400783)[; Your Nature and Bleed ]?a319032[; Your Nature ]?a400783[; Your Bleed ][]$?(a400783|a319032)[damage done to the target is increased by $319504s1% for $319504d.][]$?a354124[ The target's healing received is reduced by $354124S1% for $319504d.][]; Awards $s3 combo $lpoint:points;.
    shiv = {
        id = 5938,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 30,
        spendType = 'energy',

        talent = "shiv",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'ap_bonus': 0.9504, 'pvp_multiplier': 0.83, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #2: { 'type': ENERGIZE, 'subtype': NONE, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'resource': happiness, }
        -- #3: { 'type': DISPEL, 'subtype': NONE, 'points': 100.0, 'value': 9, 'schools': ['physical', 'nature'], 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- assassination_rogue[137037] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- assassination_rogue[137037] #19: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #20: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- cold_blood[382245] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- deadly_precision[381542] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- lethality[382238] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- arterial_precision[400783] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': CHAINED_TARGETS, }
        -- arterial_precision[400783] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_DISTANCE, }
        -- lightweight_shiv[394983] #0: { 'type': APPLY_AURA, 'subtype': MOD_MAX_CHARGES, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
        -- lightweight_shiv[394983] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- tiny_toxic_blade[381800] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 200.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- tiny_toxic_blade[381800] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -30.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- shiv[319504] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- outlaw_rogue[137036] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- outlaw_rogue[137036] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- master_assassin[256735] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- toxic_blade[245389] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'pvp_multiplier': 0.666667, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },

    -- Extend a cloak that shrouds party and raid members within $115834A1 yards in shadows, providing stealth for $d.
    shroud_of_concealment = {
        id = 114018,
        cast = 0.0,
        cooldown = 360.0,
        gcd = "global",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': PERIODIC_TRIGGER_SPELL, 'tick_time': 0.5, 'trigger_spell': 115834, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_INCREASE_SPEED, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- stillshroud[423662] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- shroud_of_night[457063] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
    },

    -- Viciously strike an enemy, causing $s1 Physical damage.; Awards $s2 combo $lpoint:points;.
    sinister_strike = {
        id = 1752,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 45,
        spendType = 'energy',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'ap_bonus': 0.21762, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': ENERGIZE, 'subtype': NONE, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'resource': happiness, }

        -- Affected by:
        -- assassination_rogue[137037] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- assassination_rogue[137037] #19: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- assassination_rogue[137037] #20: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- cold_blood[382245] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- deadly_precision[381542] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- lethality[382238] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- outlaw_rogue[137036] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- outlaw_rogue[137036] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- master_assassin[256735] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
    },

    -- Viciously strike an enemy, causing ${$s1*$<mult>} Physical damage.$?s279876[; Has a $s3% chance to hit an additional time, making your next Pistol Shot half cost and double damage.][]; Awards $s2 combo $lpoint:points; each time it strikes.
    sinister_strike_193315 = {
        id = 193315,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 45,
        spendType = 'energy',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'ap_bonus': 0.6, 'pvp_multiplier': 1.05, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': ENERGIZE, 'subtype': NONE, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'resource': happiness, }
        -- #2: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- cold_blood[382245] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- deadly_precision[381542] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- lethality[382238] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        from = "from_description",
    },

    -- Finishing move that consumes combo points to increase attack speed by $s1%. Lasts longer per combo point.;    1 point  : 12 seconds;    2 points: 18 seconds;    3 points: 24 seconds;    4 points: 30 seconds;    5 points: 36 seconds$?s193531|((s394320|s394321)&!s193531)[;    6 points: 42 seconds][]$?s193531&(s394320|s394321)[;    7 points: 48 seconds][]
    slice_and_dice = {
        id = 315496,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 25,
        spendType = 'energy',

        spend = 1,
        spendType = 'happiness',

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_MELEE_RANGED_HASTE_2, 'points': 50.0, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_ATTACK_POWER_OF_ARMOR, 'trigger_spell': 426605, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- deeper_stratagem[193531] #0: { 'type': APPLY_AURA, 'subtype': MOD_ADDITIONAL_POWER_COST, 'points': 1.0, 'value': 4, 'schools': ['fire'], 'target': TARGET_UNIT_CASTER, }
        -- tight_spender[381621] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -6.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- sanguine_stratagem[457512] #0: { 'type': APPLY_AURA, 'subtype': MOD_ADDITIONAL_POWER_COST, 'points': 1.0, 'value': 4, 'schools': ['fire'], 'target': TARGET_UNIT_CASTER, }
    },

    -- Creates a cloud of thick smoke in an $m2 yard radius around the Rogue for $d. Enemies are unable to target into or out of the smoke cloud. 
    smoke_bomb = {
        id = 212182,
        color = 'pvp_talent',
        cast = 0.0,
        cooldown = 180.0,
        gcd = "global",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': CREATE_AREATRIGGER, 'subtype': NONE, 'value': 6951, 'schools': ['physical', 'holy', 'fire', 'shadow'], 'target': TARGET_DEST_CASTER_GROUND_2, }
        -- #1: { 'type': UNKNOWN, 'subtype': NONE, 'points': 8.0, }
    },

    -- Increases your movement speed by $s1% for $d. Usable while stealthed.$?s245751[; Allows you to run over water.][]
    sprint = {
        id = 2983,
        cast = 0.0,
        cooldown = 120.0,
        gcd = "none",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_INCREASE_SPEED, 'points': 70.0, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': PERIODIC_DUMMY, 'tick_time': 0.25, 'points': 1.0, }

        -- Affected by:
        -- improved_sprint[231691] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -60000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- featherfoot[423683] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- featherfoot[423683] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 4000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- maneuverability[197000] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- maneuverability[197000] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
    },

    -- Conceals you in the shadows until cancelled, allowing you to stalk enemies without being seen. $?s14062[Movement speed while stealthed is increased by $s3% and damage dealt is increased by $s4%.]?s108209[ Abilities cost $112942s1% less while stealthed. ][]$?s31223[ Attacks from Stealth and for $31223s1 sec after deal $31665s1% more damage.][]
    stealth = {
        id = 1784,
        cast = 0.0,
        cooldown = 2.0,
        gcd = "none",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_LEECH, 'value': 30, 'schools': ['holy', 'fire', 'nature', 'frost'], 'value1': 2, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points_per_level': 5.0, 'points': 40.0, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MOD_SPEED_ALWAYS, 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': APPLY_AURA, 'subtype': MOD_LEECH, 'target': TARGET_UNIT_CASTER, }
        -- #4: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }

        -- Affected by:
        -- shadowheart[455131] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 2.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_4_VALUE, }
        -- shadowrunner[378807] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_3_VALUE, }
        -- subterfuge[108208] #0: { 'type': APPLY_AURA, 'subtype': OVERRIDE_ACTIONBAR_SPELLS, 'trigger_spell': 1784, 'triggers': stealth, 'spell': 115191, 'value': 1784, 'schools': ['nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }
    },

    -- Restore $s1 Energy. Mastery increased by ${$s2*$mas}.1% for $d.
    thistle_tea = {
        id = 381623,
        cast = 0.0,
        cooldown = 1.0,
        gcd = "none",

        talent = "thistle_tea",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': ENERGIZE, 'subtype': NONE, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'resource': energy, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MASTERY, 'points': 8.0, 'target': TARGET_UNIT_CASTER, }
    },

    -- Stab your enemy with a toxic poisoned blade, dealing $s2 Nature damage.; Your Nature damage done against the target is increased by $245389s1% for $245389d.; Awards $s3 combo $lpoint:points;.
    toxic_blade = {
        id = 245388,
        cast = 0.0,
        cooldown = 25.0,
        gcd = "global",

        spend = 20,
        spendType = 'energy',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'ap_bonus': 0.53, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #2: { 'type': ENERGIZE, 'subtype': NONE, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'resource': happiness, }
        -- #3: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 245389, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- mastery_potent_assassin[76803] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- mastery_potent_assassin[76803] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'sp_bonus': 1.7, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shiv[319504] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- toxic_blade[245389] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'pvp_multiplier': 0.666667, 'points': 30.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },

    -- $?s221622[Increases the target's damage by $221622m1%, and redirects][Redirects] all threat you cause to the targeted party or raid member, beginning with your next damaging attack within the next $d and lasting $59628d.
    tricks_of_the_trade = {
        id = 57934,
        cast = 0.0,
        cooldown = 30.0,
        gcd = "none",

        talent = "tricks_of_the_trade",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': REDIRECT_THREAT, 'subtype': NONE, 'points': 100.0, 'value': 30000, 'schools': ['frost', 'shadow'], 'target': TARGET_UNIT_TARGET_RAID, }
        -- #1: { 'type': APPLY_AURA, 'subtype': DUMMY, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 100.0, 'target': TARGET_UNIT_TARGET_RAID, }
    },

    -- Allows you to vanish from sight, entering stealth while in combat. For the first $11327d after vanishing, damage and harmful effects received will not break stealth. Also breaks movement impairing effects.
    vanish = {
        id = 1856,
        cast = 0.0,
        cooldown = 1.0,
        gcd = "none",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': SANCTUARY_2, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 18461, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': ENERGIZE, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, 'resource': happiness, }
        -- #3: { 'type': FORCE_DESELECT, 'subtype': NONE, 'attributes': ['Exclude Own Party'], 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- without_a_trace[382513] #0: { 'type': APPLY_AURA, 'subtype': MOD_MAX_CHARGES, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
    },

} )