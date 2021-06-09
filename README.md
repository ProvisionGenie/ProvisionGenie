# ProvisionGenie

🚨 Watch out - this is still under construction 🚨

![under construction](https://github.com/LuiseFreese/ProvisionGenie/blob/main/media/undraw_under_construction_46pa.svg)

**Guidance & Provisioning for Microsoft Teams**

ProvisionGenie lets you learn how Microsoft Teams works in general and how you can make it for your team. As Teams is a platform that can connect to a lot of services, we want to make your start even easier. We will skill you up and guide you through some questions regarding how your Team should look like. As a result, you can request the 'Team of your dreams', which will be provisioned automatically for you.

The core components of this solution:

* Power Apps Canvas App 
* 5 DataVerse tables
* 5 Azure Logic Apps flows

## Power Apps Canvas App

### High level overview on what the Canvas App does: 
* Short upskilling nuggets in Pop Ups
* Questionnaire to get information on Teams Name, Teams Description and logged in User to provision the Team itself
* Questionnaire to get channel information to provision channels
* Questionnaire to get information on SharePoint list columns to provision this SharePoint list
* Questionnaire to get information on SharePoint library columns to provision this SharePoint library
* Questionnaire to get information if Owner additionally wants a SharePoint list for taskmanagement and a welcome package, which pins a customizeable website to Channel general for additional learning content
* Patch 5 Dataverse tables with the information we got by user

### Screens and their basic concepts:

##### Navigation
1. Create a `_selectedScreen` variable as a record containing row (number), title (text) and image (image) and create `NavigationMenu` collection .onStart, wrap both in `Concurrent()`:

``` Concurrent(
    Set(
        _selectedScreen,
        {
            Row: 1,
            Title: "Welcome",
            Image: ic_fluent_home_48_regular
        }
    ),
    ClearCollect(
        NavigationMenu,
        {
            Row: 1,
            Title: "Welcome",
            Image: ic_fluent_home_48_regular
        },
        {
            Row: 2,
            Title: "Teams",
            Image: ic_fluent_people_32_regular
        },
        {
            Row: 3,
            Title: "Channels",
            Image: ic_fluent_text_bullet_list_square_24_regular
        },
        {
            Row: 4,
            Title: "Libraries",
            Image: ic_fluent_document_48_regular
        },
        {
            Row: 5,
            Title: "Lists",
            Image: ic_fluent_clipboard_bullet_list_ltr_20_regular
        },
        {
            Row: 6,
            Title: "Checkout",
            Image: ic_fluent_checkbox_checked_24_regular
        }
    )
```

2. Create a gallery
with 
* Rectangle
* Textlabel
* Image

3. Set **Items** of the gallery to `NavigationMenu`
4. Set **TemplateFill** to `If(ThisItem.Row = _selectedScreen.Row, RGBA(220, 220, 220, 1), RGBA(0,0,0,0))`
5. Set **OnSelect** to 

```
Set(
    _selectedScreen,
    ThisItem
);
If(
    ThisItem.Row = 1,
    Navigate(
        'Welcome Screen',
        None
    ),
    ThisItem.Row = 2,
    Navigate(
        'Teams Screen',
        None
    ),
    ThisItem.Row = 3,
    Navigate(
        'Channel Screen',
        None
    ),
    ThisItem.Row = 4,
    Navigate(
        'Libraries Screen',
        None
    ),
    ThisItem.Row = 5,
    Navigate(
        'Lists Screen',
        None
    ),
    ThisItem.Row = 6,
    Navigate(
        'Checkout Screen',
        None
    )
)
```
7. Set **Visible** of the rectangle to `ThisItem.Row = _selectedScreen.Row`
8. Set **Text** of the TextLabel to `ThisItem.Title`
9. Set **Image** of the Image to `ThisItem.Image`

> keep in mind to always `Set(_selectedScreen,{Title: "your screenname", <rownumber>})` if you want to let the user navigate to another screen not using the navigation gallery. 



##### 
#### on all screens: 

##### Navigation

##### SidePanel
#### Welcome Screen

#### Teams Screen
#### Channels Screen
#### Library Screen
#### Lists Screen
#### Checkout Screen

### Variables

### Collections

## 5 DataVerse tables
//ToDo: describe relationships
## 5 Azure Logic Apps flows


* link to Deployment Guide
* link to Fact Sheet for Admins
* link to End User Quick Start Guide
* link to License

## Developers

![Carmen and Luise](https://github.com/LuiseFreese/ProvisionGenie/blob/main/media/Carmen_Luise.png)

This solution is an initiative by [Luise Freese](https://m365princess.com) and [Carmen Ysewijn](https://digipersonal.com/). 

## Contributions

We welcome contributions, we summarized how you can contribute in the [contribution guidelines](https://github.com/LuiseFreese/ProvisionGenie/blob/main/CONTRIBUTING.md). 

## Support us

💙 If you like this project, give it a ⭐ and share it with your friends!

![appreciation](https://github.com/LuiseFreese/ProvisionGenie/blob/main/media/undraw_Appreciation_re_p6rl.svg)

## Disclaimer

THIS CODE IS PROVIDED AS IS WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
