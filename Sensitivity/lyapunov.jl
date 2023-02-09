using GLMakie

Base.@kwdef mutable struct DynamicSyistem
	n = 1
	μ = 1
	x_current = 0.1
	f::Function = (μ, x) -> x * μ * (1 - x)
	f_der::Function = (μ, x) -> μ * (1 - 2 * x)
end

#=  Lyapunov function  =#
function lyapunov(dysy, μ, n)
	save_x = dysy.x_current
	dysy.x_current = 0.1

	i = 0
	ret = 0
	while(i < n)
		ret += log(abs(dysy.f_der(μ, dysy.x_current)))
		dysy.x_current = dysy.f(μ, dysy.x_current)
		i += 1
	end
	dysy.x_current = save_x

	ret / n
end
