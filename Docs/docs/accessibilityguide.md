# Accessibility Guide

We believe, that good software is for everyone and that mental and linguistic representation in media and applications should include everyone, which is why we chose to not have a white, male, english speaking person in mind as a default user of our app. We put in some thoughts on accessibility and inclusion - as we want ProvisionGenie to serve as many people as possible.

## Accessibility in UI

Accessibility is one of our core design principles, which is why we never choose something to just be pretty on the cost of not being accessible anymore.

We made some effort to

* support a highcontrast theme that blends into the UI of Microsoft Teams. This theme meets the requirements of WCAG 2.1 standard in terms of contrast ratio of text, images and surrounding background as well as font size.
* follow even more inclusive design good practices such as

    * using the  `AccessibleLabels` property for all controls
    * using `Role` property for headings
    * grouping content into containers
    * using the `Notify` function to interact with users
    * following a logical control order.

## Language and images

* All texts, including error messages and hint texts are localized in all 12 available languages.
* We also aim to use inclusive language, which is why we don't use male generic language.
* We use lots of pictures to illustrate and contextualize the learning content we provide. We made sure to choose illustrations that depict people with various skin colors and genders.
