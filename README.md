### AWS Application Load Balancer Module
-----------------
##### Introduction
As you already know, a load balancer serves as the single point of contact for clients. The load balancer distributes incoming application traffic across multiple targets, such as EC2 instances, in multiple Availability Zones. This increases the availability of your application. A listener checks for connection requests from clients, using the protocol and port that you configure. The rules that you define for a listener determine how the load balancer routes requests to its registered targets.
Hence, I created this module to simply the process so that it can be re-used as many times as I want.

##### Features

- Deploy AWS Application Load Balancer
- Deploy Security Group for Load Balancer
- Create two listners for handling HTTP & HTTPS request
- Load Certificate from Amazon Certificate Manager
- Automatically Adjust listner rules based on the choice of SSL installation.

This module can be imported into your terraform using the Github link. You'd need to pass values for the following variables when invoking this module:
* alb_switch: Whether or not to deploy ALB
* subnet_ids : ID's of the subnet that you would like to load balance
* vpc_id : ID of the VPC
* cert_arn : ARN of the SSL certificate
* cert_switch : Switch to enable/disable HTTPS listener.

Once, the module deploy the load balancer, the following values will be available as output
- Load Balancer ID
- Load Balancer DNS Name
- Target Group ARN

##### Future Updates
1. Enable Health-Check
2. Ability to add additional ports & listeners
3. Allocate weight to Target group routing

