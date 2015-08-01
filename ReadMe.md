## Meta APSR

Scrape and analyze abstracts and meta data of American Political Science Review articles.

### Get the (Meta) Data

To scrape meta data and abstract for all APSR articles from [APSR](http://journals.cambridge.org/action/displayBackIssues?jid=PSR), use [get_apsr_data.py](scripts/get_apsr_data.py).

#### Details about the script:

**Requirements:** `urllib2`

* INPUT: [Links to all the issues](http://journals.cambridge.org/action/displayBackIssues?jid=PSR)
* OUTPUT: Each row in the csv is a separate article. 
  csv file with following cols:
   + article.url
   + issue.year
   + issue.volume
   + issue.date.of.publication
   + issue.pages
   + article.title
   + article.abstract
   + article.pages
   + 10 colums e.g author1, institution1, etc, ...,author1, institution1 
   + article.abstract.views
   + article.full.text.views

**Options:**  

* START_LINK: http://journals.cambridge.org/action/displayBackIssues?jid=PSR
* FINAL_OUTPUT_FILE: name of the output file. e.g. FINAL_OUTPUT_FILE = article_output.csv
* HEADER: Column names in the output file

**Note:**

The script allows for interruption. If interrupted, it will restart from where it was aborted. And it will append the results to the existing output file.

### Analyze the Data

* [Recode the data](analysis/meta_apsr.R)
* Article lengths (measured by number of pages) over time. ([Script](analysis/length.R), [Graph](figs/page_lengths.pdf))  
* Number of authors per article over time. ([Script](analysis/authors.R), [Graph](figs/n_authors.pdf))  

### Related

* [Proportion of precise quantitative statements in APSR abstracts](https://github.com/soodoku/quant-discipline)

### License

Released under the [MIT License](License.md)