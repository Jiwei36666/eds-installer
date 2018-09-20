# eds-installer

With this command tool, we can gererate the edgescale eds installer scrtipt, then we can install the edgescale agent into any linux OS.
Suppose the eds binary have installed in the folder /testdir/, execute below comand to generate the installer scrtipt.
```
# ./geninstaller.sh -r /testdir/ -o arm64_install
```
Once it is successfully, one installer scrtip arm64_install.sh will be generated in current folder.

Then install the agent into a new board:
```
# ./installername.sh
```

And also, we can clean the agent at any time.
```
# /etc/init.d/edgescale stop
# ./installername.sh clean
```

## Example 

```
./geninstaller.sh -h
 Command to generate edgescale eds agent installer.
    -r agent folder in rootfs folder(Eg: /)
    -o output file
```
Example:
```
root@testserver001:~/test# ./geninstaller.sh -r / -o testinstall
compress the agent binary :/
usr/local/bin/startup.sh
usr/local/bin/k8s.sh
usr/local/bin/mq-agent
usr/local/bin/env.sh
usr/local/bin/cert-agent
usr/local/bin/kubelet
etc/init.d/edgescale
etc/edgescale-version
etc/rc3.d/S09edgescale
etc/rc5.d/S09edgescale
eds.tgz is generated
generating installer :testinstall
testinstall.sh is generated
root@testserver001:~/test#
root@testserver001:~/test# ./testinstall.sh
Install files? y
Success to install edgescale client
root@testserver001:~/test#


```
