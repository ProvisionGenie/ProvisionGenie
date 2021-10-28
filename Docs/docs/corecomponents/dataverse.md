# Dataverse

![header image](../media/index/Genie_Header.png)

We chose Dataverse as our storage for all requests and created five tables:

1. We log all requests in the **TeamsRequest** table, these are the most important columns:

- TeamName
- TeamDescription
- TeamOwner
- includeTaskList
- includeWelcomePackage

2. Each Team can have multiple channels, which we log in the **TeamsChannel** table, these are the most important columns:

- Channelname
- ChannelDescription
- Teamsrequest (to link to the correct Team)

3. Each Team can also have a list and a library, we log them in the **SharePointLibrary** and **SharePointLIst** tables, these are the most important columns:

- LibraryName / ListName
- Teamsrequest (to link to the correct Team)

4. Each List/Library can contain columns, we log them in the **ListColumns** table, these are the most important columns:

- ColumnName
- ColumnType
- ColumnValues (for ColumnType `Choice`)

- ![Dataverse-datamodel](../media/corecomponents/dataverse-datamodel.png)
