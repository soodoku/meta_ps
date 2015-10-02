"
Meta APSR
Title Length Over Time
@author Gaurav Sood

"

# Take out titles with nchar 150 as they are generally book reviews -- n=41
apsr <- subset(apsr, title_len <= 150)

# Plot
ggplot(apsr, aes(issue.year, title_len)) + 
geom_smooth(method = "loess", span=.4, colour="#ccccff", alpha=0.4) +
geom_point(width=1, size = I(1.3), color="#42C4C7", alpha=.35) +
scale_y_continuous(breaks=seq(0, 150, 25), labels=nolead0s(seq(0, 150, 25)), lim=c(0, 150)) + 
scale_x_continuous(breaks=seq(1900,2020,10), labels=nolead0s(seq(1900,2020,10)), lim=c(1905,2015)) +
expand_limits(x = 0, y = 1900) + 
ylab("Number of Characters in the Article Title")+
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
	  axis.text.x  = element_text(angle = 0),
	  axis.ticks.y = element_blank(),
	  axis.line.x  = element_line(colour = 'red', size = 3, linetype = 'dashed'),
	  axis.title.x = element_text(vjust=-1),
	  axis.title.y = element_text(vjust= 1),
	  axis.ticks.x = element_line(color="#e3e3e3", size=.2),
	  plot.margin = unit(c(0,.5,.5,.5), "cm"))
ggsave("figs/title_len_over_time.pdf")
