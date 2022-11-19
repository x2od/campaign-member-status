# Campaign Type Member Statuses

This code was developed for Marketing Admins who want to enforce the Campaign Member Status options for Campaigns of certain types. It was originally written by Sercante LLC (https://github.com/sercante-llc/campaign-member-status).

> This application is designed to run on the Salesforce Platform

## Table of contents

- [Campaign Type Member Statuses](#campaign-type-member-statuses)
  - [Table of contents](#table-of-contents)
  - [What You Get](#what-you-get)
  - [Pushing Code to a Sandbox](#pushing-code-to-a-sandbox)
  - [Post-Install Configuration](#post-install-configuration)
  - [Installing into a Scratch Org](#installing-into-a-scratch-org)
  - [How it Works](#how-it-works)
    - [New Campaign Created](#new-campaign-created)
    - [Editing a Campaign Type Member Status](#editing-a-campaign-type-member-status)
    - [Removing a Campaign Type Member Status](#removing-a-campaign-type-member-status)
  - [FAQ](#faq)
    - [Why Don't you just prevent people from messing around with Protected Statuses?](#why-dont-you-just-prevent-people-from-messing-around-with-protected-statuses)
    - [I get Apex test errors after deploying the code. How can I fix them?](#i-get-apex-test-errors-after-deploying-the-code-how-can-i-fix-them)

## What You Get

When deploying this package to your org, you will get:

- 1 Custom Metadata Type (and page layout)
- 1 Campaign Custom Field
- 1 ChangeDataCapture configuration
- 2 Apex Triggers
- 5 Production Apex Classes
- 3 Apex Test Classes

## Pushing Code to a Sandbox

Follow this set of instructions if you want to deploy the solution into your org without using an Unlocked Package. This will require a Sandbox, and then a ChangeSet to deploy into Production.

1. If you know about and use `git`, clone this repository

   ```shell
   git clone https://github.com/dschach/campaign-member-status.git
   cd campaign-member-status
   ```

   **or**

   1. [Download a zip file](https://github.com/dschach/campaign-member-status/archive/main.zip)
   1. Extract the contents
   1. Navigate to the directory (sample commands below, though it may be different for you depending where you downlaod things)

   ```shell
   cd Downloads/campaign-member-status-main/campaign-member-status-main
   ```

   4. Verify you are in the same directory as the sfdx-project.json file

   ```shell
   # mac or Linux
   ls

   # windows
   dir
   ```

1. Setup your environment

   - [Install Salesforce CLI](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_install_cli.htm)

1. Authorize your Salesforce org and provide it with an alias (**myorg** in the commands below)

   ```shell
   # Connect SFDX to a Sandbox Org
   sfdx force:auth:web:login -s -a myorg -r https://test.salesforce.com

   # if for some reason you need to specify a specific URL, use this slightly altered command, making the correct adjustments
   sfdx force:auth:web:login -s -a myorg -r https://mycompanyloginurl.my.salesforce.com
   ```

1. Run this command in a terminal to deploy the reports and dashboards
   ```shell
   sfdx force:source:deploy -p "force-app/main/default" -u myorg
   ```
1. Continue with [Post-Install Configuration](#post-install-configuration)

## Post-Install Configuration

1. Once installed, create some Protected Statuses
   1. Log in to Salesforce Lightning, go to Setup
   1. Navigate to Custom Metadata Types, click Manage Records for Campaign Type Member Status
   1. To create your first ones, click New
   1. Fill in the various fields
      1. Label: Used in the List of Campaign Statuses in the Setup view in step 3 above. Recommended convention: TYPE-STATUS
      1. Name: This is an API name that can be used by developers. Not required by this package. Recommended: let this autofill after you type in the Label
      1. Campaign Type: This is the actual value for the Campaign's Type field.
      1. Protected Status: This is the Status value that will become protected
      1. Is Default: Select this if this Status should be the default (please pick only 1 per Type)
      1. Is Responded: Select this if this Status should be marked as Responded
   1. Click Save (or Save & New) and repeat a whole bunch
1. Create a scheduled job to restore deleted protected statuses
   1. Back in Setup, go to Apex Classes and click Schedule Apex
   1. Fill in the few fields
      1. Job Name: give this a nice descriptive name so you remember what it is in 3 months
      1. Apex Class: CampaignMemberStatusJob
      1. Frequency: set this to what works for you. We recommend running this daily during off-peak hours
      1. Start: today
      1. End: some time in the distant future
      1. Preferred Start Time: off peak hours

Once you have provided your statuses, you are good to go. Give it a whirl by creating a new Campaign with the Type that you have set up. Then take a look at the Statuses already created.

## Installing into a Scratch Org

1. Set up your environment. The steps include:

   - Enable Dev Hub in your org
   - [Install Salesforce CLI](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_install_cli.htm)

1. If you haven't already done so, authorize your hub org and provide it with an alias (**myhuborg** in the command below):

   ```shell
   sfdx force:auth:web:login -d -a myhuborg
   ```

1. If you know about and use `git`, clone this repository

   ```shell
   git clone https://github.com/dschach/campaign-member-status.git
   cd campaign-member-status
   ```

1. Run the included script to create a scratch org and push the metadata

   ```shell
   . scripts/scratchorg.sh
   ```

1. Continue with [Post-Install Configuration](#post-install-configuration)

## How it Works

Once everything is set up (above), Campaigns should maintain a consistent set of Campaign Member Statuses. Here's how we accomplish that.

### New Campaign Created

When a new Campaign is created, we check to see if the Type of Campaign is defined in any of the Protected Campaign Member Status records (the Custom Metadata Type that was set up earlier). If there is a match, the solution will:

1. Automatically add a checkbox to the Campaign Custom Field "Has Campaign Type Member Statuses".
1. Automatically adjust the CampaignMemberStatus records to match all Protected Campaign Member Statuses expected

### Editing a Campaign Type Member Status

For a Campaign that "Has Campaign Type Member Statuses", when one of the CampaignMemberStatus records is edited we will double check all statuses of that Campaign to make sure that all Protected ones still exist. If there are any missing, they will be recreated almost instantly (you may need to refresh the page for them to show up if there's a delay).

### Removing a Campaign Type Member Status

If a user removes a Campaign Type Member Status, the Scheduled Job (that was created as part of [Post-Install Configuration](#post-install-configuration)) will search for Campaigns missing a Status and recreate it.

## FAQ

### Why Don't you just prevent people from messing around with Protected Statuses?

We really wish we could. A "before update" and "before delete" Apex Trigger would be the simplest way to handle this. Unfortunately, Apex Triggers are not (yet) possible on CampaignMemberStatus records, so we end up having to fix it after-the-fact.

### I get Apex test errors after deploying the code. How can I fix them?

If you have Apex tests which set up a Campaign record as part of the test, the functionality in this package will get called and might blow up. This is because how Salesforce internally treats the automatic generation of Campaign Member Status records when a new Campaign is created (it's weird).

You have 2 options:

1. For the purpose of the test, disable this functionality. You can accomplish this by adding `TriggerHandler.bypass('CampaignTriggerHandler` in your Apex Test set up.
2. To actually see the records that Salesforce would create, you would need to have your test `@isTest(seeAllData=true)`. There are a lot of considerations with this approach, so please use wisely.
