import schedule
import time
import os

def run_night_shift():
    print("⏰ Alarm ringing! Starting the batch prediction...")
    os.system("python3 batch_predict.py")

# Set the alarm! 
# Note: Google Cloud servers run on UTC time. 
# 02:00 UTC perfectly aligns with 7:30 AM IST for your morning coffee!
schedule.every().day.at("02:00").do(run_night_shift)

print("🕰️ Python Scheduler is now live and waiting for 2:00 AM UTC...")

# This loop keeps the script awake to check the time
while True:
    schedule.run_pending()
    time.sleep(60)
