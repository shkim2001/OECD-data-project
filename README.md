---
## Stat 220, Final Project
---
*By Sunny Kim, Joshua Song*

### Abstract

For our final project, we looked at the dataset that contains the OECD countries’ suicide and fertility rate and create an interactive graph/shiny app for the data. According to the official Organization for Economic Co-operation and Development website, the definition of suicide rate and fertility rate are the following:

* **Suicide rate** : Deaths deliberately initiated and performed by a person in the full knowledge or expectation of its fatal outcome.

* **Fertility rate** : Total number of children that would be born to each woman if she were to live to the end of her child-bearing years and give birth to children in alignment with the prevailing age-specific fertility rates.

With these two datasets, we aim to find out whether continent relate to suicide rate and fertility rate of OECD countries.

_________________

### data

Folder that includes the datasets we are using for our shiny application.

**OECD suicide rate**\
https://data.oecd.org/healthstat/suicide-rates.htm \
Citation : OECD (2023), Suicide rates (indicator). doi: 10.1787/a82f3459-en (Accessed on 02 March 2023)

**OECD fertility rate**\
https://data.oecd.org/pop/fertility-rates.htm \
Citation : OECD (2023), Fertility rates (indicator). doi: 10.1787/8272fb01-en (Accessed on 02 March 2023)

Data Source: Organization for Economic Co-operation and Development Website

_________________

### Research Questions

* How does suicide rate relate to the continent of the OECD countries? 
* How does fertility rate relate to the continent of the OECD countries?
_________________

### app.R

File that contains information about UI, server, and data modifications for our shiny application

The app includes the following:
* **About** : The main page of the website has information about the website and each tab.
* **Dataset** : Explains the definition of suicide rate and fertility rate and the source of data.
* **Suicide Rate** : The tab is divided into two sub-tabs:
    * View By Continent: The user will be seeing an interactive ggplotly graph that has “Year” on the horizontal axis, “Value” on the vertical axis, and the suicide rate data of countries located in each selected continent as a line graph.
    * View By Country: The user will be seeing an interactive ggplotly graph that has “Year” on the horizontal axis, “Value” on the vertical axis, and the suicide rate data for all countries as a pale gray colored line graph. On the same graph, the suicide rate fata for the country that the user selected will be the only line shown in color, which allows the users to understand where the selected country is among other OECD countries in terms of suicide rate.
* **Fertility Rate** : The tab is divided into two sub-tabs:
    * View By Continent: The user will be seeing an interactive ggplotly graph that has “Year” on the horizontal axis, “Value” on the vertical axis, and the fertility rate data of countries located in each selected continent as a line graph. 
    * View By Country: The user will be seeing an interactive ggplotly graph that has “Year” on the horizontal axis, “Value” on the vertical axis, and the fertility rate data for all countries as a pale gray colored line graph. On the same graph, the fertility rate data for the country that the user selected will be the only line shown in color, which allows the users to understand where the selected country is among other OECD countries in terms of fertility rate.

_________________

### www

Folder that contains image files for our shiny application

_________________

### Technical_Report.pdf

This file is our technical report for our final project. You can also read it from this link [here](https://docs.google.com/document/d/1H2jt1A1q1-UBHWVctQkfk9-MkhEGuVqRSMnM4CW2KOg/edit?usp=sharing).

The report contains more detailed information about what the research question we worked on, what datasets we used, what methodology we used, our analysis, and etc. 
_________________

### Shiny App

Link to shiny app: https://songj2.shinyapps.io/Final_Project/
