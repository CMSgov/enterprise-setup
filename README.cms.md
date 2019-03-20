# CMS Installation Notes

The default CircleCI repository is setup to create only one installation. This doesn't
allow to to easily test across multiple environments, or manage multiple deployments.
In order to create a more seamless process we've made the following modifications to this
repository.

- Add bootstrap directories for each environment/account we're installing into.
- Modifications to circle CI's terraform.
  - Disable the public IP of of the services host.
  - Disable provider configuration, use parent environment, remove from variables.tf
  - Add outputs.tf to expose select id's of created resources.
- Create a cms module and env directories for each deployment.
  - Pull network and tag configuration from West pipelines.
  - Create LB and security group for services host.

## Approach

In order to allow upstream changes to easily be merged into this repository in the future
we are making as few as possible changes to the main circle terraform and instead wrapping
the existing configuration into a 'cms' module which supplies configuration to the circle
terraform and creates any additional CMS resources.

## Files

- /bootstrap/* - Terraform environment setup directories (CMS West Standard)
- /modules/cms - Main application module for customizing the Circle environment
- /envs/* - environment directories which consume the cms module.

## Bootstrapping

This follows the CMS West procedure for bootstrapping and environment. The
bootstrap/* directory contains terraform setup for creating buckets in all environments.

##
