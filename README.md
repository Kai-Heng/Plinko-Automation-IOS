# **Plinko Automation iOS**

## **Overview**
Plinko Automation iOS is a script designed to automate betting on the Plinko game on **Stake** using a **Fibonacci-based** and **brainless** betting strategy. The automation interacts with the **web elements** of the game, places bets dynamically, and manages bet amounts based on **loss streaks** or **continuous betting** (brainless mode). It also adjusts the bet amount according to the **active currency** (Gold or Sweeps) and stops once the **target balance** is reached.

## **Features**
✅ **Automated Betting:** Places bets continuously using either **Fibonacci betting strategy** or **brainless mode**.  
✅ **Brainless Mode:** When enabled, places the same small bet repeatedly without tracking previous results.  
✅ **Loss Tracking:** Increases the bet amount after consecutive losses in Fibonacci mode.  
✅ **Currency Detection:** Adjusts bet values based on active currency (**Gold or Sweeps**).  
✅ **Balance Management:** Prevents over-betting by capping bets at **50% of the balance**.  
✅ **Start/Stop Controls:** Provides commands to **start, pause, resume, and stop** the automation.  
✅ **Target Balance Setting:** Allows defining a stopping point when a certain balance is reached.  
✅ **Haptic Feedback:** Provides **tactile feedback** when pressing any control buttons.  
✅ **Dark Theme & Robotic UI Design:** Improved visuals with futuristic UI enhancements.  
✅ **Background Execution:** Keeps the app running in the background using a **silent audio trick**.  

---

## **How to Use**
### **1. Launch the App**
- Open the **Plinko Automation iOS** app.
- Wait for the **splash screen** (2 seconds), the WebView will load the Stake Plinko page simultaneuosly.

### **2. Start Betting**
- Press the **Start** button to begin **automated betting**.

### **3. Toggle Brainless Mode**
- Enable **Brainless Mode** to place **constant small bets** instead of Fibonacci betting.

### **4. Pause & Resume Automation**
- Press **Pause** to stop temporarily.
- Press **Resume** to continue betting.

### **5. Stop the Automation**
- Press **Stop** to completely stop the bot.

### **6. Set Target Balance**
- Enter a **target balance** in the text field and press **Set** to define a stopping point.

---

## **Configuration**
### **Currency Handling**
- **Gold Currency:** Minimum bet = **0.11**.
- **Sweeps Currency:** Minimum bet = **0.01**.
- The script **automatically detects** the active currency and adjusts bets accordingly.

### **Betting Strategies**
#### **Fibonacci Betting Mode (Default)**
1. Starts with a **base bet** of **0.0001**.
2. If the bot encounters **7 consecutive losses**, it switches to a **Fibonacci progression** to recover losses.
3. Once a **win is detected**, the bet resets to the **minimum value**.

#### **Brainless Mode**
- When enabled, the bot **ignores wins/losses** and **spams** the same small bet **non-stop**.

---

## **Dependencies**
- **WebKit (WKWebView)** for injecting JavaScript.
- **Stake website compatibility** (Selectors may need updates if the site's structure changes).
- **AVFoundation** for **silent audio trick** to enable background execution.
- **UIKit** for **Haptic Touch Feedback**.

---

## **Troubleshooting**
❌ **WebView not loading?**  
✔ Ensure that JavaScript execution is **enabled** in WebView.  

❌ **Bets are not being placed?**  
✔ Confirm that the **game selectors** match the **latest Stake website structure**.  

❌ **Incorrect bet amount?**  
✔ Check if the bot is correctly detecting **Gold or Sweeps currency**.  

❌ **Automation stops suddenly?**  
✔ Verify that the **target balance** is not reached.  

---

## **Disclaimer**
🚨 **This software is for educational and research purposes only.**  
📌 **Use at your own risk.** The authors are **not responsible** for any losses incurred while using this automation tool.  

---
