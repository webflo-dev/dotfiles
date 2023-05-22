#!/usr/bin/env bash

# vant.conf is located here: /etc/vanta.conf

sudo systemctl enable vanta-agent.service
sudo systemctl start vanta-agent.service

/var/vanta/vanta-cli status

sudo /var/vanta/vanta-cli reset
sudo /var/vanta/vanta-cli doctor
