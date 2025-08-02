# SyncthingScripts

## Overview

This repository contains a collection of utilities and automation scripts for working with Syncthing. It will grow to include additional tools for monitoring, configuration, troubleshooting, and improving the experience of using Syncthing across devices.

This is ideal for users who want to automate Syncthing's bandwidth usage—limiting it during the day to preserve network performance, and removing the limit at night for faster syncing. The included scripts, scheduler tasks, and configuration tips aim to make setup easy and require minimal technical experience.

## Files

- `AddSpeedLimit.bat`: Applies an upload and download limit to Syncthing (default is 500 KiB/s each).
- `RemoveSpeedLimit.bat`: Removes all upload and download limits from Syncthing.

## Configuration

Each script defines a few variables at the top that must be configured before use:

- `API_KEY`: Your Syncthing API key (found under Settings → General in the Syncthing Web UI).
- `HOST`: Typically `http://127.0.0.1:8384`, which is Syncthing's default local API endpoint.
- `RATE_IN`: Download speed limit in KiB/s (only in `AddSpeedLimit.bat`)
- `RATE_OUT`: Upload speed limit in KiB/s (only in `AddSpeedLimit.bat`)

### Unit Conversion Reference

All bandwidth limits are specified in **KiB/s** (kibibytes per second). Here’s how that compares to other units:

| Unit      | Equivalent in KiB/s | Notes                        |
|-----------|---------------------|------------------------------|
| 1 KiB/s   | 1                   | Kibibyte per second          |
| 1 MiB/s   | 1024                | 1 MiB = 1024 KiB             |
| 1 Mbps    | ~122.07             | 1 megabit = ~0.122 MiB = ~122 KiB |
| 10 Mbps   | ~1220.7             |                              |
| 40 Mbps   | ~4882.8             |                              |

To convert Mbps to KiB/s: `Mbps × 1024 ÷ 8 = KiB/s`

## Usage

This repository contains tools tailored for Windows-based Syncthing setups. See below for complete setup instructions on that platform. Additional cross-platform tools may be added in the future.

## Windows Setup

1. Replace `REPLACE_WITH_YOUR_API_KEY` in both `.bat` files with your actual Syncthing API key.
2. Optionally adjust `RATE_IN` and `RATE_OUT` to match your preferred bandwidth caps.
3. Schedule each script using Windows Task Scheduler:

   - **AddSpeedLimit.bat** → Trigger daily at 8:00 AM
   - **RemoveSpeedLimit.bat** → Trigger daily at 10:00 PM

4. (Optional) Use the provided `.xml` Task Scheduler files to automatically configure scheduled execution:

   - `AddSpeedLimit.xml` → Can be imported into Windows Task Scheduler to apply limits at 8:00 AM daily.
   - `RemoveSpeedLimit.xml` → (to be added) will remove limits at 10:00 PM daily.

   To use:
   - Open **Task Scheduler**
   - Click **Import Task…**
   - Select the corresponding XML file
   - Confirm and save — it will create a pre-configured task that runs daily

5. (Recommended) Run `SetupTasks.bat` as Administrator to automatically import both Task Scheduler jobs. This script sets up the Add and Remove speed limit tasks without requiring any manual interaction with Task Scheduler. You’ll see a confirmation message if it succeeds.

## Example

A setup using the default configuration will:

- Limit Syncthing to 500 KiB/s upload/download during the day (8 AM–10 PM)
- Remove limits at night (10 PM–8 AM) for full-speed sync

These scripts are useful when sharing files over Syncthing with limited daytime bandwidth or to avoid saturating the network during work hours.