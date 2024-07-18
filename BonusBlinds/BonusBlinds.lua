--- STEAMODDED HEADER
--- MOD_NAME: Bonus Blinds
--- MOD_ID: BB
--- PREFIX: bb
--- MOD_AUTHOR: [mathguy]
--- MOD_DESCRIPTION: Bonus Blinds
--- VERSION: 1.3
----------------------------------------------
------------MOD CODE -------------------------

---------------------------------------------------

function disco_jokers()
    if #G.jokers.cards > 1 then
        local wiggle = {}
        for i = #G.jokers.cards, 2, -1 do
            local j = math.ceil(pseudorandom(pseudoseed('disco'))*i)
            local e_swap = true
            if G.jokers.cards[j].ability.eternal and not (G.jokers.cards[i].config.center.eternal_compat and not G.jokers.cards[i].ability.perishable) then
                e_swap = false
            end
            if G.jokers.cards[i].ability.eternal and not (G.jokers.cards[j].config.center.eternal_compat and not G.jokers.cards[j].ability.perishable) then
                e_swap = false
            end
            if (not not G.jokers.cards[i].ability.eternal) == (not not G.jokers.cards[j].ability.eternal) then
                e_swap = false
            end
            local p_swap = true
            if G.jokers.cards[j].ability.perishable and not (G.jokers.cards[i].config.center.perishable_compat and not G.jokers.cards[i].ability.eternal) then
                p_swap = false
            end
            if G.jokers.cards[i].ability.perishable and not (G.jokers.cards[j].config.center.perishable_compat and not G.jokers.cards[j].ability.eternal) then
                p_swap = false
            end
            if (not not G.jokers.cards[i].ability.perishable) == (not not G.jokers.cards[j].ability.perishable) then
                p_swap = false
            end
            local ep_swap = true
            if G.jokers.cards[j].ability.eternal and not G.jokers.cards[i].config.center.eternal_compat then
                ep_swap = false
            end
            if G.jokers.cards[i].ability.eternal and not G.jokers.cards[j].config.center.eternal_compat then
                ep_swap = false
            end
            if G.jokers.cards[j].ability.perishable and not G.jokers.cards[i].config.center.perishable_compat then
                ep_swap = false
            end
            if G.jokers.cards[i].ability.perishable and not G.jokers.cards[j].config.center.perishable_compat then
                ep_swap = false
            end
            if ((not not G.jokers.cards[i].ability.perishable) == (not not G.jokers.cards[j].ability.perishable)) and 
            ((not not G.jokers.cards[i].ability.eternal) == (not not G.jokers.cards[j].ability.eternal)) then
                ep_swap = false
            end
            if e_swap or p_swap or ep_swap then
                local pool = {}
                if e_swap then
                    table.insert(pool, 'e')
                end
                if p_swap then
                    table.insert(pool, 'p')
                end
                if ep_swap then
                    table.insert(pool, 'ep')
                end
                local swap = pseudorandom_element(pool, pseudoseed('disco'))
                if (swap == 'e') or (swap == 'ep') then
                    local a, b = G.jokers.cards[i].ability.eternal, G.jokers.cards[j].ability.eternal
                    G.jokers.cards[i].ability.eternal = b
                    G.jokers.cards[j].ability.eternal = a
                    wiggle[i] = true
                    wiggle[j] = true
                end
                if (swap == 'p') or (swap == 'ep') then
                    local a, b = G.jokers.cards[i].ability.perishable, G.jokers.cards[j].ability.perishable
                    local c, d = G.jokers.cards[i].ability.perish_tally, G.jokers.cards[j].ability.perish_tally
                    G.jokers.cards[i].ability.perishable = b
                    G.jokers.cards[i].ability.perish_tally = d
                    G.jokers.cards[j].ability.perishable = a
                    G.jokers.cards[j].ability.perish_tally = c
                    wiggle[i] = true
                    wiggle[j] = true
                end
            end
        end 
        local rental_count = 0
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].ability.rental == true then
                rental_count = rental_count + 1
            end
        end
        if (rental_count ~= 0) and (rental_count ~= #G.jokers.cards) then
            rental_count = #G.jokers.cards - rental_count
            local pool = {}
            for i = 1, #G.jokers.cards do
                pool[i] = true
            end
            for i = 1, rental_count do
                local val, key = pseudorandom_element(pool, pseudoseed('disco'))
                pool[key] = nil
            end
            for i = 1, #G.jokers.cards do
                if (pool[i] == true) and (G.jokers.cards[i].ability.rental ~= true) then
                    G.jokers.cards[i]:set_rental(true)
                    wiggle[i] = true
                elseif (pool[i] ~= true) and (G.jokers.cards[i].ability.rental == true) then
                    G.jokers.cards[i]:set_rental(nil)
                    wiggle[i] = true
                end
            end
        end
        for i, j in pairs(wiggle) do
            G.jokers.cards[i]:juice_up()
        end
        if #wiggle > 0 then
            play_sound('card1', 1)
        end
    end
end

local bonusType = SMODS.ConsumableType {
    key = 'Bonus',
    primary_colour = G.C.RED,
    secondary_colour = G.C.RED,
    loc_txt = {
        name = 'Bonus Blind',
        collection = 'Bonus Blinds',
        undiscovered = {
            name = 'Undiscovered Bonus',
            text = { 'idk stuff ig' },
        }
    },
    collection_rows = { 6, 6 },
    shop_rate = 2,
    rarities = {
        {key = 'Common', rate = 100},
        {key = 'Uncommon', rate = 25},
        {key = 'Rare', rate = 5},
        {key = 'Legendary', rate = 1},
    },
    default = "c_bb_bonus"
}

SMODS.Bonus = SMODS.Consumable:extend {
    set = 'Bonus',
    set_badges = function(self, card, badges)
        local colours = {
            Common = HEX('FE5F55'),
            Uncommon =  HEX('8867a5'),
            Rare = HEX("fda200"),
            Legendary = {0,0,0,1}
        }
        local len = string.len(localize('k_' .. string.lower(self.rarity)) or self.rarity)
        local size = 1.3 - (len > 5 and 0.02 * (len - 5) or 0)
        badges[#badges + 1] = create_badge(localize('k_' .. string.lower(self.rarity)) or self.rarity, colours[self.rarity], nil, size)
    end,
    can_use = function(self, card)
        return ((not not G.blind_select) and (G.STATE ~= G.STATES.BUFFOON_PACK) and (G.STATE ~= G.STATES.TAROT_PACK) and (G.STATE ~= G.STATES.SPECTRAL_PACK) and (G.STATE ~= G.STATES.STANDARD_PACK) and (G.STATE ~= G.STATES.PLANET_PACK)) or ((card.area == G.pack_cards) and (#G.consumeables.cards < (G.consumeables.config.card_limit + ((card.edition and card.edition.negative) and 1 or 0))))
    end,
    use = function(self, card, area, copier)
        if area == G.pack_cards then
            local card2 = copy_card(card)
            G.pack_cards:remove_card(card)
            card:remove()
            G.consumeables:emplace(card2)
        else
            self:use2(card, area, copier)
        end
    end,
    cost = 2
}

SMODS.Atlas({ key = "mystery", atlas_table = "ASSET_ATLAS", path = "mystery.png", px = 71, py = 95})

SMODS.Atlas({ key = "another", atlas_table = "ASSET_ATLAS", path = "bonus.png", px = 71, py = 95})

SMODS.Atlas({ key = "loops", atlas_table = "ASSET_ATLAS", path = "loop.png", px = 71, py = 95})

SMODS.Atlas({ key = "bonus_tags", atlas_table = "ASSET_ATLAS", path = "tags.png", px = 34, py = 34})

SMODS.Atlas({ key = "vouchery", atlas_table = "ASSET_ATLAS", path = "vouchers.png", px = 71, py = 95})

SMODS.Atlas({ key = "boostery", atlas_table = "ASSET_ATLAS", path = "boosters.png", px = 71, py = 95})

SMODS.Atlas({ key = "jokery", atlas_table = "ASSET_ATLAS", path = "jokers.png", px = 71, py = 95})

SMODS.Atlas({ key = "decks", atlas_table = "ASSET_ATLAS", path = "Backs.png", px = 71, py = 95})

local unknown = SMODS.UndiscoveredSprite {
    key = 'Bonus',
    atlas = 'mystery',
    pos = {x = 0, y = 0}
}

--- Common (11)

SMODS.Bonus {
    key = 'extra',
    loc_txt = {
        name = "Bonus Blind",
        text = {
            "Charges {C:money}$#2#{}",
            "to play {C:blue}#1#{}"
        }
    },
    atlas = "another",
    pos = {x = 0, y = 0},
    rarity = 'Common',
    set_ability = function(self, card, initial, delay_sprites)
        if G.P_BLINDS == nil then
            card.ability.the_blind = 'bl_small'
            card.ability.reward = {dollars = 1}
        else
            local rngpick = {}
            for i, j in pairs(G.P_BLINDS) do
                if j.boss and not j.boss.showdown and not j.boss.bonus then
                    table.insert(rngpick, i)
                end
            end
            local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
            card.ability.the_blind = blind
            card.ability.reward = {dollars = math.floor(1.5*G.P_BLINDS[blind].dollars)}
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {localize{type ='name_text', key = card.ability.the_blind, set = 'Blind'}, card.ability.reward.dollars}}
    end,
    use2 = function(self, card, area, copier)
        bonus_selection(card.ability.the_blind, {none = 1})
        ease_dollars(-card.ability.reward.dollars)
    end,
    can_use = function(self, card)
        return ((not not G.blind_select) and ((G.GAME.dollars  - G.GAME.bankrupt_at) >= card.ability.reward.dollars) and (G.STATE ~= G.STATES.BUFFOON_PACK) and (G.STATE ~= G.STATES.TAROT_PACK) and (G.STATE ~= G.STATES.SPECTRAL_PACK) and (G.STATE ~= G.STATES.STANDARD_PACK) and (G.STATE ~= G.STATES.PLANET_PACK)) or ((card.area == G.pack_cards) and (#G.consumeables.cards < (G.consumeables.config.card_limit + ((card.edition and card.edition.negative) and 1 or 0))))
    end
}

SMODS.Bonus {
    key = 'needy',
    loc_txt = {
        name = "Needy Blind",
        text = {
            "Play a {C:attention}Boss Blind{}",
            "with only {C:blue}#1#{} Hand"
        }
    },
    atlas = "another",
    pos = {x = 2, y = 0},
    rarity = 'Common',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.start_hands = 1
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.start_hands}}
    end,
    use2 =function(self, card, area, copier)
        local rngpick = {}
        for i, j in pairs(G.P_BLINDS) do
            if j.boss and not j.boss.showdown and (i ~= 'bl_needle') and not j.boss.bonus then
                table.insert(rngpick, i)
            end
        end
        local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
        bonus_selection(blind, {hands = card.ability.start_hands})
    end
}

SMODS.Bonus {
    key = 'sail',
    loc_txt = {
        name = "Sailing Blind",
        text = {
            "Play a {C:attention}Boss Blind{}",
            "with {C:red}#1#{} Discards"
        }
    },
    atlas = "another",
    pos = {x = 3, y = 0},
    rarity = 'Common',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.start_discards = 0
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.start_discards}}
    end,
    use2 =function(self, card, area, copier)
        local rngpick = {}
        for i, j in pairs(G.P_BLINDS) do
            if j.boss and not j.boss.showdown and (i ~= 'bl_water') and not j.boss.bonus then
                table.insert(rngpick, i)
            end
        end
        local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
        bonus_selection(blind, {discards = card.ability.start_discards})
    end
}

SMODS.Bonus {
    key = 'locked',
    loc_txt = {
        name = "Locked Blind",
        text = {
            "Play {C:blue}#1#{} with",
            "{C:attention}-#2#{} Hand Size"
        }
    },
    atlas = "another",
    pos = {x = 9, y = 0},
    rarity = 'Common',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.the_blind = 'bl_big'
        card.ability.hand_size_sub = 2
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {localize{type ='name_text', key = card.ability.the_blind, set = 'Blind'}, card.ability.hand_size_sub}}
    end,
    use2 =function(self, card, area, copier)
        bonus_selection(card.ability.the_blind, {hand_size = -card.ability.hand_size_sub})
    end
}

SMODS.Bonus {
    key = 'fixed',
    loc_txt = {
        name = "Fixed Blind",
        text = {
            "All {C:attention}Jokers{} become {C:attention}Pinned{}",
            "then play {C:blue}#1#{}"
        }
    },
    atlas = "another",
    pos = {x = 11, y = 0},
    rarity = 'Common',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.the_blind = 'bl_small'
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {localize{type ='name_text', key = card.ability.the_blind, set = 'Blind'}}}
    end,
    use2 =function(self, card, area, copier)
        bonus_selection(card.ability.the_blind, {pin_jokers = true})
    end
}

SMODS.Bonus {
    key = 'combo',
    loc_txt = {
        name = "Combo Blind",
        text = {
            "Play {C:blue}#1#{}. All {C:attention}Jokers{}",
            "{C:attention}face down{} this blind."
        }
    },
    atlas = "another",
    pos = {x = 0, y = 1},
    rarity = 'Common',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.the_blind = 'bl_final_heart'
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'bl_crimson', set = 'Other'}
        return {vars = {localize{type ='name_text', key = card.ability.the_blind, set = 'Blind'}}}
    end,
    use2 =function(self, card, area, copier)
        bonus_selection(card.ability.the_blind, {flip_jokers = true})
    end
}

SMODS.Bonus {
    key = 'brick',
    loc_txt = {
        name = "Brick Blind",
        text = {
            "Play a {C:attention}Boss Blind{}",
            "with {C:blue}X#1# Blind Size{}"
        }
    },
    atlas = "another",
    pos = {x = 3, y = 1},
    rarity = 'Common',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.reward = {blind_mult = 2}
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.reward.blind_mult}}
    end,
    use2 =function(self, card, area, copier)
        local rngpick = {}
        for i, j in pairs(G.P_BLINDS) do
            if j.boss and not j.boss.showdown and not j.boss.bonus then
                table.insert(rngpick, i)
            end
        end
        local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
        bonus_selection(blind, card.ability.reward)
    end
}

SMODS.Bonus {
    key = 'watching',
    loc_txt = {
        name = "Watching Blind",
        text = {
            "Play {C:green}#1#{}"
        }
    },
    atlas = "another",
    pos = {x = 5, y = 1},
    rarity = 'Common',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.the_blind = 'bl_bb_watch'
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'bl_watch', set = 'Other'}
        return {vars = {localize{type ='name_text', key = card.ability.the_blind, set = 'Blind'}}}
    end,
    use2 =function(self, card, area, copier)
        bonus_selection(card.ability.the_blind, {none = true})
    end
}

SMODS.Bonus {
    key = 'sky',
    loc_txt = {
        name = "Sky-High Blind",
        text = {
            "Play {C:blue}#1#{} with {C:attention}double{}",
            "your {C:attention}best hand{} added to {C:blue}Blind Size{}",
            "{C:inactive}(Best Hand:{}{C:attention} #2#{}{C:inactive}){}"
        }
    },
    atlas = "another",
    pos = {x = 7, y = 1},
    rarity = 'Common',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.the_blind = 'bl_small'
    end,
    loc_vars = function(self, info_queue, card)
        local best = (G.GAME and G.GAME.round_scores and G.GAME.round_scores.hand.amt) or 0
        best = number_format(best)
        return {vars = {localize{type ='name_text', key = card.ability.the_blind, set = 'Blind'}, best}}
    end,
    use2 =function(self, card, area, copier)
        bonus_selection(card.ability.the_blind, {blind_size_mod = ((G.GAME and G.GAME.round_scores and (G.GAME.round_scores.hand.amt * 2)) or 0)})
    end
}

SMODS.Bonus {
    key = 'cruel',
    loc_txt = {
        name = "Cruel Blind",
        text = {
            "Play a {C:attention}Boss Blind{} with",
            "at least {C:attention}#1#{} empty {C:attention}Joker Slot{}",
            "{C:inactive}(can destroy jokers){}"
        }
    },
    atlas = "another",
    pos = {x = 8, y = 1},
    rarity = 'Common',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.emp_jkr = 1
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.emp_jkr}}
    end,
    use2 =function(self, card, area, copier)
        local rngpick = {}
        for i, j in pairs(G.P_BLINDS) do
            if j.boss and not j.boss.showdown and not j.boss.bonus then
                table.insert(rngpick, i)
            end
        end
        local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
        bonus_selection(blind, {emp_jkr = card.ability.emp_jkr})
    end
}

SMODS.Bonus {
    key = 'roulette',
    loc_txt = {
        name = "Roulette Blind",
        text = {
            "Play {C:attention}#1#{}. {C:green}#2# in #3#{}",
            "chance for {C:attention}+#4#{} Ante.",
            "{C:inactive}(unusable on antes {C:attention}#5#{C:inactive} and {C:attention}#6#{C:inactive})"
        }
    },
    atlas = "another",
    pos = {x = 1, y = 2},
    rarity = 'Common',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.the_blind = 'bl_big'
        card.ability.ante_mod = 1
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {localize{type ='name_text', key = card.ability.the_blind, set = 'Blind'}, G.GAME.probabilities.normal, 3, 1, G.GAME.win_ante and (G.GAME.win_ante - 1) or 7, G.GAME.win_ante or 8}}
    end,
    use2 = function(self, card, area, copier)
        if pseudorandom("roulette") < G.GAME.probabilities.normal/3 then
            bonus_selection(card.ability.the_blind, {ante_mod = card.ability.ante_mod})
        else
            bonus_selection(card.ability.the_blind, {none = true})
        end
    end,
    can_use = function(self, card)
        local cond = (G.GAME.round_resets.ante ~= G.GAME.win_ante) and (G.GAME.round_resets.ante ~= (G.GAME.win_ante - 1))
        return ((not not G.blind_select) and (cond) and (G.STATE ~= G.STATES.BUFFOON_PACK) and (G.STATE ~= G.STATES.TAROT_PACK) and (G.STATE ~= G.STATES.SPECTRAL_PACK) and (G.STATE ~= G.STATES.STANDARD_PACK) and (G.STATE ~= G.STATES.PLANET_PACK)) or ((card.area == G.pack_cards) and (#G.consumeables.cards < (G.consumeables.config.card_limit + ((card.edition and card.edition.negative) and 1 or 0))))
    end
}

--- Uncommon (9)

SMODS.Bonus {
    key = 'redo',
    loc_txt = {
        name = "Redo Blind",
        text = {
            "Defeat {C:purple}#1#{} with ",
            "{C:blue}X3 Blind Size{} to get a {C:attention}#2#{}"
        }
    },
    atlas = "another",
    pos = {x = 1, y = 0},
    cost = 3,
    rarity = 'Uncommon',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.the_blind = 'bl_final_vessel'
        card.ability.reward = {tags = {'tag_boss'}, blind_mult = 3}
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'bl_violet', set = 'Other'}
        return {vars = {localize{type ='name_text', key = card.ability.the_blind, set = 'Blind'}, localize{type ='name_text', key = card.ability.reward.tags[1], set = 'Tag'}}}
    end,
    use2 =function(self, card, area, copier)
        bonus_selection(card.ability.the_blind, card.ability.reward)
    end
}

SMODS.Bonus {
    key = 'broken',
    loc_txt = {
        name = "Broken Blind",
        text = {
            "{C:green}#1# in #2#{} chance to",
            "play a {C:blue}#3#{}"
        }
    },
    atlas = "another",
    pos = {x = 5, y = 0},
    cost = 3,
    rarity = 'Uncommon',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.the_blind = 'bl_small'
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME.probabilities.normal,2,localize{type ='name_text', key = card.ability.the_blind, set = 'Blind'}}}
    end,
    use2 =function(self, card, area, copier)
        if pseudorandom("broken") < G.GAME.probabilities.normal/2 then
            bonus_selection(card.ability.the_blind, {none = 1})
        else
            G.GAME.pool_flags.failed_broken_blind = true
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                attention_text({
                    text = localize('k_nope_ex'),
                    scale = 1.3, 
                    hold = 1.4,
                    major = card,
                    backdrop_colour = G.C.SECONDARY_SET.Tarot,
                    align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and 'tm' or 'cm',
                    offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and -0.2 or 0},
                    silent = true
                    })
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                        play_sound('tarot2', 0.76, 0.4);return true end}))
                    play_sound('tarot2', 1, 0.4)
                    card:juice_up(0.3, 0.5)
            return true end }))
            delay(0.6)
        end
    end
}

SMODS.Bonus {
    key = 'spoiler',
    loc_txt = {
        name = "Spoiler Blind",
        text = {
            "Play {C:attention}Ante #1#s{} {C:attention}Showdown Blind{}",
            "on this {C:attention}Ante{}"
        }
    },
    atlas = "another",
    pos = {x = 8, y = 0},
    cost = 3,
    rarity = 'Uncommon',
    set_ability = function(self, card, initial, delay_sprites)
    end,
    loc_vars = function(self, info_queue, card)
        local showdown = (G.GAME.round_resets.ante and (G.GAME.win_ante + math.max(0, math.floor(G.GAME.round_resets.ante / G.GAME.win_ante) * G.GAME.win_ante))) or 8 
        return {vars = {showdown}}
    end,
    use2 =function(self, card, area, copier)
        local showdown = G.GAME.win_ante + math.max(0, math.floor(G.GAME.round_resets.ante / G.GAME.win_ante) * G.GAME.win_ante)
        local blind = ""
        if G.GAME.round_resets.ante == showdown then
            blind = G.GAME.round_resets.blind_choices.Boss
        elseif not G.GAME.forced_blinds or G.GAME.forced_blinds[showdown] == nil then
            local rngpick = {}
            for i, j in pairs(G.P_BLINDS) do
                if j.boss and j.boss.showdown and not G.GAME.banned_keys[i] and not j.boss.bonus then
                    table.insert(rngpick, i)
                end
            end
            local preused = {}
            local min_use = 100
            for k, v in pairs(rngpick) do
                preused[v] = G.GAME.bosses_used[v]
                if preused[v] <= min_use then 
                    min_use = preused[v]
                end
            end
            for k, v in pairs(preused) do
                if preused[k] then
                    if preused[k] <= min_use then 
                        preused[k] = nil
                    end
                end
            end
            rngpick = {}
            for i, j in pairs(G.P_BLINDS) do
                if j.boss and j.boss.showdown and not G.GAME.banned_keys[i] and not preused[i] then
                    table.insert(rngpick, i)
                end
            end
            blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
            if G.GAME.forced_blinds == nil then
                G.GAME.forced_blinds = {}
            end
            G.GAME.forced_blinds[showdown] = blind
        else
            blind = G.GAME.forced_blinds[showdown]
        end
        bonus_selection(blind, {none = true})
    end
}

SMODS.Bonus {
    key = 'meta',
    loc_txt = {
        name = "Meta Blind",
        text = {
            "Activate a {C:red}Common Bonus Blind{}. Upon",
            "blind defeat, get an {C:attention}#1#{}"
        }
    },
    atlas = "another",
    pos = {x = 2, y = 1},
    cost = 3,
    rarity = 'Uncommon',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.reward = {tags = {'tag_bb_ironic'}}
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 't_irony', set = 'Other'}
        info_queue[#info_queue+1] = {key = 'p_jumbo_bl', set = 'Other'}
        return {vars = {localize{type ='name_text', key = card.ability.reward.tags[1], set = 'Tag'}}}
    end,
    use2 =function(self, card, area, copier)
        local commons = {'extra', 'needy', 'sail', 'locked', 'fixed', 'combo', 'brick', 'watching', 'sky'}
        local common = pseudorandom_element(commons, pseudoseed('meta'))
        if common == 'extra' then
            local rngpick = {}
            for i, j in pairs(G.P_BLINDS) do
                if j.boss and not j.boss.showdown and not j.boss.bonus then
                    table.insert(rngpick, i)
                end
            end
            local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
            bonus_selection(blind, {tags = card.ability.reward.tags})
            ease_dollars(-math.floor(1.5*G.P_BLINDS[blind].dollars))
        elseif common == 'needy' then
            local rngpick = {}
            for i, j in pairs(G.P_BLINDS) do
                if j.boss and not j.boss.showdown and not j.boss.bonus and (i ~= 'bl_needle') then
                    table.insert(rngpick, i)
                end
            end
            local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
            bonus_selection(blind, {hands = 1, tags = card.ability.reward.tags})
        elseif common == 'sail' then
            local rngpick = {}
            for i, j in pairs(G.P_BLINDS) do
                if j.boss and not j.boss.showdown and (i ~= 'bl_water') and not j.boss.bonus then
                    table.insert(rngpick, i)
                end
            end
            local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
            bonus_selection(blind, {discards = 0, tags = card.ability.reward.tags})
        elseif common == 'locked' then
            bonus_selection('bl_big', {hand_size = -2, tags = card.ability.reward.tags})
        elseif common == 'fixed' then
            bonus_selection('bl_small', {pin_jokers = true, tags = card.ability.reward.tags})
        elseif common == 'combo' then
            bonus_selection('bl_final_heart', {flip_jokers = true, tags = card.ability.reward.tags})
        elseif common == 'brick' then
            local rngpick = {}
            for i, j in pairs(G.P_BLINDS) do
                if j.boss and not j.boss.showdown and not j.boss.bonus then
                    table.insert(rngpick, i)
                end
            end
            local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
            bonus_selection(blind, {blind_mult = 2, tags = card.ability.reward.tags})
        elseif common == 'watching' then
            bonus_selection('bl_bb_watch', {tags = card.ability.reward.tags})
        elseif common == 'sky' then
            local best = (G.GAME and G.GAME.round_scores and G.GAME.round_scores.hand.amt) or 0
            bonus_selection('bl_small', {blind_size_mod = best * 2, tags = card.ability.reward.tags})
        end
    end
}

SMODS.Bonus {
    key = 'disco',
    loc_txt = {
        name = "Disco Blind",
        text = {
            "Play {C:blue}#1#{}. Shuffle",
            "{C:attention}Stickers{} each {C:blue}hand{}"
        }
    },
    atlas = "another",
    pos = {x = 4, y = 1},
    cost = 3,
    rarity = 'Uncommon',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.the_blind = 'bl_final_bell'
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'bl_cerulean', set = 'Other'}
        return {vars = {localize{type ='name_text', key = card.ability.the_blind, set = 'Blind'}}}
    end,
    use2 =function(self, card, area, copier)
        bonus_selection(card.ability.the_blind, {disco = true})
    end
}

SMODS.Bonus {
    key = 'rewind',
    loc_txt = {
        name = "Rewind Blind",
        text = {
            "Play the last {C:attention}blind{}",
            "with {C:blue}X2 Hands{}"
        }
    },
    atlas = "another",
    pos = {x = 6, y = 1},
    cost = 3,
    rarity = 'Uncommon',
    set_ability = function(self, card, initial, delay_sprites)
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,
    use2 = function(self, card, area, copier)
        local blind = G.GAME.last_blind and G.GAME.last_blind.key
        bonus_selection(blind, {double_hands = true})
    end,
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        SMODS.Bonus.super.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local blind = (G.GAME.last_blind and G.GAME.last_blind.key) or nil
        local last_blind_done = blind and localize{type = 'name_text', key = blind, set = 'Blind'} or localize('k_none')
        local colour = (not blind) and G.C.RED or G.C.BLUE
        desc_nodes[#desc_nodes+1] = {
            {n=G.UIT.C, config={align = "bm", padding = 0.02}, nodes={
                {n=G.UIT.C, config={align = "m", colour = colour, r = 0.05, padding = 0.05}, nodes={
                    {n=G.UIT.T, config={text = ' '..last_blind_done..' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true}},
                }}
            }}
        }
    end,
    can_use = function(self, card)
        return ((not not G.blind_select) and (G.GAME.last_blind and not not G.GAME.last_blind.key) and (G.STATE ~= G.STATES.BUFFOON_PACK) and (G.STATE ~= G.STATES.TAROT_PACK) and (G.STATE ~= G.STATES.SPECTRAL_PACK) and (G.STATE ~= G.STATES.STANDARD_PACK) and (G.STATE ~= G.STATES.PLANET_PACK)) or ((card.area == G.pack_cards) and (#G.consumeables.cards < (G.consumeables.config.card_limit + ((card.edition and card.edition.negative) and 1 or 0))))
    end
}

SMODS.Bonus {
    key = 'patch',
    loc_txt = {
        name = "Patched Blind",
        text = {
            "Defeat a {C:attention}Blind{}",
            "for a {C:attention}reward{}"
        }
    },
    atlas = "another",
    pos = {x = 9, y = 1},
    cost = 3,
    rarity = 'Uncommon',
    set_ability = function(self, card, initial, delay_sprites)
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,
    use2 = function(self, card, area, copier)
        local rngpick = {}
        for i, j in pairs(G.P_BLINDS) do
            if not j.boss or not j.boss.bonus then
                table.insert(rngpick, i)
            end
        end
        local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
        bonus_selection(blind, {rand_reward = true})
    end,
    in_pool = function(self)
        return (not not G.GAME.pool_flags.failed_broken_blind), {allow_duplicates = false}
    end
}

SMODS.Bonus {
    key = 'dice',
    loc_txt = {
        name = "Dice Blind",
        text = {
            "Defeat a {C:attention}Boss Blind{} for",
            "{C:attention}#1#{} free {C:green}rerolls{} next shop",
        }
    },
    atlas = "another",
    pos = {x = 10, y = 1},
    cost = 3,
    rarity = 'Uncommon',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.reward = {rerolls = 5}
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.reward.rerolls}}
    end,
    use2 = function(self, card, area, copier)
        local rngpick = {}
        for i, j in pairs(G.P_BLINDS) do
            if j.boss and not j.boss.showdown and not j.boss.bonus then
                table.insert(rngpick, i)
            end
        end
        local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
        bonus_selection(blind, {free_rerolls = card.ability.reward.rerolls})
    end
}

SMODS.Bonus {
    key = 'quick',
    loc_txt = {
        name = "Quick Blind",
        text = {
            "Play {C:red}#1#{}",
        }
    },
    atlas = "another",
    pos = {x = 0, y = 2},
    cost = 3,
    rarity = 'Uncommon',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.the_blind = 'bl_bb_countdown'
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'bl_countdown', set = 'Other'}
        return {vars = {localize{type ='name_text', key = card.ability.the_blind, set = 'Blind'}}}
    end,
    use2 =function(self, card, area, copier)
        bonus_selection(card.ability.the_blind, {none = true})
    end
}

--- Rare (3)

SMODS.Bonus {
    key = 'luck',
    loc_txt = {
        name = "Lucky Blind",
        text = {
            "Defeat a {C:attention}Blind{} with ",
            "{C:blue}#1#{} Hand and {C:red}#2#{} Discard",
            "to get #3# {C:attention}#4#s{}"
        }
    },
    atlas = "another",
    pos = {x = 6, y = 0},
    rarity = 'Rare',
    cost = 5,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.start_discards = 1
        card.ability.start_hands = 1
        card.ability.reward = {tags = {'tag_voucher', 'tag_voucher'}}
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'tag_voucher', set = 'Tag'}
        return {vars = {card.ability.start_hands, card.ability.start_discards, 2, localize{type ='name_text', key = card.ability.reward.tags[1], set = 'Tag'}}}
    end,
    use2 = function(self, card, area, copier)
        local rngpick = {}
        for i, j in pairs(G.P_BLINDS) do
            if (not j.boss or not j.boss.showdown) and not (j.boss and j.boss.bonus) then
                table.insert(rngpick, i)
            end
        end
        local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
        bonus_selection(blind, {hands = card.ability.start_hands, discards = card.ability.start_discards, tags = card.ability.reward.tags })
    end
}

SMODS.Bonus {
    key = 'magma',
    loc_txt = {
        name = "Magma Blind",
        text = {
            "Defeat {C:blue}#1#{} to",
            "{C:attention}destroy{} cards {C:attention}held in hand{}"
        }
    },
    atlas = "another",
    pos = {x = 7, y = 0},
    rarity = 'Rare',
    cost = 5,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.the_blind = 'bl_hook'
        card.ability.reward = {burn_hand = true}
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'bl_snatch', set = 'Other'}
        return {vars = {localize{type ='name_text', key = card.ability.the_blind, set = 'Blind'}}}
    end,
    use2 = function(self, card, area, copier)
        bonus_selection(card.ability.the_blind, card.ability.reward)
    end,
}

SMODS.Bonus {
    key = 'lottery',
    loc_txt = {
        name = "Lottery Blind",
        text = {
            "Add {C:red}+#1#{} Mult to {C:attention}#2#{} random",
            "{C:attention}playing card{} then play {C:attention}#3#{}"
        }
    },
    atlas = "another",
    pos = {x = 1, y = 1},
    cost = 3,
    rarity = 'Rare',
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.the_blind = 'bl_flint'
        card.ability.mult = 25
        card.ability.cards = 1
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'bl_rocky', set = 'Other'}
        return {vars = {card.ability.mult, card.ability.cards, localize{type ='name_text', key = card.ability.the_blind, set = 'Blind'}}}
    end,
    use2 =function(self, card, area, copier)
        bonus_selection(card.ability.the_blind, {lotto = {amount = card.ability.mult, cards = card.ability.cards}})
    end
}

SMODS.Bonus {
    key = 'hankercheif',
    loc_txt = {
        name = "Hankercheif Blind",
        text = {
            "Play {C:attention}#1#{}. Earn {C:money}$1{} when",
            "a playing card is scored",
        }
    },
    atlas = "another",
    pos = {x = 11, y = 1},
    rarity = 'Rare',
    cost = 5,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.the_blind = 'bl_ox'
        card.ability.reward = {dollars_score = 1}
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'blind_ox', set = 'Other'}
        return {vars = {localize{type ='name_text', key = card.ability.the_blind, set = 'Blind'}}}
    end,
    use2 = function(self, card, area, copier)
        bonus_selection(card.ability.the_blind, card.ability.reward)
    end
}

--- Legendary (3)

SMODS.Bonus {
    key = 'champion',
    loc_txt = {
        name = "Champion Blind",
        text = {
            "{C:attention}-#1#{} Antes then play",
            "a {C:blue}Showdown Blind{}"
        }
    },
    atlas = "another",
    pos = {x = 4, y = 0},
    rarity = 'Legendary',
    cost = 7,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.remove_ante = 2
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.remove_ante}}
    end,
    use2 =function(self, card, area, copier)
        local rngpick = {}
        for i, j in pairs(G.P_BLINDS) do
            if j.boss and j.boss.showdown and not j.boss.bonus then
                table.insert(rngpick, i)
            end
        end
        local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
        bonus_selection(blind, {ante_mod = -card.ability.remove_ante})
    end
}

SMODS.Bonus {
    key = 'natural',
    loc_txt = {
        name = "Supernatural Blind",
        text = {
            "Play {C:green}The Serpent{}. All",
            "{C:attention}Jokers{} are {C:attention}Eternal{} for",
            "this blind. {C:attention}+1{} {C:dark_edition}Negative{}",
            "{C:spectral}Spectral{} each {C:blue}hand{}."
        }
    },
    atlas = "another",
    pos = {x = 10, y = 0},
    rarity = 'Legendary',
    cost = 7,
    set_ability = function(self, card, initial, delay_sprites)
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'bl_snake', set = 'Other'}
        info_queue[#info_queue+1] = {key = 'eternal', set = 'Other'}
        info_queue[#info_queue+1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = 1}}
        return {vars = {}}
    end,
    use2 =function(self, card, area, copier)
        bonus_selection('bl_serpent', {eternal_round = true, spectrals = true})
    end
}

SMODS.Bonus {
    key = 'mall',
    loc_txt = {
        name = "Mall Blind",
        text = {
            "Defeat a {C:blue}Showdown Blind{} for",
            "a {C:purple}Super Shop{}.",
        }
    },
    atlas = "another",
    pos = {x = 2, y = 2},
    rarity = 'Legendary',
    cost = 7,
    set_ability = function(self, card, initial, delay_sprites)
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,
    use2 = function(self, card, area, copier)
        local rngpick = {}
        for i, j in pairs(G.P_BLINDS) do
            if j.boss and j.boss.showdown and not j.boss.bonus then
                table.insert(rngpick, i)
            end
        end
        local blind = pseudorandom_element(rngpick, pseudoseed('bonus'))
        bonus_selection(blind, {super_shop = true})
    end
}

-----------------

SMODS.Spectral {
    key = 'loop',
    loc_txt = {
        name = "Loop",
        text = {
            "Create a random",
            "{C:red}Bonus Blind{}"
        }
    },
    atlas = "loops",
    pos = {x = 0, y = 0},
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            local card = create_card("Bonus", G.consumeables)
            card:add_to_deck()
            G.consumeables:emplace(card)
            card:juice_up(0.3, 0.5)
            return true
        end}))
        delay(0.6)
    end,
    can_use = function(self, card)
        return (#G.consumeables.cards < G.consumeables.config.card_limit) or (card.area == G.consumeables)
    end
}

SMODS.Tag {
    key = 'ironic',
    atlas = 'bonus_tags',
    loc_txt = {
        name = "Ironic Tag",
        text = {
            "Gives a free",
            "{C:red}Jumbo Blind Pack"
        }
    },
    pos = {x = 0, y = 0},
    apply = function(tag, context)
        if context.type == 'new_blind_choice' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.RED,function() 
                local key = 'p_bb_blind_jumbo_1'
                local card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
                G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[key], {bypass_discovery_center = true, bypass_discovery_ui = true})
                card.cost = 0
                card.from_tag = true
                G.FUNCS.use_card({config = {ref_table = card}})
                card:start_materialize()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
            return true
        end
    end,
    loc_vars = function(self, info_queue, tag)
        info_queue[#info_queue+1] = {key = 'p_jumbo_bl', set = 'Other'}
        return {}
    end,
    config = {type = 'new_blind_choice'}
}

SMODS.Voucher {
    key = 'bonus1',
    loc_txt = {
        name = "Blind Merchant",
        text = {
            "{C:red}Bonus Blinds{} cards appear",
            "{C:attention}#1#X{} more frequently",
            "in the shop"
        }
    },
    config = {rate = 1.5},
    atlas = 'vouchery',
    pos = {x = 0, y = 0},
    loc_vars = function(self, info_queue, card)
        return {vars = {1.5}}
    end,
    redeem = function(self)
        G.E_MANAGER:add_event(Event({func = function()
            if G.GAME.selected_back.name == "Ante Deck" then
                G.GAME.bonus_rate = 10*self.config.rate
            else
                G.GAME.bonus_rate = 2*self.config.rate
            end
        return true end }))
    end
}

SMODS.Voucher {
    key = 'bonus2',
    loc_txt = {
        name = "Blind Tycoon",
        text = {
            "{C:red}Bonus Blinds{} cards appear",
            "{C:attention}#1#X{} more frequently",
            "in the shop"
        }
    },
    config = {rate = 3},
    atlas = 'vouchery',
    pos = {x = 1, y = 0},
    loc_vars = function(self, info_queue, card)
        return {vars = {3}}
    end,
    requires = {'v_bb_bonus1'},
    redeem = function(self)
        G.E_MANAGER:add_event(Event({func = function()
            if G.GAME.selected_back.name == "Ante Deck" then
                G.GAME.bonus_rate = 10*self.config.rate
            else
                G.GAME.bonus_rate = 2*self.config.rate
            end
        return true end }))
    end
}

SMODS.Joker {
    key = 'change',
    name = "Loose Change",
    loc_txt = {
        name = "Loose Change",
        text = {
            "{C:attention}Bonus Blinds{} give",
            "reward money."
        }
    },
    rarity = 2,
    atlas = 'jokery',
    pos = {x = 0, y = 0},
    cost = 7,
    blueprint_compat = false
}

SMODS.Booster {
   key = 'blind_normal_1',
   atlas = 'boostery',
   group_key = 'k_blind_pack',
   loc_txt = {
        name = "Blind Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:red} Bonus Blinds{}"
        }
    },
    weight = 0.3,
    name = "Blind Pack",
    pos = {x = 0, y = 0},
    config = {extra = 3, choose = 1, name = "Blind Pack"},
    create_card = function(self, card)
        return create_card("Bonus", G.pack_cards, nil, nil, true, true, nil, 'blind')
    end
}

SMODS.Booster {
   key = 'blind_normal_2',
   atlas = 'boostery',
   group_key = 'k_blind_pack',
   loc_txt = {
        name = "Blind Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:red} Bonus Blinds{}"
        }
    },
    weight = 0.3,
    name = "Blind Pack",
    pos = {x = 1, y = 0},
    config = {extra = 3, choose = 1, name = "Blind Pack"},
    create_card = function(self, card)
        return create_card("Bonus", G.pack_cards, nil, nil, true, true, nil, 'blind')
    end
}

SMODS.Booster {
   key = 'blind_jumbo_1',
   atlas = 'boostery',
   group_key = 'k_blind_pack',
   loc_txt = {
    name = "Jumbo Blind Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:red} Bonus Blinds{}"
        }
    },
    weight = 0.3,
    cost = 6,
    name = "Jumbo Blind Pack",
    pos = {x = 0, y = 1},
    config = {extra = 5, choose = 1, name = "Blind Pack"},
    create_card = function(self, card)
        return create_card("Bonus", G.pack_cards, nil, nil, true, true, nil, 'blind')
    end
}

SMODS.Booster {
   key = 'blind_mega_1',
   atlas = 'boostery',
   group_key = 'k_blind_pack',
   loc_txt = {
        name = "Mega Blind Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:red} Bonus Blinds{}"
        }
    },
    weight = 0.07,
    cost = 8,
    name = "Mega Blind Pack",
    pos = {x = 1, y = 1},
    config = {extra = 5, choose = 2, name = "Blind Pack"},
    create_card = function(self, card)
        return create_card("Bonus", G.pack_cards, nil, nil, true, true, nil, 'blind')
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, mix_colours(G.C.RED, G.C.BLACK, 0.9))
        ease_background_colour{new_colour = G.C.FILTER, special_colour = G.C.BLACK, contrast = 2}
    end,
}

SMODS.Back {
    key = 'ante',
    loc_txt = {
        name = "Ante Deck",
        text = {
            "{C:red}Bonus Blinds{} show up",
            "more often.",
            "Required score scales far",
            "faster for each {C:attention}Ante"
        }
    },
    name = "Ante Deck",
    pos = { x = 0, y = 0 },
    atlas = 'decks',
    apply = function(self)
        G.GAME.bonus_rate = 10
        G.GAME.modifiers.scaling = (G.GAME.modifiers.scaling or 1) + 0.5
    end
}

SMODS.Back {
    key = 'mall',
    loc_txt = {
        name = "Mall Deck",
        text = {
            "After defeating each",
            "{C:attention}Boss Blind{}, visit",
            "a {C:purple}Super Shop{}"
        }
    },
    name = "Mall Deck",
    pos = { x = 1, y = 0 },
    atlas = 'decks',
    trigger_effect = function(self, args)
        if args.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss then
            G.GAME.super_shop = true
            G.GAME.current_round.super_reroll_cost = 10
        end
    end
}

----- Blinds ---

SMODS.Atlas({ key = "blinds", atlas_table = "ANIMATION_ATLAS", path = "blinds.png", px = 34, py = 34, frames = 21 })

SMODS.Blind {
    loc_txt = {
        name = 'The Watch',
        text = { 'The Eye and Psychic', 'simultaneously' }
    },
    key = 'watch',
    name = 'The Watch',
    config = {},
    boss = {min = 1, max = 10, bonus = true},
    boss_colour = HEX("008A19"),
    atlas = "blinds",
    pos = { x = 0, y = 0},
    vars = {},
    dollars = 5,
    mult = 2,
    set_blind = function(self)
        G.GAME.blind.hands = {
            ["Flush Five"] = false,
            ["Flush House"] = false,
            ["Five of a Kind"] = false,
            ["Straight Flush"] = false,
            ["Four of a Kind"] = false,
            ["Full House"] = false,
            ["Flush"] = false,
            ["Straight"] = false,
            ["Three of a Kind"] = false,
            ["Two Pair"] = false,
            ["Pair"] = false,
            ["High Card"] = false,
        }
    end,
    debuff_hand = function(self, cards, hand, handname, check)
        if #cards < 5 then
            G.GAME.blind.triggered = true
            return true
        end
        if G.GAME.blind.hands[handname] then
            G.GAME.blind.triggered = true
            return true
        end
        if not check then G.GAME.blind.hands[handname] = true end
    end,
    get_loc_debuff_text = function(self)
        return localize('bl_watch_debuff')
    end,
    in_pool = function(self)
        return false
    end
}

SMODS.Blind {
    loc_txt = {
        name = 'The Countdown',
        text = { 'Hands allowed for ', '#1#' }
    },
    key = 'countdown',
    name = 'The Countdown',
    config = {},
    boss = {min = 1, max = 10, bonus = true},
    boss_colour = HEX("AC3900"),
    atlas = "blinds",
    pos = { x = 0, y = 1},
    vars = {"1:00"},
    dollars = 5,
    mult = 2,
    set_blind = function(self)
        G.GAME.blind.config.timing = G.GAME.blind.config.timing or 60
    end,
    debuff_hand = function(self, cards, hand, handname, check)
        if G.GAME.blind.config.timing <= 0 then
            return true
        end
        return false
    end,
    get_loc_debuff_text = function(self)
        if G.GAME.blind.config.timing <= 0 then
            return localize('bl_countdown_debuff1')
        end
        return localize('bl_countdown_debuff1')
    end,
    in_pool = function(self)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.blind.config.timing == nil then
            return {vars = {"1:00.00"}}
        end
        local m = math.floor(G.GAME.blind.config.timing / 60)
        local s = (G.GAME.blind.config.timing - (60 * m))
        local d = math.floor(100 * (s - math.floor(s)))
        s = tostring(math.floor(s))
        if string.len(s) == 1 then
            s = "0" .. s
        end
        d = tostring(d)
        if string.len(d) == 1 then
            d = "0" .. d
        end
        m = tostring(m)
        return {vars = {m .. ":" .. s .. "." .. d}}
    end,
}

SMODS.Atlas({ key = "cool_shop", atlas_table = "ANIMATION_ATLAS", path = "cool_shop.png", px = 113, py = 57, frames = 4 })

----------------

function bonus_new_round(theBlind, bonusData)
    G.RESET_JIGGLES = nil
    delay(0.4)
    G.E_MANAGER:add_event(Event({
      trigger = 'immediate',
      func = function()
            G.GAME.current_round.discards_left = math.max(0, G.GAME.round_resets.discards + G.GAME.round_bonus.discards)
            G.GAME.current_round.hands_left = (math.max(1, G.GAME.round_resets.hands + G.GAME.round_bonus.next_hands))
            G.GAME.current_round.hands_played = 0
            G.GAME.current_round.discards_used = 0
            G.GAME.current_round.reroll_cost_increase = 0
            G.GAME.current_round.used_packs = {}

            for k, v in pairs(G.GAME.hands) do 
                v.played_this_round = 0
            end

            for k, v in pairs(G.playing_cards) do
                v.ability.wheel_flipped = nil
            end

            local chaos = find_joker('Chaos the Clown')
            G.GAME.current_round.free_rerolls = #chaos
            calculate_reroll_cost(true)

            G.GAME.round_bonus.next_hands = 0
            G.GAME.round_bonus.discards = 0

            local blhash = 'S'
            -- if G.GAME.round_resets.blind == G.P_BLINDS.bl_small then
            --     G.GAME.round_resets.blind_states.Small = 'Current'
            --     G.GAME.current_boss_streak = 0
            --     blhash = 'S'
            -- elseif G.GAME.round_resets.blind == G.P_BLINDS.bl_big then
            --     G.GAME.round_resets.blind_states.Big = 'Current'
            --     G.GAME.current_boss_streak = 0
            --     blhash = 'B'
            -- else
            --     G.GAME.round_resets.blind_states.Boss = 'Current'
            --     blhash = 'L'
            -- end
            G.GAME.subhash = (G.GAME.round_resets.ante)..(blhash)

            -- local customBlind = {name = 'The Ox', defeated = false, order = 4, dollars = 5, mult = 2,  vars = {localize('ph_most_played')}, debuff = {}, pos = {x=0, y=2}, boss = {min = 6, max = 10, bonus = true}, boss_colour = HEX('b95b08')}
            G.GAME.blind:set_blind(G.P_BLINDS[theBlind])
            G.GAME.blind.config.bonus = bonusData
            G.GAME.last_blind.boss = nil
            G.GAME.blind_on_deck = 'Bonus'
            if not next(SMODS.find_card("j_bb_change")) then
                G.GAME.blind.dollars = 0
                G.GAME.current_round.dollars_to_be_earned = ''
            end
            G.HUD_blind.alignment.offset.y = -10
            G.HUD_blind:recalculate(false)
            bonus_start_effect(bonusData)
            
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:calculate_joker({setting_blind = true, blind = G.GAME.round_resets.blind})
            end
            delay(0.4)

            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    G.STATE = G.STATES.DRAW_TO_HAND
                    G.deck:shuffle('nr'..G.GAME.round_resets.ante)
                    G.deck:hard_set_T()
                    G.STATE_COMPLETE = false
                    return true
                end
            }))
            return true
            end
        }))
end

function bonus_selection(theBlind, bonusData)
    stop_use()
    if G.blind_select then 
        G.GAME.facing_blind = true
        G.blind_prompt_box:get_UIE_by_ID('prompt_dynatext1').config.object.pop_delay = 0
        G.blind_prompt_box:get_UIE_by_ID('prompt_dynatext1').config.object:pop_out(5)
        G.blind_prompt_box:get_UIE_by_ID('prompt_dynatext2').config.object.pop_delay = 0
        G.blind_prompt_box:get_UIE_by_ID('prompt_dynatext2').config.object:pop_out(5) 

        G.E_MANAGER:add_event(Event({
        trigger = 'before', delay = 0.2,
        func = function()
            G.blind_prompt_box.alignment.offset.y = -10
            G.blind_select.alignment.offset.y = 40
            G.blind_select.alignment.offset.x = 0
            return true
        end}))
        G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            ease_round(1)
            inc_career_stat('c_rounds', 1)
            if _DEMO then
            G.SETTINGS.DEMO_ROUNDS = (G.SETTINGS.DEMO_ROUNDS or 0) + 1
            inc_steam_stat('demo_rounds')
            G:save_settings()
            end
            -- G.GAME.round_resets.blind = e.config.ref_table
            -- G.GAME.round_resets.blind_states[G.GAME.blind_on_deck] = 'Current'
            G.blind_select:remove()
            G.blind_prompt_box:remove()
            G.blind_select = nil
            delay(0.2)
            return true
        end}))
        G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            bonus_new_round(theBlind, bonusData)
            return true
        end
        }))
    end
end

function bonus_start_effect(bonusData)
    if bonusData.blind_size_mod then
        G.GAME.blind.chips = G.GAME.blind.chips + bonusData.blind_size_mod
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end
    if bonusData.blind_mult then
        G.GAME.blind.mult = G.GAME.blind.mult * bonusData.blind_mult
        G.GAME.blind.chips = G.GAME.blind.chips * bonusData.blind_mult
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end
    if bonusData.hands then
        ease_hands_played(bonusData.hands-G.GAME.current_round.hands_left + (G.GAME.blind.hands_sub or 0))
    end
    if bonusData.double_hands then
        ease_hands_played(G.GAME.current_round.hands_left)
    end
    if bonusData.discards then
        ease_discard(bonusData.discards-G.GAME.current_round.discards_left + (G.GAME.blind.discards_sub or 0))
    end
    if bonusData.ante_mod then
        ease_ante(bonusData.ante_mod)
        G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
        G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante + bonusData.ante_mod
        G.GAME.blind.chips = G.GAME.blind.chips * get_blind_amount(G.GAME.round_resets.blind_ante)
        G.GAME.blind.chips = G.GAME.blind.chips / get_blind_amount(G.GAME.round_resets.blind_ante - bonusData.ante_mod)
        G.GAME.blind.chips = math.floor(G.GAME.blind.chips)
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end
    if bonusData.hand_size then
        G.hand:change_size(bonusData.hand_size)
    end
    if bonusData.eternal_round then
        local eternals = {}
        for i, j in ipairs(G.jokers.cards) do
            if j.config.center.eternal_compat and not j.ability.eternal then
                table.insert(eternals, j)
            end
        end
        G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function() 
            for i, j in ipairs(eternals) do
                G.E_MANAGER:add_event(Event({ func = function() j:flip();play_sound('card1',  1.15 - (i-0.999)/(#G.jokers.cards-0.998)*0.3);return true end }))
                delay(0.15)
            end
            delay(0.23)
            for i, j in ipairs(eternals) do
                j.ability.blind_eternal = true
                G.E_MANAGER:add_event(Event({ func = function() j.ability.eternal = true;play_sound('card1',  1.15 - (i-0.999)/(#G.jokers.cards-0.998)*0.3);j:flip();return true end }))
                delay(0.15)
            end
            return true
        end}))
    end
    if bonusData.pin_jokers then
        local pins = {}
        local sorts = {}
        for i, j in ipairs(G.jokers.cards) do
            local index = j.sort_id
            local i0 = 1
            while (i0 <= #sorts) and (index < sorts[i0]) do
                i0 = i0 + 1
            end
            table.insert(pins, j)
            table.insert(sorts, i0, j.sort_id)
        end
        for i, j in ipairs(G.jokers.cards) do
            j.sort_id = sorts[i]
        end
        G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function() 
            for i, j in ipairs(pins) do
                G.E_MANAGER:add_event(Event({ func = function() j:flip();play_sound('card1',  1.15 - (i-0.999)/(#G.jokers.cards-0.998)*0.3);return true end }))
                delay(0.15)
            end
            for i, j in ipairs(pins) do
                G.E_MANAGER:add_event(Event({ func = function() j.pinned = true;return true end }))
            end
            delay(0.23)
            for i, j in ipairs(pins) do
                G.E_MANAGER:add_event(Event({ func = function() play_sound('card1',  1.15 - (i-0.999)/(#G.jokers.cards-0.998)*0.3);j:flip();return true end }))
                delay(0.15)
            end
            return true
        end}))
    end
    if bonusData.flip_jokers then
        for i, j in ipairs(G.jokers.cards) do
            j:flip()
        end
        G.E_MANAGER:add_event(Event({ func = function() play_sound('card1',  0.85);return true end }))
    end
    if bonusData.lotto then
        local pool = {}
        local chosen = {}
        for i, j in pairs(G.playing_cards) do
            table.insert(pool, j)
        end
        for i = 1, bonusData.lotto.cards do
            local card, key = pseudorandom_element(G.playing_cards, pseudoseed('lottery'))
            table.remove(pool, key)
            table.insert(chosen, card)
        end
        for i, j in pairs(chosen) do
            j.ability.perma_bonus_mult = j.ability.perma_bonus_mult or 0
            j.ability.perma_bonus_mult = j.ability.perma_bonus_mult + bonusData.lotto.amount
        end
    end
    if bonusData.emp_jkr then
        if #G.jokers.cards + bonusData.emp_jkr > G.jokers.config.card_limit then
            local deletes = {}
            local pool = {}
            for i = 1, #G.jokers.cards do
                if (not G.jokers.cards[i].abilty or not G.jokers.cards[i].abilty.eternal) and (not G.jokers.cards[i].edition or not G.jokers.cards[i].edition.negative) then
                    table.insert(pool, G.jokers.cards[i])
                end
            end
            if #pool > #G.jokers.cards + bonusData.emp_jkr - G.jokers.config.card_limit then
                for i = 1, #G.jokers.cards + bonusData.emp_jkr - G.jokers.config.card_limit do
                    local card, index = pseudorandom_element(pool, pseudoseed('empty'))
                    table.insert(deletes, card)
                    table.remove(pool, index)
                end
            else
                deletes = pool
            end
            local first = nil
            G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.75, func = function()
                for k, v in pairs(deletes) do
                    v:start_dissolve(nil, first)
                    first = true
                end
            return true end }))
        end
    end
end

function bonus_reward(bonusData)
    if bonusData.tags then
        for i, j in ipairs(bonusData.tags) do
            add_tag(Tag(j))
        end
    end
    if bonusData.flip_jokers then
        for i, j in ipairs(G.jokers.cards) do
            j:flip()
        end
        G.E_MANAGER:add_event(Event({ func = function() play_sound('card1',  0.85);return true end }))
    end
    if bonusData.rand_reward then
        local val = pseudorandom(pseudoseed('reward'))
        if val < 1/6 then
            local val2 = 0.9 + (0.1 * pseudorandom(pseudoseed('rarity')))
            G.E_MANAGER:add_event(Event({
                func = (function()
                    G.E_MANAGER:add_event(Event({
                        func = function() 
                            local card = create_card('Joker', G.jokers, nil, val2, nil, nil, nil, 'rew')
                            card:add_to_deck()
                            G.jokers:emplace(card)
                            card:set_edition({negative = true})
                            return true
                        end
                    }))                     
                    return true
            end)}))
        elseif val < 1/3 then
            add_tag(Tag('tag_double'))
            add_tag(Tag('tag_double'))
        elseif val < 1/2 then
            local val2 = 10 + math.floor(60 * pseudorandom(pseudoseed('money')))
            ease_dollars(val2)
        elseif val < 2/3 then
            local polys = {}
            local pool = {}
            for i = 1, #G.playing_cards do
                if not G.playing_cards[i].edition then
                    table.insert(pool, G.playing_cards[i])
                end
            end
            if #pool > 4 then
                for i = 1, 4 do
                    local card, index = pseudorandom_element(pool, pseudoseed('poly'))
                    table.insert(polys, card)
                    table.remove(pool, index)
                end
            else
                polys = pool
            end
            for i, j in ipairs(polys) do
                j:set_edition({polychrome = true}, nil, true)
            end
            play_sound('polychrome1', 1.2, 0.7)
        elseif val < 5/6 then
            add_tag(Tag('tag_ethereal'))
            add_tag(Tag('tag_ironic'))
        else
            add_tag(Tag('tag_voucher'))
            add_tag(Tag('tag_voucher'))
        end
    end
    if bonusData.free_rerolls then
        G.GAME.current_round.free_rerolls = G.GAME.current_round.free_rerolls + bonusData.free_rerolls
        calculate_reroll_cost(true)
    end
end

function bonus_end_of_round(bonusData)
    if bonusData.burn_hand then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function() 
                local i = #G.hand.cards
                while (i >= 1) do
                    local card = G.hand.cards[i]
                    if card.ability.name == 'Glass Card' then 
                        card:shatter()
                    else
                        card:start_dissolve(nil, i == #G.hand.cards)
                    end
                    i = i - 1
                end
                return true 
            end 
        }))
        delay(0.5)
    end
    if bonusData.hand_size then
        G.hand:change_size(-1 * bonusData.hand_size)
    end
    if bonusData.eternal_round then
        local eternals = {}
        for i, j in ipairs(G.jokers.cards) do
            if j.ability.blind_eternal then
                table.insert(eternals, j)
            end
        end
        G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function() 
            for i, j in ipairs(eternals) do
                G.E_MANAGER:add_event(Event({ func = function() j:flip();play_sound('card1',  1.15 - (i-0.999)/(#G.jokers.cards-0.998)*0.3);return true end }))
                delay(0.15)
            end
            delay(0.23)
            for i, j in ipairs(eternals) do
                j.ability.blind_eternal = nil
                G.E_MANAGER:add_event(Event({ func = function() j.ability.eternal = nil;play_sound('card1',  1.15 - (i-0.999)/(#G.jokers.cards-0.998)*0.3);j:flip();return true end }))
                delay(0.15)
            end
            return true
        end}))
    end
    if bonusData.super_shop then
        G.GAME.super_shop = true
        G.GAME.current_round.super_reroll_cost = 10
    end
end

function SMODS.current_mod.process_loc_text()
    G.localization.descriptions.Other["card_extra_mult"] = 
    {
        text = {
            "{C:red}+#1#{} extra mult"
        }
    }
    G.localization.misc.dictionary["k_blind_pack"] = "Blind Pack"
    G.localization.misc.dictionary["bl_watch_debuff"] = "Must play 5 Cards and no repeat hand types this round"
    G.localization.misc.dictionary["bl_countdown_debuff1"] = "Times up"
    G.localization.misc.dictionary["bl_countdown_debuff2"] = "Hands allowed for 1:00"
    G.localization.descriptions.Other["bl_watch"] = {}
    G.localization.descriptions.Other["bl_watch"].text = { 'Must play 5 cards.', 'No repeat hand', 'types this round.' }
    G.localization.descriptions.Other["bl_watch"].name = "The Watch"
    G.localization.descriptions.Other["bl_countdown"] = {}
    G.localization.descriptions.Other["bl_countdown"].text = { 'Hands allowed for ', '1:00' }
    G.localization.descriptions.Other["bl_countdown"].name = "The Countdown"
    G.localization.descriptions.Other["bl_crimson"] = {}
    G.localization.descriptions.Other["bl_crimson"].name = localize{type ='name_text', key = 'bl_final_heart', set = 'Blind'}
    G.localization.descriptions.Other["bl_crimson"].text = localize{type = 'raw_descriptions', key = 'bl_final_heart', set = 'Blind', vars = {}}
    G.localization.descriptions.Other["bl_violet"] = {}
    G.localization.descriptions.Other["bl_violet"].name = localize{type ='name_text', key = 'bl_final_vessel', set = 'Blind'}
    G.localization.descriptions.Other["bl_violet"].text = localize{type = 'raw_descriptions', key = 'bl_final_vessel', set = 'Blind', vars = {}}
    G.localization.descriptions.Other["t_irony"] = {}
    G.localization.descriptions.Other["t_irony"].name = "Ironic Tag"
    G.localization.descriptions.Other["t_irony"].text = { "Gives a free", "{C:red}Jumbo Blind Pack"}
    G.localization.descriptions.Other["p_jumbo_bl"] = {}
    G.localization.descriptions.Other["p_jumbo_bl"].name = "Jumbo Blind Pack"
    G.localization.descriptions.Other["p_jumbo_bl"].text = { "Choose {C:attention}1{} of up to", "{C:attention}5{C:red} Bonus Blinds{}"}
    G.localization.descriptions.Other["bl_cerulean"] = {}
    G.localization.descriptions.Other["bl_cerulean"].name = localize{type ='name_text', key = 'bl_final_bell', set = 'Blind'}
    G.localization.descriptions.Other["bl_cerulean"].text = localize{type = 'raw_descriptions', key = 'bl_final_bell', set = 'Blind', vars = {}}
    G.localization.descriptions.Other["bl_snatch"] = {}
    G.localization.descriptions.Other["bl_snatch"].name = localize{type ='name_text', key = 'bl_hook', set = 'Blind'}
    G.localization.descriptions.Other["bl_snatch"].text = localize{type = 'raw_descriptions', key = 'bl_hook', set = 'Blind', vars = {}}
    G.localization.descriptions.Other["bl_rocky"] = {}
    G.localization.descriptions.Other["bl_rocky"].name = localize{type ='name_text', key = 'bl_flint', set = 'Blind'}
    G.localization.descriptions.Other["bl_rocky"].text = localize{type = 'raw_descriptions', key = 'bl_flint', set = 'Blind', vars = {}}
    G.localization.descriptions.Other["bl_snake"] = {}
    G.localization.descriptions.Other["bl_snake"].name = localize{type ='name_text', key = 'bl_serpent', set = 'Blind'}
    G.localization.descriptions.Other["bl_snake"].text = localize{type = 'raw_descriptions', key = 'bl_serpent', set = 'Blind', vars = {}}
    G.localization.descriptions.Other["blind_ox"] = {}
    G.localization.descriptions.Other["blind_ox"].name = localize{type ='name_text', key = 'bl_ox', set = 'Blind'}
    G.localization.descriptions.Other["blind_ox"].text = localize{type = 'raw_descriptions', key = 'bl_ox', set = 'Blind', vars = {localize('ph_most_played')}}
    -- G.localization.descriptions.Other["ed_negative_consumable"] = {}
    -- G.localization.descriptions.Other["ed_negative_consumable"].name = localize{type ='name_text', key = 'e_negative_consumable', set = 'Edition'}
    -- G.localization.descriptions.Other["ed_negative_consumable"].text = localize{type = 'raw_descriptions', key = 'e_negative_consumable', set = 'Edition', vars = {1}}
end

local get_blind_amount_old = get_blind_amount
function get_blind_amount(ante)
    if G.GAME.modifiers.scaling and G.GAME.selected_back.name == "Ante Deck" then
        local save = G.GAME.modifiers.scaling
        G.GAME.modifiers.scaling = math.floor(G.GAME.modifiers.scaling)
        local old = nil
        if Talisman then
            old = get_blind_amount_old(ante) or to_big(1)
        else
            old = get_blind_amount_old(ante) or 1
        end
        G.GAME.modifiers.scaling = save
        local k = (old/old)*1.5
        if G.GAME.modifiers.scaling == 1.5 then 
            local amounts = {
            300,  1000, 4000,  15000,  30000,  60000,   100000,  200000
            }
            if ante < 1 then return (old/old)*100 end
            if ante <= 8 then return (old/old)*amounts[ante] end
            local a, b, c, d = (old/old)*amounts[8],(old/old)*1.6,ante-8, 1 + 0.2*(ante-8)
            local amount = (old/old)*math.floor(a*(b+(k*c)^d)^c)
            amount = amount - amount%(10^math.floor(math.log10(amount)-1))
            return amount
        elseif G.GAME.modifiers.scaling == 2.5 then 
            local amounts = {
              300,  1500, 6000,  18000,  50000,  90000,   180000,  350000
            }
            if ante < 1 then return (old/old)*100 end
            if ante <= 8 then return (old/old)*amounts[ante] end
            local a, b, c, d = (old/old)*amounts[8],(old/old)*1.6,ante-8, 1 + 0.2*(ante-8)
            local amount = (old/old)*math.floor(a*(b+(k*c)^d)^c)
            amount = amount - amount%(10^math.floor(math.log10(amount)-1))
            return amount
        elseif G.GAME.modifiers.scaling == 3.5 then
            local amounts = {
              300,  2000, 8000,  35000,  100000,  350000,   500000,  1000000
            }
            if ante < 1 then return (old/old)*100 end
            if ante <= 8 then return (old/old)*amounts[ante] end
            local a, b, c, d = (old/old)*amounts[8],(old/old)*1.6,ante-8, 1 + 0.2*(ante-8)
            local amount = (old/old)*math.floor(a*(b+(k*c)^d)^c)
            amount = amount - amount%(10^math.floor(math.log10(amount)-1))
            return amount
        else
            local amounts = {
                300,  3000, 12000,  50000,  175000,  450000,   700000,  1500000
              }
              if ante < 1 then return (old/old)*100 end
              if ante <= 8 then return (old/old)*amounts[ante] end
              local a, b, c, d = (old/old)*amounts[8],(old/old)*1.6,ante-8, 1 + 0.2*(ante-8)
              local amount = (old/old)*math.floor(a*(b+(k*c)^d)^c)
              amount = amount - amount%(10^math.floor(math.log10(amount)-1))
              return amount
        end
    end
    return get_blind_amount_old(ante)
end

local upd = Game.update
function Game:update(dt)
    upd(self,dt)
    if G.GAME and G.GAME.round_resets and G.GAME.blind and G.GAME.blind.name == "The Countdown" and G.GAME.blind.config and (G.GAME.blind.config.timing ~= nil) and not G.GAME.blind.disabled then
        if Talisman then
            if to_big(G.GAME.chips) < to_big(G.GAME.blind.chips) then
                G.GAME.blind.config.timing = G.GAME.blind.config.timing and math.max(0, (G.GAME.blind.config.timing) - dt) or nil
                G.GAME.blind:set_text()
            end
        else
            if (G.GAME.chips) < (G.GAME.blind.chips) then
                G.GAME.blind.config.timing = G.GAME.blind.config.timing and math.max(0, (G.GAME.blind.config.timing) - dt) or nil
                G.GAME.blind:set_text()
            end
        end
    end
end

---------Super Shop------------------------

function coolShop()
    G.shop_jokers = CardArea(
      G.hand.T.x+0,
      G.hand.T.y+G.ROOM.T.y + 9,
      math.min(3, G.GAME.shop.joker_max)*1.02*G.CARD_W,
      1.05*G.CARD_H, 
      {card_limit = G.GAME.shop.joker_max, type = 'shop', highlight_limit = 1})
    
      G.special_card = CardArea(
        G.hand.T.x+0,
        G.hand.T.y+G.ROOM.T.y + 9,
        1.02*G.CARD_W,
        1.05*G.CARD_H, 
        {card_limit = 1, type = 'shop', highlight_limit = 1})


    G.shop_vouchers = CardArea(
      G.hand.T.x+0,
      G.hand.T.y+G.ROOM.T.y + 9,
      2.1*G.CARD_W,
      1.05*G.CARD_H, 
      {card_limit = 1, type = 'shop', highlight_limit = 1})

    G.shop_booster = CardArea(
      G.hand.T.x+0,
      G.hand.T.y+G.ROOM.T.y + 9,
      2.4*G.CARD_W,
      1.15*G.CARD_H, 
      {card_limit = 2, type = 'shop', highlight_limit = 1, card_w = 1.27*G.CARD_W})

    local shop_sign = AnimatedSprite(0,0, 4.4, 2.2, G.ANIMATION_ATLAS['bb_cool_shop'])
    shop_sign:define_draw_steps({
      {shader = 'dissolve', shadow_height = 0.05},
      {shader = 'dissolve'}
    })
    G.SHOP_SIGN = UIBox{
      definition = 
        {n=G.UIT.ROOT, config = {colour = G.C.DYN_UI.MAIN, emboss = 0.05, align = 'cm', r = 0.1, padding = 0.1}, nodes={
          {n=G.UIT.R, config={align = "cm", padding = 0.1, minw = 4.72, minh = 3.1, colour = G.C.DYN_UI.DARK, r = 0.1}, nodes={
            {n=G.UIT.R, config={align = "cm"}, nodes={
              {n=G.UIT.O, config={object = shop_sign}}
            }},
            {n=G.UIT.R, config={align = "cm"}, nodes={
              {n=G.UIT.O, config={object = DynaText({string = {localize('ph_improve_run')}, colours = {lighten(G.C.RED, 0.3)},shadow = true, rotate = true, float = true, bump = true, scale = 0.5, spacing = 1, pop_in = 1.5, maxw = 4.3})}}
            }},
          }},
        }},
      config = {
        align="cm",
        offset = {x=0,y=-15},
        major = G.HUD:get_UIE_by_ID('row_blind'),
        bond = 'Weak'
      }
    }
    G.E_MANAGER:add_event(Event({
      trigger = 'immediate',
      func = (function()
          G.SHOP_SIGN.alignment.offset.y = 0
          return true
      end)
    }))
    local t = {n=G.UIT.ROOT, config = {align = 'cl', colour = G.C.CLEAR}, nodes={
            UIBox_dyn_container({
                {n=G.UIT.C, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN}, nodes={
                    {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
                      {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                        {n=G.UIT.R,config={id = 'next_round_button', align = "cm", minw = 2.8, minh = 1.5, r=0.15,colour = G.C.BLUE, one_press = true, button = 'toggle_shop', hover = true,shadow = true}, nodes = {
                          {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'y', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                            {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                              {n=G.UIT.T, config={text = localize('b_next_round_1'), scale = 0.4, colour = G.C.WHITE, shadow = true}}
                            }},
                            {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                              {n=G.UIT.T, config={text = localize('b_next_round_2'), scale = 0.4, colour = G.C.WHITE, shadow = true}}
                            }}   
                          }},              
                        }},
                        {n=G.UIT.R, config={align = "cm", minw = 2.8, minh = 0.75, r=0.15,colour = G.C.GREEN, button = 'reroll_shop', func = 'can_reroll', hover = true,shadow = true}, nodes = {
                          {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'x', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                            {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                              {n=G.UIT.T, config={text = localize('k_reroll'), scale = 0.5, colour = G.C.WHITE, shadow = true}},
                              {n=G.UIT.T, config={text = " " .. localize('$'), scale = 0.5, colour = G.C.WHITE, shadow = true}},
                              {n=G.UIT.T, config={ref_table = G.GAME.current_round, ref_value = 'reroll_cost', scale = 0.5, colour = G.C.WHITE, shadow = true}},
                            }},
                          }}
                        }},
                        {n=G.UIT.R, config={align = "cm", minw = 2.8, minh = 0.75, r=0.15,colour = G.C.PURPLE, button = 'super_reroll_shop', func = 'super_can_reroll', hover = true,shadow = true}, nodes = {
                          {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'x', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                            {n=G.UIT.R, config={align = "cm", maxw = 2.0}, nodes={
                              {n=G.UIT.T, config={text = "Mega Reroll", scale = 0.5, colour = G.C.WHITE, shadow = true}},
                              {n=G.UIT.T, config={text = " " .. localize('$'), scale = 0.5, colour = G.C.WHITE, shadow = true}},
                              {n=G.UIT.T, config={ref_table = G.GAME.current_round, ref_value = 'super_reroll_cost', scale = 0.5, colour = G.C.WHITE, shadow = true}},
                            }},
                          }}
                        }},
                      }},
                      {n=G.UIT.C, config={align = "cm", padding = 0.2, r=0.2, colour = G.C.GREEN, emboss = 0.05, minw = 5.95}, nodes={
                          {n=G.UIT.O, config={object = G.shop_jokers}},
                      }},
                      {n=G.UIT.C, config={align = "cm", padding = 0.2, r=0.2, colour = G.C.PURPLE, emboss = 0.05, minw = 1.85}, nodes={
                          {n=G.UIT.O, config={object = G.special_card}},
                      }},
                    }},
                    {n=G.UIT.R, config={align = "cm", minh = 0.2}, nodes={}},
                    {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
                      {n=G.UIT.C, config={align = "cm", padding = 0.15, r=0.2, colour = G.C.L_BLACK, emboss = 0.05}, nodes={
                        {n=G.UIT.C, config={align = "cm", padding = 0.2, r=0.2, colour = G.C.BLACK, maxh = G.shop_vouchers.T.h+0.4}, nodes={
                          {n=G.UIT.T, config={text = localize{type = 'variable', key = 'ante_x_voucher', vars = {G.GAME.round_resets.ante}}, scale = 0.45, colour = G.C.L_BLACK, vert = true}},
                          {n=G.UIT.O, config={object = G.shop_vouchers}},
                        }},
                      }},
                      {n=G.UIT.C, config={align = "cm", padding = 0.15, r=0.2, colour = G.C.PURPLE, emboss = 0.05}, nodes={
                        {n=G.UIT.O, config={object = G.shop_booster}},
                      }},
                    }}
                }
              },
              
              }, false)
        }}
    return t
end

function handle_special_shop_card(nosave_shop, reroll)
    if G.special_card and G.GAME.super_shop and G.load_special_card and not reroll then
        G.special_card:load(G.load_special_card)
        for k, v in ipairs(G.special_card.cards) do
            create_shop_card_ui(v)
            if v.ability.consumeable then v:start_materialize() end
        end
        G.load_special_card = nil
        return true
    elseif G.special_card and G.GAME.super_shop then
        local num = pseudorandom(pseudoseed('special'))
        if num < 0.25 then
            local card = create_card("Joker", G.special_card, nil, nil, nil, nil, 'j_credit_card', 'sho')
            create_shop_card_ui(card, card.type, G.special_card)
            card:set_edition({negative = true})
            card:set_eternal(nil)
            card:set_perishable(true)
            card.ability.perish_tally = 1
            G.special_card:emplace(card)
        elseif num < 0.55 then
            local num2 = pseudorandom(pseudoseed('rarity')) * 0.04
            local card = create_card("Joker", G.special_card, nil, 0.96 + num2, nil, nil, nil, 'sho')
            create_shop_card_ui(card, card.type, G.special_card)
            local num3 = pseudorandom(pseudoseed('edition'))
            if (num3 < 0.4) then
                card:set_edition({negative = true})
            else
                card:set_edition({polychrome = true})
            end
            G.special_card:emplace(card)
        elseif num < 0.9 then
            local cume, it, center = 0, 0, nil
            local megas = {}
            for k, v in ipairs(G.P_CENTER_POOLS['Booster']) do
                if (v.config.choose == 2) and not G.GAME.banned_keys[v.key] then cume = cume + ((((G.GAME.selected_back.name == "Ante Deck") and (v.group_key == 'k_blind_pack') and (v.weight*5)) or v.weight) or 1 ); table.insert(megas, v) end
            end
            local poll = pseudorandom(pseudoseed(('pack_special')..G.GAME.round_resets.ante))*cume
            for k, v in ipairs(megas) do
                if not G.GAME.banned_keys[v.key] then 
                    if not _type or _type == v.kind then it = it + ((((G.GAME.selected_back.name == "Ante Deck") and (v.group_key == 'k_blind_pack') and (v.weight*5)) or v.weight) or 1) end
                    if it >= poll and it - ((((G.GAME.selected_back.name == "Ante Deck") and (v.group_key == 'k_blind_pack') and (v.weight*5)) or v.weight) or 1) <= poll then center = v; break end
                end
            end
            local card = Card(G.special_card.T.x + G.special_card.T.w/2,
            G.special_card.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[center.key], {bypass_discovery_center = true, bypass_discovery_ui = true})
            create_shop_card_ui(card, 'Booster', G.special_card)
            card:start_materialize()
            G.special_card:emplace(card)
        elseif num < 0.98 then
            local card = create_card('Spectral', G.special_card, nil, nil, nil, nil, nil, 'sho')
            create_shop_card_ui(card, card.type, G.special_card)
            card:start_materialize()
            G.special_card:emplace(card)
        else
            local card = create_card('Spectral', G.special_card, nil, nil, nil, nil, 'c_soul', 'sho')
            create_shop_card_ui(card, card.type, G.special_card)
            card:start_materialize()
            G.special_card:emplace(card)
        end
    end
    return nosave_shop
end

G.FUNCS.super_reroll_shop = function(e) 
    stop_use()
    ease_dollars(-G.GAME.current_round.super_reroll_cost)
    G.GAME.current_round.super_reroll_cost = (G.GAME.current_round.super_reroll_cost or 10) + 5
    G.CONTROLLER.locks.shop_reroll = true
    if G.CONTROLLER:save_cardarea_focus('shop_booster') and G.CONTROLLER:save_cardarea_focus('special_card') then G.CONTROLLER.interrupt.focus = true end
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
          for i = #G.shop_booster.cards,1, -1 do
            local c = G.shop_booster:remove_card(G.shop_booster.cards[i])
            c:remove()
            c = nil
          end

          for i = #G.special_card.cards,1, -1 do
            local c = G.special_card:remove_card(G.special_card.cards[i])
            c:remove()
            c = nil
          end

          --save_run()

          play_sound('coin2')
          play_sound('other1')
          
          G.GAME.current_round.used_packs = {}
          for i = 1, 2 do
            G.GAME.current_round.used_packs = G.GAME.current_round.used_packs or {}
            if not G.GAME.current_round.used_packs[i] then
                G.GAME.current_round.used_packs[i] = get_pack('shop_pack').key
            end

            if G.GAME.current_round.used_packs[i] ~= 'USED' then 
                local card = Card(G.shop_booster.T.x + G.shop_booster.T.w/2,
                G.shop_booster.T.y, G.CARD_W*(G.P_CENTERS[G.GAME.current_round.used_packs[i]].set == 'Booster' and 1.27 or 1), G.CARD_H*(G.P_CENTERS[G.GAME.current_round.used_packs[i]].set == 'Booster' and 1.27 or 1), G.P_CARDS.empty, G.P_CENTERS[G.GAME.current_round.used_packs[i]], {bypass_discovery_center = true, bypass_discovery_ui = true})
                                                                create_shop_card_ui(card, 'Booster', G.shop_booster)
                card.ability.booster_pos = i
                card:start_materialize()
                G.shop_booster:emplace(card)
            end
          end
          handle_special_shop_card(nil, true)
          return true
        end
      }))
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.3,
        func = function()
        G.E_MANAGER:add_event(Event({
          func = function()
            G.CONTROLLER.interrupt.focus = false
            G.CONTROLLER.locks.shop_reroll = false
            G.CONTROLLER:recall_cardarea_focus('shop_booster')
            return true
          end
        }))
        return true
      end
    }))
    G.E_MANAGER:add_event(Event({ func = function() save_run(); return true end}))
end

G.FUNCS.super_can_reroll = function(e) 
    if ((G.GAME.dollars-G.GAME.bankrupt_at) - G.GAME.current_round.super_reroll_cost < 0) then 
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
        --e.children[1].children[1].config.shadow = false
        --e.children[2].children[1].config.shadow = false
        --e.children[2].children[2].config.shadow = false
    else
        e.config.colour = G.C.PURPLE
        e.config.button = 'super_reroll_shop'
        --e.children[1].children[1].config.shadow = true
        --e.children[2].children[1].config.shadow = true
        --e.children[2].children[2].config.shadow = true
    end
end

----------------------------------------------
------------MOD CODE END----------------------
