include("common.jl")

Base.@kwdef mutable struct Rossler
	n = 1
	a = 0.2
	b = 0.2
	c = 3
	Δt = 0.01

	x_current = 1
	y_current = 1
	z_current = 1
	p_data = [Point3f(x_current, y_current, z_current)]
	f_x::Function = (x, y, z) -> x + Δt * (-y - z)
	f_y::Function = (x, y, z) -> y + Δt * (x + a * y)
	f_z::Function = (x, y, z) -> z + Δt * (b + z * (x - c))
end

ros = Rossler()
fillData!(ros)
ros.p_data
lines(ros.p_data, markersize = 5)
