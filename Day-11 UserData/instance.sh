#!/bin/bash

sudo su -
yum install httpd -y
systemctl start httpd
# systemctl status httpd  --> no need to check status while writing in userdata
systemctl enable httpd
echo "Practical of User-Data Through Terraform" > /var/www/html/index.html