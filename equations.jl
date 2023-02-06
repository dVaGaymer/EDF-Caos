using GLMakie
using CSV, DataFrames

it = 1000
μ_steps = 1000
dec_digits = 5
points = Point2f[]

#=  =#
ec::Function = (x, μ) -> x * μ * (1 - x)
data_path = "ec1.csv"
μ_data = range(2.8, 4, μ_steps)
init_x = 0.1
#=  ([0, 1], Fa ) ; Fa(x) = a sin(πx) ; 0 ≤ a ≤ 1  =#
ec::Function = (x, μ) -> μ * sin(pi * x)
data_path = "ec2.csv"
μ_data = range(0, 1, μ_steps)
init_x = 0.1
#=  ([0, 1], Fa ) ; Fa(x) = ax^2sin(πx) ; 1.5 ≤ a ≤ 2.3  =#
ec::Function = (x, μ) -> μ * x^2 * sin(pi * x)
data_path = "ec3.csv"
μ_data = range(1.5, 2.3, μ_steps)
init_x = 0.1
#=  ([−∞, ∞], Fa) ; Fa(x) = x^2 + a ; −2 ≤ a ≤ 1/4  =#
ec::Function = (x, μ) -> x^2 + μ
data_path = "ec4.csv"
μ_data = range(-2, 1/4, μ_steps)
init_x = 0.1
#=  ([−1, 1], Fa) ; Fa(x) = e^(−αx^2)+ a ; −1 ≤ a ≤ 1 ; α = 4.9  =#
ec::Function = (x, μ) -> exp(-4.9 * x^2) + μ
data_path = "ec5.csv"
μ_data = range(-1, 1, μ_steps)
init_x = 0.1
