using GLMakie

# EFICIENCY IMPORTANT
it = 1000
points = 1000
approx = 5

μ_data = range(2.8, 4, points)
init_x = 0.1
P = Point2f[]

ec::Function = (x, μ) -> x * μ * (1 - x)
ec1::Function = (x, μ) -> μ * sin(pi * x)
ec2::Function = (x, μ) -> μ * x^2 * sin(pi * x)
ec3::Function = (x, μ) -> x^2 + μ
ec4::Function = (x, μ) -> exp(-4.9 * x^2) + μ

function addPoints(from, to, data, μ)
	for i = from+1:to
		push!(P, Point2f(μ, data[i]))
		# println("TEST $(Point2f(μ, data[i]))")
	end
	return to - from
end

function getAtractors(μ)
	aux_data = []
	push!(aux_data, init_x)
	for i = 1:it
		new_x = ec(aux_data[i], μ)
		fa = findall(x -> round(x; digits = approx) == round(new_x; digits = approx), aux_data)
		if (length(fa) != 0)
			# println("FOUND $(fa[1]) AT $i")
			push!(aux_data, new_x)
			return addPoints(fa[1], i + 1, aux_data, μ)
		end
		push!(aux_data, new_x)
	end
	1000
	#println(aux_data)
end

x_data = fill(0, points)
for i = 1:points
	getAtractors(μ_data[i])
end
# getAtractors(2.95)

scatter(P; markersize = 5)

# Use when pltting with ej_1_2_3.jl
# ax2 = Axis(fig[1, 5:7])
# scatter!(ax2, P; markersize = 5)
# vlines!(ax2, μSlider.value)

