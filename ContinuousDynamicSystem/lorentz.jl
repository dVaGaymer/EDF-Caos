include("common.jl")

Base.@kwdef mutable struct Lorentz
	n = 1
	σ = 10
	b = 8/3
	R = 28
	Δt = 0.01

	x_current = 1
	y_current = 1
	z_current = 1
	p_data = [Point3f(x_current, y_current, z_current)]
	f_x::Function = (x, y, z) -> x + Δt * σ * (y - x)
	f_y::Function = (x, y, z) -> y + Δt * (R * x - y - x * z)
	f_z::Function = (x, y, z) -> z + Δt * (-b * z + x * y)
end

lor = Lorentz()
fillData!(lor; it = 6000)
lor.p_data
lines(lor.p_data, markersize = 5)
