include("common.jl")

Base.@kwdef mutable struct Henon
	n = 1
	a = 0
	b = 0
	x_current = 0
	y_current = 0
	p_data = [Point2f(0.0, 0.0)]
	f_x::Function = (a, b, x, y) -> 1 + y - a * x^2
	f_y::Function = (a, b, x, y) -> b * x
end

hen = Henon(; a = 1.4, b = 0.3)
fillData!(hen)
scatter(hen.p_data, markersize = 5)
