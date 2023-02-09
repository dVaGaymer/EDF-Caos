using GLMakie
using CSV, DataFrames

aux_P = Point2f[]
function addPoints(from, to, data, μ)
	for i = from+1:to
		push!(aux_P, Point2f(μ, data[i]))
	end
	return to - from
end
function getAtractors(μ)
	aux_data = []
	push!(aux_data, x_init[])
	for i = 1:1000
		new_x = ec(μ, aux_data[i])
		fa = findall(x -> round(x; digits = dec_digits) == round(x; digits = dec_digits), aux_data)
		if (length(fa) != 0)
			push!(aux_data, new_x)
			return addPoints(fa[1], i + 1, aux_data, μ)
		end
		push!(aux_data, new_x)
	end
	1000
end
# μ_steps = 100
# x_data = fill(0, μ_steps)
# x_init = Observable(0.1)
# ec = campFunc
# dec_digits = 5
# μ_data = range(2.8, 4, μ_steps)
# data_path = "camp.csv"
for i = 1:μ_steps
	getAtractors(μ_data[i])
end
# CSV.write(data_path, aux_P)
# P[] = (Matrix(CSV.read(data_path, DataFrame; delim = ',', header = false)))::Matrix
# scatter(P; markersize = 5)

