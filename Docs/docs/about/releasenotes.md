# Release notes

![header image](../media/index/Genie_Header.png)

## v3.0.0

### Contains

* a Power Apps canvas app
* 8 Azure Logic Apps
* 8 Dataverse tables
* 2 security roles

### New features

* Allows users add guests to Teams
* Allows users add a OneNote notebook
* Supports 3 themes for Teams
  * default
  * dark mode
  * highcontrast mode
* localization support in 12 languages
  * Danish
  * Dutch
  * English
  * French
  * Finnish
  * German
  * Italian
  * Norwegian
  * Polish
  * Portuguese
  * Spanish
  * Japanese
* Allows users pin libraries and lists to channels

### Improvements

* Accessibility: Canvas app provides screenreader support
* UI: Popups and Cards in Canvas app are componentized
* Former Logic Apps to create lists and libraries are now consolidated

### Deployment

* Script reflects that additional permissions in SharePoint REST API are required to add the Notebook to a channel

### bug fixes

* countless

### Coffee needed for this release

* countless

### Contributors

#### Translations provided by native speakers

* Bruno Capuano | [Bruno on GitHub](https://github.com/elbruno/) | [Bruno on twitter](https://twitter.com/elbruno)
* Edyta Gorzon | [Edyta on twitter](https://twitter.com/EdytaGorzon)
* Fabio Franzini | [Fabio on GitHub](https://github.com/fabiofranzini) | [Fabio on twitter](https://twitter.com/franzinifabio)
* Frank Boucher | [Frank on GitHub](https://github.com/FBoucher) | [Frank on twitter](https://twitter.com/fboucheros)
* Hadrien-Nessim Socard | [Hadrien-Nessim on GitHub](https://github.com/hadness) | [Hadrien-Nessim on twitter](https://twitter.com/h4dn355)
* João Mendes | [João on twitter](https://twitter.com/joaojmendes) | [João Mendes on GitHub](https://github.com/joaojmendes/)
* Malin Martnes | [Malin on twitter](https://twitter.com/MalinMartnes)
* Mattias Melkersen | [Mattias on GitHub](https://github.com/mmelkersen) | [Mattias on twitter](https://twitter.com/MMelkersen)
* Michaël Maillot | [Michaël on GitHub](https://github.com/michaelmaillot) | [Michaël on twitter](https://twitter.com/michael_maillot)
* Simon Ågren | [Simon on GitHub](https://github.com/simonagren) | [Simon on twitter](https://twitter.com/agrenpoint)
* Tomasz Poszytek | [Tomasz on GitHub](https://github.com/tposzytek) | [Tomasz on twitter](https://twitter.com/TomaszPoszytek)
* Tomomi Imura | [Tomomi on GitHub](https://github.com/girliemac) | [Tomomi on twitter](https://twitter.com/girlie_mac)
* Vesa Nopanen | [Vesa on GitHub](https://github.com/veskunopanen) | [Vesa on twitter](https://twitter.com/vesanopanen)
* Viktor Hedberg | [Viktor on GitHub](https://github.com/hedbergtech) | [Viktor on twitter](https://twitter.com/headburgh)

#### More awesome contributors

* Dragan Panjikov | [Dragan on GitHub](https://github.com/panjkov) | [Dragan on twitter](https://twitter.com/panjkov)
* Gavin Barron | [Gavin on GitHub](https://github.com/gavinbarron) | [Gavin on twitter](https://twitter.com/gavinbarron)
* Lee Ford | [Lee on GitHub](https://github.com/leeford) | [Lee on twitter](https://twitter.com/lee_ford)
* Michael Roth | [Michael on GitHub](https://github.com/michaelroth42) | [Michael on twitter](https://twitter.com/MichaelRoth42)
* Yannick Reekmans | [Yannick on GitHub](https://github.com/YannickRe) | [Yannick on twitter](https://twitter.com/YannickReekmans)

## v2.0.0

### Contains

* a Power Apps canvas app
* 6 Azure Logic Apps
* 6 Dataverse tables
* 2 security roles

### New features

* Allows users add members and additional owners to a Team
* Allows users skip creation of channels, library, or list

### Improvements

* provides more in detail in app information on default columns in libraries and lists
* provides more up-to-date external learning resources
* enrichens user experience by better guidance and error handling

### Deployment

* App registration and deployment of all resources in Azure are now done with an idempotent, automated script

## Documentation

* lives now on a mkdocs site
* got its own logo

### Bug fixes

* solves an error message in Logic Apps regarding Managed Identity
* solves an issue in Logic Apps that let the CreateTeam flow fail
* several minor bug fixes in the Canvas App

## Contributors

This is an open-source initiative by [Luise Freese](https://twitter.com/LuiseFreese) and [Carmen Ysewijn](https://twitter.com/CarmenYsewijn) and we 💜 community contributions. This release is brought to you with the help of

(in alphabetical order by last name)

* [Gavin Barron](https://twitter.com/GavinBarron) - provided the amazing deployment script and didn't get tired of our improvement requests
* [Yannick Reekmans](https://twitter.com/YannickReekmans) - as our Chief debugging expert
* [Michael Roth](https://twitter.com/MichaelRoth42) - designed the ProvisionGenie logo for the new documentation

Note regarding versioning: Although we want to stick to [semantic versioning](https://semver.org/), we felt this update is **major** as it adds so much more capability which we wanted to reflect in the version number.

## v1.0.0

Minimum l💖vable product release of ProvisionGenie 🧞.

## Contains

* a Power Apps canvas app
* 5 Azure Logic Apps
* 5 Dataverse tables
* 2 security roles

## Features

* Allows users create a custom Microsoft Teams team including
  * channels
  * a library
  * a list
  * a tasklist and
  * a welcome package
