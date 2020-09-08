#!/bin/bash

ssh -i ~/.ssh/breakfix1key.pem cloud-user@nodea.example.com sudo chcon -R -t httpd_log_t /var/log/httpd
ssh -i ~/.ssh/breakfix1key.pem cloud-user@nodeb.example.com sudo chcon -R -t httpd_log_t /var/log/httpd
ssh -i ~/.ssh/breakfix1key.pem cloud-user@nodec.example.com sudo chcon -R -t httpd_log_t /var/log/httpd
