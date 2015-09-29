### Trends in Production and Consumption of APSR Articles

The American Political Science Review has been the pre-eminent journal in political science since its inception. Here, I analyze some trends in production and consumption of APSR articles.

#### Table of Contents:

* [Some Results](#results)
* [Scraping the (meta) data](#get-the-meta-data)
* [The data and the codebook](#data)
* [Scripts for producing the graphs and graphs](#analyze-the-data)
* **Related:** [Proportion of precise quantitative statements in APSR abstracts](https://github.com/soodoku/quant-discipline)

----

#### Results

The data show that till well into the 1960s, the average article published in the [APSR](http://journals.cambridge.org/action/displayJournal?jid=PSR) was solo-authored. Today, co-authored papers are the norm.

![No. of authors over time](figs/n_authors_per_article_over_time.png)

Over the past 100 or so years, [article length](figs/article_length.pdf) has shown marked variability. There is a marked see-saw pattern in the average length of the article, but unlike top economics journals we don't see a marked trend towards longer articles. It is very likely, however, that the length of online appendices has grown substantially. 

Number of views an [article](figs/fulltext_views.pdf) or [abstract](figs/abstract_views.pdf) has received follows the familiar power law distribution with most articles receiving very few views. 

----- 

#### Get the (Meta) Data

To scrape meta data and abstract for all APSR articles from [APSR](http://journals.cambridge.org/action/displayBackIssues?jid=PSR), use [get_apsr_data.py](scripts/get_apsr_data.py). The script depends on `urllib2`. To run the script, `python get_apsr_data.py`

**Options:**
   * Name of the output file. Specify `FINAL_OUTPUT_FILE` on line 11 of [get_apsr_data.py](scripts/get_apsr_data.py).
   * Column names. Specify `HEADER` on Line 18 of [get_apsr_data.py](scripts/get_apsr_data.py).

**Note:** The script allows for interruption. If interrupted, it will restart from where it stopped. And it will append the results to the existing output file.

#### Data

Data: [apsr_data.csv](data/apsr_data.csv)  
   
Each row in the csv is a separate article. And the columns are:  
   
   * article.url
   * issue.year
   * issue.volume 
   * issue.date.of.publication
   * issue.pages
   * article.title
   * article.abstract
   * article.pages
   * 10 colums e.g author1, institution1, etc, ...,author1, institution1 
   * article.abstract.views
   * article.full.text.views

#### Analyze the Data

* [Recode the data](scripts/meta_apsr.R)
* Article lengths (measured by number of pages) over time. ([Script](scripts/article_length.R), [Graph](figs/n_pages_per_article_over_time.pdf))  
* Number of authors per article over time. ([Script](scripts/n_authors.R), [Graph](figs/n_authors_per_article_over_time.pdf))  
* Number of articles per issue over time. ([Script](scripts/articles_per_issue.R), [Graph](figs/articles_per_issue_over_time.pdf))  
* Number of pages per issue over time. ([Script](scripts/issue_length.R), [Graph](figs/pages_per_issue_over_time.pdf))  
* Distribution of full text views. ([Script](scripts/fulltext_views.R), [Graph](figs/fulltext_views.pdf))  
* Distribution of abstract views. ([Script](scripts/abstract_views.R), [Graph](figs/abstract_views.pdf)) 
* Average number of women on an article. ([Script](scripts/gender_authors.R), [Graph](figs/gender_authors_per_article_over_time.pdf)) 
* Based on the idea by [titleogy](http://datacolada.org/2013/12/04/titleogy/), Length of title.
* Proportion of Female Authors.

#### License
Released under the [MIT License](License.md)
