"
Meta APSR
Number of articles per volume over time
@author Gaurav Sood

"

# Source recode file
source("meta_apsr.R")

# No. of articles per volume
apsr$n.articles.per.vol <- grpfun(rep(1, nrow(apsr)), apsr$issue, fun="sum")

# Smaller unique issues volumes db
apsr_issue <- ddply(apsr, .(issue.volume), head, n = 1)
# count(apsr, c("issue.volume"))

# Plot
ggplot(apsr_issue, aes(issue.year, n.articles.per.vol)) + 
geom_smooth(method = "loess", span=.4, colour="#eeeeff", alpha=0.2) +
geom_point(width=1, color="#42C4C7", size=1.5, shape=16) +
scale_y_continuous(breaks=seq(0,25,5), labels=nolead0s(seq(0,25,5)), lim=c(0,25)) + 
scale_x_continuous(breaks=seq(1900,2020,10), labels=nolead0s(seq(1900,2020,10)), lim=c(1905,2015)) +
ylab("No. of articles per issue")+
xlab("Publication Year")+
theme_minimal()+
theme(panel.grid.major.y = element_line(colour = "#e3e3e3", linetype = "dotted"),
	  panel.grid.minor   =  element_blank(),
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
	  axis.ticks.x = element_line(color="#e3e3e3", size=.2),
	  plot.margin = unit(c(0,.5,.5,.5), "cm"))

ggsave("figs/articles_per_issue_over_time.pdf")
