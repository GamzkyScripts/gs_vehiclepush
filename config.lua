Config = {
    -- More information on keys: https://docs.fivem.net/docs/game-references/controls/#controls
    pushKeyPrimary = { index = 21, label = 'SHIFT' },
    pushKeySecondary = { index = 38, label = 'E' },

    pushLabel = 'Push',

    -- The maximum engine health a vehicle can have before they are not pushable anymore. Set to 1000 to allow pushing regardless of engine health.
    engineHealth = 100.0,

    animation = {
        dict = 'missfinale_c2ig_11',
        anim = 'pushcar_offcliff_m',
    },

    disabledClasses = {
        [13] = true, -- Cycles
        [14] = true, -- Boats
        [15] = true, -- Helicopters
        [16] = true, -- Planes
        [21] = true, -- Trains
    },

    -- Disabled controls while pushing a vehicle
    disabledControls = {
        22,  -- Space
        23,  -- F
        24,  -- LMB
        73,  -- X
        140, -- R
        141, -- Q
    },
}
