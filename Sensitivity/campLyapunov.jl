using GLMakie

include("lyapunov.jl")

#= Logistic equation and its data =#
campFunc(μ, x) = (0 < x <= 1/2) ? 2 * μ * x : (1/2 < x < 1) ? 2 * μ - 2 * μ * x : 0
campFunc_der(μ, x) = (0 < x < 1/2) ? 2 * μ : (1/2 < x < 1) ? - 2 * μ : 0
campEc = DynamicSyistem(;f = (μ, x) -> campFunc(μ, x), f_der = (μ, x) -> campFunc_der(μ, x), μ = 0.2)
μ_data = 0.0:0.0001:10
λ_data = lyapunov.([campEc], μ_data, 0.1, 1000)

#= Plot =#
fig = Figure()
ax = Axis(fig[1, 1]; xlabel = "μ", xlabelsize = 50, ylabel = "λ", ylabelsize = 50)
# scatter!(μ_data, λ_data; markersize = 3)
scatter(μ_data, λ_data)
lines!(0..1, x -> campFunc(0.25, x))
lines!(0..1, x -> x)
