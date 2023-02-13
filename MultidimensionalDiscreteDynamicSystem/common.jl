using GLMakie

function step!(h)
	x_aux = h.f_x(h.a, h.b, h.x_current, h.y_current)
	y_aux = h.f_y(h.a, h.b, h.x_current, h.y_current)
	h.x_current = x_aux
	h.y_current = y_aux
	push!(h.p_data, Point2f(h.x_current, h.y_current))
end
function fillData!(attractor; it = 1000000)
	for i in 0:it
		step!(attractor)
	end
end
