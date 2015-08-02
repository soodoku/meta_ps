"
Meta APSR
Length of article over time
@author Gaurav Sood

"

# Source recode file
source("meta_apsr.R")

# Plot
ggplot(apsr, aes(article.abstract.views)) + 
geom_histogram(binwidth=1000) +
ylab("No. of Articles") +
xlab("No. of Abstract Views") + 
theme_minimal() +
theme(panel.grid.major.y = element_line(colour = "#e3e3e3", linetype = "dotted"),
	  panel.grid.minor   =  element_blank(),
	  panel.grid.major.x = element_line(colour = "#f7f7f7", linetype = "solid"),
	  panel.border       = element_blank(),
	  legend.position  = "bottom",
	  legend.key       = element_blank(),
	  legend.key.width = unit(1,"cm"),
	  axis.title.y  = element_text(size=10, vjust= 1),
	  axis.text.y  = element_text(size=8),
	  axis.ticks.y = element_blank(),
	  axis.text.x  = element_text(),
	  axis.title.x = element_text(),
	  axis.ticks.x = element_blank(),
	  plot.margin = unit(c(0,.5,.5,.5), "cm"))

ggsave("figs/abstract_views.pdf")