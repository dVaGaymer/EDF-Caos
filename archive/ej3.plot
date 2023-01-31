#!/opt/homebrew/bin/gnuplot


mu = 2.99
mux = (mu - 1)/mu
array mudata[2]
mudata[1] = mux
mudata[2] = mu * mux - mu * mux**2
x0 = 0.1
set xrange[0:1]
set yrange[0:1]
set xlabel "{/:Bold x}"
set ylabel "{/:Bold y}"
while (x0 < 1){
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
	mudata using(mudata[1]):(mudata[2]) with points pt 7 ps 2 title "({/Symbol m} - 1) / {/Symbol m}", \
	mu*x-mu*x*x notitle, \
	x notitle
	unset object
	x0 = x0 + 0.001
}
pause -1