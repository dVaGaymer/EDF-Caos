using GLMakie
using CSV, DataFrames

#=  Observables to create interactive plots  =#
data = Observable(Point2f[])
aux_func = Observable{Function}((x) -> rep.f(rep.μ, x))
P = Observable{Matrix}(Matrix(undef, 0, 0))
x_init = Observable{Float64}(0.1)
x_low = Observable{Float64}(0)
x_high = Observable{Float64}(1)
x_range = Observable(x_low[]:0.01:x_high[])
μ_init = Observable{Float64}(3)
μ_low = Observable{Float64}(2.8)
μ_high = Observable{Float64}(4)
μ_range = Observable(x_low[]:0.01:x_high[])
(c1, c2, c3, c4, c5) = (Observable(:tomato), Observable(:white), Observable(:white), Observable(:white), Observable(:white))

Base.@kwdef mutable struct DynamicSyistem
	n = 1
	μ = μ_init
	x = x_init
	f::Function = (μ, x) -> x * μ * (1 - x)
end
rep = DynamicSyistem()

#=  Functions =#
include("equations.jl")
include("functions.jl")
useEquation(1)

running = Observable(false)
#=  Init axis layout structure =#
fig = Figure()

(eq_axis, feig_axis) = (Axis(fig[1, 1:3]), Axis(fig[1, 5:7]))
μSlider = Slider(fig[1, 4];
		horizontal = false,
		range = μ_range,
		startvalue = μ_init,
		color_inactive = RGBf(0.90, 0.50, 0.50),
		color_active = RGBf(0.70, 0.20, 0.20),
		color_active_dimmed = RGBf(0.70, 0.20, 0.20))
lift(μSlider.value) do μ
	global μ_init[] = μ
	running[] = false
	aux_func[] = (x -> rep.f(μ, x))
	n = rep.n
	anim_reset(μ, x_init[], ec)
	data_aux = Point2f[]
	push!(data_aux, [rep.x, 0.0])
	while (n > 1)
		push!(data_aux, step!(rep))
		n -= 1
	end
	data[] = data_aux
end
xSlider = Slider(fig[2, 1:3];
		horizontal = true,
		range = x_range,
		startvalue = x_init,
		color_inactive = RGBf(0.50, 0.50, 0.90),
		color_active = RGBf(0.20, 0.20, 0.70),
		color_active_dimmed = RGBf(0.20, 0.20, 0.70))
lift(xSlider.value) do v
	global x_init[] = v
	running[] = false
	n = rep.n
	anim_reset(rep.μ, v, ec)
	data_aux = Point2f[]
	push!(data_aux, [v, 0.0])
	while (n > 1)
		push!(data_aux, step!(rep))
		n -= 1
	end
	data[] = data_aux
end

initAnimation = Button(fig[1, 2, Top()]; label = "Start / Stop")
stepOut = Button(fig[3, 1]; label = "Step Out", tellwidth = false)
resetAnim = Button(fig[3, 2]; label = "Reset", tellwidth = false)
stepIn = Button(fig[3, 3]; label = "Step In", tellwidth = false)
ec1_button = Button(fig[4, 1]; label = L"x_{k+1} = \mu x (1 - x_k)", tellwidth = false, fontsize = 30, buttoncolor = c1)
ec2_button = Button(fig[4, 2]; label = L"x_{k+1} = \mu sin(\pi x_k)", tellwidth = false, fontsize = 30, buttoncolor = c2)
ec3_button = Button(fig[4, 4]; label = L"x_{k+1} = \mu x^2 sin(\pi x_k)", tellwidth = false, fontsize = 30, buttoncolor = c3)
ec4_button = Button(fig[4, 6]; label = L"x_{k + 1} = x_k^2 + a", tellwidth = false, fontsize = 30, buttoncolor = c4)
ec5_button = Button(fig[4, 7]; label = L"x_{k + 1}e^{-μx_k^2}", tellwidth = false, fontsize = 30, buttoncolor = c5)

#=  Init buttons  =#
on(stepIn.clicks) do clicks; anim_next(); end
on(stepOut.clicks) do clicks; anim_prev(); end
on(resetAnim.clicks) do clicks; anim_reset(μ_init[], x_init[], ec); end
on(initAnimation.clicks) do clicks; anim_init(); end
on(initAnimation.clicks) do clicks; running[] = !running[]; end

on(ec1_button.clicks) do clicks; useEquation(1); anim_reset(μ_init[], x_init[], ec); end
on(ec2_button.clicks) do clicks; useEquation(2); anim_reset(μ_init[], x_init[], ec); end
on(ec3_button.clicks) do clicks; useEquation(3); anim_reset(μ_init[], x_init[], ec); end
on(ec4_button.clicks) do clicks; useEquation(4); anim_reset(μ_init[], x_init[], ec); end
on(ec5_button.clicks) do clicks; useEquation(5); anim_reset(μ_init[], x_init[], ec); end

#=  Create Feigenbaum Data File of current equation  =#
#include("feigenbaum_create.jl")

#=  Plots  =#
lines!(eq_axis, data)
lines!(eq_axis, x_range, aux_func)
lines!(eq_axis, x_range, x -> x)

#=  Feigenbaum plot  =#
scatter!(feig_axis, P; markersize = 5)
vlines!(feig_axis, μSlider.value)

display(fig)

#=  Camp Func  =#
useEquation(6)
