# Plinko Automation iOS

## Overview
Plinko Automation iOS is a script designed to automate betting on the Plinko game on Stake using a Fibonacci-based betting strategy. The automation interacts with the web elements of the game, places bets dynamically, and manages bet amounts based on loss streaks. It also adjusts the bet amount according to the active currency (Gold or Sweeps) and stops once the target balance is reached.

## Features
- **Automated Betting**: Places bets continuously using a Fibonacci betting strategy.
- **Loss Tracking**: Increases bet amount after consecutive losses.
- **Currency Detection**: Adjusts bet values based on active currency (Gold or Sweeps).
- **Balance Management**: Prevents over-betting by capping bets at 50% of the balance.
- **Start/Stop Controls**: Provides commands to start, pause, resume, and stop the automation.
- **Logging**: Displays real-time logs of bets and automation status in the console.

## How to Use
### 1. Inject the Script (Automatic Loaded)
Load the script inside a WebView on iOS using Swift's `evaluateJavaScript()` method.

### 2. Start Betting
To start the bot:
Press **Start** button

### 3. Pause Automation
To temporarily pause betting:
Press **Pause** button


### 4. Resume Automation
To resume betting after a pause:
Press **Resume** button


### 5. Stop the Automation
To completely stop the bot:
Press **Stop** button


### 6. Set Target Balance
To define a stopping point when a certain balance is reached:
Set target balance in the text field

## Configuration
### Currency Handling
- If the **active currency is Gold**, the minimum bet is **0.11**.
- If the **active currency is Sweeps**, the minimum bet is **0.01**.
- The script automatically detects the current currency and adjusts bets accordingly.

### Betting Strategy
- The script starts with a base bet of **0.0001**.
- If the bot encounters a **loss streak** of 7 bets, it switches to a **Fibonacci progression** to recover losses.
- Once a win is detected, the bet resets to the minimum value.

## Dependencies
- WebKit (WKWebView) for injecting JavaScript
- Stake website compatibility

## Troubleshooting
- Ensure that the WebView has JavaScript execution enabled.
- Make sure the selectors for the game elements match the current Stake website structure.
- If bets are not being placed, confirm that the currency is correctly detected.
- If encountering `JavaScript exception occurred`, check the console logs for missing elements or incorrect selectors.

## Disclaimer
This software is for educational and research purposes only. Use it at your own risk. The authors are not responsible for any losses incurred while using this automation tool.

