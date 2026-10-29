# Roblox Checkpoint System (Centralized)

A robust and clean **Server Script** for Roblox that manages checkpoints centrally using a folder structure and custom attributes. 

## Features
- **Centralized Management:** Place all checkpoint parts inside a single folder (`Checkpoints`) in the Workspace. The script automatically indexes them.
- **Attribute-Driven:** Uses individual `CheckpointID` number attributes on each part for seamless stage progression.
- **Smart Respawn Handling:** Tracks player deaths via `Humanoid.Died` and instantly teleports them back to their highest reached checkpoint upon respawning.
- **Exploit & Safety Checks:** Validates players, characters, and handles cleanups safely on server-side.

## Setup & Installation

1. Open your place in **Roblox Studio**.
2. Create a **Folder** in the Workspace and name it `Checkpoints`.
3. Put your checkpoint Parts inside this folder. 
4. **Important Naming Rule:** Name each Part in the Explorer **only** with its number (e.g., name the first part exactly `1`, the second part `2`, the third part `3`, and so on). Do not use names like "Checkpoint 1" or "Part", otherwise the script will fail.
5. For each Part, open the **Properties** window, add an Attribute:
   - **Name:** `CheckpointID`
   - **Type:** `Number`
   - **Value:** `1`, `2`, `3`, etc. (matching the part's name).
6. Insert a standard **Script** (not a LocalScript) inside **ServerScriptService**.
7. Paste the code from `CheckpointManager.lua` into the script.

## License

This project is open-source and available under the [MIT License](LICENSE).
