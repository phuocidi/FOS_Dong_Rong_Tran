## Instruction

1. Run `pod install` if there is **new pod** in Podfile **ONLY**

### ONLY and ONLY run these steps below if there is a warning in terminal: 
+ `The target … overrides the `OTHER_LDFLAGS` build setting defined in `Pods/Pods.xcconfig`

2. Open FOS_Dong_Rong_Tran.xcworkspace. Sometimes there is error for bash file not found. **Ignore this, and procceed to step 3***
3. Click on FOS_Dong_Rong_Tran as targer project (not the Pods)
4. Go to your target Build Settings -> Other linker flags -> double click . Add **$(inherited)** to a new line

### ONLY and ONLY do step 2 to 4 if there is a warning when run `pod install`
### **DON'T** REMOVE Podfile.lock with your Podfile.lock. 
### **DON'T** ever run `pod update` no matter what warning pod give you
### **DON'T** ever check in **Podfile.lock** you did run `pod update` accidentally
### May the code be excecuted properly.
