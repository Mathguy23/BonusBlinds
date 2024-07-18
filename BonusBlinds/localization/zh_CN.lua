return {
	["misc"] = {
		["dictionary"] = {
			["k_bonus"] = "额外盲注",
			["k_blind_pack"] = "盲注包",
			["bl_watch_debuff"] = "必须出5张牌，不可打出重复牌型",
			["b_bonus_cards"] = "额外盲注",
		},
	},
	["descriptions"] = {
		["Back"] = {
			["b_bb_ante"] = {
				["name"] = "底注牌组",
				["text"] = {
					"提升{C:red}额外盲注{}的出现频率",
					"大大增加{C:attention}底注{}提升时",
					"得分要求的涨幅",
				},
			},
		},
		["Tag"] = {
			["tag_bb_ironic"] = {
				["name"] = "叙事标签",
				["text"] = {
					"免费获得一个",
					"{C:red}巨型盲注包",
				},
			},
		},
		["Blind"] = {
			["bl_bb_watch"] = {
				["name"] = "全视",
				["text"] = {
					"眼睛 + 灵媒",
				},
			},
			["bl_wheel"] = {
				["text"] = {
					"#1#/7的几率，抽到的牌",
				},
			},
		},
		["Voucher"] = {
			["v_bb_bonus2"] = {
				["name"] = "盲注大亨",
				["text"] = {
					"商店内{C:red}额外盲注{}的",
					"出现频率{C:attention}X#1#",
				},
			},
			["v_bb_bonus1"] = {
				["name"] = "盲注商人",
				["text"] = {
					"商店内{C:red}额外盲注{}的",
					"出现频率{C:attention}X#1#",
				},
			},
		},
		["Joker"] = {
			["j_bb_change"] = {
				["name"] = "一块零钱",
				["text"] = {
					"{C:attention}额外盲注",
					"可给予奖励金",
				},
			},
		},
		["Bonus"] = {
			["c_bb_spoiler"] = {
				["name"] = "“终章剧透”",
				["text"] = {
					"在当前{C:attention}底注{}中",
					"对阵{C:attention}底注#1#{}的{C:attention}关底盲注",
				},
			},
			["c_bb_rewind"] = {
				["name"] = "“前情回顾”",
				["text"] = {
					"以{C:blue}两倍{}的{C:blue}出牌次数",
					"对阵上一个被击败的{C:attention}盲注",
				},
			},
			["c_bb_champion"] = {
				["name"] = "Champion Blind",
				["text"] = {
					"{C:attention}-#1#{} Antes then play",
					"a {C:blue}Showdown Blind{}",
				},
			},
			["c_bb_locked"] = {
				["name"] = "“披枷带锁”",
				["text"] = {
					"对阵{C:blue}#1#",
					"手牌上限{C:attention}-#2#",
				},
			},
			["c_bb_hankercheif"] = {
				["name"] = "Hankercheif Blind",
				["text"] = {
					"Play {C:attention}#1#{}. Earn {C:money}$1{} when",
					"a playing card is scored",
				},
			},
			["c_bb_luck"] = {
				["name"] = "Lucky Blind",
				["text"] = {
					"Defeat a {C:attention}Blind{} with ",
					"{C:blue}#1#{} Hand and {C:red}#2#{} Discard",
					"to get #3# {C:attention}#4#s{}",
				},
			},
			["c_bb_magma"] = {
				["name"] = "Magma Blind",
				["text"] = {
					"Defeat {C:blue}#1#{} to",
					"{C:attention}destroy{} cards {C:attention}held in hand{}",
				},
			},
			["c_bb_redo"] = {
				["name"] = "“卷土重来”",
				["text"] = {
					"对阵{C:blue}得分要求X3{}的{C:purple}#1#",
					"成功击败后，获得{C:attention}#2#",
				},
			},
			["c_bb_fixed"] = {
				["name"] = "“稳定三角”",
				["text"] = {
					"对阵{C:blue}#1#",
					"所有{C:attention}小丑牌",
					"均将遭到{C:attention}左极固定",
				},
			},
			["c_bb_patch"] = {
				["name"] = "Patched Blind",
				["text"] = {
					"Defeat a {C:attention}Blind{}",
					"for a {C:attention}reward{}",
				},
			},
			["c_bb_lottery"] = {
				["name"] = "Lottery Blind",
				["text"] = {
					"Add {C:red}+#1#{} Mult to {C:attention}#2#{} random",
					"{C:attention}playing card{} then play {C:attention}#3#{}",
				},
			},
			["c_bb_dice"] = {
				["name"] = "Dice Blind",
				["text"] = {
					"Defeat a {C:attention}Boss Blind{} for",
					"{C:attention}#1#{} free {C:green}rerolls{} next shop",
				},
			},
			["c_bb_combo"] = {
				["name"] = "“稀里糊涂”",
				["text"] = {
					"对阵{C:blue}#1#",
					"所有{C:attention}小丑牌背面朝上",
				},
			},
			["c_bb_extra"] = {
				["name"] = "额外盲注",
				["text"] = {
					"支付{C:money}$#2#",
					"并对阵{C:blue}#1#",
				},
			},
			["c_bb_broken"] = {
				["name"] = "“断垣残壁”",
				["text"] = {
					"有{C:green}#1#/#2#{}的几率",
					"对阵{C:blue}#3#",
				},
			},
			["c_bb_sky"] = {
				["name"] = "“晴空万里”",
				["text"] = {
					"对阵{C:blue}#1#",
					"将{C:attention}最优{}牌型的",
					"基础得分的{C:attention}双倍",
					"加值至{C:blue}最低得分要求",
					"{C:inactive}（当前最优牌型：{C:attention} #2#{C:inactive}）",
				},
			},
			["c_bb_watching"] = {
				["name"] = "“手眼通天”",
				["text"] = {
					"对阵{C:green}#1#",
				},
			},
			["c_bb_brick"] = {
				["name"] = "“固若金汤”",
				["text"] = {
					"对阵随机一个",
					"{C:blue}得分要求X#1#{}的",
					"{C:attention}Boss{}盲注",
				},
			},
			["c_bb_sail"] = {
				["name"] = "“扬帆远航”",
				["text"] = {
					"以{C:blue}#1#{}次弃牌",
					"对阵随机的{C:attention}Boss{}盲注",
				},
			},
			["c_bb_needy"] = {
				["name"] = "“捉襟见肘”",
				["text"] = {
					"以{C:blue}#1#{}次出牌",
					"对阵随机的{C:attention}Boss{}盲注",
				},
			},
			["c_bb_disco"] = {
				["name"] = "Disco Blind",
				["text"] = {
					"Play {C:blue}#1#{}. Shuffle",
					"{C:attention}Stickers{} each {C:blue}hand{}",
				},
			},
			["c_bb_cruel"] = {
				["name"] = "“惨无人道”",
				["text"] = {
					"以至少{C:attention}#1#{}个空的{C:attention}小丑牌槽位",
					"对阵随机的{C:attention}Boss{}盲注",
					"{C:inactive}（会摧毁小丑牌以满足需求）",
				},
			},
			["c_bb_meta"] = {
				["name"] = "Meta Blind",
				["text"] = {
					"Activate a {C:red}Common Bonus Blind{}. Upon",
					"blind defeat, get an {C:attention}#1#{}",
				},
			},
			["c_bb_natural"] = {
				["name"] = "Supernatural Blind",
				["text"] = {
					"Play {C:green}The Serpent{}. All",
					"{C:attention}Jokers{} are {C:attention}Eternal{} for",
					"this blind. {C:attention}+1{} {C:dark_edition}Negative{}",
					"{C:spectral}Spectral{} each {C:blue}hand{}.",
				},
			},
		},
		["Other"] = {
			["t_irony"] = {
				["name"] = "Ironic Tag",
				["text"] = {
					"Gives a free",
					"{C:red}Jumbo Blind Pack",
				},
			},
			["bl_violet"] = {
				["name"] = "靛紫之杯",
				["text"] = {
					"超大盲注",
				},
			},
			["p_jumbo_bl"] = {
				["name"] = "Jumbo Blind Pack",
				["text"] = {
					"Choose {C:attention}1{} of up to",
					"{C:attention}5{C:red} Bonus Blinds{}",
				},
			},
			["p_bb_blind_jumbo_1"] = {
				["name"] = "巨型盲注包",
				["text"] = {
					"从最多{C:attention}#2#{}张",
					"{C:red}额外盲注{}中",
					"选择{C:attention}#1#{}张",
				},
			},
			["bl_crimson"] = {
				["name"] = "绯红之心",
				["text"] = {
					"每次出牌",
					"使随机一张小丑牌失效",
				},
			},
			["p_bb_blind_mega_1"] = {
				["name"] = "超级盲注包",
				["text"] = {
					"从最多{C:attention}#2#{}张",
					"{C:red}额外盲注{}中",
					"选择{C:attention}#1#{}张",
				},
			},
			["bl_watch"] = {
				["name"] = "全视",
				["text"] = {
					"必须出5张牌",
					"不可打出重复牌型",
				},
			},
			["bl_rocky"] = {
				["name"] = "燧石",
				["text"] = {
					"基础筹码和",
					"倍率减半",
				},
			},
			["card_extra_mult"] = {
				["text"] = {
					"{C:red}+#1#{}额外倍率",
				},
			},
			["bl_cerulean"] = {
				["name"] = "蔚蓝之铃",
				["text"] = {
					"迫使 1 张牌",
					"总是被选定",
				},
			},
			["bl_snatch"] = {
				["name"] = "钩子",
				["text"] = {
					"每次出牌",
					"随机弃掉2张手牌",
				},
			},
			["blind_ox"] = {
				["name"] = "公牛",
				["text"] = {
					"打出{最常出的牌型}牌型时",
					"资金归$0",
				},
			},
			["bl_snake"] = {
				["name"] = "蛇",
				["text"] = {
					"出牌或弃牌后",
					"固定抽取3张牌",
				},
			},
			["p_bb_blind_normal_1"] = {
				["name"] = "盲注包",
				["text"] = {
					"从最多{C:attention}#2#{}张",
					"{C:red}额外盲注{}中",
					"选择{C:attention}#1#{}张",
				},
			},
			["p_bb_blind_normal_2"] = {
				["name"] = "盲注包",
				["text"] = {
					"从最多{C:attention}#2#{}张",
					"{C:red}额外盲注{}中",
					"选择{C:attention}#1#{}张",
				},
			},
			["undiscovered_bonus"] = {
				["name"] = "未发现的盲注",
				["text"] = {
					"我不到啊",
				},
			},
		},
		["Spectral"] = {
			["c_bb_loop"] = {
				["name"] = "循环",
				["text"] = {
					"随机生成一张",
					"{C:red}额外盲注",
				},
			},
		},
	},
}