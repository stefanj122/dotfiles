import os, time

PID = os.popen("pgrep -fc test.py").read()
TID = os.popen("xinput list | grep -iPo 'touchpad.*id=\K\d+'").read()
i = 0
t = 0

if int(PID) >= 2:
    os.system("echo 'Alrady runing!'")
else:
    while True:
        res = os.popen("xinput | grep 'HyperX' | awk '{print $7}' | grep 'id' | cut -d '=' -f2").read()
        if os.popen("xinput list | grep -i hyperx").read() != '':
            if i <= 2:
                os.system("xinput disable {}".format(int(TID)))
                os.system("xinput set-prop '{}' 'libinput Accel Speed' 0.25".format(int(res)))
                os.system("xinput set-prop '{}' 'libinput Accel Profile Enabled' 0, 1".format(int(res)))
                if int(os.popen("pgrep -fc imwheel").read()) < 1:
                    os.system("imwheel -b 45")
                i+=1
                t=0
        else:
            if t < 2:
                os.system("xinput enable {}".format(int(TID)))
                os.system("pkill -f imwheel")
            t+=1
            i=0
        time.sleep(2.4)
#res1 = command.run(res)
#os.system("xinput set-prop '{}' 'libinput Accel Speed' 0.25".format(int(res)))
#print(int(res))

