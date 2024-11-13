# Vehicle Push Script

#### ⭐ Check out our other resources on [gamzkystore.com](https://gamzkystore.com/) or in our [Discord](https://discord.com/invite/sjFP3HrWc3).

#### 📼 Preview video: [Streamable](https://streamable.com/cg6535)

This vehicle push script allows players to push vehicles in the game, useful when they are undrivable or stuck.

## Features
-   Framework indepenent. So it works for any framework like ESX, QBCore, etc.
-   Vehicles can only be pushed if their engine health is below a certain threshold (Configurable).
-   Configurable controls: Primary push key (SHIFT) and secondary push key (E) can be adjusted in the `config.lua`.
-   Prevents pushing of vehicle types that are unrealistic to push, such as boats, helicopters, planes, and trains, specified in `config.lua`.
-   Animation support: Players perform a realistic animation when pushing vehicles.
-   Configurable disabled controls while pushing, ensuring players can't perform other actions like firing a weapon or jumping.
-   Optionally enable interactions with ox_target (or any other targeting script, but you'll have to add it yourself).

#### Dependencies
- The only dependency is [ox_lib](https://github.com/overextended/ox_lib).
- If you want to use the targeting feature, you'll need to add [ox_target](https://github.com/overextended/ox_target) to your server.
