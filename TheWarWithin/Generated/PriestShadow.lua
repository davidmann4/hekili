-- PriestShadow.lua
-- July 2024

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State

local spec = Hekili:NewSpecialization( 258 )

-- Resources
spec:RegisterResource( Enum.PowerType.Mana )
spec:RegisterResource( Enum.PowerType.Insanity )

spec:RegisterTalents( {
    -- Priest Talents
    angelic_bulwark            = { 82675, 108945, 1 }, -- When an attack brings you below $s1% health, you gain an absorption shield equal to $s2% of your maximum health for $114214d. Cannot occur more than once every $s3 sec.
    angelic_feather            = { 82703, 121536, 1 }, -- Places a feather at the target location, granting the first ally to walk through it $121557s1% increased movement speed for $121557d.$?a440670[ When an ally walks through a feather, you are also granted $440670s3% of its effect.][] Only 3 feathers can be placed at one time.
    angels_mercy               = { 82678, 238100, 1 }, -- Reduces the cooldown of Desperate Prayer by ${$s1/-1000} sec.
    apathy                     = { 82689, 390668, 1 }, -- Your $?s137031[Holy Fire][Mind Blast] critical strikes reduce your target's movement speed by $390669s1% for $390669d.
    benevolence                = { 82676, 415416, 1 }, -- Increases the healing of your spells by $s1%.
    binding_heals              = { 82678, 368275, 1 }, -- $s1% of $?c2[Heal or ][]Flash Heal healing on other targets also heals you.
    blessed_recovery           = { 82720, 390767, 1 }, -- After being struck by a melee or ranged critical hit, heal $s1% of the damage taken over $390771d.
    body_and_soul              = { 82706, 64129 , 1 }, -- Power Word: Shield and Leap of Faith increase your target's movement speed by $65081s1% for $65081d.
    cauterizing_shadows        = { 82687, 459990, 1 }, -- When your Shadow Word: Pain$?a137032[ or Purge the Wicked][] expires or is refreshed with less than $s1 sec remaining, a nearby ally within $459992A1 yards is healed for $?a137033[${$459992s1*$s2/100}][$459992s1]. 
    crystalline_reflection     = { 82681, 373457, 2 }, -- Power Word: Shield instantly heals the target for $s3 and reflects $s1% of damage absorbed.
    death_and_madness          = { 82711, 321291, 1 }, -- If your Shadow Word: Death fails to kill a target at or below $s2% health, its cooldown is reset. Cannot occur more than once every $390628d. $?c3[ If a target dies within $322098d after being struck by your Shadow Word: Death, you gain ${$321973s1/100} Insanity.][]
    dispel_magic               = { 82715, 528   , 1 }, -- Dispels Magic on the enemy target, removing $m1 beneficial Magic $leffect:effects;.
    dominate_mind              = { 82710, 205364, 1 }, -- Controls a mind up to 1 level above yours for $d while still controlling your own mind. Does not work versus Demonic, Mechanical, or Undead beings$?a205477[][ or players]. This spell shares diminishing returns with other disorienting effects.
    essence_devourer           = { 82674, 415479, 1 }, -- Attacks from your Shadowfiend siphon life from enemies, healing a nearby injured ally for $415673s1.$?a137031[][; Attacks from your Mindbender siphon life from enemies, healing a nearby injured ally for $415676s1.]
    focused_mending            = { 82719, 372354, 1 }, -- Prayer of Mending does $s1% increased healing to the initial target.
    from_darkness_comes_light  = { 82707, 390615, 1 }, -- Each time Shadow Word: Pain$?s137032[ or Purge the Wicked][] deals damage, the healing of your next Flash Heal is increased by $s1%, up to a maximum of $?a137033&$?a134735[$390617s2][${$s1*$390617u}]%.
    holy_nova                  = { 82701, 132157, 1 }, -- An explosion of holy light around you deals up to $s1 Holy damage to enemies and up to $281265s1 healing to allies within $A1 yds, reduced if there are more than $s3 targets.
    improved_fade              = { 82686, 390670, 2 }, -- Reduces the cooldown of Fade by ${$s1/-1000)} sec.
    improved_flash_heal        = { 82714, 393870, 1 }, -- Increases healing done by Flash Heal by $s1%.
    inspiration                = { 82696, 390676, 1 }, -- Reduces your target's physical damage taken by $390677s1% for $390677d after a critical heal with $?c1[Flash Heal or Penance]?c2[Flash Heal, Heal, or Holy Word: Serenity][Flash Heal].
    leap_of_faith              = { 82716, 73325 , 1 }, -- Pulls the spirit of a party or raid member, instantly moving them directly in front of you.
    lights_inspiration         = { 82679, 373450, 2 }, -- Increases the maximum health gained from Desperate Prayer by $s1%.
    manipulation               = { 82672, 459985, 2 }, -- You take $s1% less damage from enemies affected by your Shadow Word: Pain$?a137032[ or Purge the Wicked]?a137031[ or Holy Fire][]. 
    mass_dispel                = { 82699, 32375 , 1 }, -- Dispels magic in a $32375a1 yard radius, removing all harmful Magic from $s4 friendly targets and $32592m1 beneficial Magic $leffect:effects; from $s4 enemy targets. Potent enough to remove Magic that is normally undispellable.
    mental_agility             = { 82698, 341167, 1 }, -- Reduces the mana cost of $?a137033[Purify Disease][Purify] and Mass Dispel by $s1% and Dispel Magic by $s2%.; 
    mind_control               = { 82710, 605   , 1 }, -- Controls a mind up to 1 level above yours for $d. Does not work versus Demonic$?A320889[][, Undead,] or Mechanical beings. Shares diminishing returns with other disorienting effects.
    move_with_grace            = { 82702, 390620, 1 }, -- Reduces the cooldown of Leap of Faith by ${$s1/-1000} sec.
    petrifying_scream          = { 82695, 55676 , 1 }, -- Psychic Scream causes enemies to tremble in place instead of fleeing in fear.
    phantasm                   = { 82556, 108942, 1 }, -- Activating Fade removes all snare effects.
    phantom_reach              = { 82673, 459559, 1 }, -- Increases the range of most spells by $s1%.
    power_infusion             = { 82694, 10060 , 1 }, -- Infuses the target with power for $d, increasing haste by $s1%.; Can only be cast on players.
    power_word_life            = { 82676, 373481, 1 }, -- A word of holy power that heals the target for $s1. ; Only usable if the target is below $s2% health.
    prayer_of_mending          = { 82718, 33076 , 1 }, -- Places a ward on an ally that heals them for $33110s1 the next time they take damage, and then jumps to another ally within $155793a1 yds. Jumps up to $s1 times and lasts $41635d after each jump.
    protective_light           = { 82707, 193063, 1 }, -- Casting Flash Heal on yourself reduces all damage you take by $193065s1% for $193065d.
    psychic_voice              = { 82695, 196704, 1 }, -- Reduces the cooldown of Psychic Scream by ${$m1/-1000} sec.
    renew                      = { 82717, 139   , 1 }, -- Fill the target with faith in the light, healing for $o1 over $d.
    rhapsody                   = { 82700, 390622, 1 }, -- Every $t1 sec, the damage of your next Holy Nova is increased by $390636s1% and its healing is increased by $390636s2%. ; Stacks up to $390636u times.
    sanguine_teachings         = { 82691, 373218, 1 }, -- Increases your Leech by $s1%.
    sanlayn                    = { 82690, 199855, 1 }, -- $@spellicon373218 $@spellname373218; Sanguine Teachings grants an additional $s3% Leech.; $@spellicon15286 $@spellname15286; Reduces the cooldown of Vampiric Embrace by ${$m1/-1000} sec, increases its healing done by $s2%.
    shackle_undead             = { 82693, 9484  , 1 }, -- Shackles the target undead enemy for $d, preventing all actions and movement. Damage will cancel the effect. Limit 1.
    shadow_word_death          = { 82712, 32379 , 1 }, -- A word of dark binding that inflicts $s2 Shadow damage to your target. If your target is not killed by Shadow Word: Death, you take backlash damage equal to $s6% of your maximum health.$?A364675[; Damage increased by ${$s4+$364675s2}% to targets below ${$s3+$364675s1}% health.][; Damage increased by $s4% to targets below $s3% health.]$?c3[][]$?s137033[; Generates ${$s5/100} Insanity.][]
    shadowfiend                = { 82713, 34433 , 1 }, -- Summons a shadowy fiend to attack the target for $d.$?s137033[; Generates ${$262485s1/100} Insanity each time the Shadowfiend attacks.][; Generates ${$s4/10}.1% Mana each time the Shadowfiend attacks.]
    sheer_terror               = { 82708, 390919, 1 }, -- Increases the amount of damage required to break your Psychic Scream by $s1%.
    spell_warding              = { 82720, 390667, 1 }, -- Reduces all magic damage taken by $s1%.
    surge_of_light             = { 82677, 109186, 2 }, -- Your healing spells and Smite have a $s1% chance to make your next Flash Heal instant and cost no mana. Stacks to $114255u.
    throes_of_pain             = { 82709, 377422, 2 }, -- $?s137032[Shadow Word: Pain and Purge the Wicked deal][Shadow Word: Pain deals] an additional $s1% damage. When an enemy dies while afflicted by your $?s137032[Shadow Word: Pain or Purge the Wicked][Shadow Word: Pain], you gain $?a137033[${$s3/100} Insanity.][${$s5/10}.1% Mana.]
    tithe_evasion              = { 82688, 373223, 1 }, -- Shadow Word: Death deals $s1% less damage to you.
    translucent_image          = { 82685, 373446, 1 }, -- Fade reduces damage you take by $373447s1%.
    twins_of_the_sun_priestess = { 82683, 373466, 1 }, -- Power Infusion also grants you $s1% of its effects when used on an ally.
    twist_of_fate              = { 82684, 390972, 2 }, -- After damaging or healing a target below $s3% health, gain $s1% increased damage and healing for $390978d.
    unwavering_will            = { 82697, 373456, 2 }, -- While above $s2% health, the cast time of your $?a137033[Flash Heal is]?a137032[Flash Heal and Smite are][Flash Heal, Heal, Prayer of Healing, and Smite are] reduced by $s1%.
    vampiric_embrace           = { 82691, 15286 , 1 }, -- Fills you with the embrace of Shadow energy for $d, causing you to heal a nearby ally for $s1% of any single-target Shadow spell damage you deal.
    void_shield                = { 82692, 280749, 1 }, -- When cast on yourself, $s1% of damage you deal refills your Power Word: Shield.
    void_shift                 = { 82674, 108968, 1 }, -- Swap health percentages with your ally. Increases the lower health percentage of the two to $s1% if below that amount.
    void_tendrils              = { 82708, 108920, 1 }, -- Summons shadowy tendrils, rooting all enemies within $108920A1 yards for $114404d or until the tendril is killed.
    words_of_the_pious         = { 82721, 377438, 1 }, -- For $390933d after casting Power Word: Shield, you deal $390933s1% additional damage and healing with Smite and Holy Nova.

    -- Shadow Talents
    ancient_madness            = { 82656, 341240, 1 }, -- Voidform and Dark Ascension increase the critical strike chance of your spells by $s1% for $194249d, reducing by ${$s2/10}.1% every sec.
    auspicious_spirits         = { 82667, 155271, 1 }, -- Your Shadowy Apparitions deal $s1% increased damage and have a chance to generate ${$m2/100} Insanity.
    collapsing_void            = { 94694, 448403, 1 }, -- Each time $?c3[you cast Devouring Plague][Penance damages or heals], Entropic Rift is empowered, increasing its damage and size by $?c1[$s4][$s3]%.; After Entropic Rift ends it collapses, dealing $448405s1 Shadow damage split amongst enemy targets within $448405a1 yds.
    concentrated_infusion      = { 94676, 453844, 1 }, -- Your Power Infusion effect grants you an additional $s1% haste.
    dark_ascension             = { 82657, 391109, 1 }, -- Increases your non-periodic Shadow damage by $s1% for $d.; Generates ${$m6/100} Insanity.
    dark_energy                = { 94693, 451018, 1 }, -- $?c3[Void Torrent can be used while moving. ][]While Entropic Void is active, you move $s1% faster. 
    dark_evangelism            = { 82660, 391095, 2 }, -- Your Mind Flay, Mind Spike, and Void Torrent damage increase the damage of your periodic Shadow effects by $s2%, stacking up to $391099U times.
    darkening_horizon          = { 94695, 449912, 1 }, -- Void Blast increases the duration of Entropic Rift by $?c1[${$s1}.1][${$s3}.1] sec, up to a maximum of $s2 sec.
    deathspeaker               = { 82558, 392507, 1 }, -- Your Shadow Word: Pain damage has a chance to reset the cooldown of Shadow Word: Death, increase its damage by $392511s2%, and deal damage as if striking a target below $32379s3% health.
    depth_of_shadows           = { 100212, 451308, 1 }, -- Shadow Word: Death has a high chance to summon a Shadowfiend for $s1 sec when damaging targets below $s2% health.
    devour_matter              = { 94668, 451840, 1 }, -- Shadow Word: Death consumes absorb shields from your target, dealing $32379s1 extra damage to them and granting you $?c3[$s3 Insanity][$s2% mana] if a shield was present.
    devouring_plague           = { 82665, 335467, 1 }, -- Afflicts the target with a disease that instantly causes $s1 Shadow damage plus an additional $o2 Shadow damage over $d. Heals you for ${($e2+$137033s17+$137033s18)*100}% of damage dealt.; If this effect is reapplied, any remaining damage will be added to the new Devouring Plague.
    dispersion                 = { 82663, 47585 , 1 }, -- Disperse into pure shadow energy, reducing all damage taken by $s1% for $d and healing you for $<heal>% of your maximum health over its duration, but you are unable to attack or cast spells.; Increases movement speed by $s4% and makes you immune to all movement impairing effects.; Castable while stunned, feared, or silenced. 
    distorted_reality          = { 82647, 409044, 1 }, -- Increases the damage of Devouring Plague by $s3% and causes it to deal its damage over $s1 sec, but increases its Insanity cost by ${$s5/100}.
    divine_halo                = { 94702, 449806, 1 }, -- Halo now centers around you and returns to you after it reaches its maximum distance, healing allies and damaging enemies each time it passes through them.
    divine_star                = { 82680, 122121, 1 }, -- Throw a Divine Star forward $s2 yds, healing allies in its path for $110745s1 and dealing $<shadowdstardamage> Shadow damage to enemies. After reaching its destination, the Divine Star returns to you, healing allies and damaging enemies in its path again. Healing reduced beyond $s1 targets.$?s137033[; Generates ${$m3/100} Insanity.][]
    embrace_the_shadow         = { 94696, 451569, 1 }, -- You absorb $s3% of all magic damage taken. Absorbing Shadow damage heals you for $s2% of the amount absorbed.
    empowered_surges           = { 94688, 453799, 1 }, -- $?a137033[Increases the damage done by Mind Flay: Insanity and Mind Spike: Insanity by $s2%.; ][]Increases the healing done by Flash Heals affected by Surge of Light by $s1%.
    energy_compression         = { 94678, 449874, 1 }, -- Halo damage and healing is increased by $s1%.
    energy_cycle               = { 94685, 453828, 1 }, -- $?a137031[Consuming Surge of Light reduces the cooldown of Holy Word: Sanctify by ${$s1/-1000} sec.][Consuming Surge of Insanity has a $s2% chance to conjure Shadowy Apparitions.]
    entropic_rift              = { 94684, 447444, 1 }, -- $?c3[Void Torrent][Mind Blast] tears open an Entropic Rift that follows the enemy for $450193d. Enemies caught in its path suffer $447448s1 Shadow damage every $459314t1 sec while within its reach.
    halo                       = { 82680, 120644, 1 }, -- Creates a ring of Shadow energy around you that quickly expands to a $s2 yd radius, healing allies for $120692s1 and dealing $<shadowhalodamage> Shadow damage to enemies. Healing reduced beyond $s1 targets.$?s137033[; Generates ${$m4/100} Insanity.][]
    heightened_alteration      = { 94680, 453729, 1 }, -- $?a137031[Increases the duration of Spirit of Redemption by ${$s1/1000} sec.][Increases the duration of Dispersion by ${$s2/1000} sec.]
    idol_of_cthun              = { 82643, 377349, 1 }, -- [193473] Assaults the target's mind with Shadow energy, causing $o1 Shadow damage over $d and slowing their movement speed by $s2%.; Generates ${$s3*$377358s1/100} Insanity over the duration.
    idol_of_nzoth              = { 82552, 373280, 1 }, -- Your periodic Shadow Word: Pain and Vampiric Touch damage has a $h% chance to apply Echoing Void, max $s1 targets.; Each time Echoing Void is applied, it has a chance to collapse, consuming a stack every $373305T1 sec to deal $373304s1 Shadow damage to all nearby enemies. Damage reduced beyond $373304s2 targets.; If an enemy dies with Echoing Void, all stacks collapse immediately.
    idol_of_yoggsaron          = { 82555, 373273, 1 }, -- [373279] Hurls a bolt of dark magic, dealing $s1 Shadow damage and ${$s1*$s2/100} Shadow damage to all enemies within $a1 yards of the target. Damage reduced beyond $s3 targets.
    idol_of_yshaarj            = { 82553, 373310, 1 }, -- Summoning Mindbender causes you to gain a benefit based on your target's current state or increases its duration by $373320s1 sec if no state matches.; Healthy: You and your Mindbender deal $373316s1% additional damage.; Enraged: Devours the Enraged effect, increasing your Haste by $373318s1%.; Stunned: Generates ${$373317s1/100} Insanity every $373317t1 sec.; Feared: You and your Mindbender deal $373319s1% increased damage and do not break Fear effects.
    incessant_screams          = { 94686, 453918, 1 }, -- Psychic Scream creates an image of you at your location. After $s1 sec, the image will let out a Psychic Scream.
    inescapable_torment        = { 82644, 373427, 1 }, -- $?a137032[Penance, ][]Mind Blast and Shadow Word: Death cause your Mindbender or Shadowfiend to teleport behind your target, slashing up to $s1 nearby enemies for $<value> Shadow damage and extending its duration by ${$s2/1000}.1 sec.
    inner_quietus              = { 94670, 448278, 1 }, -- $?c3[Vampiric Touch and Shadow Word: Pain deal $s1% additional damage.][Power Word: Shield absorbs $s2% additional damage.]
    insidious_ire              = { 82560, 373212, 2 }, -- While you have Shadow Word: Pain, Devouring Plague, and Vampiric Touch active on the same target, your Mind Blast and Void Torrent deal $s1% more damage.; 
    intangibility              = { 82659, 288733, 1 }, -- Dispersion heals you for an additional $<intangheal>% of your maximum health over its duration and its cooldown is reduced by ${$s1/-1000} sec.
    last_word                  = { 82652, 263716, 1 }, -- Reduces the cooldown of Silence by ${$s1/-1000} sec.
    maddening_touch            = { 82645, 391228, 2 }, -- Vampiric Touch deals $s1% additional damage and has a chance to generate ${$s2/100} Insanity each time it deals damage.
    malediction                = { 82655, 373221, 1 }, -- Reduces the cooldown of Void Torrent by ${$abs($s1/1000)} sec.
    manifested_power           = { 94699, 453783, 1 }, -- Creating a Halo grants $?a137033[Surge of Insanity][Surge of Light].
    mastermind                 = { 82671, 391151, 2 }, -- Increases the critical strike chance of Mind Blast, Mind Spike, Mind Flay, and Shadow Word: Death by $s1% and increases their critical strike damage by $s2%.
    mental_decay               = { 82658, 375994, 1 }, -- Increases the damage of Mind Flay and Mind Spike by $s3%.; The duration of your Shadow Word: Pain and Vampiric Touch is increased by $s1 sec when enemies suffer damage from Mind Flay and $s2 sec when enemies suffer damage from Mind Spike.
    mental_fortitude           = { 82659, 377065, 1 }, -- Healing from Vampiric Touch and Devouring Plague when you are at maximum health will shield you for the same amount. The shield cannot exceed $s1% of your maximum health.
    mind_devourer              = { 82561, 373202, 2 }, -- Mind Blast has a $s1% chance to make your next Devouring Plague cost no Insanity and deal $373204s2% additional damage.
    mind_melt                  = { 93172, 391090, 1 }, -- Mind Spike increases the critical strike chance of Mind Blast by $s1%, stacking up to $391092U times.; Lasts $391092d.
    mind_spike                 = { 82557, 73510 , 1 }, -- Blasts the target for $s1 Shadowfrost damage.; Generates ${$s2/100} Insanity.
    mindbender                 = { 82648, 200174, 1 }, -- Summons a Mindbender to attack the target for $d.; Generates ${$200010s1/100} Insanity each time the Mindbender attacks.
    minds_eye                  = { 82647, 407470, 1 }, -- Reduces the Insanity cost of Devouring Plague by ${$s1/-100}.
    misery                     = { 93171, 238558, 1 }, -- Vampiric Touch also applies Shadow Word: Pain to the target. Shadow Word: Pain lasts an additional ${$s2/1000} sec.
    no_escape                  = { 94693, 451204, 1 }, -- Entropic Rift slows enemies by up to $s1%, increased the closer they are to its center.
    perfected_form             = { 94677, 453917, 1 }, -- $?a137031[Your healing done is increased by $s3% while Apotheosis is active and for 20 sec after you cast Holy Word: Salvation.][Your damage dealt is increased by $s5% while Dark Ascension is active and by $s1% while Voidform is active.]
    phantasmal_pathogen        = { 82563, 407469, 2 }, -- Shadow Apparitions deal $s1% increased damage to targets affected by your Devouring Plague.
    power_surge                = { 94697, 453109, 1 }, -- Casting Halo also causes you to create a Halo around you at $s2% effectiveness every $453112t sec for $453112d.; Additionally, the radius of Halo is increased by $s1 yards.
    psychic_horror             = { 82652, 64044 , 1 }, -- Terrifies the target in place, stunning them for $d.
    psychic_link               = { 82670, 199484, 1 }, -- Your direct damage spells inflict $s1% of their damage on all other targets afflicted by your Vampiric Touch within $199486A2 yards.; Does not apply to damage from Shadowy Apparitions, Shadow Word: Pain, and Vampiric Touch.
    purify_disease             = { 82704, 213634, 1 }, -- Removes all Disease effects from a friendly target.
    resonant_energy            = { 94681, 453845, 1 }, -- $?a137033[Enemies damaged by your Halo take $453850s1% increased damage from you for $453846d, stacking up to $453846U times.][Allies healed by your Halo receive $453850s1% increased healing from you for $453850d, stacking up to $453850U times.]
    screams_of_the_void        = { 82649, 375767, 2 }, -- Devouring Plague causes your Shadow Word: Pain and Vampiric Touch to deal damage $s1% faster on all targets for $393919d.
    shadow_crash               = { 82669, 205385, 1 }, -- Aim a bolt of slow-moving Shadow energy at the destination, dealing $205386s1 Shadow damage to all enemies within $A1 yds.; Generates $/100;s2 Insanity.; This spell is cast at a selected location.
    shadowy_apparitions        = { 82666, 341491, 1 }, -- Mind Blast, Devouring Plague, and Void Bolt conjure Shadowy Apparitions that float towards all targets afflicted by your Vampiric Touch for $413231s1 Shadow damage. ; Critical strikes increase the damage by $s2%.
    shadowy_insight            = { 82662, 375888, 1 }, -- Shadow Word: Pain periodic damage has a chance to reset the remaining cooldown on Mind Blast and cause your next Mind Blast to be instant.
    shock_pulse                = { 94686, 453852, 1 }, -- Halo damage reduces enemy movement speed by $453848s1% for $453848d, stacking up to $453848U times.
    silence                    = { 82651, 15487 , 1 }, -- Silences the target, preventing them from casting spells for $d. Against non-players, also interrupts spellcasting and prevents any spell in that school from being cast for $263715d.
    surge_of_insanity          = { 82668, 391399, 1 }, -- [391403] Assaults the target's mind with Shadow energy, causing $o1 Shadow damage over $d and slowing their movement speed by $s2%.; Generates ${$s4*$s3/100} Insanity over the duration.
    sustained_potency          = { 94678, 454001, 1 }, -- Creating a Halo extends the duration of $?a137031[Apotheosis by ${$s1/1000} sec. ; If Apotheosis is not active][Dark Ascension or Voidform by ${$s1/1000} sec.; If Dark Ascension and Voidform are not active], up to $454002U seconds is stored and applied the next time you gain $?a137031[Apotheosis][Dark Ascension or Voidform].
    thought_harvester          = { 82653, 406788, 1 }, -- Mind Blast gains an additional charge.
    tormented_spirits          = { 93170, 391284, 2 }, -- Your Shadow Word: Pain damage has a $s1% chance to create Shadowy Apparitions that float towards all targets afflicted by your Vampiric Touch. ; Critical strikes increase the chance to $s2%.
    unfurling_darkness         = { 82661, 341273, 1 }, -- After casting Vampiric Touch on a target, your next Vampiric Touch within $341282d is instant cast and deals $34914s4 Shadow damage immediately.; This effect cannot occur more than once every $341291d.
    void_blast                 = { 94703, 450405, 1 }, -- [450215] Sends a blast of cosmic void energy at the enemy, causing $s1 Shadow damage.$?c3[; Generates ${$c/100*-1} Insanity.][]
    void_empowerment           = { 94695, 450138, 1 }, -- Summoning an Entropic Rift $?c1[extends the duration of your $s4 shortest Atonements by $s1 sec][grants you Mind Devourer].
    void_eruption              = { 82657, 228260, 1 }, -- Releases an explosive blast of pure void energy, activating Voidform and causing ${$228360s1*2} Shadow damage to all enemies within $a1 yds of your target.; During Voidform, this ability is replaced by Void Bolt.; Casting Devouring Plague increases the duration of Voidform by ${$s2/1000}.1 sec.
    void_infusion              = { 94669, 450612, 1 }, -- $?c1[Atonement healing with Void Blast is 100% more effective.][Void Blast generates 100% additional Insanity.]
    void_leech                 = { 94696, 451311, 1 }, -- Every $t1 sec siphon an amount equal to $s1% of your health from an ally within $s3 yds if they are higher health than you.
    void_torrent               = { 82654, 263165, 1 }, -- Channel a torrent of void energy into the target, dealing $o Shadow damage over $d.; Generates ${$289577s1*$289577s2/100} Insanity over the duration.
    voidheart                  = { 94692, 449880, 1 }, -- While Entropic Rift is active, your $?c3[Shadow damage is increased by $s1%] [Atonement healing is increased by $s2%].
    voidtouched                = { 82646, 407430, 1 }, -- Increases your Devouring Plague damage by $s2% and increases your maximum Insanity by ${$s1/100}.
    voidwraith                 = { 100212, 451234, 1 }, -- [451235] Summon a Voidwraith for $d that casts Void Flay from afar. Void Flay deals bonus damage to high health enemies, up to a maximum of $451435s2% if they are full health.$?s137033[; Generates ${$262485s1/100} Insanity each time the Voidwraith attacks.][; Generates ${$34433s4/10}.1% Mana each time the Voidwraith attacks.]
    whispering_shadows         = { 82559, 406777, 1 }, -- Shadow Crash applies Vampiric Touch to up to $391286s1 targets it damages.
    word_of_supremacy          = { 94680, 453726, 1 }, -- Power Word: Fortitude grants you an additional $s1% stamina.
} )

-- PvP Talents
spec:RegisterPvpTalents( {
    absolute_faith       = 5481, -- (408853) Leap of Faith also pulls the spirit of the $s1 furthest allies within $s2 yards and shields you and the affected allies for $<absfaith>.
    catharsis            = 5486, -- (391297) $s2% of all damage you take is stored. The stored amount cannot exceed $s3% of your maximum health. The initial damage of your next $?s204197[Purge the Wicked][Shadow Word: Pain] deals this stored damage to your target.
    driven_to_madness    = 106 , -- (199259) While Voidform or Dark Ascension is not active, being attacked will reduce the cooldown of Void Eruption and Dark Ascension by ${$199260m1/-1000} sec.
    improved_mass_dispel = 5636, -- (426438) Reduces the cooldown of Mass Dispel by ${$s1/-1000} sec.
    mind_trauma          = 113 , -- (199445) Siphon haste from enemies, stealing $247776s1% haste per stack of Mind Trauma, stacking up to $247776u times. Mind Spike and fully channeled Mind Flays grant $s1 $Lstack:stacks; of Mind Trauma and fully channeled Void Torrents grant $247777u $Lstack:stacks; of Mind Trauma. Lasts $247776d.; You can only gain $247777u stacks of Mind Trauma from a single enemy.
    mindgames            = 5638, -- (375901) Assault an enemy's mind, dealing ${$s1*$m3/100} Shadow damage and briefly reversing their perception of reality.; For $d, the next $<damage> damage they deal will heal their target, and the next $<healing> healing they deal will damage their target.$?s137033[; Generates ${$m8/100} Insanity.][]
    phase_shift          = 5568, -- (408557) Step into the shadows when you cast Fade, avoiding all attacks and spells for $408558d.; Interrupt effects are not affected by Phase Shift.
    psyfiend             = 763 , -- (211522) [199845] Deals up to $s2% of the target's total health in Shadow damage every $t1 sec. Also slows their movement speed by $s3% and reduces healing received by $s4%.
    thoughtsteal         = 5381, -- (316262) Peer into the mind of the enemy, attempting to steal a known spell. If stolen, the victim cannot cast that spell for $322431d.; Can only be used on Humanoids with mana. If you're unable to find a spell to steal, the cooldown of Thoughtsteal is reset.
    void_volley          = 5447, -- (357711) After casting Void Eruption or Dark Ascension, send a slow-moving bolt of Shadow energy at a random location every $357714T sec for $357714d, dealing $357715s1 Shadow damage to all targets within $357715A yds, and causing them to flee in Horror for $358861d.
} )

-- Auras
spec:RegisterAuras( {
    -- Absorbs $w1 damage.
    angelic_bulwark = {
        id = 114214,
        duration = 20.0,
        max_stack = 1,
    },
    -- Movement speed increased by $w1%.
    angelic_feather = {
        id = 121557,
        duration = 5.0,
        max_stack = 1,
    },
    -- Movement speed reduced by $s1%.
    apathy = {
        id = 390669,
        duration = 4.0,
        max_stack = 1,
    },
    -- Flying.
    ascension = {
        id = 161862,
        duration = 20.0,
        max_stack = 1,
    },
    -- Healing $w1 damage every $t1 sec.
    blessed_recovery = {
        id = 390771,
        duration = 6.0,
        max_stack = 1,
    },
    -- Movement speed increased by $s1%.
    body_and_soul = {
        id = 65081,
        duration = 3.0,
        max_stack = 1,
    },
    -- Your non-periodic Shadow damage is increased by $w1%$?$w2>0[ and all damage is increased by $w2%][]. $?s341240[Critical strike chance increased by ${$W4}.1%.][]
    dark_ascension = {
        id = 391109,
        duration = 20.0,
        tick_time = 1.0,
        max_stack = 1,

        -- Affected by:
        -- perfected_form[453917] #4: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- perfected_form[453917] #5: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_5_VALUE, }
    },
    -- Periodic Shadow damage increased by $w1%.
    dark_evangelism = {
        id = 391099,
        duration = 25.0,
        max_stack = 1,

        -- Affected by:
        -- dark_evangelism[391095] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- dark_evangelism[391095] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
    },
    -- If the target dies within $d, the Priest gains ${$321973s1/100} Insanity.
    death_and_madness = {
        id = 322098,
        duration = 7.0,
        max_stack = 1,
    },
    -- Shadow Word: Death damage increased by $s2% and your next Shadow Word: Death deals damage as if striking a target below $32379s2% health.
    deathspeaker = {
        id = 392511,
        duration = 15.0,
        max_stack = 1,
    },
    -- Maximum health increased by $w1%.
    desperate_prayer = {
        id = 19236,
        duration = 10.0,
        tick_time = 1.0,
        max_stack = 1,

        -- Affected by:
        -- lights_inspiration[373450] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- lights_inspiration[373450] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
    },
    -- The duration of Shadowfiend is extended by $s1 sec.
    devoured_violence = {
        id = 373320,
        duration = 0.0,
        max_stack = 1,
    },
    -- Suffering $w2 damage every $t2 sec.
    devouring_plague = {
        id = 335467,
        duration = 6.0,
        max_stack = 1,

        -- Affected by:
        -- shadow_priest[137033] #16: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_TAKEN_BY_PCT, }
        -- shadow_priest[137033] #17: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_TAKEN_BY_PCT, }
        -- dark_ascension[391109] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- distorted_reality[409044] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 6000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- distorted_reality[409044] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- distorted_reality[409044] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -40.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- distorted_reality[409044] #4: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 500.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- minds_eye[407470] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- voidtouched[407430] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 6.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- voidtouched[407430] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 6.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- dark_evangelism[391099] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- mind_devourer[373204] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
    },
    -- Damage taken reduced by $s1%. Healing for $<heal>% of maximum health.; Cannot attack or cast spells.; Movement speed increased by $s4% and immune to all movement impairing effects.
    dispersion = {
        id = 47585,
        duration = 6.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- heightened_alteration[453729] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 2000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- intangibility[288733] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -30000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
    },
    -- A Naaru is at your side. Whenever you cast a spell, the Naaru will cast a similar spell.
    divine_image = {
        id = 392990,
        duration = 9.0,
        max_stack = 1,
    },
    -- Under the control of $@auracaster.
    dominate_mind = {
        id = 205364,
        duration = 30.0,
        max_stack = 1,
    },
    -- Healing $w1 every $t1 sec.
    echo_of_light = {
        id = 77489,
        duration = 4.0,
        max_stack = 1,
    },
    -- Reduced threat level. Enemies have a reduced attack range against you.$?e3; [ ; Damage taken reduced by $s4%.][]
    fade = {
        id = 586,
        duration = 10.0,
        max_stack = 1,

        -- Affected by:
        -- improved_fade[390670] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -5000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- phantom_reach[459559] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
    },
    -- All magical damage taken reduced by $w1%.; All physical damage taken reduced by $w2%.
    focused_will = {
        id = 426401,
        duration = 8.0,
        max_stack = 1,

        -- Affected by:
        -- discipline_priest[137032] #14: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'modifies': MAX_STACKS, }
        -- holy_priest[137031] #12: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'modifies': MAX_STACKS, }
    },
    -- Conjuring $373273s1 Shadowy Apparitions will summon a Thing from Beyond.
    idol_of_yoggsaron = {
        id = 373276,
        duration = 120.0,
        max_stack = 1,
    },
    -- Reduces physical damage taken by $s1%.
    inspiration = {
        id = 390677,
        duration = 15.0,
        max_stack = 1,
    },
    -- Being pulled toward the Priest.
    leap_of_faith = {
        id = 73325,
        duration = 4.0,
        max_stack = 1,
    },
    -- Levitating.$?a343988[; Movement speed increased by $343988w%.][]
    levitate = {
        id = 111759,
        duration = 600.0,
        max_stack = 1,
    },
    -- Healing taken from the Priest increased by $s1%.
    light_of_tuure = {
        id = 208065,
        duration = 10.0,
        max_stack = 1,
    },
    -- Increases the threshold at which Shadow Word: Death will do extra damage by $s1%. Increases the extra damage by $s2%.
    looming_death = {
        id = 364675,
        duration = 3600,
        max_stack = 1,
    },
    -- Under the command of $@auracaster.
    mind_control = {
        id = 605,
        duration = 30.0,
        max_stack = 1,

        -- Affected by:
        -- phantom_reach[459559] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
    },
    -- Your next Devouring Plague costs 0 Insanity and deals $w2% additional damage.
    mind_devourer = {
        id = 373204,
        duration = 15.0,
        max_stack = 1,
    },
    -- Movement speed slowed by $s2% and taking Shadow damage every $t1 sec.
    mind_flay = {
        id = 15407,
        duration = 4.5,
        tick_time = 0.75,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- shadow_priest[137033] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadow_priest[137033] #29: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -2.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #30: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -2.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadowform[232698] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['No Immunity'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadowform[232698] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['No Immunity'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- dark_ascension[391109] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dark_ascension[391109] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- dark_ascension[391109] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- mastermind[391151] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 4.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- mastermind[391151] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- mental_decay[375994] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- dark_evangelism[391099] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- voidform[194249] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- voidform[194249] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- voidform[194249] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- discipline_priest[137032] #10: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.5, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #11: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- discipline_priest[137032] #22: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #23: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twist_of_fate[390978] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twist_of_fate[390978] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 43.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 43.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- schism[214621] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },
    -- The critical strike chance of your next Mind Blast is increased by $w1%.
    mind_melt = {
        id = 391092,
        duration = 10.0,
        max_stack = 1,

        -- Affected by:
        -- mind_melt[391090] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
    },
    -- Reduced distance at which target will attack.
    mind_soothe = {
        id = 453,
        duration = 20.0,
        max_stack = 1,

        -- Affected by:
        -- phantom_reach[459559] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
    },
    -- $w1% haste stolen from targets with Mind Trauma.
    mind_trauma = {
        id = 247776,
        duration = 15.0,
        max_stack = 1,
    },
    -- Sight granted through target's eyes.
    mind_vision = {
        id = 2096,
        duration = 60.0,
        max_stack = 1,

        -- Affected by:
        -- phantom_reach[459559] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
    },
    -- The next $w2 damage and $w5 healing dealt will be reversed.
    mindgames = {
        id = 375901,
        duration = 7.0,
        max_stack = 1,

        -- Affected by:
        -- dark_ascension[391109] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twilight_equilibrium[390707] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #12: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -38.81, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #8: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #9: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },
    -- Movement speed is unhindered.
    phantasm = {
        id = 114239,
        duration = 0.0,
        max_stack = 1,
    },
    -- Most melee attacks, ranged attacks, and spells will miss you.
    phase_shift = {
        id = 408558,
        duration = 1.0,
        max_stack = 1,
    },
    -- Haste increased by $w1%.
    power_infusion = {
        id = 10060,
        duration = 15.0,
        max_stack = 1,
    },
    -- Stamina increased by $w1%.$?$w2>0[; Magic damage taken reduced by $w2%.][]
    power_word_fortitude = {
        id = 21562,
        duration = 3600.0,
        max_stack = 1,
    },
    -- Absorbs $w1 damage.
    power_word_shield = {
        id = 17,
        duration = 15.0,
        tick_time = 1.0,
        max_stack = 1,

        -- Affected by:
        -- shadow_priest[137033] #7: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- shadow_priest[137033] #18: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_24, }
        -- shadow_priest[137033] #27: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_24, }
        -- priest[137030] #0: { 'type': APPLY_AURA, 'subtype': MOD_COOLDOWN_BY_HASTE_REGEN, 'points': 100.0, 'target': TARGET_UNIT_CASTER, }
        -- benevolence[415416] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 3.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_24, }
        -- phantom_reach[459559] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
        -- inner_quietus[448278] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_24, }
        -- discipline_priest[137032] #18: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 33.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_24, }
        -- discipline_priest[137032] #21: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_24, }
    },
    -- Damage taken reduced by $w1%.
    protective_light = {
        id = 193065,
        duration = 10.0,
        max_stack = 1,
    },
    -- Stunned.
    psychic_horror = {
        id = 64044,
        duration = 4.0,
        max_stack = 1,

        -- Affected by:
        -- phantom_reach[459559] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -13.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
    },
    -- Disoriented.
    psychic_scream = {
        id = 8122,
        duration = 8.0,
        max_stack = 1,

        -- Affected by:
        -- petrifying_scream[55676] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -4.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- phantom_reach[459559] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
        -- psychic_voice[196704] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -15000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
    },
    -- Healing $w1 health every $t1 sec.
    renew = {
        id = 139,
        duration = 15.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- shadow_priest[137033] #25: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- light_of_tuure[208065] #0: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'trigger_spell': 196685, 'points': 25.0, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- benevolence[415416] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 3.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- benevolence[415416] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 3.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- phantom_reach[459559] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
        -- renew[139] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- discipline_priest[137032] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- discipline_priest[137032] #16: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #17: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twist_of_fate[390978] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twist_of_fate[390978] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #13: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #20: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -9.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #24: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 6.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #25: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -3.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #26: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 6.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #27: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -3.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
    },
    -- The damage of your next Holy Nova is increased by $w1% and its healing is increased by $w2%.
    rhapsody = {
        id = 390636,
        duration = 3600,
        max_stack = 1,

        -- Affected by:
        -- discipline_priest[137032] #26: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': -37.5, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
    },
    -- Taking $s1% increased damage from the Priest.
    schism = {
        id = 214621,
        duration = 9.0,
        max_stack = 1,

        -- Affected by:
        -- twilight_equilibrium[390707] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },
    -- Shadow Word: Pain and Vampiric Touch are dealing damage $w2% faster.
    screams_of_the_void = {
        id = 393919,
        duration = 3.0,
        max_stack = 1,

        -- Affected by:
        -- screams_of_the_void[375767] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 40.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- screams_of_the_void[375767] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': -28.6, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
    },
    -- Shackled.
    shackle_undead = {
        id = 9484,
        duration = 50.0,
        max_stack = 1,

        -- Affected by:
        -- phantom_reach[459559] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
    },
    -- Suffering $w2 Shadow damage every $t2 sec.
    shadow_word_pain = {
        id = 589,
        duration = 16.0,
        tick_time = 2.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- shadow_priest[137033] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadow_priest[137033] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadow_priest[137033] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #10: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 21.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadow_priest[137033] #11: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 21.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #29: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -2.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #30: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -2.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadowform[232698] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['No Immunity'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadowform[232698] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['No Immunity'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- manipulation[459985] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -1.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_4_VALUE, }
        -- phantom_reach[459559] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
        -- throes_of_pain[377422] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 3.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- throes_of_pain[377422] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 3.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- dark_ascension[391109] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dark_ascension[391109] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dark_ascension[391109] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- dark_ascension[391109] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- inner_quietus[448278] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- inner_quietus[448278] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- misery[238558] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5000.0, 'modifies': BUFF_DURATION, }
        -- dark_evangelism[391099] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- voidform[194249] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- voidform[194249] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- voidform[194249] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- discipline_priest[137032] #6: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 18.1, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- discipline_priest[137032] #7: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 18.1, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #10: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.5, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #11: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- discipline_priest[137032] #22: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #23: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twist_of_fate[390978] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twist_of_fate[390978] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 43.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 43.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #6: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 69.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #7: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 69.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- screams_of_the_void[393919] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': AURA_PERIOD, }
        -- schism[214621] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },
    -- 343726
    shadowfiend = {
        id = 34433,
        duration = 15.0,
        max_stack = 1,

        -- Affected by:
        -- dark_ascension[391109] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },
    -- Spell damage dealt increased by $s1%.
    shadowform = {
        id = 232698,
        duration = 3600,
        max_stack = 1,
    },
    -- Movement speed reduced by $w1%.
    shock_pulse = {
        id = 453848,
        duration = 5.0,
        max_stack = 1,
    },
    -- Silenced.
    silence = {
        id = 15487,
        duration = 4.0,
        max_stack = 1,

        -- Affected by:
        -- last_word[263716] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -15000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
    },
    -- Next Flash Heal is instant$?$w5>0[, heals for $w5% more,][] and costs no mana.
    surge_of_light = {
        id = 114255,
        duration = 20.0,
        max_stack = 1,

        -- Affected by:
        -- empowered_surges[453799] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_5_VALUE, }
    },
    -- A Thing from Beyond serves you in combat, blasting enemies for $373279s1 Shadow damage.
    thing_from_beyond = {
        id = 373277,
        duration = 20.0,
        max_stack = 1,
    },
    -- Stolen a spell from an enemy, preventing them from casting it for $d.
    thoughtsteal = {
        id = 322431,
        duration = 20.0,
        max_stack = 1,
    },
    -- Damage taken reduced by $w%.
    translucent_image = {
        id = 373447,
        duration = 8.0,
        max_stack = 1,
    },
    -- The damage of your next Holy spell is increased by $s1%.
    twilight_equilibrium = {
        id = 390706,
        duration = 6.0,
        max_stack = 1,
    },
    -- Increases damage and healing by $w1%.
    twist_of_fate = {
        id = 390978,
        duration = 8.0,
        max_stack = 1,

        -- Affected by:
        -- twist_of_fate[390972] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- twist_of_fate[390972] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER_BY_LABEL, 'points': 5.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
    },
    -- Unfurling Darkness cannot occur.
    unfurling_darkness = {
        id = 341291,
        duration = 15.0,
        max_stack = 1,
    },
    -- $15286s1% of any single-target Shadow spell damage you deal heals a nearby ally.
    vampiric_embrace = {
        id = 15286,
        duration = 12.0,
        tick_time = 0.5,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- sanlayn[199855] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -30000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- sanlayn[199855] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
    },
    -- Suffering $w2 Shadow damage every $t2 sec.
    vampiric_touch = {
        id = 34914,
        duration = 21.0,
        pandemic = true,
        max_stack = 1,

        -- Affected by:
        -- shadow_priest[137033] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadow_priest[137033] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadow_priest[137033] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #16: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_TAKEN_BY_PCT, }
        -- shadow_priest[137033] #17: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_TAKEN_BY_PCT, }
        -- shadow_priest[137033] #29: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -2.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #30: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -2.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadowform[232698] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['No Immunity'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadowform[232698] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['No Immunity'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- dark_ascension[391109] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dark_ascension[391109] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- dark_ascension[391109] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- inner_quietus[448278] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- inner_quietus[448278] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- maddening_touch[391228] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- dark_evangelism[391099] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- unfurling_darkness[341282] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -1500.0, 'target': TARGET_UNIT_CASTER, 'modifies': CAST_TIME, }
        -- voidform[194249] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- voidform[194249] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- voidform[194249] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- discipline_priest[137032] #10: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.5, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #11: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- discipline_priest[137032] #22: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #23: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twist_of_fate[390978] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twist_of_fate[390978] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 43.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 43.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- screams_of_the_void[393919] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': AURA_PERIOD, }
        -- schism[214621] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },
    -- A Shadowy tendril is appearing under you.
    void_tendrils = {
        id = 108920,
        duration = 0.5,
        max_stack = 1,
    },
    -- Generates ${$s1*$s2/100} Insanity over $d.
    void_torrent = {
        id = 289577,
        duration = 3.9,
        max_stack = 1,
    },
    -- Throwing volleys of Shadow energy.
    void_volley = {
        id = 357714,
        duration = 3.0,
        tick_time = 0.5,
        max_stack = 1,
    },
    -- Spell damage dealt increased by $w1%.; $?s341240[Critical strike chance increased by ${$W3}.1%.][]
    voidform = {
        id = 194249,
        duration = 20.0,
        tick_time = 1.0,
        max_stack = 1,

        -- Affected by:
        -- perfected_form[453917] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- perfected_form[453917] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
    },
    -- Damage and healing of Smite and Holy Nova is increased by $s1%.
    words_of_the_pious = {
        id = 390933,
        duration = 12.0,
        max_stack = 1,
    },
} )

-- Abilities
spec:RegisterAbilities( {
    -- Places a feather at the target location, granting the first ally to walk through it $121557s1% increased movement speed for $121557d.$?a440670[ When an ally walks through a feather, you are also granted $440670s3% of its effect.][] Only 3 feathers can be placed at one time.
    angelic_feather = {
        id = 121536,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        talent = "angelic_feather",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'radius': 2.0, 'target': TARGET_UNIT_DEST_AREA_ALLY, }
    },

    -- Ascend into the air, keeping you out of harm's way. Lasts $d. Can only be used while in Ashran.
    ascension = {
        id = 161862,
        cast = 0.0,
        cooldown = 90.0,
        gcd = "global",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': FLY, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_VEHICLE_SPEED_ALWAYS, 'points': 150.0, 'target': TARGET_UNIT_CASTER, }
    },

    -- Increases your non-periodic Shadow damage by $s1% for $d.; Generates ${$m6/100} Insanity.
    dark_ascension = {
        id = 391109,
        cast = 1.5,
        cooldown = 60.0,
        gcd = "global",

        talent = "dark_ascension",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- #2: { 'type': APPLY_AURA, 'subtype': PERIODIC_DUMMY, 'tick_time': 1.0, 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- #5: { 'type': ENERGIZE, 'subtype': NONE, 'points': 3000.0, 'target': TARGET_UNIT_CASTER, 'resource': insanity, }

        -- Affected by:
        -- perfected_form[453917] #4: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- perfected_form[453917] #5: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_5_VALUE, }
    },

    -- Increases maximum health by $?s373450[${$s1+$373450s1}][$s1]% for $?a458718[${($458718s1+$s4)/1000}][${$s4/1000}] sec, and instantly heals you for that amount.
    desperate_prayer = {
        id = 19236,
        cast = 0.0,
        cooldown = 90.0,
        gcd = "none",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_INCREASE_HEALTH_PERCENT, 'points': 25.0, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': HEAL_PCT, 'subtype': NONE, 'points': 25.0, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': PERIODIC_DUMMY, 'tick_time': 1.0, 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': DUMMY, 'subtype': NONE, }

        -- Affected by:
        -- lights_inspiration[373450] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
        -- lights_inspiration[373450] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
    },

    -- Afflicts the target with a disease that instantly causes $s1 Shadow damage plus an additional $o2 Shadow damage over $d. Heals you for ${($e2+$137033s17+$137033s18)*100}% of damage dealt.; If this effect is reapplied, any remaining damage will be added to the new Devouring Plague.
    devouring_plague = {
        id = 335467,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 5000,
        spendType = 'insanity',

        talent = "devouring_plague",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': HEALTH_LEECH, 'subtype': NONE, 'amplitude': 0.3, 'sp_bonus': 1.91245, 'pvp_multiplier': 0.89, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': PERIODIC_LEECH, 'amplitude': 0.3, 'tick_time': 3.0, 'sp_bonus': 0.9083, 'pvp_multiplier': 0.89, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #2: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 100.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #3: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #4: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- shadow_priest[137033] #16: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_TAKEN_BY_PCT, }
        -- shadow_priest[137033] #17: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_TAKEN_BY_PCT, }
        -- dark_ascension[391109] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- distorted_reality[409044] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 6000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- distorted_reality[409044] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- distorted_reality[409044] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -40.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- distorted_reality[409044] #4: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 500.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- minds_eye[407470] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -500.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- voidtouched[407430] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 6.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- voidtouched[407430] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 6.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- dark_evangelism[391099] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- mind_devourer[373204] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
    },

    -- Dispels Magic on the enemy target, removing $m1 beneficial Magic $leffect:effects;.
    dispel_magic = {
        id = 528,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 0.020,
        spendType = 'mana',

        spend = 0.020,
        spendType = 'mana',

        spend = 0.140,
        spendType = 'mana',

        talent = "dispel_magic",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': DISPEL, 'subtype': NONE, 'points': 1.0, 'value': 1, 'schools': ['physical'], 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- mental_agility[341167] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -10.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- mental_agility[341167] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -10.0, 'target': TARGET_UNIT_CASTER, 'modifies': IGNORE_SHAPESHIFT, }
        -- mental_agility[341167] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -10.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- phantom_reach[459559] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
    },

    -- Disperse into pure shadow energy, reducing all damage taken by $s1% for $d and healing you for $<heal>% of your maximum health over its duration, but you are unable to attack or cast spells.; Increases movement speed by $s4% and makes you immune to all movement impairing effects.; Castable while stunned, feared, or silenced. 
    dispersion = {
        id = 47585,
        cast = 0.0,
        cooldown = 120.0,
        gcd = "global",

        talent = "dispersion",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_DAMAGE_PERCENT_TAKEN, 'points': -75.0, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 100.0, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MOD_PACIFY_SILENCE, 'value': 127, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': APPLY_AURA, 'subtype': MOD_INCREASE_SPEED, 'points': 50.0, 'target': TARGET_UNIT_CASTER, }
        -- #4: { 'type': APPLY_AURA, 'subtype': OBS_MOD_HEALTH, 'tick_time': 1.0, 'points': 25.0, 'target': TARGET_UNIT_CASTER, }
        -- #5: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'target': TARGET_UNIT_CASTER, 'mechanic': 7, }
        -- #6: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'target': TARGET_UNIT_CASTER, 'mechanic': 11, }
        -- #7: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 7.0, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- heightened_alteration[453729] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 2000.0, 'target': TARGET_UNIT_CASTER, 'modifies': BUFF_DURATION, }
        -- intangibility[288733] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -30000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
    },

    -- Throw a Divine Star forward $s2 yds, healing allies in its path for $110745s1 and dealing $<shadowdstardamage> Shadow damage to enemies. After reaching its destination, the Divine Star returns to you, healing allies and damaging enemies in its path again. Healing reduced beyond $s1 targets.$?s137033[; Generates ${$m3/100} Insanity.][]
    divine_star = {
        id = 122121,
        cast = 0.0,
        cooldown = 15.0,
        gcd = "global",

        spend = 0.020,
        spendType = 'mana',

        spend = 0.020,
        spendType = 'mana',

        talent = "divine_star",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': CREATE_AREATRIGGER, 'subtype': NONE, 'points': 6.0, 'value': 2148, 'schools': ['fire', 'shadow', 'arcane'], 'target': TARGET_DEST_CASTER, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_DEST_CASTER, }
        -- #2: { 'type': ENERGIZE, 'subtype': NONE, 'points': 600.0, 'target': TARGET_UNIT_CASTER, 'resource': insanity, }

        -- Affected by:
        -- light_of_tuure[208065] #0: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'trigger_spell': 196685, 'points': 25.0, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- phantom_reach[459559] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -13.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
    },

    -- Controls a mind up to 1 level above yours for $d while still controlling your own mind. Does not work versus Demonic, Mechanical, or Undead beings$?a205477[][ or players]. This spell shares diminishing returns with other disorienting effects.
    dominate_mind = {
        id = 205364,
        cast = 1.8,
        cooldown = 30.0,
        gcd = "global",

        spend = 0.020,
        spendType = 'mana',

        talent = "dominate_mind",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_CHARM, 'points_per_level': 1.0, 'points': 2.0, 'value': 1, 'schools': ['physical'], 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_DAMAGE_PERCENT_DONE, 'value': 127, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #2: { 'type': DUMMY, 'subtype': NONE, }
    },

    -- Fade out, removing all your threat and reducing enemies' attack range against you for $d.; 
    fade = {
        id = 586,
        cast = 0.0,
        cooldown = 30.0,
        gcd = "none",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_TOTAL_THREAT, 'points': -90000000.0, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_DETECTED_RANGE, 'points': -10.0, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MOD_MINIMUM_SPEED, 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': APPLY_AURA, 'subtype': MOD_DAMAGE_PERCENT_TAKEN, 'points': -10.0, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- improved_fade[390670] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -5000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- phantom_reach[459559] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
    },

    -- A fast spell that heals an ally for $s1.
    flash_heal = {
        id = 2061,
        cast = 1.5,
        cooldown = 0.0,
        gcd = "global",

        spend = 0.1,
        spendType = 'mana',

        -- 0. [137031] holy_priest
        -- spend = 0.036,
        -- spendType = 'mana',

        -- 1. [137033] shadow_priest
        -- spend = 0.100,
        -- spendType = 'mana',

        -- 2. [137032] discipline_priest
        -- spend = 0.036,
        -- spendType = 'mana',

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': HEAL, 'subtype': NONE, 'amplitude': 1.0, 'sp_bonus': 3.4104, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ALLY, }

        -- Affected by:
        -- shadow_priest[137033] #15: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 46.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- light_of_tuure[208065] #0: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'trigger_spell': 196685, 'points': 25.0, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- benevolence[415416] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 3.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- benevolence[415416] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 3.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- improved_flash_heal[393870] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- phantom_reach[459559] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
        -- renew[139] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- unwavering_will[373456] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': CAST_TIME, }
        -- unwavering_will[373456] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- discipline_priest[137032] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- discipline_priest[137032] #15: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 63.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- surge_of_light[114255] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': CAST_TIME, }
        -- surge_of_light[114255] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- surge_of_light[114255] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': IGNORE_SHAPESHIFT, }
        -- surge_of_light[114255] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': -100.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- surge_of_light[114255] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twist_of_fate[390978] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twist_of_fate[390978] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #15: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #16: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 28.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #24: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 6.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #25: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -3.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #26: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 6.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #27: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -3.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
    },

    -- [280752] Your successful Dispel Magic, Mass Dispel, Purify Disease, and Power Word: Shield casts generate $s1 Insanity during combat.
    hallucinations = {
        id = 199579,
        cast = 0.0,
        cooldown = 1.0,
        gcd = "pvp - shadow - hallucinations",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': ENERGIZE, 'subtype': NONE, 'points': 600.0, 'target': TARGET_UNIT_CASTER, 'resource': insanity, }
    },

    -- Creates a ring of Shadow energy around you that quickly expands to a $s2 yd radius, healing allies for $120692s1 and dealing $<shadowhalodamage> Shadow damage to enemies. Healing reduced beyond $s1 targets.$?s137033[; Generates ${$m4/100} Insanity.][]
    halo = {
        id = 120644,
        cast = 1.5,
        cooldown = 60.0,
        gcd = "global",

        spend = 0.027,
        spendType = 'mana',

        spend = 0.040,
        spendType = 'mana',

        talent = "halo",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': CREATE_AREATRIGGER, 'subtype': NONE, 'points': 6.0, 'value': 658, 'schools': ['holy', 'frost'], 'target': TARGET_DEST_CASTER, }
        -- #1: { 'type': CREATE_AREATRIGGER, 'subtype': NONE, 'points': 30.0, 'value': 33742, 'schools': ['holy', 'fire', 'nature', 'arcane'], 'target': TARGET_DEST_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': AREA_TRIGGER, 'value': 33742, 'schools': ['holy', 'fire', 'nature', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': ENERGIZE, 'subtype': NONE, 'points': 1000.0, 'target': TARGET_UNIT_CASTER, 'resource': insanity, }

        -- Affected by:
        -- light_of_tuure[208065] #0: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'trigger_spell': 196685, 'points': 25.0, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- phantom_reach[459559] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -13.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
        -- energy_compression[449874] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 30.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- power_surge[453109] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
    },

    -- An explosion of holy light around you deals up to $s1 Holy damage to enemies and up to $281265s1 healing to allies within $A1 yds, reduced if there are more than $s3 targets.
    holy_nova = {
        id = 132157,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 0.016,
        spendType = 'mana',

        talent = "holy_nova",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'sp_bonus': 0.4095, 'variance': 0.05, 'radius': 12.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_SRC_AREA_ENEMY, }
        -- #1: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 281265, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': DUMMY, 'subtype': NONE, }

        -- Affected by:
        -- shadow_priest[137033] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadow_priest[137033] #29: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -2.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #30: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -2.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadowform[232698] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['No Immunity'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadowform[232698] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['No Immunity'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- dark_ascension[391109] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dark_ascension[391109] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- dark_ascension[391109] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- words_of_the_pious[390933] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- voidform[194249] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- voidform[194249] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- voidform[194249] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- discipline_priest[137032] #10: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.5, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #11: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- discipline_priest[137032] #22: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #23: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- rhapsody[390636] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 43.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 43.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twilight_equilibrium[390706] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- schism[214621] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },

    -- Pulls the spirit of a party or raid member, instantly moving them directly in front of you.
    leap_of_faith = {
        id = 73325,
        cast = 0.0,
        cooldown = 1.0,
        gcd = "none",

        spend = 0.026,
        spendType = 'mana',

        talent = "leap_of_faith",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': SCRIPT_EFFECT, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_RAID, }
        -- #1: { 'type': APPLY_AURA, 'subtype': CAST_WHILE_WALKING_2, 'target': TARGET_UNIT_TARGET_RAID, }
    },

    -- Levitates a party or raid member for $111759d, floating a few feet above the ground, granting slow fall, and allowing travel over water.
    levitate = {
        id = 1706,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 0.009,
        spendType = 'mana',

        spend = 0.009,
        spendType = 'mana',

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_RAID, }

        -- Affected by:
        -- phantom_reach[459559] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
    },

    -- Applies Light of the Naaru to the target, healing for $s2 and increasing your healing done to that target by $208065s1% for $d.
    light_of_tuure = {
        id = 208065,
        color = 'artifact',
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'trigger_spell': 196685, 'points': 25.0, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- #1: { 'type': HEAL, 'subtype': NONE, 'sp_bonus': 1.0, 'points': 1.0, 'target': TARGET_UNIT_TARGET_ALLY, }
    },

    -- Draws upon the power of Light's Wrath, dealing $s1 Radiant damage to the target, increased by $s2% per ally affected by your Atonement.
    lights_wrath = {
        id = 207946,
        color = 'artifact',
        cast = 2.5,
        cooldown = 90.0,
        gcd = "global",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'sp_bonus': 1.75, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },

    -- Dispels magic in a $32375a1 yard radius, removing all harmful Magic from $s4 friendly targets and $32592m1 beneficial Magic $leffect:effects; from $s4 enemy targets. Potent enough to remove Magic that is normally undispellable.
    mass_dispel = {
        id = 32375,
        cast = 1.5,
        cooldown = 120.0,
        gcd = "global",

        spend = 0.080,
        spendType = 'mana',

        spend = 0.080,
        spendType = 'mana',

        spend = 0.200,
        spendType = 'mana',

        talent = "mass_dispel",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': DISPEL, 'subtype': NONE, 'points': 100.0, 'value': 1, 'schools': ['physical'], 'radius': 15.0, 'target': TARGET_UNIT_DEST_AREA_ALLY, }
        -- #1: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 32592, 'points': 1.0, 'radius': 10.0, 'target': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- #2: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 72734, 'points': 72734.0, 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- shadow_priest[137033] #6: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 42.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- mental_agility[341167] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.5, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- mental_agility[341167] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.5, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': IGNORE_SHAPESHIFT, }
        -- mental_agility[341167] #5: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.5, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- improved_mass_dispel[426438] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -60000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
    },

    -- Blasts the target's mind for $s1 Shadow damage$?s424509[ and increases your spell damage to the target by $424509s1% for $214621d.][.]$?s137033[; Generates ${$s2/100} Insanity.][]
    mind_blast = {
        id = 8092,
        cast = 1.5,
        cooldown = 0.0,
        gcd = "global",

        spend = 0.04,
        spendType = 'mana',

        -- 0. [137032] discipline_priest
        -- spend = 0.016,
        -- spendType = 'mana',

        -- 1. [137031] holy_priest
        -- spend = 0.003,
        -- spendType = 'mana',

        -- 2. [137033] shadow_priest
        -- spend = 0.003,
        -- spendType = 'mana',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'sp_bonus': 0.78336, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': ENERGIZE, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, 'resource': insanity, }
        -- #2: { 'type': DUMMY, 'subtype': NONE, }

        -- Affected by:
        -- shadow_priest[137033] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadow_priest[137033] #8: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 600.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- shadow_priest[137033] #12: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': 49.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #21: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 37.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #29: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -2.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #30: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -2.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadowform[232698] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['No Immunity'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadowform[232698] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['No Immunity'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- phantom_reach[459559] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
        -- dark_ascension[391109] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dark_ascension[391109] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dark_ascension[391109] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- dark_ascension[391109] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- mastermind[391151] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 4.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- mastermind[391151] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- thought_harvester[406788] #0: { 'type': APPLY_AURA, 'subtype': MOD_MAX_CHARGES, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
        -- mind_melt[391092] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- twilight_equilibrium[390707] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- voidform[194249] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- voidform[194249] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- voidform[194249] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- discipline_priest[137032] #8: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 80.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #10: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.5, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #11: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- discipline_priest[137032] #22: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #23: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twist_of_fate[390978] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twist_of_fate[390978] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 43.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 43.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- schism[214621] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },

    -- Controls a mind up to 1 level above yours for $d. Does not work versus Demonic$?A320889[][, Undead,] or Mechanical beings. Shares diminishing returns with other disorienting effects.
    mind_control = {
        id = 605,
        cast = 30.0,
        channeled = true,
        cooldown = 0.0,
        gcd = "global",

        spend = 0.020,
        spendType = 'mana',

        talent = "mind_control",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_POSSESS, 'points_per_level': 1.0, 'points': 35.0, 'radius': 100.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_DAMAGE_PERCENT_DONE, 'value': 127, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- phantom_reach[459559] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
    },

    -- Assaults the target's mind with Shadow energy, causing $o1 Shadow damage over $d and slowing their movement speed by $s2%.; Generates ${$s4*$s3/100} Insanity over the duration.
    mind_flay = {
        id = 15407,
        cast = 4.5,
        channeled = true,
        cooldown = 0.0,
        gcd = "global",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': PERIODIC_DAMAGE, 'tick_time': 0.75, 'sp_bonus': 0.440239, 'pvp_multiplier': 1.16, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_DECREASE_SPEED, 'mechanic': snared, 'points': -50.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #2: { 'type': APPLY_AURA, 'subtype': PERIODIC_ENERGIZE, 'tick_time': 0.75, 'points': 200.0, 'value': 13, 'schools': ['physical', 'fire', 'nature'], 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': DUMMY, 'subtype': NONE, }

        -- Affected by:
        -- shadow_priest[137033] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadow_priest[137033] #29: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -2.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #30: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -2.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadowform[232698] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['No Immunity'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadowform[232698] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['No Immunity'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- dark_ascension[391109] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dark_ascension[391109] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- dark_ascension[391109] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- mastermind[391151] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 4.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- mastermind[391151] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- mental_decay[375994] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- dark_evangelism[391099] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- voidform[194249] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- voidform[194249] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- voidform[194249] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- discipline_priest[137032] #10: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.5, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #11: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- discipline_priest[137032] #22: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #23: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twist_of_fate[390978] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twist_of_fate[390978] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 43.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 43.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- schism[214621] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },

    -- Soothes enemies in the target area, reducing the range at which they will attack you by $s1 yards. Only affects Humanoid and Dragonkin targets. Does not cause threat. Lasts $d.
    mind_soothe = {
        id = 453,
        cast = 0.0,
        cooldown = 5.0,
        gcd = "global",

        spend = 0.010,
        spendType = 'mana',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_DETECT_RANGE, 'points': -10.0, 'radius': 12.0, 'target': TARGET_DEST_DEST, 'target2': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, 'radius': 12.0, 'target': TARGET_DEST_DEST, }

        -- Affected by:
        -- phantom_reach[459559] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
    },

    -- Blasts the target for $s1 Shadowfrost damage.; Generates ${$s2/100} Insanity.
    mind_spike = {
        id = 73510,
        cast = 1.5,
        cooldown = 0.0,
        gcd = "global",

        talent = "mind_spike",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'sp_bonus': 0.808652, 'pvp_multiplier': 1.16, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': ENERGIZE, 'subtype': NONE, 'points': 400.0, 'target': TARGET_UNIT_CASTER, 'resource': insanity, }
        -- #2: { 'type': DUMMY, 'subtype': NONE, }

        -- Affected by:
        -- shadow_priest[137033] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadow_priest[137033] #29: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -2.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #30: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -2.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadowform[232698] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['No Immunity'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadowform[232698] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['No Immunity'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- dark_ascension[391109] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dark_ascension[391109] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dark_ascension[391109] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- dark_ascension[391109] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- mastermind[391151] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 4.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- mastermind[391151] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- mental_decay[375994] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- voidform[194249] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- voidform[194249] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- voidform[194249] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- discipline_priest[137032] #10: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.5, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #11: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- discipline_priest[137032] #22: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #23: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twist_of_fate[390978] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twist_of_fate[390978] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 43.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 43.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- schism[214621] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },

    -- Allows the caster to see through the target's eyes for $d. Will not work if the target is in another instance or on another continent.
    mind_vision = {
        id = 2096,
        cast = 60.0,
        channeled = true,
        cooldown = 0.0,
        gcd = "global",

        spend = 0.010,
        spendType = 'mana',

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': BIND_SIGHT, 'radius': 100.0, 'target': TARGET_UNIT_TARGET_ANY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': DUMMY, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MOD_STALKED, 'target': TARGET_UNIT_TARGET_ANY, }

        -- Affected by:
        -- phantom_reach[459559] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
    },

    -- Summons a Mindbender to attack the target for $d.; Generates ${$200010s1/100} Insanity each time the Mindbender attacks.
    mindbender = {
        id = 200174,
        cast = 0.0,
        cooldown = 60.0,
        gcd = "global",

        talent = "mindbender",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SUMMON, 'subtype': NONE, 'value': 62982, 'schools': ['holy', 'fire'], 'value1': 3254, 'target': TARGET_DEST_TARGET_ENEMY, }
        -- #1: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 41967, 'points': 75.0, 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- dark_ascension[391109] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },

    -- Assault an enemy's mind, dealing ${$s1*$m3/100} Shadow damage and briefly reversing their perception of reality.; For $d, the next $<damage> damage they deal will heal their target, and the next $<healing> healing they deal will damage their target.$?s137033[; Generates ${$m8/100} Insanity.][]
    mindgames = {
        id = 375901,
        cast = 1.5,
        cooldown = 45.0,
        gcd = "global",

        spend = 0.020,
        spendType = 'mana',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'sp_bonus': 3.0, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 400.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #2: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 100.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #3: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 375902, 'target': TARGET_UNIT_CASTER, }
        -- #4: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 400.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #5: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 450.0, 'target': TARGET_UNIT_TARGET_ANY, }
        -- #6: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 375903, 'target': TARGET_UNIT_CASTER, }
        -- #7: { 'type': ENERGIZE, 'subtype': NONE, 'points': 1000.0, 'target': TARGET_UNIT_CASTER, 'resource': insanity, }

        -- Affected by:
        -- dark_ascension[391109] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twilight_equilibrium[390707] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #12: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -38.81, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #8: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #9: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },

    -- Infuses the target with power for $d, increasing haste by $s1%.; Can only be cast on players.
    power_infusion = {
        id = 10060,
        cast = 0.0,
        cooldown = 120.0,
        gcd = "none",

        talent = "power_infusion",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MELEE_SLOW, 'sp_bonus': 0.25, 'points': 20.0, 'value': 126, 'schools': ['holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_TARGET_ALLY, }
    },

    -- Infuses the target with vitality, increasing their Stamina by $s1% for $d.; If the target is in your party or raid, all party and raid members will be affected.
    power_word_fortitude = {
        id = 21562,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 0.040,
        spendType = 'mana',

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_TOTAL_STAT_PERCENTAGE, 'points': 5.0, 'radius': 100.0, 'target': TARGET_UNIT_TARGET_ALLY_OR_RAID, 'modifies': unknown, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_DAMAGE_PERCENT_TAKEN, 'schools': ['holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'radius': 100.0, 'target': TARGET_UNIT_TARGET_ALLY_OR_RAID, }
    },

    -- A word of holy power that heals the target for $s1. ; Only usable if the target is below $s2% health.
    power_word_life = {
        id = 373481,
        cast = 0.0,
        cooldown = 15.0,
        gcd = "global",

        spend = 0.025,
        spendType = 'mana',

        spend = 0.025,
        spendType = 'mana',

        spend = 0.100,
        spendType = 'mana',

        talent = "power_word_life",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': HEAL, 'subtype': NONE, 'sp_bonus': 10.35, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, }
        -- #2: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- #3: { 'type': UNKNOWN, 'subtype': NONE, 'points': 20.0, }
    },

    -- Shields an ally for $d, absorbing $s1 damage.
    power_word_shield = {
        id = 17,
        cast = 0.0,
        cooldown = 7.5,
        gcd = "global",

        spend = 0.1,
        spendType = 'mana',

        -- 0. [137032] discipline_priest
        -- spend = 0.024,
        -- spendType = 'mana',

        -- 1. [137031] holy_priest
        -- spend = 0.031,
        -- spendType = 'mana',

        -- 2. [137033] shadow_priest
        -- spend = 0.100,
        -- spendType = 'mana',

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': SCHOOL_ABSORB, 'sp_bonus': 4.032, 'variance': 0.05, 'value': 127, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_TARGET_ALLY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': PERIODIC_DUMMY, 'tick_time': 1.0, 'target': TARGET_UNIT_TARGET_ALLY, }

        -- Affected by:
        -- shadow_priest[137033] #7: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
        -- shadow_priest[137033] #18: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_24, }
        -- shadow_priest[137033] #27: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_24, }
        -- priest[137030] #0: { 'type': APPLY_AURA, 'subtype': MOD_COOLDOWN_BY_HASTE_REGEN, 'points': 100.0, 'target': TARGET_UNIT_CASTER, }
        -- benevolence[415416] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 3.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_24, }
        -- phantom_reach[459559] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
        -- inner_quietus[448278] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_24, }
        -- discipline_priest[137032] #18: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 33.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_24, }
        -- discipline_priest[137032] #21: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_24, }
    },

    -- Places a ward on an ally that heals them for $33110s1 the next time they take damage, and then jumps to another ally within $155793a1 yds. Jumps up to $s1 times and lasts $41635d after each jump.
    prayer_of_mending = {
        id = 33076,
        cast = 0.0,
        cooldown = 12.0,
        gcd = "global",

        spend = 0.020,
        spendType = 'mana',

        spend = 0.020,
        spendType = 'mana',

        spend = 0.100,
        spendType = 'mana',

        talent = "prayer_of_mending",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ALLY, }

        -- Affected by:
        -- priest[137030] #0: { 'type': APPLY_AURA, 'subtype': MOD_COOLDOWN_BY_HASTE_REGEN, 'points': 100.0, 'target': TARGET_UNIT_CASTER, }
    },

    -- Terrifies the target in place, stunning them for $d.
    psychic_horror = {
        id = 64044,
        cast = 0.0,
        cooldown = 45.0,
        gcd = "global",

        talent = "psychic_horror",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_STUN, 'mechanic': stunned, 'points': 1.0, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- phantom_reach[459559] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -13.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
    },

    -- Lets out a psychic scream, causing all enemies within $A1 yards to flee, disorienting them for $d. Damage may interrupt the effect.
    psychic_scream = {
        id = 8122,
        cast = 0.0,
        cooldown = 45.0,
        gcd = "global",

        spend = 0.012,
        spendType = 'mana',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_FEAR, 'value': 1, 'schools': ['physical'], 'radius': 8.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_SRC_AREA_ENEMY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': USE_NORMAL_MOVEMENT_SPEED, 'points': 4.0, 'radius': 8.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_SRC_AREA_ENEMY, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MOD_ROOT_2, 'radius': 8.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_SRC_AREA_ENEMY, }

        -- Affected by:
        -- petrifying_scream[55676] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -4.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_2_VALUE, }
        -- phantom_reach[459559] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
        -- psychic_voice[196704] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -15000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
    },

    -- [199845] Deals up to $s2% of the target's total health in Shadow damage every $t1 sec. Also slows their movement speed by $s3% and reduces healing received by $s4%.
    psyfiend = {
        id = 211522,
        color = 'pvp_talent',
        cast = 0.0,
        cooldown = 45.0,
        gcd = "global",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 4.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 199824, 'target': TARGET_UNIT_CASTER, }
    },

    -- [211522] Summons a Psyfiend with ${$mhp*($m1/100)} health for $d beside you to attack the target at range with Psyflay.; $@spellicon199845 $@spellname199845; $@spelldesc199845
    psyfiend_199824 = {
        id = 199824,
        cast = 0.0,
        cooldown = 45.0,
        gcd = "global",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': SUMMON, 'subtype': NONE, 'points': 4.0, 'value': 101398, 'schools': ['holy', 'fire', 'frost'], 'value1': 3198, 'radius': 1.0, 'target': TARGET_DEST_CASTER_GROUND_2, 'target2': TARGET_UNIT_DEST_AREA_ENTRY, }
        from = "triggered_spell",
    },

    -- Removes all Disease effects from a friendly target.
    purify_disease = {
        id = 213634,
        cast = 0.0,
        cooldown = 8.0,
        gcd = "global",

        spend = 0.100,
        spendType = 'mana',

        talent = "purify_disease",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': DISPEL, 'subtype': NONE, 'points': 100.0, 'value': 3, 'schools': ['physical', 'holy'], 'target': TARGET_UNIT_TARGET_ALLY, }

        -- Affected by:
        -- mental_agility[341167] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.5, 'points': -50.0, 'target': TARGET_UNIT_CASTER, 'modifies': POWER_COST, }
    },

    -- Fill the target with faith in the light, healing for $o1 over $d.
    renew = {
        id = 139,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 0.018,
        spendType = 'mana',

        spend = 0.024,
        spendType = 'mana',

        spend = 0.080,
        spendType = 'mana',

        talent = "renew",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': PERIODIC_HEAL, 'tick_time': 3.0, 'sp_bonus': 0.32, 'pvp_multiplier': 1.22, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'target': TARGET_UNIT_TARGET_ALLY, }

        -- Affected by:
        -- shadow_priest[137033] #25: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- light_of_tuure[208065] #0: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'trigger_spell': 196685, 'points': 25.0, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- benevolence[415416] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 3.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- benevolence[415416] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 3.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- phantom_reach[459559] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
        -- renew[139] #1: { 'type': APPLY_AURA, 'subtype': MOD_HEALING_RECEIVED, 'target': TARGET_UNIT_TARGET_ALLY, }
        -- discipline_priest[137032] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- discipline_priest[137032] #16: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #17: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twist_of_fate[390978] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twist_of_fate[390978] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #13: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #20: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -9.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #24: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 6.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #25: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -3.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #26: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 6.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #27: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -3.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
    },

    -- Brings a dead ally back to life with $s1% health and mana. Cannot be cast when in combat.
    resurrection = {
        id = 2006,
        cast = 10.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 0.008,
        spendType = 'mana',

        spend = 0.008,
        spendType = 'mana',

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': RESURRECT, 'subtype': NONE, 'points': 35.0, }

        -- Affected by:
        -- phantom_reach[459559] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
    },

    -- Shackles the target undead enemy for $d, preventing all actions and movement. Damage will cancel the effect. Limit 1.
    shackle_undead = {
        id = 9484,
        cast = 1.5,
        cooldown = 0.0,
        gcd = "global",

        spend = 0.012,
        spendType = 'mana',

        talent = "shackle_undead",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_STUN, 'variance': 0.25, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- phantom_reach[459559] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
    },

    -- Hurl a bolt of slow-moving Shadow energy at your target, dealing $205386s1 Shadow damage to all enemies within $a1 yds.; Generates $/100;s2 Insanity.; This spell is cast at your target.
    shadow_crash = {
        id = 457042,
        cast = 0.0,
        cooldown = 20.0,
        gcd = "global",

        talent = "shadow_crash",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': TRIGGER_MISSILE, 'subtype': NONE, 'trigger_spell': 205386, 'radius': 8.0, 'target': TARGET_DEST_TARGET_ENEMY, }
        -- #1: { 'type': ENERGIZE, 'subtype': NONE, 'points': 600.0, 'target': TARGET_UNIT_CASTER, 'resource': insanity, }
        -- #2: { 'type': TRIGGER_MISSILE, 'subtype': NONE, 'trigger_spell': 391286, 'radius': 8.0, 'target': TARGET_DEST_TARGET_ENEMY, }

        -- Affected by:
        -- dark_ascension[391109] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },

    -- Aim a bolt of slow-moving Shadow energy at the destination, dealing $205386s1 Shadow damage to all enemies within $A1 yds.; Generates $/100;s2 Insanity.; This spell is cast at a selected location.
    shadow_crash_205385 = {
        id = 205385,
        cast = 0.0,
        cooldown = 20.0,
        gcd = "global",

        talent = "shadow_crash_205385",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': TRIGGER_MISSILE, 'subtype': NONE, 'trigger_spell': 205386, 'radius': 8.0, 'target': TARGET_DEST_DEST, }
        -- #1: { 'type': ENERGIZE, 'subtype': NONE, 'points': 600.0, 'target': TARGET_UNIT_CASTER, 'resource': insanity, }
        -- #2: { 'type': TRIGGER_MISSILE, 'subtype': NONE, 'trigger_spell': 391286, 'radius': 8.0, 'target': TARGET_DEST_DEST, }

        -- Affected by:
        -- dark_ascension[391109] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        from = "spec_talent",
    },

    -- A word of dark binding that inflicts $s2 Shadow damage to your target. If your target is not killed by Shadow Word: Death, you take backlash damage equal to $s6% of your maximum health.$?A364675[; Damage increased by ${$s4+$364675s2}% to targets below ${$s3+$364675s1}% health.][; Damage increased by $s4% to targets below $s3% health.]$?c3[][]$?s137033[; Generates ${$s5/100} Insanity.][]
    shadow_word_death = {
        id = 32379,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 0.005,
        spendType = 'mana',

        talent = "shadow_word_death",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'sp_bonus': 2.55, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'sp_bonus': 0.85, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #2: { 'type': DUMMY, 'subtype': NONE, }
        -- #3: { 'type': SCRIPT_EFFECT, 'subtype': NONE, 'points': 150.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #4: { 'type': ENERGIZE, 'subtype': NONE, 'target': TARGET_UNIT_CASTER, 'resource': insanity, }
        -- #5: { 'type': DUMMY, 'subtype': NONE, }

        -- Affected by:
        -- shadow_priest[137033] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadow_priest[137033] #14: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': 60.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #19: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -42.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #22: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 400.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_5_VALUE, }
        -- shadow_priest[137033] #24: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 100.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_4_VALUE, }
        -- shadow_priest[137033] #29: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -2.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #30: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -2.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadowform[232698] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['No Immunity'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadowform[232698] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['No Immunity'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- dark_ascension[391109] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dark_ascension[391109] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dark_ascension[391109] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- dark_ascension[391109] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- mastermind[391151] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 4.0, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- mastermind[391151] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': SHOULD_NEVER_SEE_15, }
        -- deathspeaker[392511] #2: { 'type': APPLY_AURA, 'subtype': MOD_MAX_CHARGES, 'points': 1.0, 'target': TARGET_UNIT_CASTER, }
        -- twilight_equilibrium[390707] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- voidform[194249] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- voidform[194249] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- voidform[194249] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- discipline_priest[137032] #5: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #10: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.5, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #11: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- discipline_priest[137032] #22: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #23: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twist_of_fate[390978] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twist_of_fate[390978] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 43.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 43.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 1.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- schism[214621] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },

    -- A word of darkness that causes $?a390707[${$s1*(1+$390707s1/100)}][$s1] Shadow damage instantly, and an additional $?a390707[${$o2*(1+$390707s1/100)}][$o2] Shadow damage over $d.$?s137033[; Generates ${$m3/100} Insanity.][]
    shadow_word_pain = {
        id = 589,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        spend = 0.02,
        spendType = 'mana',

        -- 0. [137032] discipline_priest
        -- spend = 0.018,
        -- spendType = 'mana',

        -- 1. [137031] holy_priest
        -- spend = 0.003,
        -- spendType = 'mana',

        -- 2. [137033] shadow_priest
        -- spend = 0.003,
        -- spendType = 'mana',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'sp_bonus': 0.1292, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': PERIODIC_DAMAGE, 'tick_time': 2.0, 'sp_bonus': 0.09588, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #2: { 'type': ENERGIZE, 'subtype': NONE, 'points': 300.0, 'target': TARGET_UNIT_CASTER, 'resource': insanity, }
        -- #3: { 'type': APPLY_AURA, 'subtype': MOD_IGNORE_TARGET_RESIST, 'value': 127, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- shadow_priest[137033] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadow_priest[137033] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadow_priest[137033] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #10: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 21.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadow_priest[137033] #11: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 21.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #29: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -2.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #30: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -2.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadowform[232698] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['No Immunity'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadowform[232698] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['No Immunity'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- manipulation[459985] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -1.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_4_VALUE, }
        -- phantom_reach[459559] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
        -- throes_of_pain[377422] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 3.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- throes_of_pain[377422] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 3.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- dark_ascension[391109] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dark_ascension[391109] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dark_ascension[391109] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- dark_ascension[391109] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- inner_quietus[448278] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- inner_quietus[448278] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- misery[238558] #1: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': 5000.0, 'modifies': BUFF_DURATION, }
        -- dark_evangelism[391099] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- voidform[194249] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- voidform[194249] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- voidform[194249] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- discipline_priest[137032] #6: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 18.1, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- discipline_priest[137032] #7: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 18.1, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #10: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.5, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #11: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- discipline_priest[137032] #22: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #23: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twist_of_fate[390978] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twist_of_fate[390978] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 43.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 43.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #6: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 69.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #7: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 69.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- screams_of_the_void[393919] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': AURA_PERIOD, }
        -- schism[214621] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },

    -- Summons a shadowy fiend to attack the target for $d.$?s137033[; Generates ${$262485s1/100} Insanity each time the Shadowfiend attacks.][; Generates ${$s4/10}.1% Mana each time the Shadowfiend attacks.]
    shadowfiend = {
        id = 34433,
        cast = 0.0,
        cooldown = 180.0,
        gcd = "global",

        talent = "shadowfiend",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SUMMON, 'subtype': NONE, 'value': 19668, 'schools': ['fire', 'frost', 'arcane'], 'value1': 3255, 'target': TARGET_DEST_TARGET_ENEMY, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #2: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 41967, 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 5.0, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- dark_ascension[391109] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
    },

    -- Assume a Shadowform, increasing your spell damage dealt by $s1%.
    shadowform = {
        id = 232698,
        cast = 0.0,
        cooldown = 0.0,
        gcd = "global",

        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['No Immunity'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_SHAPESHIFT, 'attributes': ['No Immunity'], 'target': TARGET_UNIT_CASTER, 'form': shadowform, 'creature_type': none, }
        -- #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['No Immunity'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
    },

    -- Silences the target, preventing them from casting spells for $d. Against non-players, also interrupts spellcasting and prevents any spell in that school from being cast for $263715d.
    silence = {
        id = 15487,
        cast = 0.0,
        cooldown = 45.0,
        gcd = "none",

        talent = "silence",
        startsCombat = true,
        interrupt = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_SILENCE, 'points': 1.0, 'value': 127, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- last_word[263716] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -15000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
    },

    -- Smites an enemy for $s1 Holy damage$?s231682[ and absorbs the next $<shield> damage dealt by the enemy]?s231687[ and has a $231687s1% chance to reset the cooldown of Holy Fire][].
    smite = {
        id = 585,
        cast = 1.5,
        cooldown = 0.0,
        gcd = "global",

        spend = 0.03,
        spendType = 'mana',

        -- 0. [137032] discipline_priest
        -- spend = 0.004,
        -- spendType = 'mana',

        -- 1. [137031] holy_priest
        -- spend = 0.002,
        -- spendType = 'mana',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'sp_bonus': 0.705, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- shadow_priest[137033] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadow_priest[137033] #29: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -2.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #30: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -2.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadowform[232698] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['No Immunity'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadowform[232698] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['No Immunity'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- phantom_reach[459559] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER_BY_LABEL, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': RANGE, }
        -- unwavering_will[373456] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': CAST_TIME, }
        -- unwavering_will[373456] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': GLOBAL_COOLDOWN, }
        -- dark_ascension[391109] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dark_ascension[391109] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- dark_ascension[391109] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- words_of_the_pious[390933] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- voidform[194249] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- voidform[194249] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- voidform[194249] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- discipline_priest[137032] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -25.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #10: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.5, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #11: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- discipline_priest[137032] #22: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #23: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twist_of_fate[390978] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twist_of_fate[390978] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 43.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 43.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #17: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 86.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twilight_equilibrium[390706] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 15.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- schism[214621] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },

    -- Peer into the mind of the enemy, attempting to steal a known spell. If stolen, the victim cannot cast that spell for $322431d.; Can only be used on Humanoids with mana. If you're unable to find a spell to steal, the cooldown of Thoughtsteal is reset.
    thoughtsteal = {
        id = 316262,
        cast = 0.0,
        cooldown = 90.0,
        gcd = "global",

        spend = 0.010,
        spendType = 'mana',

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'radius': 100.0, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- thoughtsteal[322431] #0: { 'type': APPLY_AURA, 'subtype': OVERRIDE_ACTIONBAR_SPELLS, 'target': TARGET_UNIT_CASTER, }
    },

    -- Fills you with the embrace of Shadow energy for $d, causing you to heal a nearby ally for $s1% of any single-target Shadow spell damage you deal.
    vampiric_embrace = {
        id = 15286,
        cast = 0.0,
        cooldown = 120.0,
        gcd = "none",

        talent = "vampiric_embrace",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': PERIODIC_DUMMY, 'tick_time': 0.5, 'points': 40.0, 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- sanlayn[199855] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -30000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- sanlayn[199855] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': EFFECT_1_VALUE, }
    },

    -- A touch of darkness that causes $34914o2 Shadow damage over $34914d, and heals you for ${($e2+$137033s17+$137033s18)*100}% of damage dealt. If Vampiric Touch is dispelled, the dispeller flees in Horror for $87204d.; Generates ${$m3/100} Insanity.
    vampiric_touch = {
        id = 34914,
        cast = 1.5,
        cooldown = 0.0,
        gcd = "global",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 2.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': PERIODIC_LEECH, 'amplitude': 0.3, 'tick_time': 3.0, 'sp_bonus': 0.222156, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #2: { 'type': ENERGIZE, 'subtype': NONE, 'points': 400.0, 'target': TARGET_UNIT_CASTER, 'resource': insanity, }
        -- #3: { 'type': SCHOOL_DAMAGE, 'subtype': NONE, 'sp_bonus': 2.02895, 'pvp_multiplier': 0.75, 'target': TARGET_UNIT_TARGET_ENEMY, }

        -- Affected by:
        -- shadow_priest[137033] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 8.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadow_priest[137033] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadow_priest[137033] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 50.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #16: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_TAKEN_BY_PCT, }
        -- shadow_priest[137033] #17: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_TAKEN_BY_PCT, }
        -- shadow_priest[137033] #29: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -2.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadow_priest[137033] #30: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'points': -2.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- shadowform[232698] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['No Immunity'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- shadowform[232698] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['No Immunity'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- dark_ascension[391109] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- dark_ascension[391109] #3: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- dark_ascension[391109] #4: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- inner_quietus[448278] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- inner_quietus[448278] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 20.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- maddening_touch[391228] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- dark_evangelism[391099] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- unfurling_darkness[341282] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -1500.0, 'target': TARGET_UNIT_CASTER, 'modifies': CAST_TIME, }
        -- voidform[194249] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- voidform[194249] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'attributes': ['Suppress Points Stacking'], 'points': 10.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- voidform[194249] #2: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': CRIT_CHANCE, }
        -- discipline_priest[137032] #10: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.5, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #11: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': -5.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- discipline_priest[137032] #22: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- discipline_priest[137032] #23: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'pvp_multiplier': 0.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- twist_of_fate[390978] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- twist_of_fate[390978] #1: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- holy_priest[137031] #2: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 43.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- holy_priest[137031] #3: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 43.0, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        -- screams_of_the_void[393919] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': AURA_PERIOD, }
        -- schism[214621] #0: { 'type': APPLY_AURA, 'subtype': MOD_SPELL_DAMAGE_FROM_CASTER, 'points': 10.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
    },

    -- Releases an explosive blast of pure void energy, activating Voidform and causing ${$228360s1*2} Shadow damage to all enemies within $a1 yds of your target.; During Voidform, this ability is replaced by Void Bolt.; Casting Devouring Plague increases the duration of Voidform by ${$s2/1000}.1 sec.
    void_eruption = {
        id = 228260,
        cast = 1.5,
        cooldown = 120.0,
        gcd = "global",

        talent = "void_eruption",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'attributes': ['Add Target (Dest) Combat Reach to AOE', 'Area Effects Use Target Radius'], 'radius': 10.0, 'target': TARGET_DEST_TARGET_ENEMY, 'target2': TARGET_UNIT_DEST_AREA_ENEMY, }
        -- #1: { 'type': DUMMY, 'subtype': NONE, }

        -- Affected by:
        -- dark_ascension[391109] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'points': 25.0, 'target': TARGET_UNIT_CASTER, 'modifies': DAMAGE_HEALING, }
        -- voidform[194249] #6: { 'type': APPLY_AURA, 'subtype': OVERRIDE_ACTIONBAR_SPELLS, 'attributes': ['Suppress Points Stacking'], 'spell': 205448, 'target': TARGET_UNIT_CASTER, }
    },

    -- Swap health percentages with your ally. Increases the lower health percentage of the two to $s1% if below that amount.
    void_shift = {
        id = 108968,
        cast = 0.0,
        cooldown = 300.0,
        gcd = "none",

        talent = "void_shift",
        startsCombat = false,

        -- Effects:
        -- #0: { 'type': DUMMY, 'subtype': NONE, 'target': TARGET_UNIT_TARGET_ALLY, }
    },

    -- Summons shadowy tendrils, rooting all enemies within $108920A1 yards for $114404d or until the tendril is killed.
    void_tendrils = {
        id = 108920,
        cast = 0.0,
        cooldown = 60.0,
        gcd = "global",

        spend = 0.010,
        spendType = 'mana',

        talent = "void_tendrils",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': MOD_ROOT, 'points': 6.0, 'radius': 8.0, 'target': TARGET_SRC_CASTER, 'target2': TARGET_UNIT_SRC_AREA_ENEMY, }
    },

    -- Raise your dagger into the sky, channeling a torrent of void energy into the target for $o Shadow damage over $d. Insanity does not drain during this channel.; Requires Voidform.
    void_torrent = {
        id = 205065,
        color = 'artifact',
        cast = 4.0,
        channeled = true,
        cooldown = 60.0,
        gcd = "global",

        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': PERIODIC_DAMAGE, 'tick_time': 1.0, 'sp_bonus': 0.55, 'points': 1.0, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': DUMMY, 'points': 2.0, 'target': TARGET_UNIT_CASTER, }
    },

    -- Channel a torrent of void energy into the target, dealing $o Shadow damage over $d.; Generates ${$289577s1*$289577s2/100} Insanity over the duration.
    void_torrent_263165 = {
        id = 263165,
        cast = 3.0,
        channeled = true,
        cooldown = 45.0,
        gcd = "global",

        talent = "void_torrent_263165",
        startsCombat = true,

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': PERIODIC_DAMAGE, 'tick_time': 1.0, 'sp_bonus': 2.09673, 'variance': 0.05, 'target': TARGET_UNIT_TARGET_ENEMY, }
        -- #1: { 'type': APPLY_AURA, 'subtype': MOD_AURA_TIME_RATE_BY_SPELL_LABEL, 'points': -100.0, 'value': 3678, 'schools': ['holy', 'fire', 'nature', 'frost', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': TRIGGER_SPELL, 'subtype': NONE, 'trigger_spell': 289577, 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': APPLY_AURA, 'subtype': MOD_AURA_TIME_RATE_BY_SPELL_LABEL, 'points': -100.0, 'value': 3678, 'schools': ['holy', 'fire', 'nature', 'frost', 'arcane'], 'target': TARGET_UNIT_CASTER, }

        -- Affected by:
        -- dark_energy[451018] #0: { 'type': APPLY_AURA, 'subtype': CAST_WHILE_WALKING, 'points': 20.0, 'target': TARGET_UNIT_CASTER, }
        -- malediction[373221] #0: { 'type': APPLY_AURA, 'subtype': ADD_FLAT_MODIFIER, 'points': -15000.0, 'target': TARGET_UNIT_CASTER, 'modifies': COOLDOWN, }
        -- dark_evangelism[391099] #0: { 'type': APPLY_AURA, 'subtype': ADD_PCT_MODIFIER, 'target': TARGET_UNIT_CASTER, 'modifies': PERIODIC_DAMAGE_HEALING, }
        from = "spec_talent",
    },

} )