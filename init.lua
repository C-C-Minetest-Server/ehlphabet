-- ehlphabet/init.lua
-- Letter blocks
--[[
    This mod is originally licensed under WTFPL (see below).
    It is now relicensed with CC0 1.0.
    To view a copy of this license,
    visit http://creativecommons.org/publicdomain/zero/1.0
]]

local minetest = minetest

local digits = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }
local base_chars = {
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O",
    "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
}
local special_chars = {
    "!", "#", "$", "%", "&", "(", ")", "*", "+", ",", "-", ".", "/", ":", ";",
    "<", "=", ">", "?", "@", "'", '"'
}
local german_chars = { "Ä", "Ö", "Ü", "ß" }
local cyrillic_chars = {
    "А", "Б", "В", "Г", "Д", "Е", "Ё", "Ж", "З", "И", "Й", "К", "Л", "М", "Н",
    "О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ъ", "Ы", "Ь",
    "Э", "Ю", "Я"
}
local greek_chars = {
    "Α", "Β", "Γ", "Δ", "Ε", "Ζ", "Η", "Θ", "Ι", "Κ", "Λ", "Μ", "Ν", "Ξ", "Ο",
    "Π", "Ρ", "Σ", "Τ", "Υ", "Φ", "Χ", "Ψ", "Ω"
}
local additional_chars = {
    "猫", "北", "东", "東", "南", "西", "站",
}

local characters = {}
local characters_sticker = {}

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

table.insert_all(characters, base_chars)
table.insert_all(characters, digits)
table.insert_all(characters, special_chars)
table.insert_all(characters, german_chars)
table.insert_all(characters, cyrillic_chars)
table.insert_all(characters, greek_chars)
table.insert_all(characters, additional_chars)

table.insert_all(characters_sticker, characters)
table.insert(characters_sticker, " ")

local create_alias = true

local rotate_simple = minetest.global_exists("screwdriver") and screwdriver.rotate_simple or nil

-- generate all available blocks
for _, name in ipairs(characters) do
    local desc = S("Ehlphabet Block '@1'", name)
    local byte = name:byte()
    local mb = is_multibyte(name)
    local file, key

    if mb then
        mb = byte
        byte = name:byte(2)
        key = "ehlphabet:" .. mb .. byte
        file = ("%03d_%03d"):format(mb, byte)
    else
        key = "ehlphabet:" .. byte
        file = ("%03d"):format(byte)
    end

    minetest.register_node(
        key,
        {
            description = desc,
            tiles = { "ehlphabet_" .. file .. ".png" },
            paramtype2 = "facedir",    -- neu
            on_rotate = rotate_simple, -- neu
            is_ground_content = false, --neu
            groups = { cracky = 3, not_in_creative_inventory = 1, not_in_crafting_guide = 1, ehlphabet_block = 1 }
        }
    )
    --    minetest.register_craft({type = "shapeless", output = "ehlphabet:block", recipe = {key}})

    if create_alias then
        minetest.register_alias("abjphabet:" .. name, key)
    end

    -- deactivate alias creation on last latin character
    if name == "Z" then
        create_alias = false
    end

    minetest.register_node(key .. "_sticker", {
        description = S("@1 Sticker", desc),
        tiles = { "ehlphabet_" .. file .. ".png",
            "ehlphabet_" .. file .. ".png^[transformR180" },
        inventory_image = "ehlphabet_" .. file .. ".png",
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
    }
    )
end

minetest.register_craft({ type = "shapeless", output = "ehlphabet:block", recipe = { "group:ehlphabet_block" } })

-- empty sticker
minetest.register_node("ehlphabet:32_sticker", {
    description = S("Blank Sticker"),
    tiles = { "ehlphabet_000.png" },
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
})

-- Materieals
local materieal_paper = xcompat.materials.paper
local materieal_coal = xcompat.materials.coal_lump
local materieal_stick = xcompat.materials.stick

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
        if not inv:is_empty("input") or not inv:is_empty("output") then
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
        meta:set_string(
            "formspec",
            "size[8,6]" ..
            "field[3.8,.5;1,1;lettername;" .. S("Letter") .. ";]" ..
            "list[current_name;input;2.5,0.2;1,1;]" ..
            "list[current_name;output;4.5,0.2;1,1;]" ..
            "list[current_player;main;0,2;8,4;]" ..
            "button[2.54,-0.25;3,4;name;" .. S("Blank -> Letter") .. "]"
        )
        local inv = meta:get_inventory()
        inv:set_size("input", 1)
        inv:set_size("output", 1)
    end,

    on_receive_fields = function(pos, _, fields, _)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local inputstack = inv:get_stack("input", 1)
        local outputstack = inv:get_stack("output", 1)
        local ch = fields.lettername

        if ch ~= nil and ch ~= "" then
            if inputstack:get_name() == "ehlphabet:block"
                or inputstack:get_name() == materieal_paper then
                local ost = outputstack:get_name()
                local mb = is_multibyte(ch)
                local key = mb and (ch:byte(1) .. ch:byte(2)) or ch:byte()
                key = key .. (inputstack:get_name() == materieal_paper and "_sticker" or "")
                if ost ~= "" and
                    ost ~= "ehlphabet:" .. key then
                    --  other type in output slot -> abort
                    return
                end
                local clist = characters
                if inputstack:get_name() == materieal_paper then
                    clist = characters_sticker
                end
                for _, v in pairs(clist) do
                    if v == ch then
                        inv:add_item("output", "ehlphabet:" .. key)
                        inputstack:take_item()
                        inv:set_stack("input", 1, inputstack)
                        break
                    end
                end
            end
        end
    end
}
)

--  Alias  (Och_Noe 20180124)
minetest.register_alias("abjphabet:machine", "ehlphabet:machine")
--

minetest.register_node("ehlphabet:block", {
    description = S("Ehlphabet Block (blank)"),
    tiles = { "ehlphabet_000.png" },
    groups = { cracky = 3 }
}
)

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
minetest.register_craft({
    output = "ehlphabet:231140 4",
    recipe = {
        { "",             "",             "" },
        { "ehlphabet:78", "",             "" },
        { "ehlphabet:69", "ehlphabet:75", "ehlphabet:79" }
    }
})

minetest.register_craft({
    output = "ehlphabet:229140 5",
    recipe = {
        { "ehlphabet:78", "ehlphabet:79", "ehlphabet:82" },
        { "ehlphabet:84", "ehlphabet:72", "" },
        { "",             "",             "" },
    }
})

minetest.register_craft({
    output = "ehlphabet:228184 5",
    recipe = {
        { "ehlphabet:69", "ehlphabet:65", "ehlphabet:83" },
        { "ehlphabet:84", "",             "ehlphabet:83" },
        { "",             "",             "" },
    }
})

minetest.register_craft({
    output = "ehlphabet:230157 5",
    recipe = {
        { "ehlphabet:69", "ehlphabet:65", "ehlphabet:83" },
        { "ehlphabet:84", "",             "ehlphabet:84" },
        { "",             "",             "" },
    }
})

minetest.register_craft({
    output = "ehlphabet:229141 5",
    recipe = {
        { "ehlphabet:83", "ehlphabet:79", "ehlphabet:85" },
        { "ehlphabet:84", "ehlphabet:72", "" },
        { "",             "",             "" },
    }
})

minetest.register_craft({
    output = "ehlphabet:232165 4",
    recipe = {
        { "ehlphabet:87", "ehlphabet:69", "ehlphabet:83" },
        { "ehlphabet:84", "",             "" },
        { "",             "",             "" },
    }
})

minetest.register_craft({
    output = "ehlphabet:231171 7",
    recipe = {
        { "ehlphabet:83", "ehlphabet:84", "ehlphabet:65" },
        { "ehlphabet:84", "ehlphabet:73", "ehlphabet:79" },
        { "ehlphabet:78", "",             "" },
    }
})

-- print("[MOD] Elphabet is loaded")
