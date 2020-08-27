#!/bin/bash
ssh nodea.example.com sudo chcon -R -t httpd_log_t /var/log/httpd
ssh nodeb.example.com sudo chcon -R -t httpd_log_t /var/log/httpd
ssh nodec.example.com sudo chcon -R -t httpd_log_t /var/log/httpd
