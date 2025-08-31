return {
    descriptions = {
        Joker = {
            j_maxboism_bluetoothgrenade = {
                name = 'Bluetooth Grenade',
                text = {
                    'After {C:attention}5{} rounds, this card {C:attention}explodes{} and gives {C:money}$50{}',
                    '{C:inactive}(Currently {C:attention}#1#{}/5){}',
                }
            },
            j_maxboism_cheatsheet = {
                name = 'Cheat Sheet',
                text = {
                    'This joker gives {C:red}+#1#{} Mult on first round played,',
                    'then nothing for two rounds',
                    'and then gives {X:mult,C:white}X#2#{} Mult on the fourth round',
                    '{C:inactive}(Currently round {C:attention}#3#{}/4){}'
                }
            },
            j_maxboism_curseofra = {
                name = 'Curse Of Ra',
                text = {
                    'Converts {C:attention}Stone{} cards in hand to {C:attention}Sand{} cards',
                    '{C:attention}Sand{} cards also count as {C:attention}Stone{} cards while this joker is held'
                }
            },
            j_maxboism_homophobicslenderman = {
                name = 'Homophobic Slenderman',
                text = {
                    'Collect my {C:attention}Page{} cards from the {C:attention}shop{}',
                    '{C:inactive}(Currently #1#/7){}',
                    '{C:inactive}(Currently{} {X:chips,C:white}X#2#{} {C:inactive}Chips and{} {X:mult,C:white}X#2#{} {C:inactive}Mult){}'
                }
            },
            j_maxboism_infiniteparking = {
                name = 'Infinite Parking',
                text = {
                    '{C:attention}1{} card from played hand',
                    'will not be {C:attention}discarded{}'
                }
            },
            j_maxboism_leftnut = {
                name = 'Left Nut',
                text = {
                    'Played {C:attention}Stone{} or {C:attention}Sand{} cards are retriggered {C:attention}2{} times',
                    'if played to the left of {C:attention}Non-Stone/Sand{} cards'
                }
            },
            j_maxboism_pickledmask = {
                name = 'Pickled Mask',
                text = {
                    'All played {C:attention}face{} cards',
                    'become {C:dark_edition}Polychrome{} cards when scored'
                }
            },
            j_maxboism_testjerker = {
                name = 'test jerker',
                text = {
                    'A {C:page}black{} joker with {C:red}unique{} effects.'
                }
            },
            j_maxboism_thepeasant = {
                name = 'The Peasant',
                text = {
                    'Score {X:mult,C:white}X#1# {} when a {C:orange}face{} card is scored,',
                    'then multiply Mult by 1.1',
                    '(Mult resets after hand)'
                }
            },
            j_maxboism_vsmaxboi = {
                name = 'VS MaxBoi',
                text = {
                    '{C:green}#1# in #2#{} chance to give {X:red,C:white}^1.5{} mult.'
                }
            },
            j_maxboism_noentry = {
                name = 'No Entry',
                text = {
                    'Gives {X:mult,C:white}X#1#{} Mult if Poker Hand held in hand is {C:attention}#2#{}',
                    '{C:inactive}(Each higher tier gives{} {X:mult,C:white}+X#3#{} {C:inactive}Mult){}',
                }
            },
            j_maxboism_sleevedjoker = {
                name = 'Sleeved Joker',
                text = {
                    '{C:attention}Sleeves{} a random non-scoring playing card',
                }
            },
            j_maxboism_ghostbuster = {
                name = 'Ghost Buster',
                text = {
                    '{C:money}+#1#${} at the end of a round',
                    'per {C:spectral}Spectral{} card used this run',
                    '{C:inactive}(Currently {C:money}+#2#${}{C:inactive}){}'
                }
            }
        },
        page = {
            c_maxboism_page1 = {
                name = 'Page 1',
                text = {
                    '{C:inactive}Passive:{} All {C:mult}+Mult{} from {C:attention}Enhancements{} is set to {C:attention}0{}',
                    '{C:default}Active:{} Make a random joker {C:dark_edition}Holographic{}'
                }
            },
            c_maxboism_page2 = {
                name = 'Page 2',
                text = {
                    '{C:inactive}Passive:{} Lose {C:money}$1{} per hand played',
                    '{C:default}Active:{} Create a {C:attention}#1#{}',
                    '{C:inactive}(If used inside shop, mimic the effect of the tag instead){}'
                }
            },
            c_maxboism_page3 = {
                name = 'Page 3',
                text = {
                    '{C:inactive}Passive:{} {C:red}-1{} hand size',
                    '{C:default}Active:{} {C:attention}+1{} hand size'
                }
            },
            c_maxboism_page4 = {
                name = 'Page 4',
                text = {
                    '{C:inactive}Passive:{} {C:green}#1# in #2#{} chance to decrease level of played hand',
                    '{C:default}Active:{} Level up {C:attention}most played hand{} 6 times'
                }
            },
            c_maxboism_page5 = {
                name = 'Page 5',
                text = {
                    '{C:inactive}Passive:{} Apply {X:chips,C:white}X#1#{} {C:blue}Chips{} before scoring concludes',
                    '{C:default}Active:{} Apply {C:dark_edition}Foil{} to all cards held in hand',
                    '{C:inactive}(Overrides existing editions){}'
                }
            },
            c_maxboism_page6 = {
                name = 'Page 6',
                text = {
                    '{C:inactive}Passive:{} {C:attention}Shuffle{} all jokers when a hand is played',
                    '{C:default}Active:{} Apply {C:dark_edition}Negative{} to a random joker',
                    'Apply a random {C:attention}sticker{} to {C:attention}#1#{} joker(s)'
                }
            },
            c_maxboism_page7 = {
                name = 'Page 7',
                text = {
                    '{C:inactive}Passive:{} Debuff a random card {C:attention}rank{}',
                    '{C:default}Active:{} Give {C:attention}2{} {C:dark_edition}Negative{} cards of the given {C:attention}rank{}',
                    '{C:inactive}(Resets every hand; Currently {C:attention}#1#s{}){}'
                }
            },

        },
        game = {
            c_maxboism_lingo = {
                name = 'Lingo',
                text = {
                    'Solve a {C:attention}puzzle{} for a {C:attention}reward{}',
                    '{C:inactive}(Reward:{} {C:money}20${C:money} {C:inactive}| Penalty:{} {C:money}-2${}{C:inactive}){}'
                }
            },
        },
        friend = {
            c_maxboism_thetram = {
                name = 'The Tram',
                text = {
                    "Creates a",
                    "{C:maxboism_friendendary,E:1}Friendendary{} Joker",
                    "from the {C:attention}Tram{} pool.",
                    "{C:inactive}(Must have room){}"
                }
            },
            c_maxboism_thezaza = {
                name = 'The Zaza',
                text = {
                    "Creates a",
                    "{C:maxboism_friendendary,E:1}Friendendary{} Joker",
                    "from the {C:attention}Zaza{} pool.",
                    "{C:inactive}(Must have room){}"
                }
            },
        },
        Edition = {
            e_maxboism_sepia = {
                name = 'Sepia',
                text = {
                    'Balances {C:attention}#1#%{} of chips and mult'
                },
            }
        },
        Enhanced = {
            m_maxboism_sand = {
                name= 'Sand Card',
                text = {
                    '{X:chips,C:white}X#1#{} chips',
                    'no suit or rank'
                }
            }
        },
        Other = {
            maxboism_lockseal_seal = {
                name = 'Sleeve',
                text = {
                    '{C:attention}Sleeved{} cards can not be {C:red}destroyed{}.',
                    '{C:red}Debuffed{} {C:attention}Sleeved{} cards are {C:red}destroyed{} immediately.'
                }
            }
        }
    },
    misc = {
        labels = {
            maxboism_sepia = 'Sepia',
            maxboism_lockseal_seal = 'Sleeve'
        },
        dictionary = {
            maxboism_joker_bluetoothgrenade_explode = 'Explosion.sfx',
            maxboism_joker_bluetoothgreande_buy = 'Throwing!',
            maxboism_joker_curseofra_message = 'They crumble...',
            maxboism_joker_homophobicslenderman_freebie = 'Freebie!',
            maxboism_joker_homophobicslenderman_found = 'Found!',
            maxboism_joker_homophobicslenderman_lost = 'Lost...',
            maxboism_joker_infiniteparking_parked = 'Parked!',
            maxboism_joker_pickledmask_message = 'Colorful!',
            maxboism_joker_thepeasant_message = 'Reset!',
            maxboism_joker_sleevedjoker_message = 'Sleeved!'
        },
    }
}
