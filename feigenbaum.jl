using GLMakie

it = 1000
points = 1000

init_x = 0.1
μ_data = range(2.8, 4, points)
approx = 5

P = Point2f[]

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
		new_x = aux_data[i] * μ * (1 - aux_data[i])
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
