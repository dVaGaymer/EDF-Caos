include("common.jl")

Base.@kwdef mutable struct Ikeda
	n = 1
	a = 0
	b = 0
	x_current = 0
	y_current = 0
	p_data = [Point2f(0.0, 0.0)]
	f_x::Function = (a, b, x, y) -> 1 + a * (x*cos(0.4 - (6/(1+x^2+y^2))) - y*sin(0.4 - (6/(1+x^2+y^2))))
	f_y::Function = (a, b, x, y) -> a * (x*sin(0.4 - (6/(1+x^2+y^2))) + y*cos(0.4 - (6/(1+x^2+y^2))))
end

ik = Ikeda(; a = 0.8)
fillData!(ik)
ik.p_data
scatter(ik.p_data, markersize = 5)
