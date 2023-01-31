using GLMakie

# Animation settings
running = Observable(false)

# N of iterations
it = 100

# Initial conditions
x_init = 0.1
Base.@kwdef mutable struct Logistic
	n = 0
	μ = 3.2
	x = x_init
	f::Function = (μ_aux, x_aux) -> μ_aux * x_aux * (1 - x_aux)
end

# Each iteration apply logistic equation
function step!(l::Logistic)
	if (l.n == 0)
		y = 0
		x = l.x
	elseif (l.n % 2 != 0)
		x = l.x
		y = l.f(l.μ, l.x)
	elseif (l.n % 2 == 0)
		x = l.f(l.μ, l.x)
		y = x
	end
	l.n += 1
	l.x = x
	Point2f(x, y)
end

# Initalize logistic ecuation
rep = Logistic()
data = Observable(Point2f[])
push!(data[], step!(rep))

#= PLOTTING =#
fig = Figure()
axis = Axis(fig[1, 1:3])
lines!(axis, data)
lines!(axis, 0:0.01:1, x -> rep.f(rep.μ, x))
lines!(axis, 0:0.01:1, x -> x)

include("events.jl")
