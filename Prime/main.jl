### A Pluto.jl notebook ###
# v0.20.16

using Markdown
using InteractiveUtils

# ╔═╡ 6799a962-4b97-11f0-09c5-a3dd1bde673a
begin
	using PlutoUI, LaTeXStrings
end

# ╔═╡ dab0fc69-515a-4784-acea-e020259f25c2
begin
	const TASK = (
		T⃰₃ = 1643.15,  # Температура газа перед турбиной
		N  = 65e6,     # Полезная мощность турбины
		n  = 5441,     # Частота вращения  турбины
		Pₙ = 0.1013e6, # Давление    наружного воздуха
		Tₙ = 288,      # Температура наружного воздуха
		π⃰ₖ = 18,       # Степень повышения давления
	)

	const CONST = (
		# Газ
		Cpᵧ  = 1160,
		Rᵧ   = 287,
		kᵧ   = 1.33,
		kk_1 = 1.33 / (1.33 - 1),
		k_1k = (1.33 - 1) / 1.33,

		# Воздух
		Cpₙ  = 1030,
		Rₙ   = 287,
		kₙ  = 1030 / (1030 - 287),

		# КПД и т.д. - случайные числа.
		σ₁   = 0.987, # Коэфф. потерь на входном устройстве
		σ⃰ₖₛ  = 0.980,  # Коэфф. потерь в камере сгорания
		σ⃰₄   = 0.985, # Коэфф. потерь в выходном устройстве
		
		ηₐ   = 0.910,  # Адиабатный КПД компрессора
		ηₚ   = 0.870,  # Политропный КПД турбины
		ηₘₜ  = 0.990, # Коэфф. мех. потерь в турбине
		ηₘₖ  = 0.990, # Коэфф. мех. потерь в компрессоре
		ηₖₛ  = 0.990,  # КПД камеры сгорания

		# Константы для охладителя
		Qₙₚ  = 44.3e6,
		hₜₒₚ = 0,
		L₀   = 15,
		T̂₀   = 273.15, # Абсолютный 0
		Cpₐ  = 1200,
		Tₛₜ  = 1100,   # Допустимая температура стали
		σᵤₜ  = 0.20,

		# Константы для компрессора
		σ⃰ᵢₙ  = 0.99,
		σ⃰ₒᵤₜ = 0.98,
		η⃰ₐ   = 0.88,
		cᶻ₁  = 140,
		cᶻ₂  = 120,
		ν₁   = 0.5,
		Ω    = 0.5,
		hₘ   = 25e3,
		k₁   = 0.65,

		# Константы для турбины
		kₙₜ  = 1.0185,
		λ₂ₜ  = 0.5,
		ηₐₜ  = 0.91,
		å    = 90,
		σ₅₀₀ = 610e6,
		d₂ₘ  = 1.4,
		m    = 4,
	)
end

# ╔═╡ f8608c64-aead-49cb-809e-bf60b383ff1c
function calc_prime(𝒞 = CONST, 𝒯 = TASK)
	P⃰₁  = 𝒞.σ₁ * 𝒯.Pₙ
	T⃰₁  = 𝒯.Tₙ
	P⃰₂  = 𝒯.π⃰ₖ * P⃰₁
	T⃰₂  = 𝒯.Tₙ * 𝒯.π⃰ₖ^((𝒞.kₙ-1)/𝒞.kₙ)
	H⃰ₒₖ = 𝒞.Cpₙ * T⃰₁ * ( 𝒯.π⃰ₖ^((𝒞.kₙ-1)/𝒞.kₙ) - 1 )
	Hₖ  = H⃰ₒₖ / 𝒞.ηₐ
	P⃰₃  = P⃰₂ * 𝒞.σ⃰ₖₛ
	P⃰₄  = 𝒯.Pₙ / 𝒞.σ⃰₄
	π⃰ₜ  = P⃰₃ / P⃰₄
	H⃰ₒₜ = 𝒞.Cpᵧ * 𝒯.T⃰₃ * (1 - π⃰ₜ^(-𝒞.k_1k))
	Hₜ  = H⃰ₒₜ * 𝒞.ηₚ
	T⃰₄  = 𝒯.T⃰₃ * π⃰ₜ^(-𝒞.k_1k)
	Gₙ  = 𝒯.N / ( Hₜ * 𝒞.ηₘₜ - Hₖ / 𝒞.ηₘₖ )
	Q̇₁  = 𝒞.Cpᵧ * (𝒯.T⃰₃ - T⃰₂)
	Q₁  = Q̇₁ / 𝒞.ηₖₛ
	ηe  = (Hₜ * 𝒞.ηₘₜ - Hₖ / 𝒞.ηₘₖ) / Q₁
	Φ   = (Hₜ * 𝒞.ηₘₜ - Hₖ / 𝒞.ηₘₖ) / (Hₜ * 𝒞.ηₘₜ)

	# Расчет с охладителем
	t⃰₂   = T⃰₂ - 𝒞.T̂₀
	t⃰₃   = 𝒯.T⃰₃ - 𝒞.T̂₀
	gₐᵢᵣ = (𝒞.Qₙₚ*𝒞.ηₖₛ + 𝒞.hₜₒₚ + 𝒞.L₀*𝒞.Cpₙ*t⃰₂ - (𝒞.L₀+1)*𝒞.Cpₐ*t⃰₃) / (𝒞.Cpₙ * (t⃰₃-t⃰₂))
	a    = (𝒞.L₀ + gₐᵢᵣ)/ 𝒞.L₀
	gₜ   = 1 / (a * 𝒞.L₀)
	gᶜc  = 0.01 + 0.25 / 10000 * (𝒯.T⃰₃ - 𝒞.Tₛₜ)
	gᵖc  = 0.08 + 0.22 / 10000 * (𝒯.T⃰₃ - 𝒞.Tₛₜ)
	gc   = 𝒞.σᵤₜ * (gᶜc + gᵖc)
	ĝc   = ( (1+gₜ) * gc ) / ( 1 + (1+gₜ)*gc )
	Gₜ   = gₜ * (1-ĝc) * Gₙ
	Ωᵣₐₛ = H⃰ₒₜ * Gₙ / Gₜ
	Hₑ   = (1+gₜ) * (1-ĝc) * Hₜ * 𝒞.ηₘₜ - Hₖ * 𝒞.ηₘₖ
	Ωₐₗₗ = Hₑ * Gₙ / Gₜ
	
	(; P⃰₁, T⃰₁, P⃰₂, T⃰₂, H⃰ₒₖ,	Hₖ,	P⃰₃, P⃰₄,	π⃰ₜ,	H⃰ₒₜ, Hₜ, T⃰₄, Gₙ, Q̇₁, Q₁, ηe, Φ,
	t⃰₂, t⃰₃, gₐᵢᵣ, a, gₜ, gᶜc, gᵖc, gc, ĝc, Gₜ, Ωᵣₐₛ, Hₑ, Ωₐₗₗ)
end

# ╔═╡ fe821429-f573-4fb8-9268-54aeb6be6e49
function calc_comp(I, π⃰ₖ, 𝒞 = CONST, 𝒯 = TASK)
	P⃰₁   = 𝒞.σ⃰ᵢₙ * 𝒯.Pₙ
	T⃰₁   = 𝒯.Tₙ
	P⃰ₖ   = 𝒯.Pₙ * π⃰ₖ
	P⃰₂   = P⃰ₖ / 𝒞.σ⃰ₒᵤₜ
	ρ₁   = P⃰₁ / (𝒞.Rₙ * T⃰₁)
	nₖ   = 𝒞.kₙ * 𝒞.η⃰ₐ / (𝒞.kₙ * 𝒞.η⃰ₐ - 𝒞.kₙ + 1)
	ρ₂   = ρ₁ * (P⃰₂/P⃰₁)^(1/nₖ)
	D₁   = √( 4I.Gₙ / ( ρ₁ * π * (1 - 𝒞.ν₁^2) * 𝒞.cᶻ₁ ) )
	Dᵥₜ₁ = 𝒞.ν₁ * D₁
	Dₘ₁  = (Dᵥₜ₁ + D₁) / 2
	l₁   = (D₁ - Dᵥₜ₁) / 2
	F₂   = I.Gₙ / (𝒞.cᶻ₂ * ρ₂)
	ν₂   = (π * Dₘ₁^2 - F₂) / (π * Dₘ₁^2 + F₂)
	l₂   = (1 - ν₂) * √( F₂/(π * (1 - ν₂^2)) )
	uₙ₁  = 𝒯.n * π * D₁ / 60
	H⃰ₐ   = (𝒞.kₙ / (𝒞.kₙ-1)) * 𝒞.Rₙ * T⃰₁ * ( ( P⃰₂/P⃰₁ )^( (𝒞.kₙ-1)/𝒞.kₙ) - 1 )
	H⃰ₖ   = H⃰ₐ / 𝒞.η⃰ₐ
	i    = ceil(H⃰ₖ / 𝒞.hₘ)
	kₘ = (2H⃰ₖ/𝒞.hₘ - 3 + (8-i)*𝒞.k₁) / (5+i)
	h₁   = 𝒞.k₁ * 𝒞.hₘ
	h₂   = kₘ * 𝒞.hₘ
	uₘ₁  = π * Dₘ₁ * 𝒯.n / 60
	Φ₁   = 𝒞.cᶻ₁ / uₘ₁
	h̄₁   = h₁ / uₘ₁^2
	otn  = h̄₁ / Φ₁
	otm  = 𝒞.Ω / Φ₁
	P₀ᵍ  = 0.935 - 0.777 * otm + 0.503 * otm^2
	J    = otn / P₀ᵍ
	Jᵃ   = (-0.916 + √(0.916^2 + 4 * (0.177-J) * 0.0884) ) / (-2 * 0.0884)
	tb   = 1 / Jᵃ
	tbem = tb * Dᵥₜ₁ / Dₘ₁
	u    = uₘ₁
	cᵤ₁  = u * (1-𝒞.Ω) - h₁ / 2u
	cᵤ₂  = u * (1-𝒞.Ω) + h₁ / 2u
	c₁   = √(𝒞.cᶻ₁^2 + cᵤ₁^2)
	α₁   = atand(𝒞.cᶻ₁ / cᵤ₁)
	T₁   = T⃰₁ - c₁^2 / ( 2 * 𝒞.Rₙ * (𝒞.kₙ/(𝒞.kₙ-1)) )
	wᵤ₁  = cᵤ₁ - u
	w₁   = √(𝒞.cᶻ₁^2 + wᵤ₁^2)
	Mʷ₁  = w₁ / √(𝒞.kₙ * 𝒞.Rₙ * T₁)
	β₁   = atand(𝒞.cᶻ₁ / (-wᵤ₁))
	Δcᶻ  = (𝒞.cᶻ₁ - 𝒞.cᶻ₂) / i
	Ccᶻ₂ = 𝒞.cᶻ₁ - Δcᶻ/2
	c₂   = √(Ccᶻ₂^2 + cᵤ₂^2)
	α₂   = atand(Ccᶻ₂ / cᵤ₂)
	wᵤ₂  = cᵤ₂ - u
	w₂   = √(Ccᶻ₂^2 + wᵤ₂^2)
	β₂   = atand(Ccᶻ₂ / (-wᵤ₂))
	ϵ    = β₂ - β₁
	Φₙ   = 𝒞.cᶻ₁ / uₙ₁
	Mʷₘ  = uₙ₁ * √(1 + Φₙ^2) / √(𝒞.kₙ * 𝒞.Rₙ * T⃰₁)
	
	(; P⃰₁, T⃰₁, P⃰ₖ, P⃰₂, ρ₁, nₖ, ρ₂, D₁, Dᵥₜ₁, Dₘ₁, l₁, F₂, ν₂, l₂, uₙ₁, H⃰ₐ, H⃰ₖ, i, kₘ, h₁, h₂, uₘ₁, Φ₁, h̄₁, otn, otm, P₀ᵍ, J, tb, tbem, u, cᵤ₁, cᵤ₂, c₁, α₁, T₁, wᵤ₁, w₁, Mʷ₁, β₁, Δcᶻ, Ccᶻ₂, c₂, α₂, wᵤ₂, w₂, β₂, ϵ, Φₙ, Mʷₘ)
end

# ╔═╡ d4a9d15f-df48-456b-9bc7-ff88a61d634f
function calc_turb(I, C, π⃰ₖ, T⃰₀, 𝒞 = CONST, 𝒯 = TASK)
	P⃰₀   = 𝒞.σ⃰ₖₛ * C.P⃰ₖ
	Nₖ   = C.H⃰ₖ * I.Gₙ
	Nₜ   = 𝒯.N + Nₖ
	Gᵧ   = I.Gₙ + I.Gₜ
	Hᵤₜ  = 𝒞.kₙₜ * Nₜ / Gᵧ
	ΔT⃰ₜ  = Hᵤₜ / 𝒞.Cpᵧ
	T⃰₂ₜ  = T⃰₀ - ΔT⃰ₜ
	aᵏʳ₂ = √( (2𝒞.kᵧ)/(𝒞.kᵧ+1) * 𝒞.Rₙ * T⃰₂ₜ )
	c₂ₜ  = 𝒞.λ₂ₜ * aᵏʳ₂
	Hₐₜ  = Hᵤₜ + c₂ₜ^2 / 2
	Hₒₜ  = Hₐₜ / 𝒞.ηₐₜ
	T⃰₂ₜₜ = T⃰₀ - Hₒₜ / 𝒞.Cpᵧ
	P₂ₜ  = P⃰₀ * (T⃰₂ₜₜ / T⃰₀)^𝒞.kk_1
	T₂T  = T⃰₂ₜ - c₂ₜ^2 / (2𝒞.Cpᵧ)
	ρ₂ₜ  = P₂ₜ / (𝒞.Rₙ * T₂T)
	F₂ₜ  = Gᵧ / (ρ₂ₜ * c₂ₜ * sind(𝒞.å))
	σₚ   = 8.9 * 𝒯.n^2 * F₂ₜ
	kₚ   = 𝒞.σ₅₀₀ / σₚ
	u₂   = (π * 𝒞.d₂ₘ * 𝒯.n) / 60
	l₂   = F₂ₜ / (π * 𝒞.d₂ₘ)
	kₘ   = 𝒞.d₂ₘ / l₂
	Y    = √(2 * u₂^2 / Hₒₜ)
	
	(; P⃰₀, Nₖ, Gᵧ, Nₜ, Hᵤₜ, ΔT⃰ₜ, T⃰₂ₜ, aᵏʳ₂, c₂ₜ, Hₐₜ, Hₒₜ, T⃰₂ₜₜ, P₂ₜ, T₂T, ρ₂ₜ, F₂ₜ, σₚ, kₚ, u₂, l₂, kₘ, Y )
end

# ╔═╡ ced360e6-6a20-462b-862f-bb68fed673cd
begin
	I = calc_prime()

	# Результат A2GTP
	π⃰ₖ  = 16
	T⃰₀  = 1693
	
	C = calc_comp(I, π⃰ₖ)
	T = calc_turb(I, C, π⃰ₖ, T⃰₀)
	
	md"Вычисление"
end

# ╔═╡ f39cfba9-db24-43ef-9cc6-dc294456a177
md"# Приложение"

# ╔═╡ 9942bf76-188a-47b7-838d-52280230aee3
begin
	function typst_vars(nt; prefix = "")
	    modified_nt = add_suffix_to_names(replace_letters_in_names(nt), prefix)

	    lines = ["#let $k = num($(v)) \n#let Raw$k = $(v)" for (k, v) in pairs(modified_nt)]
	    join(lines, "\n")
	end
	
	function replace_letters_in_names(nt::NamedTuple)
	    new_names = [Symbol(replace(String(name), 
									"₁"   => "1", 
									"₂"   => "2",
									"₃"   => "3",
									"₄"   => "4",
									"₅"   => "5",
									"₆"   => "6",
									"₇"   => "7",
									"₈"   => "8",
									"₉"   => "9",
									"₀"   => "0",
									"⃰"    => "s",
									"_"   => "",
									"ₒₚₜ" => "0",
									"¹"   => "1",
									"²"   => "2",
								   )) for name in keys(nt)]
	    return NamedTuple{Tuple(new_names)}(values(nt))
	end

	function add_suffix_to_names(nt::NamedTuple, prefix::String)
    	new_names = [Symbol(prefix * String(name)) for name in keys(nt)]
    	return NamedTuple{Tuple(new_names)}(values(nt))
	end
end

# ╔═╡ 7781971c-c446-4661-a3c6-c0409092ea02
begin
	open("vars.typ", "w") do file
    	write(file,
			  "#import \"lib.typ\": * \n \n",
			  typst_vars(TASK; prefix ="TA"), "\n \n",
			  typst_vars(CONST; prefix ="CO"), "\n \n",
			  "#let AAπsₖ = $π⃰ₖ \n#let AATs0 = $T⃰₀ \n \n",
			  typst_vars(I; prefix ="I"), "\n \n",
			  typst_vars(C; prefix ="C"), "\n \n",
			  typst_vars(T; prefix ="T"), "\n \n",
			 )
	end

	md"Запись в файл"

end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
LaTeXStrings = "~1.4.0"
PlutoUI = "~0.7.62"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.7"
manifest_format = "2.0"
project_hash = "1129e6029f64e49d4c39f44dd06fb2e0b002646d"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.MIMEs]]
git-tree-sha1 = "c64d943587f7187e751162b3b84445bbbd79f691"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.1.0"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "7d2f8f21da5db6a806faf7b9b292296da42b2810"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"

    [deps.Pkg.extensions]
    REPLExt = "REPL"

    [deps.Pkg.weakdeps]
    REPL = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "d3de2694b52a01ce61a036f18ea9c0f61c4a9230"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.62"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

    [deps.Statistics.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.Tricks]]
git-tree-sha1 = "6cae795a5a9313bbb4f60683f7263318fc7d1505"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.10"

[[deps.URIs]]
git-tree-sha1 = "cbbebadbcc76c5ca1cc4b4f3b0614b3e603b5000"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╟─6799a962-4b97-11f0-09c5-a3dd1bde673a
# ╠═dab0fc69-515a-4784-acea-e020259f25c2
# ╠═f8608c64-aead-49cb-809e-bf60b383ff1c
# ╠═fe821429-f573-4fb8-9268-54aeb6be6e49
# ╟─d4a9d15f-df48-456b-9bc7-ff88a61d634f
# ╠═ced360e6-6a20-462b-862f-bb68fed673cd
# ╟─f39cfba9-db24-43ef-9cc6-dc294456a177
# ╟─9942bf76-188a-47b7-838d-52280230aee3
# ╠═7781971c-c446-4661-a3c6-c0409092ea02
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
