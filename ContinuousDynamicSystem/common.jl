using GLMakie

function step!(at)
	x_aux = at.f_x(at.x_current, at.y_current, at.z_current)
	y_aux = at.f_y(at.x_current, at.y_current, at.z_current)
	z_aux = at.f_z(at.x_current, at.y_current, at.z_current)
	at.x_current = x_aux
	at.y_current = y_aux
	at.z_current = z_aux
	push!(at.p_data, Point3f(at.x_current, at.y_current, at.z_current))
end
function fillData!(attractor; it = 100000)
	for i in 0:it
		step!(attractor)
	end
end
