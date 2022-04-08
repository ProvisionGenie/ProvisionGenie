# Language Packs

ProvisionGenie has a multi-language feature, which means that it can run in different languages. So far we can provide a language pack for

* Danish
* Dutch
* English
* French
* Finnish
* German
* Italian
* Norwegian
* Polish
* Spanish
* Japanese

Admins can decide, if they want to let users use all of these languages or limit this list of supported languages to what makes sense to them. Users will then only see the limited list of languages to choose from.

## How does it work

In the Power Platform solution, there are 2 Dataverse tables that handle localization:

- Localizations

which can hold all texts in all supported languages that we provide

- Supported Languages

which can hold a list of languages that admins want to support.

These Dataverse tables don't have any rows in them, but provide you already with the schema that is needed to make multi-language work.

All rows of the languages that we support can be imported into Dataverse during Deployment process or even later with Excel files that we provide.

## What if you need an additional language?

If you want ProvisionGenie to work in a language that we currently do not support, we have two options to help you:

1. We provide you with an Excel file in which you can translate into your target language. After you imported the rows into the Localizations table and created a new row for that language in the Supported Languages table, ProvisionGenie can speak a new language. We would then ask you to share the translation back with us so that we can share it with the broader community
2. If you don't want to translate by yourself, you can submit this as a feature request - maybe another contributor likes to help here.

## Big thanks to all contributors

Translations were provided by native speakers - thanks to our amazing global community!

* Mattias Melkersen | [Mattias on GitHub](https://github.com/mmelkersen) | [Mattias on twitter](https://twitter.com/MMelkersen)
* Michaël Maillot | [Michaël on GitHub](https://github.com/michaelmaillot) | [Michaël on twitter](https://twitter.com/michael_maillot)
* Frank Boucher | [Frank on GitHub](https://github.com/FBoucher) | [Frank on twitter](https://twitter.com/fboucheros)
* Hadrien-Nessim Socard | [Hadrien-Nessim on GitHub](https://github.com/hadness) | [Hadrien-Nessim on twitter](https://twitter.com/h4dn355)
* Vesa Nopanen | [Vesa on GitHub](https://github.com/veskunopanen) | [Vesa on twitter](https://twitter.com/vesanopanen)
* Fabio Franzini | [Fabio on GitHub](https://github.com/fabiofranzini) | [Fabio on twitter](https://twitter.com/franzinifabio)
* Malin Martnes | [Malin on twitter](https://twitter.com/MalinMartnes)
* Tomasz Poszytek | [Tomasz on GitHub](https://github.com/tposzytek) | [Tomasz on twitter](https://twitter.com/TomaszPoszytek)
* Edyta Gorzon | [Edyta on twitter](https://twitter.com/EdytaGorzon)
* Bruno Capuano | [Bruno on GitHub](https://github.com/elbruno/) | [Bruno on twitter](https://twitter.com/elbruno)
* Simon Ågren | [Simon on GitHub](https://github.com/simonagren) | [Simon on twitter](https://twitter.com/agrenpoint)
* Viktor Hedberg | [Viktor on GitHub](https://github.com/hedbergtech) | [Viktor on twitter](https://twitter.com/headburgh)
* Tomomi Imura | [Tomomi on GitHub](https://github.com/girliemac) | [Tomomi on twitter](https://twitter.com/girlie_mac)

