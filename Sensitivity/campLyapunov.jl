using GLMakie

include("lyapunov.jl")

#= Logistic equation and its data =#
function campFunc(μ, x)
	if (x < 0 || x > 1)
		return 0
	end
	if (0 < x < 1/2)
		2 * μ * x
	else
		if (1/2 < x < 1)
			2 * μ - 2 * μ * x
		end
	end
end
function campFunc_der(μ, x)
	if (x < 0 || x > 1)
		return 0
	end
	if (0 < x < 1/2)
		2 * μ
	else
		if (1/2 < x < 1)
			- 2 * μ
		end
	end
end
campEc = DynamicSyistem(;f = (μ, x) -> campFunc(μ, x))
campEc = DynamicSyistem(;f_der = (μ, x) -> campFunc_der(μ, x))
μ_data = 3.4:0.0001:4
λ_data = lyapunov.([campEc], μ_data, 1000)

#= Plot =#
fig = Figure()
ax = Axis(fig[1, 1]; xlabel = "μ", xlabelsize = 50, ylabel = "λ", ylabelsize = 50)
# scatter!(μ_data, λ_data; markersize = 3)
scatter(μ_data, λ_data)

