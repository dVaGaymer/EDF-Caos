#!/opt/homebrew/bin/gnuplot


mu = 1
set xrange[0:1]
set yrange[0:1]
set xlabel "{/:Bold x}"
set ylabel "{/:Bold y}"
while (mu < 3){
	x0 = (mu - 1) / mu
	len = 50
	array xdata[len]
	array ydata[len]
	
	xdata[1]=x0
	ydata[1]=0
	i = 2
	while (i < len){
		ydata[i] = mu * xdata[i - 1] - mu * xdata[i - 1]**2
		xdata[i] = xdata[i - 1]
		xdata[i + 1] = ydata[i]
		ydata[i + 1] = ydata[i]
		i = i + 2
	}
	plot xdata using (xdata[$1]):(ydata[$1]) with lines notitle, \
	mu*x-mu*x*x notitle
	mu = mu + 0.001
	pause 0.004
}
pause -1
