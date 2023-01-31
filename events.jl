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
