#=  Calculate next STEP  =#
function step!(l::DynamicSyistem)
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

animation_max_it = 2000
#=  Animation functions  =#
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
function anim_reset(μ, x, ec)
	splice!(data[], 1:length(data[]))
	rep.μ = μ
	rep.x = x
	rep.n = 1
	rep.f = ec
	push!(data[], [x, 0.0])
	data[] = data[]
	aux_func[] = ((x) -> rep.f(rep.μ, x))
end
function anim_init()
	@async while (running[] == true)
		while (rep.n < animation_max_it && running[] == true)
			push!(data[], step!(rep))
			sleep(0.01)
			data[] = data[]
		end
		while (rep.n > 1 && running[] == true)
			pop!(data[])
			rep.x = last(data[])[1]
			rep.n -= 1
			sleep(0.01)
			data[] = data[]
		end
	end
end
