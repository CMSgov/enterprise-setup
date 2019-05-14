# Fargate Application Template

This infrastructure template is a reference infrastructure for defining an
application which is composed of one or more backing docker containers. This
template is only concerned with setting up common infrastructure used by
applications and leaves the actual service  creation and task definition
creation to an the application. This allows applications to be independently
modified and deployed to configured endpoint. This application template
supplies the following components:

- Frontend ALB for ingress traffic.
- Fargate Cluster

Clients may access the target groups and Fargate cluster by using resource
tags (application and stack)

![architecture](../../../docs/architecture.png)

## Not Included

Applications which service specific endpoints are responsible for creating
their Fargate/ECS services and deploying to those endpoints. Applications
should consume the target groups created here for application deployment.
In the architecture diagram, the 'Applicaiton Containers' are supplied by
these application modules.

## Requirements

Use of this template assumes the following:

- An account has been created.
- A bootstrap configuration has been initialized in this account (see [/bootstrap](/bootstrap/README.md))
- A VPC has been created and resources tagged for consumptions by this module.

## Usage

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| application | Descriptive name of this environment | no | testapp |
| stack | (dev,test,imp, prod) | yes | - |
| alb_cert | arn of the tls cert to apply to this listener | no | "" |

## Database Configuration

This template configures a Postgres RDS database (see rds.tf) for use by the
demo application. Connection parameters for RDS are stored as a `SecureString`
parameter in SSM. Prior to terraforming your app into creation, you should
setup the first 5 parameters listed below.

Parameters are resolved by looking for a parameter called
/APPLICATION-STACK/PARAMETER_NAME in the SSM param store
(ex: /testapp-dev/db_admin_user)

You can set parameters using the aws cli as described below:

`aws ssm put-parameter --name /APPLICATION-STACK/PARAM_NAME
--value VALUE --type SecureString --region us-west-2`

Example: `aws ssm put-parameter --name /testapp-dev/db_admin_user
--value adminuser --type SecureString --region us-west-2`

### Parameters

- rds_admin_user - admin user for the RDS instance.
- rds_admin_pass - admin password for the RDS instance.
- rds_app_user - Application user for container to connect as.
- rds_app_pass - Application password for container to use.
- rds_app_db - Name of postgres database for application to use, and terraform
  to create.
- rds_app_host - AUTO_CONFIGURED - RDS hostname for the new database service.
  Terraform will set this for you.