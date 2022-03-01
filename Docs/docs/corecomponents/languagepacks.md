# Language Packs

ProvisionGenie has a multi-language feature, which means that it can run in different languages. So far we can provide a language pack for

- english
- german
- dutch
- french
- spanish
- swedish
- finnish

Admins can decide, if they want to let users use all of these languages or limit this list of supported languages to what makes sense to them. Users will then only see the limited list of languages to choose from.

## How does it work

In the Power Platform solution, there are 2 Dataverse tables that handle localization:

- localizations

which can hold all texts in all supported languages that we provide

- Supported Languages

which can hold a list of languages that admins want to support.

These Dataverse tables don't have any rows in them, but provide you already with the schema that is needed to make multi-language work.

All rows of the languages that we support can be imported into Dataverse during Deployment process or even later with Excel files that we provide.

## What if you need an additional language?

If you want ProvisionGenie to work in a language that we currently not support, we have two options to help you:

1. We provide you with an Excel file in which you can translate into your target language. After you imported the rows into thhe localizations table and created a new row for that language in the Supported Languages table, ProvisionGenie can speak a new language. We would then ask you to share the translation back with us so that we can share it with the broader community
2. If you don't want to translate by yourself, you can submit this as a feature request - maybe another contributor likes to help here.

## Big thanks to all contributors

Translations were provided by native speakers - thanks to our amazing global community!

Head over to GitHub to see all credits.