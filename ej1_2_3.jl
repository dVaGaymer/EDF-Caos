using GLMakie

# Animation settings
running = Observable(false)

# N of iterations
it = 200

# Initial conditions
x_init = 0.1
μ_init = 2.5
Base.@kwdef mutable struct Logistic
	n = 1
	μ = μ_init
	x = x_init
	f::Function = (μ, x) -> μ * sin(pi * x)
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

# functions
function anim_next()
	if (running[] == true)
		return
	end
	push!(data[], step!(rep))
	data[] = data[]
end
function anim_prev()
	if (running[] == true || length(data[]) == 1)
		return
	end
	pop!(data[])
	rep.x = last(data[])[1]
	rep.n -= 1
	data[] = data[]
end
function anim_reset(x, μ)
	splice!(data[], 1:length(data[]))
	rep.μ = μ
	rep.x = x
	rep.n = 1
	push!(data[], [x, 0.0])
	data[] = data[]
end
function anim_init()
	@async while (running[] == true)
		while (rep.n < it && running[] == true)
			push!(data[], step!(rep))
			sleep(0.1)
			data[] = data[]
		end
		while (rep.n > 1 && running[] == true)
			pop!(data[])
			rep.x = last(data[])[1]
			rep.n -= 1
			sleep(0.1)
			data[] = data[]
		end
	end
end

# Initalize logistic ecuation
rep = Logistic()
data = Observable(Point2f[])
anim_reset(x_init, μ_init)
func = Observable{Function}(x -> rep.f(2, x))

#= PLOTTING =#
fig = Figure()
axis = Axis(fig[1, 1:3])
lines!(axis, data)
lines!(axis, -10:0.01:10, func)
lines!(axis, -10:0.01:10, x -> x)

# Initialize sliders
μSlider = Slider(fig[1, 4];
		horizontal = false,
		range = 0.0:0.001:4,
		startvalue = μ_init,
		color_inactive = RGBf(0.90, 0.50, 0.50),
		color_active = RGBf(0.70, 0.20, 0.20),
		color_active_dimmed = RGBf(0.70, 0.20, 0.20))
xSlider = Slider(fig[2, 1:3];
		horizontal = true,
		range = 0.0:0.01:1,
		startvalue = x_init,
		color_inactive = RGBf(0.50, 0.50, 0.90),
		color_active = RGBf(0.20, 0.20, 0.70),
		color_active_dimmed = RGBf(0.20, 0.20, 0.70))

lab = Observable("(μ: $μ_init| x: $x_init)")
lift(xSlider.value) do v
	lab[] = "(μ: $μ_init| x: $x_init)"
	global x_init = v
	running[] = false
	n = rep.n
	anim_reset(v, rep.μ)
	data_aux = Point2f[]
	push!(data_aux, [v, 0.0])
	while (n > 1)
		push!(data_aux, step!(rep))
		n -= 1
	end
	data[] = data_aux
end
lift(μSlider.value) do μ
	lab[] = "(μ: $μ_init| x: $x_init)"
	global μ_init = μ
	running[] = false
	func[] = (x -> rep.f(μ, x))
	n = rep.n
	anim_reset(x_init, μ)
	data_aux = Point2f[]
	push!(data_aux, [rep.x, 0.0])
	while (n > 1)
		push!(data_aux, step!(rep))
		n -= 1
	end
	data[] = data_aux
end

#Intialice button and its functions
initAnimation = Button(fig[1, 2, Top()]; label = lab)
stepOut = Button(fig[3, 1]; label = "Step Out")
resetAnim = Button(fig[3, 2]; label = "Reset")
stepIn = Button(fig[3, 3]; label = "Step In")
stepIn.tellwidth = false
stepOut.tellwidth = false
resetAnim.tellwidth = false

on(stepIn.clicks) do clicks; anim_next(); end
on(stepOut.clicks) do clicks; anim_prev(); end
on(resetAnim.clicks) do clicks; anim_reset(x_init, μ_init); end
on(initAnimation.clicks) do clicks; anim_init(); end
on(initAnimation.clicks) do clicks; running[] = !running[]; end

display(fig)

# use when plotting with feigenbaum.jl
include("feigenbaum.jl")
