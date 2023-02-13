include("common.jl")

Base.@kwdef mutable struct Duffing
	n = 1
	a = 0
	b = 0
	x_current = 0
	y_current = 0
	p_data = [Point2f(0.0, 0.0)]
	f_x::Function = (a, b, x, y) -> y
	f_y::Function = (a, b, x, y) -> -b * x + a * y - y^3
end

duf = Duffing(; x_current = 0.1, y_current = 0.1, a = 2.75, b = 0.2)
fillData!(duf)
duf.p_data
scatter(duf.p_data, markersize = 5)
