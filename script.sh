#!/bin/bash
cd /root/project/lpic
git config user.email "javadevops.com@gmail.com"
git config user.name "Javad"
echo "Current Date and Time: $(date)" >> README.md
git add .
git commit -m "Automatic commit"
git remote add origin https://github.com/javadevops-com/lpic.git
git push -u origin main