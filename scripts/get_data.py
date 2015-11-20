'''

  Scrape Meta Data and Abstracts of CUP Journal Articles

'''

import urllib2
#import sys

START_LINK = "http://journals.cambridge.org/action/displayBackIssues?jid=PSR"
FINAL_OUTPUT_FILE = "apsr_data.csv"

AUTHORS_HEADER=""
MAX_AUTHORS_NUMBER = 10
for i in range(MAX_AUTHORS_NUMBER):
    AUTHORS_HEADER = AUTHORS_HEADER + ", author%d, institution%d" %(i+1, i+1,)
    
HEADER = "article.url, issue.year, issue.volume, issue.date.of.publication, issue.pages, article.title, article.abstract, article.doi, article.pages" + AUTHORS_HEADER + ", article.abstract.views, article.full.text.views"

SEARCH_URL = "http://journals.cambridge.org/action/"
ARTICLE_DATABASE_MARKER=set()
USELESS_TAGS = ["<a>","</a>","<b>","</b>","<p>","</p>","\n","<em>","</em>","<i>","</i>","&nbsp;"]

def removeEndLineCharacter(mystr):
    if mystr.find("\n"):
        return mystr[:-1]
    
def removeDoubleQuote(myStr):
    return myStr.replace("\"", "").strip();

def removeDivInText(myStr, divs):
    for div in divs:
        myStr = myStr.replace(div,"")
    return myStr

def refineHTMLToText(myStr):
    for div in USELESS_TAGS:
        myStr = myStr.replace(div,"")
    myStr = myStr.replace("  "," ").strip()
    return myStr


def findWithPattern(mystr, startPattern, endPattern):
    """
    Find the string that starts with <startPattern> and ends with <endPattern> in the orginal string <mystr>.
    Args:
        + mystr: orginal string.
        + startPattern: 
        + endPattern: 
    Returns:
        + The found string,
        + and the remained part of the orginal string.
    """
    x = mystr.find(startPattern)
    if x==-1:
        return "",mystr
    mystr = mystr[x + len(startPattern):]
    y = mystr.find(endPattern)
    if y==-1:
        return "",mystr
    return mystr[:y], mystr[y+len(endPattern):]


def getNextIssue(data):
    """
    Get next Issue in the html "data"
    """
    issueDiv, data = findWithPattern(data,'<li name="issue-','</li>')
    if len(issueDiv)==0:
        return "","","","","",""
    
    # Extract year, volume
    yearVolume,issueDiv = findWithPattern("-" + issueDiv,'-','"')
    yearVolumes = yearVolume.split("-")
    year = "-".join(yearVolumes[:-1])
    volume = yearVolumes[-1]

    # Extract issus link
    linkDiv, issueDiv = findWithPattern(issueDiv,'<span class="issue-number"','</span>')
    link, linkDiv = findWithPattern(linkDiv,'<a href="','"')
    link = SEARCH_URL + link.replace(";","&")

    # Extract issue date
    date,issueDiv = findWithPattern(issueDiv,'<span class="issue-date">','</span>')
    date = date.strip()

    # Exract issue pages
    pageDiv,issueDiv = findWithPattern(issueDiv,'<span class="issue-pages" style="float:left;">','</span>')
    pages,pageDiv = findWithPattern(pageDiv,'(pp)','&nbsp;')
    pages = pages.strip()
    pages = "-".join(p.strip() for p in pages.split("-"))
    return year, volume, date, pages, link, data


def getNextArticle(data):
    """
    Get next Article link in the html "data"
    """
    articleDiv, data = findWithPattern(data,'<!-- Start of journal -->','<!-- End of journal item -->')
    if len(articleDiv)==0:
        return "",""
    link, articleDiv = findWithPattern(articleDiv,'href="','"')
    link = SEARCH_URL+ link.replace(";","&")
    return link,data

def getAuthorsUnis(authorsDiv, unisDivs):
    """
    Extract pairs of author-institution from html data "authorsDiv" and "unisDivs"
    Args:
        + authorsDiv: html data contents information about authors's name
        + unisDivs: html data contents information about institution's name
    Returns:
        + a dictionaty type result: pairs of author-institution
    """
    #print "-----------------"
    #print unisDivs
    #print "-----------------"
    
    result = {}
    if authorsDiv.find("</sup>")>-1:
        # Case with multiple authors
        authors = {}
        unis={}

        # Extract authors
        authorItems = authorsDiv.split("</sup>")
        for item in authorItems:
            name,target = findWithPattern(item,'','<sup>')
            if target.find('<a')>-1:
                target,tmp = findWithPattern(target,'>','</a>')
            name = name.replace("</b>"," ")
            name = name.replace(","," ")
            name = name.replace(" and ","")
            name = refineHTMLToText(name)
            if len(name)>1 and name[0]=='<' and name[-1]=='>':
                name=""
            if len(name)>0:
                authors[name] = target

        # Extract institutions
        if unisDivs.find("</p>")>-1:
            unisDivs = unisDivs.split("</p>")
        elif unisDivs.find("</span>")>-1:
            unisDivs = unisDivs.split("</span>")
        else:
            unisDivs = [unisDivs]
        for unisDiv in unisDivs:
            uniItems = unisDiv.split("<sup")
            for item in uniItems:
                target,name = findWithPattern(item,'>','</sup>')
                name = refineHTMLToText(name)
                target = refineHTMLToText(target)
                unis[target] = name
        # Pairing author-institution
        for a in authors.keys():
            if authors[a] in unis.keys():
                result[a] = unis[authors[a]]
            else:
                result[a] = ""
    else:
        # Case with single author
        if len(authorsDiv)>0:
            authors = authorsDiv.strip().replace('&nbsp;','')
            uni = refineHTMLToText(unisDivs)
            authors = authors.split(" and ")
            for author in authors:
                result[refineHTMLToText(author)] = uni
    #print result
    return result

def getArticleContent(link):
    """
    Extract article information of the link
    """
    # Get raw html data
    req = urllib2.Request(link)
    response = urllib2.urlopen(req)
    dataFull = response.read()
    headerDiv, data = findWithPattern(dataFull,'<div class="sh-left">','<!-- Start of rss feeds -->')

    titleh, headerDiv = findWithPattern(headerDiv, '<h2>','</h2>')

    # Extract pages
    pagesDiv, headerDiv = findWithPattern(headerDiv, '</a>','</li>')
    pages, pagesDiv = findWithPattern(pagesDiv+"*_*", ' pp ','*_*')
    pages = pages.strip()

    # Extract DOI
    DOIDiv, headerDiv = findWithPattern(headerDiv, '<a class="cboDOI"','</a>')
    DOI, DOIDiv = findWithPattern(DOIDiv+'*_*', 'target="_blank">','*_*')
    DOI = DOI.strip()

    descriptionsDiv,data = findWithPattern(data, '<!-- Start of descriptions -->','<!-- End of descriptions -->')

    # Extract title
    title, tmp = findWithPattern(dataFull, "articleTitle: '<b>","</b><br/>'")

    # Extract authorsDiv
    authorsDiv,tmp  = findWithPattern(descriptionsDiv,'<h3 class="author">','</h3>')
    if len(authorsDiv)==0:
        authorsDiv,tmp  = findWithPattern(descriptionsDiv,'<td><b><b>','</b><br>')
    authorsDiv = authorsDiv.strip()

    # Extract unisDivs
    unisDivs, descriptionsDiv = findWithPattern(tmp,'<p>','</p></p>')
    if len(unisDivs)==0:
        unisDivs, descriptionsDiv = findWithPattern(tmp,'<span>','<br><br></td>')
    unisDivs = unisDivs.strip()

    # Get pairs of author-institution
    authors = getAuthorsUnis(authorsDiv,unisDivs)

    # Extract abstract
    abstract,tmp = findWithPattern(dataFull,"abstract: '<p><p>",'<br/><br/>')
    if len(abstract)==0:
        abstract,tmp = findWithPattern(descriptionsDiv,"<p>",'</div>')

    # Remove useless tags in abstract and title
    abstract = refineHTMLToText(abstract)
    title = refineHTMLToText(title)

    # Get abstract_views_div and full_text_views_div by through another http request
    aid,tmp = findWithPattern(link,'aid=','&')
    fileid,tmp = findWithPattern(link+"*_*",'fileId=','*_*')
    viewLink = "http://journals.cambridge.org/action/displayJournalTab?jid=PSR&tab=metrics&compId=%s&fileId=%s" %(aid,fileid)
    req2 = urllib2.Request(viewLink)
    response2 = urllib2.urlopen(req2)
    data2 = response2.read()

    # Extract abstract_views
    abstract_views_div,tmp =findWithPattern(data2,'<div class="left">Abstract Views:</div>','</div>')
    abstract_views,tmp = findWithPattern(abstract_views_div + '*_*','<div class="right">','*_*')

    # Extract full_text_views
    full_text_views_div,tmp =findWithPattern(data2,'<div class="left">Full Text Views:</div>','</div>')
    full_text_views,tmp = findWithPattern(full_text_views_div + '*_*','<div class="right">','*_*')

    # Return result
    return title, abstract, DOI, pages, authors, abstract_views, full_text_views


def getArticlesInIssue(issue_year, issue_volume, issue_date, issue_pages, issue_link, myfile):
    """
    Process articles in an issue
    """
    req = urllib2.Request(issue_link)
    response = urllib2.urlopen(req)
    data = response.read()
    
    link,data = getNextArticle(data)
    #link = "http://journals.cambridge.org/action/displayAbstract?fromPage=online&amp&aid=92327&amp&fulltextType=BR&amp&fileId=S0003055401892017"
    while len(link)>0:
        # only scrape new link
        if link not in ARTICLE_DATABASE_MARKER:
            print "   + GET ARTICLE--- %s" % (link,)
            title, abstract, doi, pages, authors, abstract_views, full_text_views = getArticleContent(link)
            #print "---GOT---", title, doi, pages, authors, len(abstract)

            authorStr = ""
            for author in authors.keys():
                authorStr = authorStr + ',"%s","%s"'%(author.replace('"',''), authors[author].replace('"',''))
            for i in range (MAX_AUTHORS_NUMBER-len(authors.keys())):
                authorStr = authorStr + ',"",""'
                
            # Write to output file
            title = title.replace('"','\'')
            abstract = abstract.replace('"','\'').replace("\n","\\n")
            rowStr = '"%s","%s","%s","%s","%s","%s","%s","%s","%s"%s,"%s","%s"\n' %(link, issue_year, issue_volume, issue_date, issue_pages, title, abstract, doi, pages, authorStr, abstract_views, full_text_views,)
            myfile.write(rowStr)

            # Mark the new row
            ARTICLE_DATABASE_MARKER.add(link)
            
        #testing
        #sys.exit(0)
            
        # Get next article
        link,data = getNextArticle(data)
            
##################################START SCRAPING#########################################
print "---START SCRAPING %s---"% (START_LINK,)
req = urllib2.Request(START_LINK)
response = urllib2.urlopen(req)
data = response.read()    

with open (FINAL_OUTPUT_FILE, "ab+") as myfile:
    # Read previous data
    datafile=myfile.readlines()
    if len(datafile)==0:
        myfile.write(HEADER + "\n")
    else:
        datafile = datafile[1:]
    for line in datafile:
        items = removeEndLineCharacter(line).split(",")
        ARTICLE_DATABASE_MARKER.add(removeDoubleQuote(items[0]))
    
    # Start scraping    
    year, volume, date, pages, link, data = getNextIssue(data)
    while len(link)>0:
        print "---GET ISSUES--- %s-%s %s" % (year, volume, link,)
        getArticlesInIssue(year, volume, date, pages, link, myfile)
        year, volume, date, pages, link, data = getNextIssue(data)

    myfile.close()
##################################FINISHED#########################################
print "DONE"
