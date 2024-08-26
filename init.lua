-- ehlphabet/init.lua
-- Letter blocks
--[[
    This mod is originally licensed under WTFPL (see below).
    It is now relicensed with CC0 1.0.
    To view a copy of this license,
    visit http://creativecommons.org/publicdomain/zero/1.0
]]

local minetest = minetest

local characters = {}
local characters_sticker = {}
local characters_glass = {}

ehlphabet = {}
ehlphabet.path = minetest.get_modpath(minetest.get_current_modname())

local S = minetest.get_translator("ehlphabet")
ehlphabet.intllib = S

local function is_multibyte(ch)
    local byte = ch:byte()
    -- return (195 == byte) or (208 == byte) or (209 == byte)
    if not byte then
        return false
    else
        return (byte > 191)
    end
end

local rotate_simple = minetest.global_exists("screwdriver") and screwdriver.rotate_simple or nil

local create_alias = true
for _, char in ipairs({
    -- digits
    "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",

    -- base characters
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O",
    "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",

    -- special characters
    "!", "#", "$", "%", "&", "(", ")", "*", "+", ",", "-", ".", "/", ":", ";",
    "<", "=", ">", "?", "@", "'", '"',

    -- german characters
    "Ä", "Ö", "Ü", "ß",

    -- cryillic characters
    "А", "Б", "В", "Г", "Д", "Е", "Ё", "Ж", "З", "И", "Й", "К", "Л", "М", "Н",
    "О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ъ", "Ы", "Ь",
    "Э", "Ю", "Я",

    -- greek characters
    "Α", "Β", "Γ", "Δ", "Ε", "Ζ", "Η", "Θ", "Ι", "Κ", "Λ", "Μ", "Ν", "Ξ", "Ο",
    "Π", "Ρ", "Σ", "Τ", "Υ", "Φ", "Χ", "Ψ", "Ω",

    -- additional characters
    "非", "常", "可", "愛", "爱", "的", "猫",
    "北", "东", "東", "南", "西", "站",
}) do
    local name = "ehlphabet:" .. char:byte(1)
    local filekey = ("%03d"):format(char:byte(1))
    if is_multibyte(char) then
        name = name .. char:byte(2)
        filekey = filekey .. ("_%03d"):format(char:byte(2))
    end

    minetest.register_node(name, {
        description = S("Ehlphabet Block '@1'", char),
        tiles = { "ehlphabet_char_base.png^ehlphabet_char_" .. filekey .. ".png" },
        paramtype2 = "facedir",    -- neu
        on_rotate = rotate_simple, -- neu
        is_ground_content = false, --neu
        groups = {
            cracky = 3,
            not_in_creative_inventory = 1,
            not_in_crafting_guide = 1,
            ehlphabet_block = 1
        },
        sounds = xcompat.sounds.node_sound_stone_defaults(),
    })

    minetest.register_node(name .. "_sticker", {
        description = S("Ehlphabet Sticker '@1'", char),
        tiles = {
            "ehlphabet_char_base.png^ehlphabet_char_" .. filekey .. ".png",
            "ehlphabet_char_base.png^ehlphabet_char_" .. filekey .. ".png^[transformR180"
        },
        inventory_image = "ehlphabet_char_base.png^ehlphabet_char_" .. filekey .. ".png",
        paramtype = "light",
        paramtype2 = "wallmounted", -- "colorwallmounted",
        on_rotate = rotate_simple,
        drawtype = "nodebox",
        is_ground_content = false,
        drop = "", -- new
        node_box = {
            type = "wallmounted",
            wall_bottom = { -0.5, -0.5, -0.5, 0.5, -0.49, 0.5 },
            wall_top = { -0.5, 0.49, -0.5, 0.5, 0.5, 0.5 },
            wall_side = { -0.5, -0.5, -0.5, -0.49, 0.5, 0.5 },
        },
        groups = {
            attached_node = 1,
            dig_immediate = 2,
            not_in_creative_inventory = 1,
            not_in_crafting_guide = 1,
            not_blocking_trains = 1
        },
        sounds = xcompat.sounds.node_sound_leaves_defaults(),
    })

    minetest.register_node(name .. "_glass", {
        description = S("Ehlphabet Glass '@1'", char),
        tiles = {
            "ehlphabet_char_" .. filekey .. ".png^[invert:rgb",
            "ehlphabet_char_" .. filekey .. ".png^[invert:rgb^[transformR180"
        },
        inventory_image = "ehlphabet_char_" .. filekey .. ".png^[invert:rgb",
        paramtype = "light",
        paramtype2 = "wallmounted", -- "colorwallmounted",
        on_rotate = rotate_simple,
        drawtype = "nodebox",
        is_ground_content = false,
        drop = "", -- new
        node_box = {
            type = "wallmounted",
            wall_bottom = { -0.5, -0.5, -0.5, 0.5, -0.49, 0.5 },
            wall_top = { -0.5, 0.49, -0.5, 0.5, 0.5, 0.5 },
            wall_side = { -0.5, -0.5, -0.5, -0.49, 0.5, 0.5 },
        },
        groups = {
            attached_node = 1,
            dig_immediate = 2,
            not_in_creative_inventory = 1,
            not_in_crafting_guide = 1,
            not_blocking_trains = 1
        },
        sounds = xcompat.sounds.node_sound_glass_defaults(),
        use_texture_alpha = "blend",
    })

    if create_alias then
        minetest.register_alias("abjphabet:" .. char, name)
    end
    -- deactivate alias creation on last latin character
    if name == "Z" then
        create_alias = false
    end

    characters[char] = name
    characters_sticker[char] = name .. "_sticker"
    characters_glass[char] = name .. "_glass"
end

-- Alias (can't generate dynamically for non-ascii)
for src, dst in pairs({
    -- English Alphabet
    ["a"] = "A",
    ["b"] = "B",
    ["c"] = "C",
    ["d"] = "D",
    ["e"] = "E",
    ["f"] = "F",
    ["g"] = "G",
    ["h"] = "H",
    ["i"] = "I",
    ["j"] = "J",
    ["k"] = "K",
    ["l"] = "L",
    ["m"] = "M",
    ["n"] = "N",
    ["o"] = "O",
    ["p"] = "P",
    ["q"] = "Q",
    ["r"] = "R",
    ["s"] = "S",
    ["t"] = "T",
    ["u"] = "U",
    ["v"] = "V",
    ["w"] = "W",
    ["x"] = "X",
    ["y"] = "Y",
    ["z"] = "Z",

    -- German Alphabet
    ["ä"] = "Ä",
    ["ö"] = "Ö",
    ["ü"] = "Ü",
    ["ß"] = "ß",

    -- cryillic characters
    ["а"] = "А",
    ["б"] = "Б",
    ["в"] = "В",
    ["г"] = "Г",
    ["д"] = "Д",
    ["е"] = "Е",
    ["ë"] = "Ё",
    ["ж"] = "Ж",
    ["з"] = "З",
    ["и"] = "И",
    ["й"] = "Й",
    ["к"] = "К",
    ["л"] = "Л",
    ["м"] = "М",
    ["н"] = "Н",
    ["о"] = "О",
    ["п"] = "П",
    ["р"] = "Р",
    ["с"] = "С",
    ["т"] = "Т",
    ["у"] = "У",
    ["ф"] = "Ф",
    ["х"] = "Х",
    ["ц"] = "Ц",
    ["ч"] = "Ч",
    ["ш"] = "Ш",
    ["щ"] = "Щ",
    ["ъ"] = "Ъ",
    ["ы"] = "Ы",
    ["ь"] = "Ь",
    ["э"] = "Э",
    ["ю"] = "Ю",
    ["я"] = "Я",

    -- greek characters
    ["α"] = "Α",
    ["β"] = "Β",
    ["γ"] = "Γ",
    ["δ"] = "Δ",
    ["ε"] = "Ε",
    ["ζ"] = "Ζ",
    ["η"] = "Η",
    ["θ"] = "Θ",
    ["ι"] = "Ι",
    ["κ"] = "Κ",
    ["λ"] = "Λ",
    ["μ"] = "Μ",
    ["ν"] = "Ν",
    ["ξ"] = "Ξ",
    ["ο"] = "Ο",
    ["π"] = "Π",
    ["ρ"] = "Ρ",
    ["σ"] = "Σ",
    ["ς"] = "Σ",
    ["τ"] = "Τ",
    ["υ"] = "Υ",
    ["φ"] = "Φ",
    ["χ"] = "Χ",
    ["ψ"] = "Ψ",
    ["ω"] = "Ω",
}) do
    characters[src] = characters[dst]
    characters_sticker[src] = characters_sticker[dst]
    characters_glass[src] = characters_glass[dst]
end

minetest.register_craft({ type = "shapeless", output = "ehlphabet:block", recipe = { "group:ehlphabet_block" } })

-- empty sticker
characters_sticker[" "] = "ehlphabet:32_sticker"
characters_sticker[""] = "ehlphabet:32_sticker"
minetest.register_node("ehlphabet:32_sticker", {
    description = S("Blank Sticker"),
    tiles = { "ehlphabet_char_base.png" },
    paramtype = "light",
    paramtype2 = "wallmounted", -- "colorwallmounted",
    on_rotate = rotate_simple,
    drawtype = "nodebox",
    is_ground_content = false,
    drop = "", -- new
    node_box = {
        type = "wallmounted",
        wall_bottom = { -0.5, -0.5, -0.5, 0.5, -0.49, 0.5 },
        wall_top = { -0.5, 0.49, -0.5, 0.5, 0.5, 0.5 },
        wall_side = { -0.5, -0.5, -0.5, -0.49, 0.5, 0.5 },
    },
    groups = {
        attached_node = 1,
        dig_immediate = 2,
        not_in_creative_inventory = 1,
        not_blocking_trains = 1
    },
    sounds = xcompat.sounds.node_sound_leaves_defaults(),
})

-- Materieals
local materieal_paper = xcompat.materials.paper
local materieal_glass = xcompat.materials.glass
local materieal_coal = xcompat.materials.coal_lump
local materieal_stick = xcompat.materials.stick

if minetest.registered_items["xpanes:pane_flat"] then
    -- MTG
    materieal_glass = "xpanes:pane_flat"
elseif minetest.registered_items["xpanes:pane_natural_flat"] then
    -- MCL
    materieal_glass = "xpanes:pane_natural_flat"
end

minetest.register_node("ehlphabet:machine", {
    description = S("Letter Machine"),
    tiles = {
        "ehlphabet_machine_top.png",
        "ehlphabet_machine_bottom.png",
        "ehlphabet_machine_side.png",
        "ehlphabet_machine_side.png",
        "ehlphabet_machine_back.png",
        "ehlphabet_machine_front.png"
    },
    paramtype = "light",
    paramtype2 = "facedir",
    groups = { cracky = 2 },

    -- "Can you dig it?" -Cyrus
    can_dig = function(pos, player)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        if not (inv:is_empty("input") and inv:is_empty("output")) then
            if player then
                minetest.chat_send_player(
                    player:get_player_name(),
                    S("You cannot dig the @1 with blocks inside", S("Letter Machine"))
                )
            end -- end if player
            return false
        end     -- end if not empty
        return true
    end,        -- end can_dig function

    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec",
            "size[8,6]" ..
            "field[3.8,.5;1,1;lettername;" .. S("Letter") .. ";]" ..
            "list[current_name;input;2.5,0.2;1,1;]" ..
            "list[current_name;output;4.5,0.2;1,1;]" ..
            "list[current_player;main;0,2;8,4;]" ..
            "button[2.54,-0.25;3,4;name;" .. S("Blank -> Letter") .. "]" ..
            "field_close_on_enter[lettername;false]" ..
            "listring[current_player;main]" ..
            "listring[current_name;input]" ..
            "listring[current_player;main]" ..
            "listring[current_name;output]")
        local inv = meta:get_inventory()
        inv:set_size("input", 1)
        inv:set_size("output", 1)
    end,

    on_receive_fields = function(pos, _, fields)
        if not (fields.name or (fields.key_enter and fields.key_enter_field == "lettername")) then
            return
        end

        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local inputstack = inv:get_stack("input", 1)
        local letter = fields.lettername

        local stackname = inputstack:get_name()
        local output_name
        if stackname == "ehlphabet:block" then
            output_name = characters[letter]
        elseif stackname == materieal_paper then
            output_name = characters_sticker[letter]
        elseif stackname == materieal_glass then
            output_name = characters_glass[letter]
        end
        if output_name and inv:room_for_item("output", output_name) then
            inv:add_item("output", output_name)
            inputstack:take_item()
            inv:set_stack("input", 1, inputstack)
        end
    end,

    allow_metadata_inventory_put = function(_, listname, _, stack)
        if listname == "input" then
            local stack_name = stack:get_name()
            if stack_name == "ehlphabet:block"
                or stack_name == materieal_paper
                or stack_name == materieal_glass then
                return stack:get_count()
            end
        end
        return 0
    end,

    allow_metadata_inventory_move = function() return 0 end,
})

--  Alias  (Och_Noe 20180124)
minetest.register_alias("abjphabet:machine", "ehlphabet:machine")
--

minetest.register_node("ehlphabet:block", {
    description = S("Ehlphabet Block (blank)"),
    tiles = { "ehlphabet_char_base.png" },
    groups = { cracky = 3 }
})

--RECIPE: blank blocks
minetest.register_craft({
    output = "ehlphabet:block 8",
    recipe = {
        { materieal_paper, materieal_paper, materieal_paper },
        { materieal_paper, "",              materieal_paper },
        { materieal_paper, materieal_paper, materieal_paper }
    }
})

--RECIPE: build the machine!
minetest.register_craft({
    output = "ehlphabet:machine",
    recipe = {
        { materieal_stick, materieal_coal,    materieal_stick },
        { materieal_coal,  "ehlphabet:block", materieal_coal },
        { materieal_stick, materieal_coal,    materieal_stick }
    }
})

--RECIPE: craft unused blocks back into paper
minetest.register_craft({
    output = materieal_paper,
    recipe = { "ehlphabet:block" },
    type = "shapeless"
})

-- Chinese Characters - craft from latin characters
for dst, recipe in pairs({
    ["非"] = {
        { "N", "O", "T" },
    },
    ["常"] = {
        { "N", "O", "R" },
        { "M", "A", "L" },
    },
    ["可"] = {
        { "C", "A", "N" }
    },
    ["爱"] = {
        { "L", "O", "V" },
        { "E", "",  "S" },
    },
    ["愛"] = {
        { "L", "O", "V" },
        { "E", "",  "T" },
    },
    ["的"] = {
        { "D", "E" }, -- Can't find any better...
    },
    ["猫"] = {
        { "N", "",  "" },
        { "E", "K", "O" },
    },
    ["北"] = {
        { "N", "O", "R" },
        { "T", "H", "" },
    },
    ["东"] = {
        { "E", "A", "S" },
        { "T", "",  "S" },
    },
    ["東"] = {
        { "E", "A", "S" },
        { "T", "",  "T" },
    },
    ["南"] = {
        { "S", "O", "U" },
        { "T", "H", "" },
    },
    ["西"] = {
        { "W", "E", "S" },
        { "T", "",  "" },
    },
    ["站"] = {
        { "S", "T", "A" },
        { "T", "I", "O" },
        { "N", "",  "" },
    },
}) do
    local recipe_block, recipe_sticker = table.copy(recipe), table.copy(recipe)
    local output = 0
    for _, row in ipairs(recipe_block) do
        for i, char in ipairs(row) do
            if char ~= "" then
                row[i] = characters[char]
                output = output + 1
            end
        end
    end
    for _, row in ipairs(recipe_sticker) do
        for i, char in ipairs(row) do
            if char ~= "" then
                row[i] = characters_sticker[char]
            end
        end
    end

    minetest.register_craft({
        output = characters[dst] .. " " .. output,
        recipe = recipe_block
    })

    minetest.register_craft({
        output = characters_sticker[dst] .. " " .. output,
        recipe = recipe_sticker
    })
end
