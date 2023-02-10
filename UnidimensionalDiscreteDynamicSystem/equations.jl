using GLMakie
using CSV, DataFrames

function useEquation(n_ec)
	global it = 1000
	global dec_digits = 5
	global μ_steps = 1000
	(c1[], c2[], c3[], c4[], c5[]) = (:white, :white, :white, :white, :white)
	if (n_ec == 1)
		#=  =#
		global ec = ((μ, x) -> x * μ * (1 - x))::Function
		global data_path = "UnidimensionalDiscreteDynamicSystem/feigenbaum_data/ec1.csv"
		global μ_data = range(2.8, 4, μ_steps)
		global (x_init[], x_low[], x_high[], μ_init[], μ_low[], μ_high[]) = 0.1, 0.0, 1.0, 3.0, 2.8, 4
		c1[] = :tomato
	end
	if (n_ec == 2)
		#=  ([0, 1], Fa ) ; Fa(x) = a sin(πx) ; 0 ≤ a ≤ 1  =#
		global ec = (μ, x) -> μ * sin(pi * x)
		global data_path = "UnidimensionalDiscreteDynamicSystem/feigenbaum_data/ec2.csv"
		global μ_data = range(0, 1, μ_steps)
		global (x_init[], x_low[], x_high[], μ_init[], μ_low[], μ_high[]) = 0.1, 0.0, 1.0, 0.5, 0.0, 1.0
		c2[] = :tomato
	end
	if (n_ec == 3)
		#=  ([0, 1], Fa ) ; Fa(x) = ax^2sin(πx) ; 1.5 ≤ a ≤ 2.3  =#
		global ec = (μ, x) -> μ * x^2 * sin(pi * x)
		global data_path = "UnidimensionalDiscreteDynamicSystem/feigenbaum_data/ec3.csv"
		global μ_data = range(1.5, 2.3, μ_steps)
		global (x_init[], x_low[], x_high[], μ_init[], μ_low[], μ_high[]) = 0.5, 0.0, 1.0, 2.0, 1.5, 2.3
		c3[] = :tomato
	end
	if (n_ec == 4)
		#=  ([−∞, ∞], Fa) ; Fa(x) = x^2 + a ; −2 ≤ a ≤ 1/4  =#
		global ec = (μ, x) -> x^2 + μ
		global data_path = "UnidimensionalDiscreteDynamicSystem/feigenbaum_data/ec4.csv"
		global μ_data = range(-2, 1/4, μ_steps)
		global (x_init[], x_low[], x_high[], μ_init[], μ_low[], μ_high[]) = 0.5, -10.0, 10.0, 0.0, -2, 1/4
		c4[] = :tomato
	end
	if (n_ec == 5)
		#=  ([−1, 1], Fa) ; Fa(x) = e^(−αx^2)+ a ; −1 ≤ a ≤ 1 ; α = 4.9  =#
		global ec = (μ, x) -> exp(-4.9 * x^2) + μ
		global data_path = "UnidimensionalDiscreteDynamicSystem/feigenbaum_data/ec5.csv"
		global μ_data = range(-1, 1, μ_steps)
		global (x_init[], x_low[], x_high[], μ_init[], μ_low[], μ_high[]) = 0.1, -1.0, 1.0, 0.0, -1, 1
		c5[] = :tomato
	end
	if (n_ec == 6)
		#=  ([−1, 1], Fa) ; Fa(x) = e^(−αx^2)+ a ; −1 ≤ a ≤ 1 ; α = 4.9  =#
		global ec = (μ, x) -> campFunc(μ, x)
		global data_path = "UnidimensionalDiscreteDynamicSystem/feigenbaum_data/ec6.csv"
		global μ_data = range(0, 1, μ_steps)
		global (x_init[], x_low[], x_high[], μ_init[], μ_low[], μ_high[]) = 0.25, 0.1, 1.0, 0.25, 0, 1
		c5[] = :tomato
	end
	P[] = (Matrix(CSV.read(data_path, DataFrame; delim = ',', header = false)))::Matrix
	#=  Reset everything  =#
	splice!(data[], 1:length(data[]))
	rep.μ = μ_init[]
	rep.x = x_init[]
	rep.n = 1
	rep.f = ec
	push!(data[], [x_init[], 0.0])
	data[] = data[]
	aux_func[] = x -> rep.f(rep.μ, x)
	μ_init[]
	x_init[]
	x_range[] = x_low[]:0.01:x_high[]
	μ_range[] = μ_low[]:0.01:μ_high[]
end
