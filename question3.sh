#!/bin/bash

vpc_id=`aws ec2 create-vpc --cidr-block 10.0.3.0/28 | jq ".Vpc.VpcId"`
subnet_1_a=`aws ec2 create-subnet --vpc-id $vpc_id --availability-zone us-east-1a --cidr-block 10.0.3.0/28 | jq ".Subnet.SubnetId"`
subnet_2_a=`aws ec2 create-subnet --vpc-id $vpc_id --availability-zone us-east-1a --cidr-block 10.0.3.16/28 | jq ".Subnet.SubnetId"`
subnet_1_b=`aws ec2 create-subnet --vpc-id $vpc_id --availability-zone us-east-1b --cidr-block 10.0.3.32/28 | jq ".Subnet.SubnetId"`
subnet_2_b=`aws ec2 create-subnet --vpc-id $vpc_id --availability-zone us-east-1b --cidr-block 10.0.3.48/28 | jq ".Subnet.SubnetId"`
subnet_1_c=`aws ec2 create-subnet --vpc-id $vpc_id --availability-zone us-east-1c --cidr-block 10.0.3.64/28 | jq ".Subnet.SubnetId"`
subnet_2_c=`aws ec2 create-subnet --vpc-id $vpc_id --availability-zone us-east-1c --cidr-block 10.0.3.80/28 | jq ".Subnet.SubnetId"`
ig_id=`aws ec2 create-internet-gateway | jq ".InternetGateway.InternetGatewayId"`
aws ec2 attach-internet-gateway --internet-gateway-id $ig_id --vpc-id $vpc_id

routetable1_id=`aws ec2 create-route-table --vpc-id $vpc_id | jq ".RouteTable.RouteTableId"`
routetable2_id=`aws ec2 create-route-table --vpc-id $vpc_id | jq ".RouteTable.RouteTableId"`

aws ec2 create-route --route-table-id $routetable1_id --destination-cidr-block 0.0.0.0/0 --gateway-id $ig_id
aws ec2 associate-route-table --route-table-id $routetable1_id --subnet-id $subnet_1_a
aws ec2 associate-route-table --route-table-id $routetable1_id --subnet-id $subnet_1_b
aws ec2 associate-route-table --route-table-id $routetable1_id --subnet-id $subnet_1_c
aws ec2 associate-route-table --route-table-id $routetable2_id --subnet-id $subnet_2_a
aws ec2 associate-route-table --route-table-id $routetable2_id --subnet-id $subnet_2_b
aws ec2 associate-route-table --route-table-id $routetable2_id --subnet-id $subnet_2_c
