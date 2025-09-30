-- chatlock/init.lua
-- Stable Chat Lock mod for Minetest (emoji-free)

local chat_locked = false

-- Always reset chat lock on restart (chat starts open)
minetest.register_on_mods_loaded(function()
    chat_locked = false
end)

-- Privilege for locking/unlocking
minetest.register_privilege("clo", {
    description = "Can chat when chat is locked / control chat lock",
    give_to_singleplayer = false,
})

-- Block messages if locked
minetest.register_on_chat_message(function(name, message)
    if chat_locked and not minetest.check_player_privs(name, {clo = true}) then
        minetest.chat_send_player(name, minetest.colorize("#FF0000", "Chat is currently locked!"))
        return true -- block message
    end
    return false -- allow normal chat
end)

-- Toggle chat lock
minetest.register_chatcommand("cl", {
    description = "Toggle chat lock (lock/unlock)",
    privs = {clo = true},
    func = function(name)
        chat_locked = not chat_locked
        if chat_locked then
            minetest.chat_send_all(minetest.colorize("#FF4444", "Chat has been LOCKED by " .. name))
        else
            minetest.chat_send_all(minetest.colorize("#44FF44", "Chat has been UNLOCKED by " .. name))
        end
        return true
    end,
})

-- Explicitly open chat
minetest.register_chatcommand("clopen", {
    description = "Force open chat (unlocks regardless)",
    privs = {clo = true},
    func = function(name)
        if not chat_locked then
            return true, "Chat is already unlocked."
        end
        chat_locked = false
        minetest.chat_send_all(minetest.colorize("#44FF44", "Chat has been FORCE-OPENED by " .. name))
        return true
    end,
})

-- Check chat status
minetest.register_chatcommand("clstatus", {
    description = "Check current chat lock status",
    func = function(name)
        if chat_locked then
            return true, "Chat is currently LOCKED."
        else
            return true, "Chat is currently UNLOCKED."
        end
    end,
})
