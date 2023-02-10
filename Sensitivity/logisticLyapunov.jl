using GLMakie

include("lyapunov.jl")

#= Logistic equation and its data =#
logEc = DynamicSyistem()
μ_data = 3.4:0.0001:4
λ_data = lyapunov.([logEc], μ_data, 0.5, 1)

#= Plot =#
fig = Figure()
ax = Axis(fig[1, 1]; xlabel = "μ", xlabelsize = 50, ylabel = "λ", ylabelsize = 50)
# scatter!(μ_data, λ_data; markersize = 3)
lines!(μ_data, λ_data)
