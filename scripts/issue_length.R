"
Meta APSR
Pages per issue over time
@author Gaurav Sood

"

# Source recode file
source("meta_apsr.R")

# Total number of pages per issue
apsr$issue.page.length <- grpfun(apsr$article.page.length,apsr$issue, fun="sum")

# Smaller unique issues volumes db
apsr_issue <- ddply(apsr, .(issue), head, n = 1)


# Plot
ggplot(apsr_issue, aes(issue.year, issue.page.length)) + 
geom_smooth(method = "loess", span=.2, colour="#eeeeff", alpha=0.2) +
geom_point(width=1, color="#42C4C7") +
scale_y_continuous(breaks=seq(0,325,50), labels=nolead0s(seq(0,325,50)), lim=c(0,325)) + 
scale_x_continuous(breaks=seq(1900,2020,10), labels=nolead0s(seq(1900,2020,10)), lim=c(1905,2015)) +
ylab("No. of pages in each volume")+
xlab("Publication Year")+
theme_minimal()+
theme(panel.grid.major.y = element_line(colour = "#e3e3e3", linetype = "dotted"),
	  panel.grid.minor.x = element_blank(),
	  panel.grid.major.x = element_line(colour = "#f7f7f7", linetype = "solid"),
	  panel.border       = element_blank(),
	  legend.position  = "bottom",
	  legend.key       = element_blank(),
	  legend.key.width = unit(1,"cm"),
	  axis.title   = element_text(size=10),
	  axis.text    = element_text(size=8),
	  axis.ticks.y = element_blank(),
	  axis.line.x  = element_line(colour = 'red', size = 3, linetype = 'dashed'),
	  axis.title.x = element_text(vjust=-1),
	  axis.title.y = element_text(vjust= 1),
	  axis.ticks = element_line(color="#cccccc"),
	  plot.margin = unit(c(0,.5,.5,.5), "cm"))

ggsave("figs/pages_per_issue_over_time.pdf")
