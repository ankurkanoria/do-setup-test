#!/bin/bash
yum -y install git
git clone https://github.com/ankurkanoria/do-setup-test.git /opt/setup-scripts
source /opt/setup-scripts/init.sh