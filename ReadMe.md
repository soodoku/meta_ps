### Meta APSR

Scrape and analyze abstracts and meta data of [American Political Science Review](http://journals.cambridge.org/action/displayJournal?jid=PSR) articles.
* [Script for Getting the (Meta) Data](#get-the-meta-data)
* [The data and the codebook](#data)
* [Scripts for producing the graphs and graphs](#analyze-the-data)
* Related: [Proportion of precise quantitative statements in APSR abstracts](https://github.com/soodoku/quant-discipline)

The data show that till well into 1960s, average article published in the APSR was solo-authored. Today, co-authored papers are the norm.
![No. of authors over time](figs/n_authors_per_article_over_time.png)


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

#### License

Released under the [MIT License](License.md)