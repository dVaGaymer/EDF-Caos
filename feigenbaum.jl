using GLMakie
using CSV, DataFrames

# IF FILE IS NOT CREATED
function addPoints(from, to, data, μ)
	for i = from+1:to
		push!(P, Point2f(μ, data[i]))
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
			push!(aux_data, new_x)
			return addPoints(fa[1], i + 1, aux_data, μ)
		end
		push!(aux_data, new_x)
	end
	1000
end
x_data = fill(0, points)
for i = 1:points
	getAtractors(μ_data[i])
end
CSV.write(data_path, P)

#=----------------------------------------------------------------------------------------------------------=#

# Read from file directly
df = CSV.read(data_path, DataFrame; delim = ',', header = false)
P = Matrix(df)
# Use when pltting with ej_1_2_3.jl
ax2 = Axis(fig[1, 5:7])
scatter!(ax2, P; markersize = 5)
vlines!(ax2, μSlider.value)
