# Release notes

![header image](../media/index/Genie_Header.png)

## v2.0.0

**Contains** 

* a Power Apps canvas app
* 6 Azure Logic Apps
* 6 Dataverse tables
* 2 security roles

**New features**

* lets users add members and additional owners to a Team
* lets users skip creation of channels, library, or list

**Deployment**

* App registration and deployment of all resources in Azure are now done with an idempotent, automated script

**Documentation**

* lives now on a mkdocs site
* got its own logo

**Bug fixes**

* solves an error message in Logic Apps regarding Managed Identity
* several minor bug fixes in the Canvas App

**Contributors**

This is an open-source initiative by [Luise Freese](https://twitter.com/LuiseFreese) and [Carmen Ysewijn](https://twitter.com/CarmenYsewijn) and we 💜 community contributions. This release is brought to you with the help of

(in alphabetical order by last name)

* [Gavin Barron](https://twitter.com/GavinBarron) - provided the amazing deployment script and didn't get tired of our improvement requests
* [Yannick Reekmans](https://twitter.com/YannickReekmans) - as our Chief debugging expert
* [Michael Roth](https://twitter.com/MichaelRoth42) - designed the ProvisionGenie logo for the new documentation

Note regarding versioning: Although we try to stick to [semantic versioning](https://semver.org/), we felt this update is **major** as it adds so much more capability which we wanted to reflect in the version number. 

## v1.0.0
Minimum l💖vable product release of ProvisionGenie 🧞.

**Contains:**

* a Power Apps canvas app
* 5 Azure Logic Apps
* 5 Dataverse tables
* 2 security roles

**Features:**

* lets users create a custom Microsoft Teams team including
  * channels
  * a library
  * a list
  * a tasklist and
  * a welcome package
