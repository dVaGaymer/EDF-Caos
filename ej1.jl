using GLMakie

# Animation settings
running = Observable(false)

# N of iterations
it = 100

# Initial conditions
x_init = 0.1
Base.@kwdef mutable struct Logistic
	n = 0
	μ = 2.5
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

#Intialice button and its functions
initAnimation = Button(fig[1, 2, Top()]; label = "Start/Stop Animation")
stepOut = Button(fig[2, 1]; label = "Step Out")
resetAnim = Button(fig[2, 2]; label = "Reset")
stepIn = Button(fig[2, 3]; label = "Step In")
stepIn.tellwidth = false
stepOut.tellwidth = false
resetAnim.tellwidth = false

on(stepIn.clicks) do clicks; anim_next(); end
on(stepOut.clicks) do clicks; anim_prev(); end
on(resetAnim.clicks) do clicks; anim_reset(); end
on(initAnimation.clicks) do clicks; anim_init(); end
on(initAnimation.clicks) do clicks; running[] = !running[]; end

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
function anim_reset()
	splice!(data[], 2:length(data[]))
	rep.x = x_init
	rep.n = 0
	data[] = data[]
end
function anim_init()
	@async while (running[] == true)
		push!(data[], step!(rep))
		data[] = data[]
		sleep(0.1)
	end
end
