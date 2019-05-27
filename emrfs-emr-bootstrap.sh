#!/usr/bin/env bash

echo "Installing Python libraries..."
sudo pip install boto3
sudo pip install pandas
sudo pip install numpy
sudo pip install pyarrow
echo "Upgrading AWS CLI..."
sudo yum upgrade aws-cli -y
echo "Updating distro..."
sudo yum update -y