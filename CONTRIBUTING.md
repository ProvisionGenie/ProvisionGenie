# Contributing Guidance

If you'd like to contribute to ProvisionGenie, read the following guidelines. We want to make sure that everyone gets the most out of their efforts.

## Code of Conduct

This project has adopted the [Contributor Covenant Code of Conduct](https://github.com/ProvisionGenie/ProvisionGenie/blob/main/CODE_OF_CONDUCT.md).
For more information, see the [Contributor Covenant](https://www.contributor-covenant.org/).

## Question or Problem?

Please use proper issues for bug reports, documentation fix, feature requests and general feedback. This way we can more easily track actual bugs from the code and help get things fixed.

If you have general questions about Power Apps, Azure Logic Apps, Microsoft identity platform, Microsoft Graph and more, feel also free to use following channels for having an open discussion with the community and engineering.

- [Microsoft 365 PnP Community](https://techcommunity.microsoft.com/t5/microsoft-365-pnp-blog/bg-p/Microsoft365PnPBlog) at [techcommunity.microsoft.com](https://techcommunity.microsoft.com)

## Hacktoberfest

we want to celebrate [Hacktoberfest](https://hacktoberfest.digitalocean.com/) with you! This repository participates and submitting your PR counts!

## Typos, Issues, Bugs and contributions

Please follow these recommendations.

- Always fork repository to your own account for applying modifications
- Do not combine multiple changes to one PR, please submit for example any samples and documentation updates using separate PRs
- If you are submitting typo or documentation fix, you can combine modifications to single PR where suitable

## Submitting changes as pull requests

Here's a high level process for submitting new samples or updates to existing ones.

1. Fork the main repository to your GitHub account
2. Include your changes to your branch
3. Commit your changes using descriptive commit message - These are used to track changes on the repositories for bi-weekly communications, please don't be this person:

![XKCD GIT COMMIT](https://imgs.xkcd.com/comics/git_commit.png)

(image by xkcd, can be found at [https://xkcd.com/1296/](https://xkcd.com/1296/))

4. Create a pull request in your own fork and target 'main' branch
5. Fill up the provided PR template with the requested details

> note. Delete the feature specific branch only AFTER your PR has been processed.

## Documentation
ProvisionGenie uses [MkDocs](https://www.mkdocs.org/]) to publish documentation pages. For simplicity, we recommend using the MkDocs Material Docker container which contains all dependencies installed.

### Preview docs using the Docker container
If you're using Visual Studio Code and have the [Docker extension](https://code.visualstudio.com/docs/containers/overview) installed, you can run preview the docs using the container either by executing the `Run docs container` task, or, if you have pulled the image previously, from the **Images** pane by running the MkDocs container interactively. This article explains [working with Docker containers using VSCode](https://blog.mastykarz.nl/docker-containers-visual-studio-code-extension/) in more detail.

Alternatively, you can run the container in command-line:

- on macOS / WSL2:
  - run `cd ./Docs` to change directory to where the docs are stored
  - run `docker run --rm -it -p 8000:8000 -v ${PWD}:/docs squidfunk/mkdocs-material:7.3.4` to start the local web server with MkDocs and view the documentation in the web browser
- on Windows:
  - run `docker run --rm -it -p 8000:8000 -v c:/projects/provisiongenie/docs:/docs squidfunk/mkdocs-material:7.3.4` to start the local web server with MkDocs and view the documentation in the web browser

### Preview docs using MkDocs installed on your machine.
If you want, you can also install MkDocs on your machine. See more information about installing MkDocs on your operating system at http://www.mkdocs.org/#installation. ProvisionGenie documentation uses the mkdocs-material theme. See more information about installing mkdocs-material on your operating system at https://squidfunk.github.io/mkdocs-material.

Once you have MkDocs installed on your machine, in the command line:

- run `cd ./Docs` to change directory to where the docs are stored
- run `mkdocs serve` to start the local web server with MkDocs and view the documentation in the web browser

## Step-by-step guidance to contribute to open source projects

In case you find all of this confusing but still like to contribute, there is help! The [Sharing is Caring](https://pnp.github.io/sharing-is-caring/) initiative of [Microsoft 365 PnP Community](https://aka.ms/m365pnp) is offering hands-on guidance in free sessions. Feel free to check them out!

💖
