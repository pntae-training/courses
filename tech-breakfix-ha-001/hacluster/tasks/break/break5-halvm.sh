#!/bin/bash

ssh -i /home/cloud-user/.ssh/breakfix1key.pem cloud-user@nodea sudo lvmconf --enable-halvm --services --startstopservices
ssh -i /home/cloud-user/.ssh/breakfix1key.pem cloud-user@nodeb  sudo lvmconf --enable-halvm --services --startstopservices
ssh -i /home/cloud-user/.ssh/breakfix1key.pem cloud-user@nodea  dracut -H -f /boot/initramfs-`uname -r`.img `uname -r`
ssh -i /home/cloud-user/.ssh/breakfix1key.pem cloud-user@nodeb  sudo dracut -H -f /boot/initramfs-`uname -r`.img `uname -r`

