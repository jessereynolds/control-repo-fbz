# cd4pe notes

[continuous delivery for puppet enterprise docs](https://puppet.com/docs/continuous-delivery/3.x/cd_user_guide.html)

## Installation

Using 1.4.1 of the puppetlabs-cd4pe module to build the CD4PE server works well. 

## Creating users

Anyone can create themselves an account, then be logged straight in, and able to create a workspace. This is surprising. No user validation required? Do we just assume all user auth happens via LDAP / SAML?

## Configuring the PE integration

Questions:

- Why does the module not automate the creation of the cd4pe PE user, role definition, etc? A la vra_puppet_plugin_prep would be nice. Worth adding to the official cd4pe module I think. 
- Has anyone else automated this with puppet code?


## Configuring the SCM integration

Docs issues

- is not clear that you need to do this within a workspace - the github etc integrations when you log in as root are just for OAuth auth
- granting access to all my organisations in github seems excessive (via the OAuth app)

## Adding job hardware - docker - puppet agent

I am trying to get my head around this note in the docs for adding docker job hardware:

  Note: Due to the fact that Continuous Delivery for PE job hardware nodes are classified as PE infrastructure nodes, the puppet_agent module cannot be used to successfully upgrade Puppet agents running on job hardware. To upgrade the Puppet agent on a job hardware node, use the agent upgrade script.

I have just assigned a node the Docker capability. I cannot discern the mechanism here. The docs say the node will be classified into the PE infrastructure nodes but this node is not showing as a member of “PE Infrastructure Agent” node group

## Viewing Nodes and Reports

Hmm the report link ’View in PE console” under inventory / nodes is a 404 on the PE console - reports URLs were /#/inspect/report/blahblah but are now /#/enforcement/report/blahblahsince 2019.7 I think … would be nice if we rewrote those URLs in PE’s nginx as they are common things to link to from change requests, tickets etc

## Understanding CD4PE Workflow

In the "Workflow phase 1: Developing changes" section - https://puppet.com/docs/continuous-delivery/3.x/working_with_cd4pe.html#developing_changes - there seems to be no place for deploying a feature branch while you are developing that branch, so that you can test your code on real machines before raising a PR to master. Further, docs advocate deleting the feature branch after the PR is merged into master, before there's any chance to test the code on a real machine. ... This conflicts with advice in the next section on the feature branch workflow. 

Deploying modules separately ... 

  Modularized content can be attached to a Puppetfile statically, such that the modularized content cannot be independently deployed or updated, or the content can be attached dynamically, so that **the modularized content can be deployed independent of the control repo** using a different Continuous Delivery for PE pipeline or deployment action.

Is the above just talking about `:control_branch` ? 

  Pipelines typically start automatically as soon as a new change has been merged to the master branch of a content repository.

Not when a PR is rasied to master? 

  Deployment pipelines typically deploy validated changes automatically up to some level lower than "production," but pause or wait for human approval before continuing to run and deploy to more sensitive, higher-tiered environments.

Good!

## Feature branch workflow

This is all very good but I object to using agent specified envirnonment for the following reasons:

- Only applies for a single puppet run. the next puppet run will go back to the previous state so you've got an unknown time window in which to test, unless you disable the puppet agent (and remember to enable it again afterwards). 
- Does not make visible to team mates that you are using a particular node to test your feature branch on. Someone else may do a run straight after you, from their feature branch, making it hard for you to test your changes. 

Why not have CD4PE create a temporary environment group to test the feature on? Then you can just add a node to it and do a run. Maybe CD4PE could put the node into the group too. When merged CD4PE can remove that feature environment node group and the node goes back to it's regular programming. 

...

So far there's been no mention of adding a control repo... 

## Create a regex branch pipeline

Docs say "In the Continuous Delivery for PE web UI, navigate to a control repo or module repo.
Click Add pipeline " however there is no button there 'Add pipeline'. There is only 'Add default pipeline'.  ... Oh, there is a tiny + button with no text near it. Probably would have tried that if the docs wording had't put me off. 

Not sure how to get auto-promote to work.

## Webhook  created on GitHub.com

Webhook cannot hit my internal CD4PE server. 

## Manual pipeline run

All tests pass first time, so the docker "job hardware" is working correctly. 

```
2020-07-02 11:13:41 UTC: Bolt command executed: bolt plan run cd4pe_deployments::cd4pe_job --configfile /disk/8648343270172819074/bolt.yaml --format json --transport pcp --params {"cd4pe_job_owner":"fbz","cd4pe_web_ui_endpoint":"http://pe-201814-agent.puppetdebug.vlan:8080/","job_instance_id":"2","targets":["pe-201814-agent-3.puppetdebug.vlan"],"docker_image":"puppet/puppet-dev-tools:latest"}
```

## Getting started docs - first pipeline execution

Gets you to set up the default pipeline. Says about this:

  When triggered by your commit, the pipeline automatically runs tests on your code, skips over the impact analysis stage that we haven't yet set up, and stops, as the pipeline is set up not to autopromote into the Deployment stage.

However, it doesn't skip over the impact analysis stage, it fails there. 


