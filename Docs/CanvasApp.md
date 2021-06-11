# Power Apps Canvas App

Purpose of this app is to foster teamwork by letting owners-to-be of Microsoft Teams teams make smarter decisions on how a team can work in Teams. Usually, a business consultant would talk a team through assets that are available in Teams and Microsoft 365 and answer all question with 'it depends'. They would explain that people usually 

* confuse chat with task assignment "could you please"
* confuse email with status reports "per my last email"
* confuse SharePoint with a dumpster for any file in the world "can you migrate this pile of mess to someone else's computer?"

and show them what channels are made for, how a team can work with metadata on files and how stying on track works with Microsoft Lists. The Business consultant would ask them if they wanted more learning material pinned to their brand new team and if they wanted the team of they dreams already be created for them, so that it works from Day 1. 

This is, what Provisiongenie does: 

## High level overview on what the Canvas App does

* Short upskilling nuggets in Pop Ups so that owner can make informed decisions on channels, metadata and tools to use
* Questionnaire to get information on 
  * Teams Name, Teams Description and logged in User to provision the Team itself
  * Channels 
  * SharePoint list columns to provision this SharePoint list
  * SharePoint library columns to provision this SharePoint library
  * if Owner additionally wants a SharePoint list for taskmanagement and a welcome package
* Patch 5 Dataverse tables with the information we got by user

## How do I get the app? 

* To get the entire solution as-is, please head over to our Deployment Guide
* To contribute to it, please see our [Contribution Guide](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/CONTRIBUTING.md)
* If you like to reverse-engineer it, please take this basic documentation as a first start. Please note, that this is not a full tutorial on how to rebuild the canvas app, but it should explain how things work on a high level. 
* You can also download the .msapp file from here and import this app into your environment - please note that this won't give you the full experience, as the entire process of provisioning does not run in this canvas app but in Azure Logic Apps flows which get triggered by new rows in different tables in Dataverse.

## Basic UI concepts

This app is designed to be a personal app in Microsoft Teams and we aimed to adopt the Teams look & feel by following the guidance available in the [Microsoft Teams UI Toolkit](https://docs.microsoft.com/en-us/microsoftteams/platform/concepts/design/design-teams-app-ui-templates?tabs=desktop). This means, that we will not explain all basic UI components in this document but refer to the Toolkit. 

### Colors

Set variables **onStart** for the colors you use the most- for example:

`Set(color_blurple,ColorValue("#6264A7"))` and 
`Set(color_bg,ColorValue("#F5F5F5"))`

This way, you can refer to these values - or change them, if needed, more easily.  

### Navigation

1. Create a `_selectedScreen` variable as a record containing 
* row (number)
* title (text)
* image (image) 
and create a `NavigationMenu` collection .onStart, wrap both in `Concurrent()`:

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

(To make this work replace the name of the images with the images you uploaded 💡

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
6. Set **Visible** of the rectangle to `ThisItem.Row = _selectedScreen.Row`
7. Set **Text** of the TextLabel to `ThisItem.Title`
8. Set **Image** of the Image to `ThisItem.Image`

> Keep in mind to always `Set(_selectedScreen,{Title: "your screenname", Row: <rownumber>})`in addition to `Navigate(your screenname)` if you want to let the user navigate to another screen not using the navigation gallery. 

### SidePanel

The SidePanel consists of 2 tabs, **Details** and **Resources** and we use 

* 2 Textlabels for the tab names
* 2 Rectangles as an underline for the tab names
* at least 2 **HTMLText** controls to display content depending on the tab
* 
This is how it works: 

* Set **HTMLText** of HTML text control to 
```
"
<div style='margin: 0 0 0 20px; font-size: 11pt !important; font-weight: lighter; color: #252525; padding: 0 10px; width: 100%; overflow: hidden;'>
   
  
    <div style=""float: left; width: 20px; text-align: right; margin: 0 20px 0 0; font-weight: bold;"" >*</div>
    <div style=""float: left; width: 75%; "">
        Step 1 <br><br>
    </div>
    <div style=""clear: both""></div>
  
    <div style=""float: left; width: 20px; text-align: right; margin: 0 20px 0 0; font-weight: bold;"" >*</div>
    <div style=""float: left; width: 75%; "">
      Step 2<br><br>
    </div>
    <div style=""clear: both""></div>
  
    <div style=""float: left; width: 20px; text-align: right; margin: 0 20px 0 0; font-weight: bold;"" >*</div>
    <div style=""float: left; width: 75%; "">
       Step 3<br><br>
    </div>
    <div style=""clear: both""></div>

    <div style=""float: left; width: 20px; text-align: right; margin: 0 20px 0 0; font-weight: bold;"" >*</div>
    <div style=""float: left; width: 75%; "">
       Step 4<br><br> 
    </div>
        <div style=""clear: both""></div>

    <div style=""float: left; width: 20px; text-align: right; margin: 0 20px 0 0; font-weight: bold;"" >*</div>
    <div style=""float: left; width: 75%; "">
        Step 5<br> 
    </div>
      <div style=""clear: both""></div>

    <div style=""float: left; width: 20px; text-align: right; margin: 0 20px 0 0; font-weight: bold;"" >*</div>
    <div style=""float: left; width: 75%; "">
       Step 6<br> 
    </div>

"
```
* Repeat with different text in the second HTML text control
* Set **OnSelect** of the `Details` Textlabel to `UpdateContext({IsShowResourcesTab: false})`
* Set **OnSelect** of the `Resources` Textlabel to `UpdateContext({IsShowResourcesTab:true})`
* Set **Visible** of the `Resources` HTMLText to `IsShowResourcesTab`
* Set **Visible** of the `Resources` Rectangle to `IsShowResourcesTab`
* Set **Visible** of the `Details` HTMLText to `!IsShowResourcesTab`
* Set **Visible** of the `Details` Rectangle to `!IsShowResourcesTab`
* Set **FontWeight** of `Details` textlabel to `If(!IsShowResourcesTab,FontWeight.Bold, FontWeight.Lighter)` 
* Set **FontWeight** of `Resources` textlabel to `If(IsShowResourcesTab,FontWeight.Bold, FontWeight.Lighter)`

This way, the content of `Resources` gets visible once the `Details` content is non-visible and vice versa. Also, user switches between the content by selecting the respecting textlabels. Font-weight will switch from `lighter` to `bold` and Rectangle (that serves as an underline) will be visible once user selects a Textlabel

### PopUp 

In the app, we make use of various PopUps, either to educate users about how to work in Microsoft Teams, or to explain something that users can request (like 'Welconme Package') or to indicate a success. Most PopUps contain 3 different pages, which means theat we need 3 times different content for them as well

Popups contain the following controls: 

* Textlabel that serves as a Title for this PopUp
* TextLabel that serves as the main content for this PopUp
* Rectangle that serves as a Dimmer
* Button that serves as background for the PopUp
* Circles that serves as Stepper Dots so users can select them to navigate back and forth of the pages
* Cancel icon to close the PopUp
* HTMLtext to create a shadow around the PopUp
* 2 Buttons for next/back
* Image
* Rectangle to prettify the PopUp

#### Rectangle for Dimmer

Purpose here is do create a lightbox effect and to dim everything but the PopUp itself. Following the Teams UI Toolkit: 

* Set **Fill** to `RGBA(37, 36, 35, 0.75)`
* Set size to the entire screen

#### Button that serves as background

As Rectangles in Power Apps don't support rounded corners (Border radius) we will use a Button instead. 

* Set **Width** to `600`
* Set **Height** to `480`
* Set **Color** to `White`
* Set **Hover color** to `White`
* Set **Pressed color** to `White`
* Set **Border radius** to `3`

#### Circles that serves as Stepper Dots 

* Create 3 circles
* Set their **Width** to 8
* Set their **Height** to 8
* Align them horizontally
* Set **OnSelect** of Circle1 to `UpdateContext({isPage:1})`
* Set **OnSelect** of Circle2 to `UpdateContext({isPage:2})`
* Set **OnSelect** of Circle3 to `UpdateContext({isPage:3})`
* Set **Fill** of Circle1 to `If(isPage=1,color_blurple,color_bg)`
* Set **Fill** of Circle2 to `If(isPage=2,color_blurple,color_bg)`
* Set **Fill** of Circle3 to `If(isPage=3,color_blurple,color_bg)`

This way, the circle is `color_blurple` on the correct page. 

#### Cancel icon to close the PopUp

* Place your Cancel icon at the upper right hand corner of the button
* Set **OnSelect** to `UpdateContext({isShowPopUp: false})`

#### HTMLtext to create a shadow around the PopUp

To have a nice shadow around the PopUp

* Create an HTMLtext control
* Set its **HTMLtext** to `"<div style='margin:10px;width:600px;height:480px;background-color:#;box-shadow:0 3px 6px 1px  #252525; border-radius:3px'></div>"`
* Rearrange controls so that the shadow is underneath the button

#### Next button

* Create a button
* Set colors as stated in Teams UI Toolkit if you like this to be design consistent to Teams, otherwise choose your own colors (preferably set them as variables)
* Set **OnSelect** to 
```
If(
    isPage= 1,
    UpdateContext({isPage: 2}),
    If(
        isPageTrack = 2,
        UpdateContext({isPage: 3}),
        UpdateContext({isShowPopUp: false})
    )
)
```
This way, users navigate to the next screen if they are on page 1 or 2 and close the PoPup if they are on page 3. 

* Set **Text** to `If(isPage=1,"yourtext-->2",If(isPage=2,"yourtext-->3","Close"))` This way, we display different texts depending on the page our user is currently at
* Set **Width** to `If(isPage=1,<value1>,If(isPage=2, <value2>,<value3>)` This way, the width of the button adjusts
* Set **X** to `If(isPage=1,<value1>,If(isPage=2, <value2>,<value3>)` to adjust horizontal position of the button. 

> To calculate this correctly, place the button by drag'n'drop where you want it. Now check the x-value, add the width to it. This is your target value. For the other pages, you will need to deduct the width of the button from that target value so you get the x-value of the button on that page. If you have more than 1 PopUp, it's worth to think about parameterizing this as well 

#### Back button

* Create a button
* Set colors as stated in Teams UI Toolkit if you like this to be design consistent to Teams, otherwise choose your own colors (preferably set them as variables)
* Set **OnSelect** to 
```
If(
    isPage = 1,
    UpdateContext({isPage: 3}),
    If(
        isPage = 3,
        UpdateContext({isPageConversations: 2}),
        UpdateContext({isPageConversations:1})
    )
)
```
This way, users navigate to the previous screen. 

#### Image

* Insert an image
* Set **Width** to `600`
* Set **Height** to `240`
* Set **Image** to `If(isPage=1,<image1>,If(isPage=2,<image2>,<image3>))`

You will notice, that due to the Border radius of the background button, the edges of the image don't look like 90° corners. This is why we will insert a rectangle to cover this

#### Rectangle

* Create a Rectangle
* Set its **Fill** to `White**
* Set **Width** to `600`
* Set **Height** to `17`
* Place it so it overlaps with the rounded corners

#### Label for the Title

Each page should have a title.

* Create a Textlabel
* Set its **Text** to `If(isPage=1,<yourTitle1>,If(isPage=2,<yourTitle2>,<yourTitle3>))`

#### Label for the main content

* Create a Textlabel
* Set its **Text** to `If(isPage=1,<yourContent1>,If(isPage=2,<yourContent2>,<yourContent>))`

To display this PopUp you will need to do the following steps: 

* group the controls
* Set **Visible** of the group to `isShowPopUp`
* trigger this PopUp - this could be another button, which **OnSelect** needs to be set to `UpdateContext({isShowPopUp: true})`

## Screens

Navigation and Sidepanel will be shown on every screen, only the HTMLtext in the SidePanel changes to contextually display details (how to use this screen) and resources (learning contentabout Teams).  In addition to that, we need the folloing controls: 

### Welcome Screen

We built

* 1 Welcome [PopUps](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/Docs/CanvasApp.md#popup) that is triggered by AppStart and introduces users on three pages what this app is about
* 4 different [PopUps](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/Docs/CanvasApp.md#popup) for the learning content
* 4 respecting Cards that serve as a more beautiful trigger for these PopUps
* 1 Button to navigate to the **Teams** screen and start the provisioning process
  * Set **OnSelect** of this Button to 

```
Navigate(
    'Teams Screen',
    ScreenTransition.Cover
);
Set(
    _selectedScreen,
    {
        Title: "Teams",
        Row: 2
    }
)
```

### Teams Screen

* Purpose if this screen is to get information about 
  * name
  * description
  * whether our owner (= signed-in user) wants a 'WelcomePackage' or not
  * whether our owner wants a SharePoint list provisioned for taskmanagement

We get the information by a form which is connected to a DataVerse table **Teams Requests** - see also Solution Overview

A few notes: 
* We modified the styling of the DataCards of the Form to match the criteria of Teams Toolkit. 
* For the yes/no question about the SharePoint list as a taskmanagement tool, we build another PopUp o explain this. For info on why we don't provision see Known limitations

The **Next** button's **OnSelect** is set to 
```
Navigate(
    'Channel Screen',
    ScreenTransition.Cover
);
Set(
    _selectedScreen,
    {
        Title: "Channels",
        Row: 3
    }
);
Set(
    TeamName,
    DataCardValue1_1.Text
);
Set(
    TeamsDescription,
    DataCardValue3_1.Text
);
Set(
    isWelcomePackage,
    Toggle1.Value
);
Set(
    isSharePointListTasks,
    Toggle1_1.Value
)

```
Which navigates to the next **Channels** screen, sets the Navigation correctly and saves the values in variables. Please note, that at this point we won't submit this form to the datasource.

### Channels Screen

On this screen, our owner-to-be can create the channels they want to be provisioned in their new Team. We work here with: 

* 1 TextInput to get a value
* a Button to add this value into a collection
* a Button to clear the collection
* a gallery to display the collection

#### add Button

* Set its **OnSelect** to 

```
  If(txtTagToAdd.Text in colChannels.ChannelName, 
    Notify(
        "You already added this Channel. Please try again with a different name.",
        NotificationType.Warning
    ),
    Collect(
        colChannels,{ChannelName:
        txtTagToAdd.Text
        });
        
    UpdateContext({locClearTextInput: true});
    UpdateContext({locClearTextInput: false})
); 
```

This way, we use the **Notify** function to warn our user in case they add a Channel name that already exists in collection. If the channel name does not exist already in the collection, we add it.Then we update a variable that controls the **Reset** property of the TextInput, so that its always empty again afetr we added a channelname to the collection. 
  
#### TextInput

Set **Reset** to `locClearTextInput`

#### clear Button

In case our user wants to start all over again, we give them a button to do so. 

Set **OnSelect** to 

```
Clear(colChannels);
UpdateContext({locClearTextInput: true});
UpdateContext({locClearTextInput: false})
```
which empties the collection and updates the variables that controls the **Reset** property of TexInput again. 

#### gallery

* Set **Items** to `colChannels`
* Set the **Text** of **Title** Textlabel in the gallery to `ThisItem.ChannelName`
* Change the default **Nextarrow* icon to a **Cancel** icon and set its **OnSelect** to  `RemoveIf(colChannels,ChannelName=ThisItem.ChannelName)`

This way, our user can review the list of channels and even remove some of them again.  


This neat solution is described in more detail on [Carmen Ysewijn's blog](https://digipersonal.com/2021/04/22/canvas-app-ui-element-tag-box-list/)

#### Next button

With this button we want to set a variable that concatenates the Channels to a single string with, separated by `, ` , navigate to the next screen and set our navigation correctly. To achieve this, set **OnSelect** to 
```
Set(
    varChannels,
    Concat(
        colChannels,
        ChannelName & ", "
    )
);
Navigate('Libraries Screen',Cover);
Set(
    _selectedScreen,
    {
        Title: "Libraries",
        Row: 4
    }
)

```


### Library Screen
### Lists Screen
### Checkout Screen

### Variables

### Collections
