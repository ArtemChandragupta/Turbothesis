### A Pluto.jl notebook ###
# v0.20.20

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 89d5d4d4-a5f0-11f0-275d-edfe9355555d
begin
	using PlutoUI
	using LaTeXStrings
	using CairoMakie
	using Statistics
	using JSON
end

# ╔═╡ 4b0d698d-7921-4bf0-b5d4-0bf680d992e5
begin
	const TASK = (
		T⃰₃ = 1643.15,  # Температура газа перед турбиной
		N  = 65e6,     # Полезная мощность турбины
		n  = 5441,     # Частота вращения  турбины
		Pₙ = 0.1013e6, # Давление    наружного воздуха
		Tₙ = 288,      # Температура наружного воздуха
		π⃰ₖ = 18,       # Степень повышения давления
		γ  = 20,       # Угол раскрытия турбины
	)

	const CONST = (
		# Газ
		Cpᵧ  = 287 * 1.33 / (1.33 - 1),
		Rᵧ   = 287,
		kᵧ   = 1.33,
		kk_1 = 1.33 / (1.33 - 1),
		k_1k = (1.33 - 1) / 1.33,

		# Воздух
		Cpₙ = 1030,
		Rₙ  = 287,
		kₙ  = 1030 / (1030 - 287),

		# КПД и т.д. - случайные числа.
		σ₁   = 0.987, # Коэфф. потерь на входном устройстве
		σ⃰ₖₛ  = 0.980, # Коэфф. потерь в камере сгорания
		σ⃰₄   = 0.985, # Коэфф. потерь в выходном устройстве
		
		ηₐ   = 0.900, # Политропный КПД компрессора
		ηₚ   = 0.870, # Политропный КПД турбины
		ηₘₜ  = 0.990, # Коэфф. мех. потерь в турбине
		ηₘₖ  = 0.990, # Коэфф. мех. потерь в компрессоре
		ηₖₛ  = 0.990, # КПД камеры сгорания

		# Константы для охладителя
		Qₙₚ  = 44.3e6,
		hₜₒₚ = 0,
		L₀   = 15,
		T̂₀   = 273.15, # Абсолютный 0
		Cpₐ  = 1200,
		Tₛₜ  = 1100,   # Допустимая температура стали
		σᵤₜ  = 1.04,   # Утечка охладителя

		# Константы для компрессора
		σ⃰ᵢₙ  = 0.99,
		σ⃰ₒᵤₜ = 0.98,
		η⃰ₐ   = 0.92, # Адиабатный КПД компрессора
		cᶻ₁  = 140,
		cᶻ₂  = 120,
		ν₁   = 0.5,
		Ω    = 0.5,
		hₘ   = 25e3,
		k₁   = 0.65,

		# Константы для турбины
		kₙₜ  = 1.04,
		λ₂ₜ  = 0.6,
		ηₐₜ  = 0.91,
		å    = 90,
		σ₅₀₀ = 610e6,
		Y    = 0.55,
		m    = 4,
	)

	md"### Задание и константы"
end

# ╔═╡ fb7eb31f-8d28-4e05-b994-29a85e359b14
md"### Расчетные функции"

# ╔═╡ b5be0f61-904f-498d-8b4d-3bb84cf62270
begin
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
		ηₑ  = (Hₜ * 𝒞.ηₘₜ - Hₖ / 𝒞.ηₘₖ) / Q₁
		φ   = (Hₜ * 𝒞.ηₘₜ - Hₖ / 𝒞.ηₘₖ) / (Hₜ * 𝒞.ηₘₜ)
	
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
		
		(; P⃰₁, T⃰₁, P⃰₂, T⃰₂, H⃰ₒₖ,	Hₖ,	P⃰₃, P⃰₄,	π⃰ₜ,	H⃰ₒₜ, Hₜ, T⃰₄, Gₙ, Q̇₁, Q₁, ηₑ, φ, 
		 t⃰₂, t⃰₃, gₐᵢᵣ, a, gₜ, gᶜc, gᵖc, gc, ĝc, Gₜ, Ωᵣₐₛ, Hₑ, Ωₐₗₗ
		 )
	end
	
	md"λ Расчет тепловой схемы"
end

# ╔═╡ 56a5a75a-20ff-443e-992a-c8a5957b7a90
begin
	function calc_comp(I, Å, 𝒞 = CONST, 𝒯 = TASK)
		P⃰₁   = 𝒞.σ⃰ᵢₙ * 𝒯.Pₙ
		T⃰₁   = 𝒯.Tₙ
		P⃰ₖ   = 𝒯.Pₙ * Å.π⃰ₖ
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
		H⃰ₐ   = (𝒞.kₙ / (𝒞.kₙ-1)) * 𝒞.Rₙ * T⃰₁ * ( (P⃰₂/P⃰₁)^( (𝒞.kₙ-1)/𝒞.kₙ) - 1 )
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
	
	md"λ Расчет компрессора"
end

# ╔═╡ 40561c16-193e-4349-bc16-a7d9ceb55f62
begin
	function calc_turb(I, C, Å, 𝒞 = CONST, 𝒯 = TASK)
		P⃰₀   = 𝒞.σ⃰ₖₛ * C.P⃰ₖ
		Nₖ   = C.H⃰ₖ * I.Gₙ
		Nₜ   = 𝒯.N + Nₖ
		Gᵧ   = I.Gₙ + I.Gₜ
		Hᵤₜ  = 𝒞.kₙₜ * Nₜ / Gᵧ
		ΔT⃰ₜ  = Hᵤₜ / 𝒞.Cpᵧ
		T⃰₂ₜ  = Å.T⃰₀ - ΔT⃰ₜ
		aᵏʳ₂ = √( (2𝒞.kᵧ)/(𝒞.kᵧ+1) * 𝒞.Rᵧ * T⃰₂ₜ )
		c₂ₜ  = 𝒞.λ₂ₜ * aᵏʳ₂
		Hₐₜ  = Hᵤₜ + c₂ₜ^2 / 2
		Hₒₜ  = Hₐₜ / 𝒞.ηₐₜ
		T⃰₂ₜₜ = Å.T⃰₀ - Hₒₜ / 𝒞.Cpᵧ
		P₂ₜ  = P⃰₀ * (T⃰₂ₜₜ / Å.T⃰₀)^𝒞.kk_1
		T₂T  = T⃰₂ₜ - c₂ₜ^2 / (2𝒞.Cpᵧ)
		ρ₂ₜ  = P₂ₜ / (𝒞.Rᵧ * T₂T)
		F₂ₜ  = Gᵧ / (ρ₂ₜ * c₂ₜ * sind(𝒞.å))
		σₚ   = 8.9 * 𝒯.n^2 * F₂ₜ
		kₚ   = 𝒞.σ₅₀₀ / σₚ
		d₂ₘ  = 60 * 𝒞.Y / (π * 𝒯.n) * √(Hₒₜ / 2)
		u₂   = π * d₂ₘ * 𝒯.n / 60
		l₂   = F₂ₜ / (π * d₂ₘ)
		kₘ   = d₂ₘ / l₂
		
		(; P⃰₀, Nₖ, Gᵧ, Nₜ, Hᵤₜ, ΔT⃰ₜ, T⃰₂ₜ, aᵏʳ₂, c₂ₜ, Hₐₜ, Hₒₜ, T⃰₂ₜₜ, P₂ₜ, T₂T, ρ₂ₜ, F₂ₜ, σₚ, kₚ, d₂ₘ, u₂, l₂, kₘ)
	end
	
	md"λ Расчет турбины простой"
end

# ╔═╡ 692ea0cf-2fc9-47fb-9542-930c64ac94bc
begin
	function build_geometry(T, 𝒯 = TASK)
		ah = 4 # Отношение высоты лопатки к её толщине
		aw = 3 # Отношение толщины лопатки к расстоянию между двумя лопатками
		β  = 3 # Угол сужения лопатки
	
		ll₁ = zeros(8)
		xl₁ = zeros(8)
		ll₂ = zeros(8)
		xl₂ = zeros(8)
	
		# Сопловые лопатки 1 и рабочие лопатки 2 состоят из 2-х ребер, поэтому всего точек 8, а не 4, как ступеней.
	
		# Задняя кромка последней рабочей лопатки
		ll₂[8] = T.l₂ * (1 + tand(𝒯.γ) * tand(β))
		xl₂[8] = 0
	
		for n in 4:-1:1
			# Передняя кромка n-ной рабочей лопатки
			xl₂[2n-1] = xl₂[2n] - ll₂[2n] / ah
			ll₂[2n-1] =  ll₂[8] + tand(𝒯.γ) * xl₂[2n-1]
			# Задняя кромка n-ной сопловой лопатки
			xl₁[2n] = xl₂[2n-1] + (xl₂[2n-1] - xl₂[2n]) / aw
			ll₁[2n] = ll₂[8] + tand(𝒯.γ) * xl₁[2n]
			# Передняя кромка n-ной сопловой лопатки
			xl₁[2n-1] = xl₁[2n] - ll₁[2n] / ah
			ll₁[2n-1] = ll₂[8] + tand(𝒯.γ) * xl₁[2n-1]
	
			# Задняя кромка n-1-ой рабочей лопатки. На первой ступени такой нет
			if n>1
				xl₂[2n-2] = xl₁[2n-1] - (xl₁[2n] - xl₁[2n-1]) / aw
				ll₂[2n-2] = ll₂[8] + tand(𝒯.γ) * xl₂[2n-2]	
			end
		end
	
		# Переворачиваем координаты на натуральные
		xl₂ .-= xl₁[1]
		xl₁ .-= xl₁[1]
	
		
	
		(; ll₁, xl₁, ll₂, xl₂, β)
	end
	
	md"λ Определение геометрии продольного разреза"
end

# ╔═╡ 77bbea27-c0fa-4320-ab84-ff91730410e3
begin
	function calc_G(G, T; 𝒞 = CONST, 𝒯 = TASK)
		P⃰₀    = T.P⃰₀
		d₂ₘ   = T.d₂ₘ
		HuT   = T.Nₜ * 𝒞.kₙₜ / G
		ΔtT   = HuT / 𝒞.Cpᵧ
	    T⃰₂T   = 𝒯.T⃰₃ - ΔtT
	    aₖᵣ   = √(2𝒞.kᵧ / (𝒞.kᵧ + 1) * 𝒞.Rᵧ * T⃰₂T)
	    c₂T   = aₖᵣ * 𝒞.λ₂ₜ
	    Hₐₜ   = HuT + c₂T^2 / 2
	    H₀T   = Hₐₜ / 𝒞.ηₐₜ
	    T₂tT  = 𝒯.T⃰₃ - H₀T / 𝒞.Cpᵧ
	    p₂T   = T.P⃰₀ * (T₂tT / 𝒯.T⃰₃)^𝒞.kk_1
	    T₂T   = T⃰₂T - c₂T^2 / 2𝒞.Cpᵧ
	    ρ₂T   = p₂T / (T₂T * 𝒞.Rᵧ)
	    F₂T   = G / (ρ₂T * c₂T * sind(𝒞.å))
	    σ_p   = 0.89 * 𝒯.n^2 * F₂T
	    u₂    = π * d₂ₘ * 𝒯.n / 60
	    l₂    = F₂T / (π * d₂ₘ)
	    d₂Tl₂ = d₂ₘ / l₂
	    Y     = u₂ * √(𝒞.m / 2H₀T)
	
		(; P⃰₀, d₂ₘ, HuT, ΔtT, T⃰₂T, aₖᵣ, c₂T, Hₐₜ, H₀T, T₂tT, p₂T, T₂T, ρ₂T, F₂T, σ_p, u₂, l₂, d₂Tl₂, Y )
	end
	
	md"λ Вспомогательный расчет турбины для определения оптимального расхода"
end

# ╔═╡ 7290e07c-eedc-429f-a2fa-7130dae8da37
begin
	function stage_params(T, P₂, Φ, Ψ, l̄, 𝒯 = TASK)
		l₁  = (l̄.ll₁[2], l̄.ll₁[4], l̄.ll₁[6], l̄.ll₁[8]) # Задней кромки сл
		l₂  = (l̄.ll₂[2], l̄.ll₂[4], l̄.ll₂[6], l̄.ll₂[8]) # Задней кромки рл
		l₂₁ = (l̄.ll₂[1], l̄.ll₂[3], l̄.ll₂[5], l̄.ll₂[7]) # Передней кромки рл
		b₂  = (l̄.xl₂[2]-l̄.xl₂[1], l̄.xl₂[4]-l̄.xl₂[3], l̄.xl₂[6]-l̄.xl₂[5], l̄.xl₂[8]-l̄.xl₂[7]) # Ширина рабочей лопатки
		
		p₂ = P₂
	
		d₁ₘ = @. T.d₂ₘ - T.l₂ + l₁
		d₂ₘ = @. T.d₂ₘ - T.l₂ + l₂
	
		n = 0.6
	
		rk = (T.d₂ₘ - T.l₂)/2
		rₘ = @. d₂ₘ / 2
	
		ρTk = 0.07
		ρTc = @. 1 - (1 - ρTk) * (rk/rₘ)^(2n) * Φ^2
	
		stages = [
			(n   = n,
	     	 rk  = rk,
	         rₘ  = rₘ[i],
	     	 l₁  = l₁[i],
	    	 l₂  = l₂[i],
			 l₂₁ = l₂₁[i],
			 b₂  = b₂[i],
			 p₂  = p₂[i],
	         d₁ₘ = d₁ₘ[i],
			 d₂ₘ = d₂ₘ[i],
			 Φ   = Φ,
			 Ψ   = Ψ[i],
			 ρTc = ρTc[i]
			) for i in 1:4
		]
	
		(stages[1], stages[2], stages[3], stages[4])
	end
	
	md"λ Подготовка параметров ступеней"
end

# ╔═╡ c2b940ae-7013-4184-916f-cc2c6c3bb718
begin
	function calc_stages(G, T, Params, 𝒯 = TASK)
		S1 = calc_stage( T.P⃰₀,  𝒯.T⃰₃, G, Params[1])
		S2 = calc_stage(S1.p⃰₂, S1.T⃰₂, G, Params[2])
		S3 = calc_stage(S2.p⃰₂, S2.T⃰₂, G, Params[3])
		S4 = calc_stage(S3.p⃰₂, S3.T⃰₂, G, Params[4])

		H = S1.Hᵤ + S2.Hᵤ + S3.Hᵤ + S4.Hᵤ
	
		return (S1, S2, S3, S4, H)
	end
	
	function calc_stage(p⃰₀, T⃰₀, G, 𝒫, 𝒞 = CONST, 𝒯 = TASK)
		p₂   = 𝒫.p₂
		H₀   = 𝒞.Cpᵧ * T⃰₀ * (1 - (p₂/p⃰₀)^𝒞.k_1k )
		T₂tt = T⃰₀ - H₀ / 𝒞.Cpᵧ
		c₁t  = √( 2(1 - 𝒫.ρTc) * H₀)
		c₁   = c₁t * 𝒫.Φ
		T₁t  = T⃰₀ - c₁t^2 / 2𝒞.Cpᵧ
		p₁   = p⃰₀ * (T₁t / T⃰₀)^𝒞.kk_1
		T₁   = T⃰₀ - c₁^2 / 2𝒞.Cpᵧ
		ρ₁   = p₁ / (𝒞.Rᵧ * T₁)
		F₁r  = G * 𝒞.Rᵧ * T₁ / (p₁ * c₁)
		F₁   = π * 𝒫.d₁ₘ * 𝒫.l₁
		α₁   = asind(F₁r / F₁)
		c₁u  = c₁ * cosd(α₁)
		c₁z  = c₁ * sind(α₁)
		u₁   = π * 𝒫.d₁ₘ * 𝒯.n / 60
		u₂   = π * 𝒫.d₂ₘ * 𝒯.n / 60
		w₁u  = c₁u - u₁
		w₁   = √(c₁z^2 + w₁u^2)
		β₁   = atand(c₁z / w₁u)
		T⃰w₁  = T₁ + w₁^2 / 2𝒞.Cpᵧ
		p⃰w₁  = p₁ * (T⃰w₁/T₁)^𝒞.kk_1
		T⃰w₂  = T⃰w₁ - (u₁^2 - u₂^2) / 2𝒞.Cpᵧ
		p⃰w₂t = p⃰w₁ * (T⃰w₂ / T⃰w₁)^𝒞.kk_1
		H⃰₂   = 𝒞.Cpᵧ * T⃰w₂ *(1 - (p₂ / p⃰w₂t)^𝒞.k_1k)
		w₂t  = √(2H⃰₂)
		w₂   = w₂t * 𝒫.Ψ
		T₂   = T⃰w₁ - w₂^2 / 2𝒞.Cpᵧ
		F₂r  = G * 𝒞.Rᵧ * T₂ / (p₂ * w₂)
		F₂   = π * 𝒫.d₂ₘ * 𝒫.l₂
		β⃰₂   = asind(F₂r/F₂)
		w₂u  = w₂ * cosd(β⃰₂)
		c₂z  = w₂ * sind(β⃰₂)
		c₂u  = u₂ - w₂u
		α₂   = atand(c₂z / c₂u)
		c₂   = √(c₂z^2 + c₂u^2)
		T⃰₂   = T₂ + c₂^2 / 2𝒞.Cpᵧ
		p⃰₂   = p₂ * (T⃰₂ / T₂)^𝒞.k_1k
		Mc₁  = c₁ / √(𝒞.kᵧ * 𝒞.Rᵧ * T₁)
		Mw₂  = w₂ / √(𝒞.kᵧ * 𝒞.Rᵧ * T₂)
		T⃰₂tt = T₂tt * (p⃰₂/p₂)^𝒞.k_1k
		ηᵤ   = (T⃰₀ - T⃰₂)/(T⃰₀ - T₂tt)
		η⃰ᵤ   = (T⃰₀ - T⃰₂)/(T⃰₀ - T⃰₂tt)
		Hᵤ   = (T⃰₀ - T⃰₂) * 𝒞.Cpᵧ
	
		(; p⃰₀, T⃰₀, p₂, H₀, T₂tt, c₁t, c₁, T₁t, p₁, T₁, ρ₁, F₁r, F₁, α₁, c₁u, c₁z, u₁, u₂, w₁u, w₁, β₁, T⃰w₁, p⃰w₁, T⃰w₂, p⃰w₂t, H⃰₂, w₂t, w₂, T₂, F₂r, F₂, β⃰₂, w₂u, c₂z, c₂u, α₂, c₂, T⃰₂, p⃰₂, Mc₁, Mw₂, T⃰₂tt, ηᵤ, η⃰ᵤ, Hᵤ)
	end

	md"λ Расчет по ступеням"
end

# ╔═╡ 65781f50-667a-44c0-beb2-466dfb293d36
begin
	function find_Gₒₚₜ(T, P₂, Φ, Ψ, l̄)
	
		G➞ = range(T.Gᵧ - 40, T.Gᵧ + 40, length = 500)
		T➞ = map(G -> calc_G(G, T), G➞)
		
		Params➞ = [stage_params(Tᵢ, P₂, Φ, Ψ, l̄) for Tᵢ in T➞]
	    𝒮  = calc_stages.(G➞, T➞, Params➞)
	    𝒮₄ = [s[4] for s in 𝒮 ]
		ᾱ₂ = [s.α₂ for s in 𝒮₄]
		H➞ = [s[5] for s in 𝒮 ]
	
		Gₒₚₜ = (G➞[argmax(ᾱ₂)] + G➞[argmin(ᾱ₂)])/2
		Hᵢ   = (H➞[argmax(ᾱ₂)] + H➞[argmin(ᾱ₂)])/2
	
		(Gₒₚₜ, Hᵢ)
	end
	
	md"λ Поиск оптимального расхода для конкретных Φ и Ψ"
end

# ╔═╡ ec47fa62-62ea-4bf8-a57f-9e6b10b5fa0b
begin
	function find_GΦΨ(T, Φ➞, Ψ➞, P₂, l̄)
		results = []
		good_results = []
	
		for Φᵢ in Φ➞
			for Ψᵢ in Ψ➞
				(Gᵢ, Hᵢ) = find_Gₒₚₜ(T, P₂, Φᵢ, (Ψᵢ, Ψᵢ, Ψᵢ, Ψᵢ), l̄)
				if abs(Gᵢ - T.Gᵧ) < 0.01
					push!(good_results, (Gᵢ, Φᵢ, Ψᵢ, Hᵢ))
				end
				push!(results, (Gᵢ, Φᵢ, Ψᵢ, Hᵢ))
			end
		end
	
		Δₘᵢₙ = Inf
		best_result = nothing
	
		for res in good_results
	    	Δᵢ = abs(res[4]*T.Gᵧ/CONST.kₙₜ - T.Nₜ)
	    	if Δᵢ < Δₘᵢₙ
	        	Δₘᵢₙ = Δᵢ
	        	best_result = res
	    	end
		end
	
		(best_result, results)
	end
	
	md"λ Варьирование Φ и Ψ"
end

# ╔═╡ 3e5014a8-e39f-4d3c-bb2f-122dea8482bb
begin
	function swirl_reverse(Params, mid, swirl_params)
		ɤ = calc_ɤ(Params, mid, swirl_params)
		
		r3 = calc_swirl_mid(Params,         mid, ɤ)
		
		r1 = calc_swirl(1,  Params, 0,      mid, ɤ)
		r2 = calc_swirl(2,  Params, r1.w₂u, mid, ɤ)
		r4 = calc_swirl(4,  Params, r1.w₂u, mid, ɤ)
		r5 = calc_swirl(5,  Params, r1.w₂u, mid, ɤ)

		a = ( (r5.ρK-r1.ρK) * r3.r - r3.ρK * (r5.r-r1.r) - r5.ρK * r1.r + r1.ρK * r5.r ) / ((r5.r-r1.r) * (r5.ρK-r1.ρK) * (r5.r-r3.r) ) 
		b = (r3.ρK-r1.ρK - a*(r3.r-r1.r)^2) / (r3.r-r1.r)
		c = r1.ρK

		ρKp1 = a * (r1.r-r1.r)^2 + b * (r1.r-r1.r) + c
		ρKp2 = a * (r2.r-r1.r)^2 + b * (r2.r-r1.r) + c
		ρKp3 = a * (r3.r-r1.r)^2 + b * (r3.r-r1.r) + c
		ρKp4 = a * (r4.r-r1.r)^2 + b * (r4.r-r1.r) + c
		ρKp5 = a * (r5.r-r1.r)^2 + b * (r5.r-r1.r) + c

		R1 = merge(r1, (ρKp = ρKp1, Δρ = ρKp1 - r1.ρK))
		R2 = merge(r2, (ρKp = ρKp2, Δρ = ρKp2 - r2.ρK))
		R3 = merge(r3, (ρKp = ρKp3, Δρ = ρKp3 - r3.ρK))
		R4 = merge(r4, (ρKp = ρKp4, Δρ = ρKp4 - r4.ρK))
		R5 = merge(r5, (ρKp = ρKp5, Δρ = ρKp5 - r5.ρK))
	
		return (; R = (R1, R2, R3, R4, R5), a, b, c, ɤ)
	end

	function calc_ɤ(𝒫, 𝓜, swirl_params, 𝒞 = CONST, 𝒯 = TASK)
		γ  = 𝒯.γ
		α₁ = swirl_params.α₁
		β⃰₂ = swirl_params.β⃰₂
		F  = swirl_params.F
		ρK = swirl_params.ρK
		
		n₁ = log(tand(α₁)/tand(𝓜.α₁)) / log(𝒫.rₘ/ (𝒫.rₘ + 𝒫.l₂/2))
		n₂ = log(tand(𝓜.β⃰₂)/tand(β⃰₂)) / log((𝒫.rₘ + 𝒫.l₂/2)/ 𝒫.rₘ)
		b₁ = (𝒫.rₘ + 𝒫.l₂/2)^n₁ * tand(α₁)
		b₂ = 𝒫.rₘ^n₂ * tand(𝓜.β⃰₂)
		A  = (F * 𝓜.c₁z)/(𝒫.l₂/2)
		B  = 𝓜.c₁z - A * 𝒫.rₘ
		χ¹ = 𝓜.p₁ * (𝓜.T⃰₀  / 𝓜.T₁)^𝒞.kk_1 / 𝓜.p⃰₀
		χ² = 𝓜.p₂ * (𝓜.T⃰w₂ / 𝓜.T₂)^𝒞.kk_1 / 𝓜.p⃰w₂t

		(; α₁, F, γ, ρK, β⃰₂, n₁, n₂, b₁, b₂, A, B, χ¹, χ²)
	end

	function calc_swirl_mid(𝒫, 𝓜, ɤ, 𝒞 = CONST)
		r    = 𝒫.rₘ
		b    = 𝒫.b₂
		γ    = ɤ.γ/2
		c₁   = 𝓜.c₁
		α₁   = 𝓜.α₁
		c₁u  = 𝓜.c₁u
		c₁z  = 𝓜.c₁z
		c₁r  = c₁z * tand(γ)
		u₁   = 𝓜.u₁
		u₂   = 𝓜.u₂
		β₁   = 𝓜.β₁
		w₁   = 𝓜.w₁
		w₁u  = c₁u - u₁
		w₂u  = -u₂
		c₂u  = 𝓜.c₂u
		c₂z  = 𝓜.c₂z
		c₂   = 𝓜.c₂
		c₂r  = 𝓜.c₂z * tand(γ)
		α₂   = 𝓜.α₂
		β⃰₂   = 𝓜.β⃰₂
		w₂   = 𝓜.w₂
		T₁   = 𝓜.T₁
		p₁   = 𝓜.p₁
		ρ₁   = 𝓜.ρ₁
		T⃰w₁  = 𝓜.T⃰w₁
		T₂   = 𝓜.T₂
		p₂   = 𝓜.p₂
		ρ₂   = p₂ / (T₂ * 𝒞.Rᵧ)
		πρc₁ = 2π * ρ₁ * c₁z * r
		πρc₂ = 2π * ρ₂ * c₂z * r
		ρT   = 𝒫.ρTc
		Hₚ   = (w₂^2 - w₁^2)/2 + (u₁^2 - u₂^2)/2
		Hᵤ   = (c₁^2 - c₂^2)/2 + (w₂^2 - w₁^2)/2 + (u₁^2 - u₂^2)/2
		ρK   = Hₚ / Hᵤ

		(; r, b, γ, c₁, α₁, c₁u, c₁z, c₁r, u₁, u₂, β₁, w₁, w₁u, w₂u, c₂u, c₂z, c₂, c₂r, α₂, β⃰₂, w₂, T₁, p₁, ρ₁, T⃰w₁, T₂, p₂, ρ₂, πρc₁, πρc₂, ρT, Hₚ, Hᵤ, ρK)
	end

	function calc_swirl(№, 𝒫, w₂u_R1, 𝓜, ɤ, 𝒞 = CONST, 𝒯 = TASK)
		r    = 𝒫.rk + 𝒫.l₂ * (№-1)/4
		b    = 𝒫.b₂
		γ    = ɤ.γ * (№-1)/4
		α₁   = atand(ɤ.b₁ / (r^ɤ.n₁))
		c₁z  = r * ɤ.A + ɤ.B
		c₁u  = c₁z / tand(α₁)
		c₁r  = c₁z * tand(γ )
		c₁   = √(c₁z^2 + c₁u^2 + c₁r^2)
		u₁   = 2π * (𝒫.rk + 𝒫.l₁ * (№-1)/4) * 𝒯.n / 60
		u₂   = 2π * r * 𝒯.n / 60
		w₁u  = c₁u - u₁
		β₁   = atand(c₁z / w₁u)
		w₁   = c₁z / sind(β₁)
		w₂u  = № == 1 ? (-(u₁*w₁u+2u₂^2*ɤ.ρK)/u₂) : w₂u_R1+(-𝓜.u₂-w₂u_R1)*(№-1)/2
		c₂u  = w₂u + u₂
		β⃰₂   = atand(ɤ.b₂ / r^ɤ.n₂)
		c₂z  = -w₂u * tand(β⃰₂)
		c₂r  =  c₂z * tand(γ )
		c₂   = √(c₂z^2 + c₂u^2 + c₂r^2)
		α₂   = atand(c₂z / c₂u)
		w₂   = c₂z / sind(β⃰₂)
		T₁   = 𝓜.T⃰₀ - c₁^2 / 2𝒞.Cpᵧ
		p₁   = 𝓜.p⃰₀ * ɤ.χ¹ * (1 - c₁^2 / (𝒞.kk_1 * 2𝒞.Rᵧ * 𝓜.T⃰₀) )^𝒞.kk_1
		ρ₁   = p₁ / (𝒞.Rᵧ * T₁)
		T⃰w₁  = T₁  + w₁^2 / 2𝒞.Cpᵧ
		T₂   = T⃰w₁ - w₂^2 / 2𝒞.Cpᵧ
		p₂   = 𝓜.p⃰₀ * ɤ.χ¹ * ɤ.χ² * (1-(c₁^2+w₂^2-w₁^2)/(𝒞.kk_1*2𝒞.Rᵧ*𝓜.T⃰₀))^𝒞.kk_1
		ρ₂   = p₂ / (T₂ * 𝒞.Rᵧ)
		πρc₁ = 2π * ρ₁ * c₁z * r
		πρc₂ = 2π * ρ₂ * c₂z * r
		ρT   = ( (p₁/𝓜.p⃰₀)^𝒞.k_1k - (p₂/𝓜.p⃰₀)^𝒞.k_1k ) / (1 - (p₂/𝓜.p⃰₀)^𝒞.k_1k )
		Hₚ   = (w₂^2 - w₁^2)/2 + (u₁^2 - u₂^2)/2
		Hᵤ   = (c₁^2 - c₂^2)/2 + (w₂^2 - w₁^2)/2 + (u₁^2 - u₂^2)/2
		ρK   = № == 1 ? ɤ.ρK : Hₚ / Hᵤ

		(; r, b, γ, c₁, α₁, c₁u, c₁z, c₁r, u₁, u₂, β₁, w₁, w₁u, w₂u, c₂u, c₂z, c₂, c₂r, α₂, β⃰₂, w₂, T₁, p₁, ρ₁, T⃰w₁, T₂, p₂, ρ₂, πρc₁, πρc₂, ρT, Hₚ, Hᵤ, ρK)
	end
	md"λ Расчет обратной закрутки"
end

# ╔═╡ e24903de-8706-4d29-aaf0-2005799675e1
begin
	I = calc_prime()

	# Результат A2GTP
	Å = (π⃰ₖ = 16, T⃰₀ = 1643, Gₙ = 173.363, Gᵧ = 155.083)
	
	C = calc_comp(I, Å)
	T = calc_turb(I, C, Å)
	
	md"### ∮ Первичный расчет"
end

# ╔═╡ 4e7e1ddb-8a03-4818-be9e-fa31698faf07
begin
	P₂ = (900_000, 480_000, 230_000, T.P₂ₜ)
	# πₜ = (T.P₂ₜ / T.P⃰₀)^(1/4)
	# P₂ = (T.P⃰₀*πₜ, T.P⃰₀*πₜ^2, T.P⃰₀*πₜ^3, T.P⃰₀*πₜ^4)
	Φ➞ = range(0.94, 0.98, length=200)
	Ψ➞ = range(0.94, 0.98, length=200)

	l̄ = build_geometry(T)
	((Gₒₚₜ, Φ, Ψ), Ḡ) = find_GΦΨ(T, Φ➞, Ψ➞, P₂, l̄)
	P = stage_params(T, P₂, Φ, (Ψ,Ψ,Ψ,Ψ), l̄)
	S = calc_stages(Gₒₚₜ, T, P)
	
	md"### ∮ Расчет по ступеням"
end

# ╔═╡ 23866f8f-bdff-45be-afcd-91d3c87a200e
begin
	function find_FρK_threaded(α₁, β⃰₂, F_range, ρK_range)
	    T = @NamedTuple{F::Float64, ρK::Float64, σ::Float64, Δρ::Float64}
	    tasks = []
	    
	    F_list = collect(F_range)
	    
	    for chunk_start in 1:6:length(F_list)  # 6 потоков
	        chunk_end = min(chunk_start + 5, length(F_list))
	        chunk = F_list[chunk_start:chunk_end]
	        
	        task = Threads.@spawn begin
	            local_valid = T[]
	            for F in chunk
	                for ρK in ρK_range
	                    Params = (; α₁, F, ρK, β⃰₂)
	                    RR, a, b, c, ɤ = swirl_reverse(P[4], S[4], Params)
	                    Δρ = sum(r.Δρ for r in RR)
	                    p̄  = [r.p₂ for r in RR]
	
	                    if abs(Δρ) < 0.1 &&
	                    all(p̄[i] < p̄[i+1] for i in 1:4) &&
	                    all(RR[i].ρT < RR[i+1].ρT for i in 1:4) &&
	                    all(RR[i].ρK < RR[i+1].ρK for i in 1:4)
	                        
	                        pₘ = (p̄[5] - p̄[1]) / 5
	                        σ  = (abs(p̄[1]-pₘ) + abs(p̄[2]-pₘ) + abs(p̄[3]-pₘ) + abs(p̄[4]-pₘ) + abs(p̄[5]-pₘ)) / 5pₘ
	                        
	                        result = (; F, ρK, σ, Δρ)
	                        push!(local_valid, result)
	                    end
	                end
	            end
	            local_valid
	        end
	        push!(tasks, task)
	    end
	    
	    results = fetch.(tasks)
	    return reduce(vcat, results)
	end
	
	md"λ Варьирование для закрутки потока - когда многопоточность сломана"
end

# ╔═╡ cfbd1033-b649-4ab2-941a-1519bcc28986
begin
	function find_FρK_threaded_1(α₁, β⃰₂, F_range, ρK_range)
	    T = @NamedTuple{F::Float64, ρK::Float64, σ::Float64, Δρ::Float64}
		nthreads = Threads.nthreads()
	    valid_parts = [T[] for _ in 1:nthreads]
	    
	    Threads.@threads for F in F_range
	        tid = Threads.threadid()
	        local_valid = valid_parts[tid]
	        
	        for ρK in ρK_range
	            Params = (; α₁, F, ρK, β⃰₂)
	            RR, a, b, c, ɤ = swirl_reverse(P[4], S[4], Params)
				Δρ = sum(r.Δρ for r in RR)
				p̄  = [r.p₂ for r in RR]
	
	            if abs(Δρ) < 0.1 &&
				all(p̄[i] < p̄[i+1] for i in 1:4) &&
				all(RR[i].ρT < RR[i+1].ρT for i in 1:4) &&
				all(RR[i].ρK < RR[i+1].ρK for i in 1:4)
					
					pₘ = (p̄[5] - p̄[1]) / 5
					σ  = (abs(p̄[1]-pₘ) + abs(p̄[2]-pₘ) + abs(p̄[3]-pₘ) + abs(p̄[4]-pₘ) + abs(p̄[5]-pₘ)) / 5pₘ
					
	                result = (; F, ρK, σ, Δρ)
	                push!(local_valid, result)
					
	            end
	        end
	    end
	    
	    return reduce(vcat, valid_parts)
	end
	
	md"λ Варьирование для закрутки потока"
end

# ╔═╡ 7e4039e8-ed6c-46eb-a079-9df82d4272d6
@bind Cα₁ PlutoUI.NumberField(13:33, default=30)

# ╔═╡ d1889b73-726a-468b-9bb9-e69cd81a796b
@bind Cβ⃰₂ PlutoUI.NumberField(15:65, default=37)

# ╔═╡ 6316022b-a071-4d6b-be2a-d786c8edad45
begin
	#Cα₁ = 31
	#Cβ⃰₂ = 39
	
	F_range  = range(-0.5, 0  , length=400)
	ρK_range = range(0.2 , 0.5, length=400)
	
	valid_FρK = find_FρK_threaded(Cα₁, Cβ⃰₂, F_range, ρK_range)
	filtered_FρK = argmin(p -> p.σ, filter(p -> abs(p.Δρ) < 0.01, valid_FρK))
	
	md"### ∮ Поиск _хороших_ значений ρk и F"
end

# ╔═╡ 43b474fc-51fa-4aef-86fa-cba0eb59bcf9
begin
	(α₁, β⃰₂, F, ρK) = (Cα₁, Cβ⃰₂, filtered_FρK[1], filtered_FρK[2])

	swirl_params = (; α₁, F, ρK, β⃰₂)
	R, a, b, c, ɤ = swirl_reverse(P[4], S[4], swirl_params)
	
	md"### ∮ Обратная закрутка"
end

# ╔═╡ b0aa65a1-3433-4b48-9196-d47e6e35379e
md"# Приложение"

# ╔═╡ 7e82ca6c-5c36-4c0d-ba07-914ff604f107
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

	md"ʧ Парсер для typst"
end

# ╔═╡ 48f45b5a-03af-4b1c-bdb9-16964246e85c
md"### 📊 Графики"

# ╔═╡ 8fd74453-354f-4cae-8e46-c310abdc6b5b
begin
	function plot_geometry(l̄)
		with_theme(theme_latexfonts()) do
			
			viridis_cmap = cgrad(:viridis)
	        color1 = viridis_cmap[0.1]
	        color2 = viridis_cmap[0.8]
			
			fig = Figure(size=(800, 400))
			ax = Axis(fig[1,1],aspect = DataAspect(), title = "Продольное сечение")
			
			for i in 1:Int(length(l̄.ll₁)/2)
				poly!(ax, color = color1, Point2f[
					(l̄.xl₁[2i  ], 0          ), (l̄.xl₁[2i  ], l̄.ll₁[2i]), 
					(l̄.xl₁[2i-1], l̄.ll₁[2i-1]), (l̄.xl₁[2i-1], 0        )
				])
			end
	
			for i in 1:Int(length(l̄.ll₁)/2)
				poly!(ax, color = color2, Point2f[
					(l̄.xl₂[2i  ], 0          ), (l̄.xl₂[2i  ], l̄.ll₂[2i]),
					(l̄.xl₂[2i-1], l̄.ll₂[2i-1]), (l̄.xl₂[2i-1], 0        )
				])
			end
	
			fig
		end
	end
	md"👁 Отображение продольного сечения"
end

# ╔═╡ 1f21d0d2-43a3-489b-9b77-d09d0824f799
plot_geometry(l̄)

# ╔═╡ 18159b8a-c05b-4191-9eae-71f7b7646e7d
begin
	function plot_Ḡ(Ḡ, Φ, Ψ, T)
		with_theme(theme_latexfonts()) do
			G_values = [G[1] for G in Ḡ]
			Φ_values = [G[2] for G in Ḡ]
			Ψ_values = [G[3] for G in Ḡ]
			H_values = [G[4]*G[1]/ CONST.kₙₜ for G in Ḡ]
		
			G_matrix = reshape(G_values, (length(Ψ➞), length(Φ➞)))'
			H_matrix = reshape(H_values, (length(Ψ➞), length(Φ➞)))'
		
			fig = Figure()
			ax = Axis(fig[1, 1], xlabel = "Φ", ylabel = "Ψ")
			hm = heatmap!(ax, Φ➞, Ψ➞, G_matrix, interpolate = true)
			Colorbar(fig[1, 2], hm, label = L"G_{opt}", minorticksvisible=true)
	
			contour!(ax, Φ➞,Ψ➞,G_matrix, levels = [T.Gᵧ], color = "#e75480" )
			contour!(ax, Φ➞,Ψ➞,H_matrix, levels = [T.Nₜ], color = "#b8860b" )
			scatter!(ax, Φ, Ψ, color = "#e75480", markersize=8)
	
			save("assets/G.svg", fig)
		
			fig
		end
	end
	md"👁 Отображение поиска оптимальных Φ и Ψ"
end

# ╔═╡ 4acc88bf-4bbf-49b5-8006-920901d8ddc9
plot_Ḡ(Ḡ, Φ, Ψ, T)

# ╔═╡ 6cf7f12e-cc58-4b08-816b-584e02dbd071
begin
	function plot_tooth(valid_params, F_range, ρK_range, filtered_FρK)
	
	    function fill_matrix(field)
	        matrix = fill(NaN, (length(ρK_range), length(F_range)))
	        for param in valid_params
	            i = findfirst(==(param.F), F_range)
	            j = findfirst(==(param.ρK), ρK_range)
	            if i !== nothing && j !== nothing
	                matrix[j, i] = getfield(param, field)
	            end
	        end
	        return matrix
	    end
	
	    σ_matrix  = fill_matrix(:σ )
	    Δρ_matrix = fill_matrix(:Δρ)
	
	    with_theme(theme_latexfonts()) do
	        fig = Figure(size=(800, 400))
	
	        # Общие настройки для осей
	        axis_settings = (
	            xminorticksvisible = true, xminorgridvisible = true,
	            xminorticks = IntervalsBetween(10),
	            yminorticksvisible = true, yminorgridvisible = true,
	            yminorticks = IntervalsBetween(10),
	        )
	
	        # График для среднеквадратичного отклонения
	        ax1 = Axis(fig[1, 1];
	            ylabel = L"F",
	            xlabel = L"\rho_K",
	            title  = L"\sigma ($\alpha_1 = %$(Cα₁)$, $\beta^*_2 = %$(Cβ⃰₂)$)",
	            axis_settings...
	        )
	        hm1 = heatmap!(ax1, ρK_range, F_range, σ_matrix, rasterize = true)
	        Colorbar(fig[1, 2], hm1, label="σ", width=15)
	        scatter!(ax1, filtered_FρK[2], filtered_FρK[1], color=:red, markersize=8)
	
	        # График для разницы полиномиальной и нормальной степени реактивности
	        ax2 = Axis(fig[1, 3];
	            xlabel = L"\rho_K",
	            title  = L"$\Delta \rho$ ($\alpha_1 = %$(Cα₁)$, $\beta^*_2 = %$(Cβ⃰₂)$)",
	            axis_settings...
	        )
	        hm2 = heatmap!(ax2, ρK_range, F_range, abs.(Δρ_matrix), rasterize=true)
	        Colorbar(fig[1, 4], hm2, label=L"\Delta", width=15)
	        scatter!(ax2, filtered_FρK[2], filtered_FρK[1], color=:red, markersize=8)
	
	        colgap!(fig.layout, 1, 10)
	        colgap!(fig.layout, 3, 10)
	        
			save("assets/var.svg", fig)
	        fig
	    end
	end
	md"👁 Отображение поиска параметров закрутки"
end

# ╔═╡ d51bd461-3106-4b8d-9d3a-66c7fb6c8ab1
plot_tooth(valid_FρK, F_range, ρK_range, filtered_FρK)

# ╔═╡ 0654861a-f4d5-4adb-b929-8e7e6ae78b89
begin
	function plot_goodies(R)
		with_theme(theme_latexfonts()) do
			fig = Figure(size = (1200, 400))
	
			ax1 = Axis(fig[1, 1],
				title = LaTeXString("Σ Δρ_k = $(round(sum(r.Δρ for r in R), digits=2))"),
		    	ylabel = "ρ"
			)
		
			# Линии для ρK и ρT
			scatterlines!(ax1, 1:length(R), [r.ρK for r in R],
				label = "ρK, ρK = $(round(ρK, digits=2)), F = $(round(F, digits=2))")
			scatterlines!(ax1, 1:length(R), [r.ρT for r in R], label = "ρT")
			axislegend(ax1, halign = :right, valign = :bottom)
		
			# График давлений
			ax2 = Axis(fig[1, 2],
					   title = L"p_2 \ при \ обратной \ закрутке",
					   ylabel = "p₂"
					  )
			scatterlines!(ax2, 1:length(R), [r.p₂ for r in R], label = "p₂")
	
			save("assets/goodies.svg", fig)
	
			fig
		end
	end
	md"👁 Отображение изменения степеней реактивности и давления за последней ступенью"
end

# ╔═╡ 9ade3b75-1232-4b47-bd1f-a5ac636d3fc6
plot_goodies(R)

# ╔═╡ bd295267-109a-4c84-bba3-7cdd0d682b18
md"### Профили"

# ╔═╡ ca7636ed-2d30-4086-bc61-ef31ab371969
begin
	function hermite_polynomial(x0, y0, y0_prime, x1, y1, y1_prime)
		function spline(x)
			h = x1 - x0
	    	t = (x - x0) / h

	        H00 = (1 + 2t) * (1 - t)^2
    	    H10 = t^2 * (3 - 2t)
	    	H01 = t * (1 - t)^2
	    	H11 = t^2 * (t - 1)

		    y0 * H00 + y1 * H10 + h * (y0_prime * H01 + y1_prime * H11)
		end
	end

	md"λ Кривая Эрмита"
end

# ╔═╡ 8845a7bd-f62c-4531-953e-5aabd6b8e708
begin
	function centroid(x1, y1, x2, y2, θ₁ₚ, θ₁ₛ, θ₂ₚ, θ₂ₛ, l, ξ, R₁, R₂)
    	total_area  = 0.0
	    weighted_cx = 0.0
    	weighted_cy = 0.0

		function circular_centroid(R, θ₁, θ₂, cx, cy)
			θ = - θ₁ + θ₂
		    A = (R^2 / 2) * (θ - sin(θ))
		    d = (4R * sin(θ/2)^3) / (3(θ - sin(θ)))
	    	bisector_angle = (θ₁ + θ₂)/2

		    x = cx + d * cos(bisector_angle)
	    	y = cy + d * sin(bisector_angle)

		    x, y, A
		end

	    for i in 1:length(x1)-1
    	    # Точки четырехугольника между кривыми
        	a = (x1[i]  , y1[i]  )
        	b = (x1[i+1], y1[i+1])
        	c = (x2[i+1], y2[i+1])
        	d = (x2[i]  , y2[i]  )

	        # Разбиваем на два треугольника и вычисляем их свойства
    	    # Треугольник 1: a-b-c
        	area1 = abs((b[1]-a[1])*(c[2]-a[2]) - (c[1]-a[1])*(b[2]-a[2])) / 2
	        cx1 = (a[1] + b[1] + c[1]) / 3
    	    cy1 = (a[2] + b[2] + c[2]) / 3

	        # Треугольник 2: a-c-d
    	    area2 = abs((c[1]-a[1])*(d[2]-a[2]) - (d[1]-a[1])*(c[2]-a[2])) / 2
        	cx2 = (a[1] + c[1] + d[1]) / 3
        	cy2 = (a[2] + c[2] + d[2]) / 3

	        # Суммируем вклады
    	    total_area  +=       area1 +       area2
        	weighted_cx += cx1 * area1 + cx2 * area2
        	weighted_cy += cy1 * area1 + cy2 * area2
    	end

		cx₁, cy₁, A₁ = circular_centroid(R₁, θ₁ₚ, θ₁ₛ, 0, 0)
		cx₂, cy₂, A₂ = circular_centroid(R₂, θ₂ₚ, θ₂ₛ, l, ξ)

	    (( (weighted_cx + A₁*cx₁ + A₂*cx₂) / (total_area + A₁ + A₂),
		   (weighted_cy + A₁*cy₁ + A₂*cy₂) / (total_area + A₂ + A₁) ),
		 [cx₁, cy₁, A₁], [cx₂, cy₂, A₂]
		)
	end

	md"λ Вычисление центроида"
end

# ╔═╡ 5d979de0-beb0-41df-a5cd-779eec0e611f
begin
	function thickness(xp, yp, xs, ys)
		c̄ = []
	
		for i in 1:length(xp)
			j  = argmin(  √( (xp[i]-xs[j])^2 + (yp[i]-ys[j])^2 ) for j in 1:length(xs))
			cᵢ = minimum( √( (xp[i]-xs[j])^2 + (yp[i]-ys[j])^2 ) for j in 1:length(xs))
		
			push!(c̄, (; i, j, cᵢ))
		end

		max = argmax(item -> item.cᵢ, c̄)

		xₘ = ( xp[max.i] + xs[max.j] ) / 2
		yₘ = ( yp[max.i] + ys[max.j] ) / 2
		cₘ = max.cᵢ / 2

		(; pₘ = (xₘ, yₘ), cₘ)
	end

	md"λ Вычисление толщины профиля"
end

# ╔═╡ 92eaacb2-756d-4f8e-b9c3-c02353c14417
begin
	function distance(xp, yp, xs, ys, Δ)
		d̄ = []
	
		for i in 1:length(xp)
			j  = argmin( √( (xp[i]-xs[j])^2 + (yp[i]-ys[j]-Δ)^2 ) for j in 1:length(xs))
			dᵢ = minimum(√( (xp[i]-xs[j])^2 + (yp[i]-ys[j]-Δ)^2 ) for j in 1:length(xs))
		
			push!(d̄, (; j, dᵢ))
		end

		d̄
	end

	md"λ Вычисление расстояния между профилями"
end

# ╔═╡ 0f7c4d6c-e748-4de0-8166-47d03f4129ec
begin
	function calc_conf(b, c, ρ)
		c̄    = c/b
		t̄ₒₚₜ = ρ.β₁ > 0 ? 
			(0.55 * (1-c̄) * (sind(ρ.β₁      )/ sind(ρ.β⃰₂) * (180/ (180 - (       ρ.β₁ + ρ.β⃰₂)) )^(1/3) )) : 
			(0.55 * (1-c̄) * (sind(180 + ρ.β₁)/ sind(ρ.β⃰₂) * (180/ (180 - ( 180 + ρ.β₁ + ρ.β⃰₂)) )^(1/3) ))
		tₒₚₜ  = t̄ₒₚₜ * b
		Lᵒ    = 2π * ρ.r
		z     = round(Lᵒ / tₒₚₜ)
		t     = Lᵒ / z

		(; c̄, t̄ₒₚₜ, tₒₚₜ, Lᵒ, z, t)
	end

	md"λ Вычисление числа лопаток"
end

# ╔═╡ 61b7a669-218b-4cc2-a45b-ea70cdda0250
begin
	function profile_build(R, n, R₁, R₂, Δ₁, Δ₂, l̄)
		# Нормализация углов
		if R[n].β₁ < 0
			β₁ₜₑₘₚ = 180 + R[n].β₁
		else
			β₁ₜₑₘₚ = R[n].β₁
		end
	    α₁, β₁ = R[n].α₁ - 90, β₁ₜₑₘₚ - 90
    	α₂, β₂ = 90 + R[n].α₂, 90 - R[n].β⃰₂

	    # Углы для построения профиля
    	β₁ₚ, β₂ₚ = β₁ + Δ₁, β₂ - Δ₂
    	β₁ₛ, β₂ₛ = β₁ - Δ₁, β₂ + Δ₂

		l = R[n].b - 2tand(l̄.β) * (R[n].r - R[1].r)
		ξ = l * (R[n].w₁u + R[n].w₂u) / (R[n].w₁u / tand(β₁) + R[n].w₂u / tand(β₂))
		r = R[n].r

		# Длина хорды
		b = √(l^2 + ξ^2)

		# Точки для сплайнов
    	p1 = ( R₁ * cosd(90 + β₁ₚ)    ,  R₁ * sind(90 + β₁ₚ)    )
    	p2 = ( R₂ * cosd(90 + β₂ₚ) + l,  R₂ * sind(90 + β₂ₚ) + ξ)
    	s1 = (-R₁ * cosd(90 + β₁ₛ)    , -R₁ * sind(90 + β₁ₛ)    )
    	s2 = (-R₂ * cosd(90 + β₂ₛ) + l, -R₂ * sind(90 + β₂ₛ) + ξ)

	    # Построение сплайнов оригинального профиля
		cline = hermite_polynomial(0, 0 , tand(β₁ ), l, ξ , tand(β₂ ))
    	pline = hermite_polynomial(p1..., tand(β₁ₚ), p2..., tand(β₂ₚ))
    	sline = hermite_polynomial(s1..., tand(β₁ₛ), s2..., tand(β₂ₛ))

		xc = range(0    , l    , 200)
    	xp = range(p1[1], p2[1], 200)
    	xs = range(s1[1], s2[1], 200)

	    yc = cline.(xc)
    	yp = pline.(xp)
    	ys = sline.(xs)

		# Вычисление центроида
    	cntr, ctr1, ctr2 = centroid(xp,yp,xs,ys,
									deg2rad(90 + β₁ₚ), deg2rad(360 - 90 + β₁ₛ),
									deg2rad(90 + β₂ₚ), deg2rad(    - 90 + β₂ₛ),
									l,ξ, R₁,R₂)

		# Вычисление наибольшей толщины профиля и положения этого сечения
		cₘₐₓ = thickness(xp, yp, xs, ys)

		# Вычисление оптимального числа лопаток
		Z    = calc_conf(b, cₘₐₓ.cₘ, R[n])

		(; R₁, R₂, l, ξ, r, b, α₁, β₁, α₂, β₂, β₁ₚ, β₂ₚ, β₁ₛ, β₂ₛ, xc, yc, xp, yp, xs, ys, cntr, ctr1, ctr2, cₘₐₓ, Z)
	end

	md"Λ Построение профиля"
end

# ╔═╡ 20f45d03-754e-4d6a-b1ad-431745281c4e
begin
	Pr1 = profile_build(R, 1, 0.003  , 0.001 , 11, 3, l̄)
	Pr2 = profile_build(R, 2, 0.00285, 0.0008, 11, 3, l̄)
	Pr3 = profile_build(R, 3, 0.00235, 0.0007, 11, 3, l̄)
	Pr4 = profile_build(R, 4, 0.00175, 0.0006, 11, 3, l̄)
	Pr5 = profile_build(R, 5, 0.00125, 0.0005, 11, 3, l̄)

	nₗ = Pr1.Z.z

	md"### ∮ Построение профилей рабочих лопаток"
end

# ╔═╡ 9d1db807-3229-4d28-b78b-325f9c82c60d
begin
	function profile_show(Pr)
		with_theme(theme_latexfonts()) do
			fig = Figure(figure_padding = 0)
    		ax = Axis(fig[1, 1], aspect = DataAspect())
			hidespines!(ax)
    		hidedecorations!(ax)

		    # Отображаем центроид
    		scatter!(ax, Pr.cntr, color=:gray, markersize=10)

			# Отображение толщины
			arc!(ax, color = :gray, linewidth = 1, Pr.cₘₐₓ.pₘ, Pr.cₘₐₓ.cₘ, 0, 2π)

			α  = atan(Pr.ξ / Pr.l) + pi/2 #+ 3π/4
			dl = 0.2Pr.l * cos(α)
    	    diam_points = [
				(Pr.cₘₐₓ.pₘ[1]+Pr.cₘₐₓ.cₘ*cos(α), Pr.cₘₐₓ.pₘ[2]+Pr.cₘₐₓ.cₘ*sin(α)),
				(Pr.cₘₐₓ.pₘ[1]-Pr.cₘₐₓ.cₘ*cos(α), Pr.cₘₐₓ.pₘ[2]-Pr.cₘₐₓ.cₘ*sin(α)),
				(
					Pr.cₘₐₓ.pₘ[1]-Pr.cₘₐₓ.cₘ*cos(α) - dl,
					Pr.cₘₐₓ.pₘ[2]-Pr.cₘₐₓ.cₘ*sin(α) - dl * tan(α)
				)
        	]

			lines!(ax, color = :gray, linewidth = 1, linestyle = :dash, 
				   [diam_points[2], diam_points[3]]
				  )
			bracket!(ax, color=:gray, linewidth = 0, width = 0,
					 diam_points[2], diam_points[3],
					 text  = "c = $(round(Int, Pr.cₘₐₓ.cₘ * 2000)) mm"
					)
			arrows2d!(ax, color = :gray, argmode = :endpoint,
					  shaftwidth = 1, tipwidth = 8, tiplength = 6,
					  tailwidth = 8, taillength = 6,
					  tail = Point2f[(0, 0), (1, -0.5), (1, 0.5)],
					  diam_points[1], diam_points[2]
					 )

			# Контуры окружностей

			diam_points_1 = [
				(0 + Pr.R₁ * cos(α), 0 + Pr.R₁ * sin(α)),
				(0 - Pr.R₁ * cos(α), 0 - Pr.R₁ * sin(α)),
				(0 + Pr.R₁ * cos(α) + dl, 0 + Pr.R₁ * sin(α) + dl * tan(α))
        	]
			lines!(ax, color = :gray, linewidth = 1,
				   [diam_points_1[2], diam_points_1[3]]
				  )
			bracket!(ax, color = :gray, linewidth = 0, width = 0,
					 diam_points_1[3], diam_points_1[1],
					 text = "⌀ $(round(Int, 2000Pr.R₁)) mm"
					)

			diam_points_2 = [
				(Pr.l + Pr.R₂ * cos(α)     , Pr.ξ + Pr.R₂ * sin(α)),
				(Pr.l - Pr.R₂ * cos(α)     , Pr.ξ - Pr.R₂ * sin(α)),
				(Pr.l - Pr.R₂ * cos(α) - dl, Pr.ξ - Pr.R₂ * sin(α) - dl * tan(α)),
        	]
			lines!(ax, color = :gray, linewidth = 1,
				   [diam_points_2[1], diam_points_2[3]]
				  )
			bracket!(ax, color = :gray, linewidth = 0, width = 0,
					 diam_points_2[3], diam_points_2[2],
					 text = "⌀ $(round(Int, 2000Pr.R₂)) mm"
					)

			# Хорда
			lines!(ax, color = :gray, linewidth = 1, linestyle = :dash,
				   [0, Pr.l], [0, Pr.ξ]
				  )
			bracket!(ax, color = :gray, linewidth = 1, 0, 0, Pr.l, Pr.ξ,
					 text = "b = $(round(Int, Pr.b * 10^3)) mm"
					)

			arc!(ax, (0   , 0   ), Pr.R₁, 0, 2π, color = :gray, linewidth = 1)
			arc!(ax, (Pr.l, Pr.ξ), Pr.R₂, 0, 2π, color = :gray, linewidth = 1)

			# Дуги скругления
			arc!(ax, color = :black, linewidth = 2, (0   , 0   ), Pr.R₁,
				 deg2rad(90 + Pr.β₁ₚ), deg2rad(360 - 90 + Pr.β₁ₛ)
				)
			arc!(ax, color = :black, linewidth = 2, (Pr.l, Pr.ξ), Pr.R₂,
				 deg2rad(90 + Pr.β₂ₚ), deg2rad(     -90 + Pr.β₂ₛ)
				)
    
		    # Профиль лопатки
    		lines!(ax, Pr.xc, Pr.yc, color = :gray , linewidth = 1)
    		lines!(ax, Pr.xp, Pr.yp, color = :black, linewidth = 2)
    		lines!(ax, Pr.xs, Pr.ys, color = :black, linewidth = 2)

			# m = 10000

			# Треугольники скоростей
		    # lines!(ax, [0, R.c₁ * cosd(α₁)/m], [0, R.c₁ * sind(α₁)/m], color=:red)
			# arrows2d!(ax, [0], [0], [c₁ * cosd(α₁)], [c₁ * sind(α₁)], color=:red)
		    # lines!(ax, [0, R.w₁ * cosd(β₁)/m], [0, R.w₁ * sind(β₁)/m], color=:red)
    		# lines!(ax, [l, l + c₂ * cosd(α₂)], [ξ, ξ + c₂ * sind(α₂)], color=:blue)
	    	# lines!(ax, [l, l + w₂ * cosd(β₂)], [ξ, ξ + w₂ * sind(β₂)], color=:blue)
    
	    	fig
		end
	end

	md"👁 Отображение одного профиля"
end

# ╔═╡ ba361882-01ce-426b-8725-90f00d00be4a
profile_show(Pr1)

# ╔═╡ 0edf5251-3d74-4f2c-bced-88fdb511d2f8
begin
	function profile_shift(Pr)

		Δ = Pr.Z.t

		with_theme(theme_latexfonts()) do
			fig = Figure()
    		ax = Axis(fig[1, 1], aspect = DataAspect())
			hidespines!(ax)
    		hidedecorations!(ax)

			# Расстояния между профилями
			ds = distance(Pr.xp, Pr.yp, Pr.xs, Pr.ys, Δ)

			distances = [1000d.dᵢ for d in ds]

			min_dist, max_dist = extrema(distances)
    		norm_distances = (distances .- min_dist) ./ (max_dist - min_dist)

			colors = [cgrad(:viridis, [0, 1])[d] for d in norm_distances]

			for i in 1:length(Pr.xp)
				lines!(ax, color = colors[i], linewidth=4,
					   [Pr.xp[i], Pr.xs[ds[i].j]    ],
					   [Pr.yp[i], Pr.ys[ds[i].j] + Δ]
				  	)
			end

			# Дуги скругления
			arc!(ax, color = :black, linewidth = 2, (0   , 0   ),
				 Pr.R₁, deg2rad(90 + Pr.β₁ₚ), deg2rad(360 - 90 + Pr.β₁ₛ)
				)
			arc!(ax, color = :black, linewidth = 2, (Pr.l, Pr.ξ),
				 Pr.R₂, deg2rad(90 + Pr.β₂ₚ), deg2rad(     -90 + Pr.β₂ₛ)
				)

		    # Профиль лопатки
    		lines!(ax, Pr.xp, Pr.yp, color = :black, linewidth = 2)
	    	lines!(ax, Pr.xs, Pr.ys, color = :black, linewidth = 2)

			# Дуги скругления
			arc!(ax, (0   ,        Δ), Pr.R₁, deg2rad(90 + Pr.β₁ₚ), deg2rad(360 - 90 + Pr.β₁ₛ), color = :black, linewidth = 2)
			arc!(ax, (Pr.l, Pr.ξ + Δ), Pr.R₂, deg2rad(90 + Pr.β₂ₚ), deg2rad(     -90 + Pr.β₂ₛ), color = :black, linewidth = 2)

		    # Профиль лопатки
    		lines!(ax, Pr.xp, Pr.yp .+ Δ, color = :black, linewidth = 2)
    		lines!(ax, Pr.xs, Pr.ys .+ Δ, color = :black, linewidth = 2)

			Colorbar(fig[1, 2], limits=(min_dist,max_dist), minorticksvisible=true,
					 label = L"t, \ м м"
					)
    
	    	fig
		end
	end

	md"👁 Отображение конфузорности"
end

# ╔═╡ 44ec2743-fcc2-41fd-a7eb-0e86202ccb6b
profile_shift(Pr1)

# ╔═╡ 7cb1c106-ccfe-48eb-af87-0eb6812a4000
begin
	function profiles_show(Pr1, Pr2, Pr3, Pr4, Pr5)
    	Pr = [Pr1, Pr2, Pr3, Pr4, Pr5]
    	with_theme(theme_latexfonts()) do
        	fig = Figure(figure_padding = 0)
	        ax = Axis(fig[1, 1], aspect = DataAspect())
	        hidespines!(ax)
    	    hidedecorations!(ax)

        	colors = cgrad(:viridis, 6, categorical = true)

	        for i in 1:5
    	        cx = Pr[i].cntr[1]
        	    cy = Pr[i].cntr[2]
            	color = colors[i]  # Цвет текущего профиля

	            # Скорректированные центры для дуг
    	        arc_center1 = (0 - cx, 0 - cy)
        	    arc_center2 = (Pr[i].l - cx, Pr[i].ξ - cy)

	            # Создаем точки для дуг с высоким разрешением
    	        n_points = 100
            
	            # Первая дуга (входная кромка)
				angles1 = range(deg2rad(90 + Pr[i].β₁ₚ), deg2rad(360 - 90 + Pr[i].β₁ₛ), length=n_points)
				arc1_points = [Point2f(arc_center1[1] + Pr[i].R₁ * cos(θ), arc_center1[2] + Pr[i].R₁ * sin(θ)) for θ in angles1]
            
	            # Вторая дуга (выходная кромка)
				angles2 = range(deg2rad(90 + Pr[i].β₂ₚ), deg2rad(-90 + Pr[i].β₂ₛ), length=n_points)
				arc2_points = [Point2f(arc_center2[1] + Pr[i].R₂ * cos(θ), arc_center2[2] + Pr[i].R₂ * sin(θ)) for θ in angles2]

	            # Полный контур профиля, включая дуги
    	        full_contour = vcat(
					[Point2f(x - cx, y - cy) for (x, y) in zip(Pr[i].xp, Pr[i].yp)],
                	arc2_points,
					reverse([Point2f(x - cx, y - cy) for (x, y) in zip(Pr[i].xs, Pr[i].ys)]),
                	arc1_points
            	)

	            # Заливка профилей
    	        poly!(ax, full_contour, color=(color, 0.7))

        	    # Контуры поверх заливки
            	lines!(ax, Pr[i].xc .- cx, Pr[i].yc .- cy, color=color, linewidth=1)
            	lines!(ax, Pr[i].xp .- cx, Pr[i].yp .- cy, color=color, linewidth=2)
	            lines!(ax, Pr[i].xs .- cx, Pr[i].ys .- cy, color=color, linewidth=2)
				lines!(ax, color = color, linewidth = 2,
					   [p[1] for p in arc1_points], [p[2] for p in arc1_points]
					  )
				lines!(ax, color = color, linewidth = 2,
					   [p[1] for p in arc2_points], [p[2] for p in arc2_points]
					  )
        	end

			save("assets/profiles.svg", fig)

        	fig
    	end
	end

	md"👁 Отображение всех профилей"
end

# ╔═╡ 65e1301d-9baa-4c84-9bbf-0a82ed444c29
profiles_show(Pr1, Pr2, Pr3, Pr4, Pr5)

# ╔═╡ b4612166-cbe9-4b21-b630-e08481294a03
function transformProfile(Pr)
	cx = -1000Pr.cntr[1]
	cy = -1000Pr.cntr[2]

    c1s = (cx + 1000Pr.R₁ * cosd(90  +  Pr.β₁ₚ            ),
		   cy + 1000Pr.R₁ * sind(90  +  Pr.β₁ₚ            ))
    c1e = (cx - 1000Pr.R₁ * cosd(90  +  Pr.β₁ₛ            ),
		   cy - 1000Pr.R₁ * sind(90  +  Pr.β₁ₛ            ))
	c1m = (cx + 1000Pr.R₁ * cosd(180 + (Pr.β₁ₚ + Pr.β₁ₛ)/2),
		   cy + 1000Pr.R₁ * sind(180 + (Pr.β₁ₚ + Pr.β₁ₛ)/2))
    
	c2s = (cx + 1000Pr.l + 1000Pr.R₂ * cosd(90 + Pr.β₂ₚ               ),
		   cy + 1000Pr.ξ + 1000Pr.R₂ * sind(90 + Pr.β₂ₚ               ))
	c2e = (cx + 1000Pr.l - 1000Pr.R₂ * cosd(90 + Pr.β₂ₛ               ),
		   cy + 1000Pr.ξ - 1000Pr.R₂ * sind(90 + Pr.β₂ₛ               ))
	c2m = (cx + 1000Pr.l + 1000Pr.R₂ * cosd(    (Pr.β₂ₚ + Pr.β₂ₛ) / 2 ),
		   cy + 1000Pr.ξ + 1000Pr.R₂ * sind(    (Pr.β₂ₚ + Pr.β₂ₛ) / 2 ))
    
    pls = (cx + 1000Pr.xp[1]  , cy + 1000Pr.yp[1]  )
    ple = (cx + 1000Pr.xp[end], cy + 1000Pr.yp[end])
    pl1 = (cx + 1000Pr.xp[1]   +                (Pr.xp[end] - Pr.xp[1]) * 1000/3,
		   cy + 1000Pr.yp[1]   + tand(Pr.β₁ₚ) * (Pr.xp[end] - Pr.xp[1]) * 1000/3)
    pl2 = (cx + 1000Pr.xp[end] -                (Pr.xp[end] - Pr.xp[1]) * 1000/3,
		   cy + 1000Pr.yp[end] - tand(Pr.β₂ₚ) * (Pr.xp[end] - Pr.xp[1]) * 1000/3)
    
    sls = (cx + 1000Pr.xs[1]  , cy + 1000Pr.ys[1]  )
    sle = (cx + 1000Pr.xs[end], cy + 1000Pr.ys[end])
	sl1 = (cx + 1000Pr.xs[1]   +                (Pr.xs[end] - Pr.xs[1]) * 1000/3,
		   cy + 1000Pr.ys[1]   + tand(Pr.β₁ₛ) * (Pr.xs[end] - Pr.xs[1]) * 1000/3)
    sl2 = (cx + 1000Pr.xs[end] -                (Pr.xs[end] - Pr.xs[1]) * 1000/3,
		   cy + 1000Pr.ys[end] - tand(Pr.β₂ₛ) * (Pr.xs[end] - Pr.xs[1]) * 1000/3)

    (
        c1 = (c1s, c1e, c1m     ),
        c2 = (c2s, c2e, c2m     ),
        pl = (pls, ple, pl1, pl2),
        sl = (sls, sle, sl1, sl2),
		rl = 1000Pr.r
    )
end

# ╔═╡ 4886ddbb-9cc1-483c-8441-bd2b1961d540
function write_Haskell(Data)
	open("waterfall/Data.hs", "w") do f
		write(f, "module Data where \n")
		write(f, "import Linear (V3 (..), V2 (..), zero) \n")
		for section in 1:length(Data)
			write(f, "p$(section)c1s = V2 ($(Data[section][1][1][1])) ($(Data[section][1][1][2])) \n")
			write(f, "p$(section)c1e = V2 ($(Data[section][1][2][1])) ($(Data[section][1][2][2])) \n")
			write(f, "p$(section)c1m = V2 ($(Data[section][1][3][1])) ($(Data[section][1][3][2])) \n")

			write(f, "p$(section)c2s = V2 ($(Data[section][2][1][1])) ($(Data[section][2][1][2])) \n")
			write(f, "p$(section)c2e = V2 ($(Data[section][2][2][1])) ($(Data[section][2][2][2])) \n")
			write(f, "p$(section)c2m = V2 ($(Data[section][2][3][1])) ($(Data[section][2][3][2])) \n")

			write(f, "p$(section)ls0 = V2 ($(Data[section][3][1][1])) ($(Data[section][3][1][2])) \n")
			write(f, "p$(section)ls1 = V2 ($(Data[section][3][2][1])) ($(Data[section][3][2][2])) \n")
			write(f, "p$(section)ls2 = V2 ($(Data[section][3][3][1])) ($(Data[section][3][3][2])) \n")
			write(f, "p$(section)ls3 = V2 ($(Data[section][3][4][1])) ($(Data[section][3][4][2])) \n")

			write(f, "p$(section)lp0 = V2 ($(Data[section][4][1][1])) ($(Data[section][4][1][2])) \n")
			write(f, "p$(section)lp1 = V2 ($(Data[section][4][2][1])) ($(Data[section][4][2][2])) \n")
			write(f, "p$(section)lp2 = V2 ($(Data[section][4][3][1])) ($(Data[section][4][3][2])) \n")
			write(f, "p$(section)lp3 = V2 ($(Data[section][4][4][1])) ($(Data[section][4][4][2])) \n")

			write(f, "p$(section)r = $(Data[section][5]) \n")

			write(f, "\n")
		end
	end
end

# ╔═╡ e93e7b4b-069f-44c5-8a0a-d1236ee4b2cc
begin
	write_Haskell(transformProfile.([Pr1, Pr2, Pr3, Pr4, Pr5]))
	md"Запись профилей рабочих лопаток для waterfall-cad"
end

# ╔═╡ 8047ae16-5263-46a7-8ef9-ee6a82c9f520
begin
	function profile_build_2(S, R, n, R₁, R₂, Δ₁, Δ₂, l̄)
		# Нормализация углов
		α₁ = S[3].α₂ - 90
		α₂ = R[n].α₁ + 90

	    # Углы для построения профиля
    	α₁ₚ, α₂ₚ = α₁ - Δ₁, α₂ + Δ₂
    	α₁ₛ, α₂ₛ = α₁ + Δ₁, α₂ - Δ₂

		l = R[n].b #- 2tand(l̄.β) * (R[n].r - R[1].r)
		ξ = l * (S[3].c₂u + R[n].c₁u) / (S[3].c₂u / tand(α₁) + R[n].c₁u / tand(α₂))
		r = R[n].r

		# Длина хорды
		b = √(l^2 + ξ^2)

		# Точки для сплайнов
    	p1 = ( R₁ * cosd(90 + α₁ₚ)    ,  R₁ * sind(90 + α₁ₚ)    )
    	p2 = ( R₂ * cosd(90 + α₂ₚ) + l,  R₂ * sind(90 + α₂ₚ) + ξ)
    	s1 = (-R₁ * cosd(90 + α₁ₛ)    , -R₁ * sind(90 + α₁ₛ)    )
    	s2 = (-R₂ * cosd(90 + α₂ₛ) + l, -R₂ * sind(90 + α₂ₛ) + ξ)

	    # Построение сплайнов оригинального профиля
		cline = hermite_polynomial(0, 0 , tand(α₁ ), l, ξ , tand(α₂ ))
    	pline = hermite_polynomial(p1..., tand(α₁ₚ), p2..., tand(α₂ₚ))
    	sline = hermite_polynomial(s1..., tand(α₁ₛ), s2..., tand(α₂ₛ))

		xc = range(0    , l    , 200)
    	xp = range(p1[1], p2[1], 200)
    	xs = range(s1[1], s2[1], 200)

	    yc = cline.(xc)
    	yp = pline.(xp)
    	ys = sline.(xs)

		# Вычисление центроида
    	cntr, ctr1, ctr2 = centroid(xp,yp,xs,ys,
									deg2rad(90 + α₁ₚ), deg2rad(    - 90 + α₁ₛ),
									deg2rad(90 + α₂ₚ), deg2rad(360 - 90 + α₂ₛ),
									# α₁ₚ,α₂ₚ,α₁ₛ,α₂ₛ,
									l,ξ, R₁,R₂)

		# Вычисление наибольшей толщины профиля и положения этого сечения
		cₘₐₓ = thickness(xp, yp, xs, ys)

		# Вычисление оптимального числа лопаток
		Z    = calc_conf(b, cₘₐₓ.cₘ, R[n])

		(; R₁, R₂, l, ξ, r, b, α₁, α₂, α₁ₚ, α₂ₚ, α₁ₛ, α₂ₛ, xc, yc, xp, yp, xs, ys, cntr, ctr1, ctr2, cₘₐₓ, Z)
	end

	md"Λ Построение профиля сопловой лопатки"
end

# ╔═╡ 7e3efafc-2d86-4e36-ad67-bbb12de0a0c0
begin
	Prs1 = profile_build_2(S, R, 1, 0.004, 0.001, 10, 3, l̄)
	Prs2 = profile_build_2(S, R, 2, 0.004, 0.001, 10, 3, l̄)
	Prs3 = profile_build_2(S, R, 3, 0.004, 0.001, 10, 3, l̄)
	Prs4 = profile_build_2(S, R, 4, 0.004, 0.001, 10, 3, l̄)
	Prs5 = profile_build_2(S, R, 5, 0.004, 0.001, 10, 3, l̄)

	md"### ∮ Построение профилей сопловых лопаток"
end

# ╔═╡ 071cf1e8-2cb9-40d6-8930-90ce150e22fb
begin
	function profile_show_2(Pr)
		with_theme(theme_latexfonts()) do
			fig = Figure(figure_padding = 0)
    		ax = Axis(fig[1, 1], aspect = DataAspect())
			hidespines!(ax)
    		hidedecorations!(ax)

		    # Отображаем центроид
    		scatter!(ax, Pr.cntr, color=:gray, markersize=10)

			# Отображение толщины
			arc!(ax, color = :gray, linewidth = 1, Pr.cₘₐₓ.pₘ, Pr.cₘₐₓ.cₘ, 0, 2π)

			α  = atan(Pr.ξ / Pr.l) + pi/2
			dl = 0.3Pr.l * cos(α)
    	    diam_points = [
				(Pr.cₘₐₓ.pₘ[1]+Pr.cₘₐₓ.cₘ*cos(α), Pr.cₘₐₓ.pₘ[2]+Pr.cₘₐₓ.cₘ*sin(α)),
				(Pr.cₘₐₓ.pₘ[1]-Pr.cₘₐₓ.cₘ*cos(α), Pr.cₘₐₓ.pₘ[2]-Pr.cₘₐₓ.cₘ*sin(α)),
				(
					Pr.cₘₐₓ.pₘ[1]+Pr.cₘₐₓ.cₘ*cos(α) + dl,
					Pr.cₘₐₓ.pₘ[2]+Pr.cₘₐₓ.cₘ*sin(α) + dl * tan(α)
				)
        	]

			lines!(ax, color = :gray, linewidth = 1, linestyle = :dash, 
				   [diam_points[2], diam_points[3]]
				  )
			bracket!(ax, color=:gray, linewidth = 0, width = 0,
					 diam_points[1], diam_points[3],
					 text  = "c = $(round(Int, Pr.cₘₐₓ.cₘ * 2000)) mm"
					)
			arrows2d!(ax, color = :gray, argmode = :endpoint,
					  shaftwidth = 1, tipwidth = 8, tiplength = 6,
					  tailwidth = 8, taillength = 6,
					  tail = Point2f[(0, 0), (1, -0.5), (1, 0.5)],
					  diam_points[1], diam_points[2]
					 )

			# Контуры окружностей

			diam_points_1 = [
				(0 + Pr.R₁ * cos(α), 0 + Pr.R₁ * sin(α)),
				(0 - Pr.R₁ * cos(α), 0 - Pr.R₁ * sin(α)),
				(0 + Pr.R₁ * cos(α) + dl, 0 + Pr.R₁ * sin(α) + dl * tan(α))
        	]
			lines!(ax, color = :gray, linewidth = 1,
				   [diam_points_1[2], diam_points_1[3]]
				  )
			bracket!(ax, color = :gray, linewidth = 0, width = 0,
					 diam_points_1[3], diam_points_1[1],
					 text = "⌀ $(round(Int, 2000Pr.R₁)) mm"
					)

			diam_points_2 = [
				(Pr.l + Pr.R₂ * cos(α)     , Pr.ξ + Pr.R₂ * sin(α)),
				(Pr.l - Pr.R₂ * cos(α)     , Pr.ξ - Pr.R₂ * sin(α)),
				(Pr.l + Pr.R₂ * cos(α) + dl, Pr.ξ + Pr.R₂ * sin(α) + dl * tan(α)),
        	]
			lines!(ax, color = :gray, linewidth = 1,
				   [diam_points_2[2], diam_points_2[3]]
				  )
			bracket!(ax, color = :gray, linewidth = 0, width = 0,
					 diam_points_2[3], diam_points_2[1],
					 text = "⌀ $(round(Int, 2000Pr.R₂)) mm"
					)

			# Хорда
			lines!(ax, color = :gray, linewidth = 1, linestyle = :dash,
				   [0, Pr.l], [0, Pr.ξ]
				  )
			bracket!(ax, color = :gray, linewidth = 1, 0, 0, Pr.l, Pr.ξ, orientation = :down,
					 text = "b = $(round(Int, Pr.b * 10^3)) mm"
					)

			arc!(ax, (0   , 0   ), Pr.R₁, 0, 2π, color = :gray, linewidth = 1)
			arc!(ax, (Pr.l, Pr.ξ), Pr.R₂, 0, 2π, color = :gray, linewidth = 1)

			# Дуги скругления
			arc!(ax, color = :black, linewidth = 2, (0   , 0   ), Pr.R₁,
				 deg2rad(90 + Pr.α₁ₚ), deg2rad(- 90 + Pr.α₁ₛ)
				)
			arc!(ax, color = :black, linewidth = 2, (Pr.l, Pr.ξ), Pr.R₂,
				 deg2rad(90 + Pr.α₂ₚ), deg2rad(360     -90 + Pr.α₂ₛ)
				)
    
		    # Профиль лопатки
    		lines!(ax, Pr.xc, Pr.yc, color = :gray , linewidth = 1)
    		lines!(ax, Pr.xp, Pr.yp, color = :black, linewidth = 2)
    		lines!(ax, Pr.xs, Pr.ys, color = :black, linewidth = 2)

			# Треугольники скоростей
		    # lines!(ax, [0, 0.02 * cosd(Pr.α₁)], [0, 0.02 * sind(Pr.α₁)], color=:red)
    		# lines!(ax,
				  #  [Pr.l, Pr.l + 0.03 * cosd(Pr.α₂)], 
				  #  [Pr.ξ, Pr.ξ + 0.03 * sind(Pr.α₂)], color=:blue)

	    	fig
		end
	end

	md"👁 Отображение одного профиля сопловой лопатки"
end

# ╔═╡ e4ead9dc-7b59-4f4c-ae3f-83f4a842dedb
profile_show_2(Prs1)

# ╔═╡ 8e992360-1373-4168-bc59-a7b04792befa
begin
	function profiles_show_2(Pr1, Pr2, Pr3, Pr4, Pr5)
    	Pr = [Pr1, Pr2, Pr3, Pr4, Pr5]
    	with_theme(theme_latexfonts()) do
        	fig = Figure(figure_padding = 0)
	        ax = Axis(fig[1, 1], aspect = DataAspect())
	        hidespines!(ax)
    	    hidedecorations!(ax)

        	colors = cgrad(:viridis, 6, categorical = true)

	        for i in 1:5
    	        cx = Pr[i].cntr[1]
        	    cy = Pr[i].cntr[2]
            	color = colors[i]  # Цвет текущего профиля

	            # Скорректированные центры для дуг
    	        arc_center1 = (0 - cx, 0 - cy)
        	    arc_center2 = (Pr[i].l - cx, Pr[i].ξ - cy)

	            # Создаем точки для дуг с высоким разрешением
    	        n_points = 100
            
	            # Первая дуга (входная кромка)
				angles1 = range(deg2rad(90 + Pr[i].α₁ₚ), deg2rad(- 90 + Pr[i].α₁ₛ), length=n_points)
				arc1_points = [Point2f(arc_center1[1] + Pr[i].R₁ * cos(θ), arc_center1[2] + Pr[i].R₁ * sin(θ)) for θ in angles1]
            
	            # Вторая дуга (выходная кромка)
				angles2 = range(deg2rad(90 + Pr[i].α₂ₚ), deg2rad(360 -90 + Pr[i].α₂ₛ), length=n_points)
				arc2_points = [Point2f(arc_center2[1] + Pr[i].R₂ * cos(θ), arc_center2[2] + Pr[i].R₂ * sin(θ)) for θ in angles2]

	            # Полный контур профиля, включая дуги
    	        full_contour = vcat(
					[Point2f(x - cx, y - cy) for (x, y) in zip(Pr[i].xp, Pr[i].yp)],
                	arc2_points,
					reverse([Point2f(x - cx, y - cy) for (x, y) in zip(Pr[i].xs, Pr[i].ys)]),
                	arc1_points
            	)

	            # Заливка профилей
    	        poly!(ax, full_contour, color=(color, 0.7))

        	    # Контуры поверх заливки
            	lines!(ax, Pr[i].xc .- cx, Pr[i].yc .- cy, color=color, linewidth=1)
            	lines!(ax, Pr[i].xp .- cx, Pr[i].yp .- cy, color=color, linewidth=2)
	            lines!(ax, Pr[i].xs .- cx, Pr[i].ys .- cy, color=color, linewidth=2)
				lines!(ax, color = color, linewidth = 2,
					   [p[1] for p in arc1_points], [p[2] for p in arc1_points]
					  )
				lines!(ax, color = color, linewidth = 2,
					   [p[1] for p in arc2_points], [p[2] for p in arc2_points]
					  )
        	end

			save("assets/profiles.svg", fig)

        	fig
    	end
	end

	md"👁 Отображение всех профилей"
end

# ╔═╡ a74f6353-4c78-49e3-998f-baec3f10377d
profiles_show_2(Prs1, Prs2, Prs3, Prs4, Prs5)

# ╔═╡ 08812d58-0a6f-4845-94fe-5c9a965a118c
function transformProfile_2(Pr)
	cx = -1000Pr.cntr[1]
	cy = -1000Pr.cntr[2]

    c1s = (cx + 1000Pr.R₁ * cosd(90 + Pr.α₁ₚ            ),
		   cy + 1000Pr.R₁ * sind(90 + Pr.α₁ₚ            ))
    c1e = (cx - 1000Pr.R₁ * cosd(90 + Pr.α₁ₛ            ),
		   cy - 1000Pr.R₁ * sind(90 + Pr.α₁ₛ            ))
	c1m = (cx + 1000Pr.R₁ * cosd(    (Pr.α₁ₚ + Pr.α₁ₛ)/2),
		   cy + 1000Pr.R₁ * sind(    (Pr.α₁ₚ + Pr.α₁ₛ)/2))
    
	c2s = (cx + 1000Pr.l + 1000Pr.R₂ * cosd(90  +  Pr.α₂ₚ               ),
		   cy + 1000Pr.ξ + 1000Pr.R₂ * sind(90  +  Pr.α₂ₚ               ))
	c2e = (cx + 1000Pr.l - 1000Pr.R₂ * cosd(90  +  Pr.α₂ₛ               ),
		   cy + 1000Pr.ξ - 1000Pr.R₂ * sind(90  +  Pr.α₂ₛ               ))
	c2m = (cx + 1000Pr.l + 1000Pr.R₂ * cosd(180 + (Pr.α₂ₚ + Pr.α₂ₛ) / 2 ),
		   cy + 1000Pr.ξ + 1000Pr.R₂ * sind(180 + (Pr.α₂ₚ + Pr.α₂ₛ) / 2 ))
    
    pls = (cx + 1000Pr.xp[1]  , cy + 1000Pr.yp[1]  )
    ple = (cx + 1000Pr.xp[end], cy + 1000Pr.yp[end])
    pl1 = (cx + 1000Pr.xp[1]   +                (Pr.xp[end] - Pr.xp[1]) * 1000/3,
		   cy + 1000Pr.yp[1]   + tand(Pr.α₁ₚ) * (Pr.xp[end] - Pr.xp[1]) * 1000/3)
    pl2 = (cx + 1000Pr.xp[end] -                (Pr.xp[end] - Pr.xp[1]) * 1000/3,
		   cy + 1000Pr.yp[end] - tand(Pr.α₂ₚ) * (Pr.xp[end] - Pr.xp[1]) * 1000/3)
    
    sls = (cx + 1000Pr.xs[1]  , cy + 1000Pr.ys[1]  )
    sle = (cx + 1000Pr.xs[end], cy + 1000Pr.ys[end])
	sl1 = (cx + 1000Pr.xs[1]   +                (Pr.xs[end] - Pr.xs[1]) * 1000/3,
		   cy + 1000Pr.ys[1]   + tand(Pr.α₁ₛ) * (Pr.xs[end] - Pr.xs[1]) * 1000/3)
    sl2 = (cx + 1000Pr.xs[end] -                (Pr.xs[end] - Pr.xs[1]) * 1000/3,
		   cy + 1000Pr.ys[end] - tand(Pr.α₂ₛ) * (Pr.xs[end] - Pr.xs[1]) * 1000/3)

    (
        c1 = (c1s, c1e, c1m     ),
        c2 = (c2s, c2e, c2m     ),
        pl = (pls, ple, pl1, pl2),
        sl = (sls, sle, sl1, sl2),
		rl = 1000Pr.r
    )
end

# ╔═╡ c31c4aba-1cb8-4d45-9e25-634f929b67e6
function write_Haskell_2(Data)
	open("waterfall/Data2.hs", "w") do f
		write(f, "module Data2 where \n")
		write(f, "import Linear (V3 (..), V2 (..), zero) \n")
		for section in 1:length(Data)
			write(f, "p$(section)c1s = V2 ($(Data[section][1][1][1])) ($(Data[section][1][1][2])) \n")
			write(f, "p$(section)c1e = V2 ($(Data[section][1][2][1])) ($(Data[section][1][2][2])) \n")
			write(f, "p$(section)c1m = V2 ($(Data[section][1][3][1])) ($(Data[section][1][3][2])) \n")

			write(f, "p$(section)c2s = V2 ($(Data[section][2][1][1])) ($(Data[section][2][1][2])) \n")
			write(f, "p$(section)c2e = V2 ($(Data[section][2][2][1])) ($(Data[section][2][2][2])) \n")
			write(f, "p$(section)c2m = V2 ($(Data[section][2][3][1])) ($(Data[section][2][3][2])) \n")

			write(f, "p$(section)ls0 = V2 ($(Data[section][3][1][1])) ($(Data[section][3][1][2])) \n")
			write(f, "p$(section)ls1 = V2 ($(Data[section][3][2][1])) ($(Data[section][3][2][2])) \n")
			write(f, "p$(section)ls2 = V2 ($(Data[section][3][3][1])) ($(Data[section][3][3][2])) \n")
			write(f, "p$(section)ls3 = V2 ($(Data[section][3][4][1])) ($(Data[section][3][4][2])) \n")

			write(f, "p$(section)lp0 = V2 ($(Data[section][4][1][1])) ($(Data[section][4][1][2])) \n")
			write(f, "p$(section)lp1 = V2 ($(Data[section][4][2][1])) ($(Data[section][4][2][2])) \n")
			write(f, "p$(section)lp2 = V2 ($(Data[section][4][3][1])) ($(Data[section][4][3][2])) \n")
			write(f, "p$(section)lp3 = V2 ($(Data[section][4][4][1])) ($(Data[section][4][4][2])) \n")

			write(f, "p$(section)r = $(Data[section][5]) \n")

			write(f, "\n")
		end
	end
end

# ╔═╡ 2fd068a7-9f7f-49ab-986b-c15593d89eee
begin
	write_Haskell_2(transformProfile_2.([Prs1, Prs2, Prs3, Prs4, Prs5]))
	md"Запись профилей сопловых лопаток для waterfall-cad"
end

# ╔═╡ 8678ac5d-fea0-4697-b2e6-799e72afda5a
md"### 📋 Красивые таблицы"

# ╔═╡ 1ae0f50a-c021-41cd-a389-cec934e34e26
function table_swirl_short()
	r̂1 = map(x -> round(x; sigdigits=4), R[1])
	r̂2 = map(x -> round(x; sigdigits=4), R[2])
	r̂3 = map(x -> round(x; sigdigits=4), R[3])
	r̂4 = map(x -> round(x; sigdigits=4), R[4])
	r̂5 = map(x -> round(x; sigdigits=4), R[5])

	md"""
	# Обратная закрутка
	| Величина                |Сечение 1 |Сечение 2 |Сечение 3 |Сечение 4 |Сечение 5 |
	|:------------------------|:--------:|:--------:|:--------:|:--------:|:--------:|
	| $\alpha_1, \degree$     |$(r̂1.α₁)  |$(r̂2.α₁)  |$(r̂3.α₁)  |$(r̂4.α₁)  |$(r̂5.α₁)  |
	| $\beta_1, \degree$      |$(r̂1.β₁)  |$(r̂2.β₁)  |$(r̂3.β₁)  |$(r̂4.β₁)  |$(r̂5.β₁)  |
	| $\alpha_2, \degree$     |$(r̂1.α₂)  |$(r̂2.α₂)  |$(r̂3.α₂)  |$(r̂4.α₂)  |$(r̂5.α₂)  |
	| $\beta^*_2, \degree$    |$(r̂1.β⃰₂)  |$(r̂2.β⃰₂)  |$(r̂3.β⃰₂)  |$(r̂4.β⃰₂)  |$(r̂5.β⃰₂)  |
	| $u_1, \text{м/с}$       |$(r̂1.u₁)  |$(r̂2.u₁)  |$(r̂3.u₁)  |$(r̂4.u₁)  |$(r̂5.u₁)  |
	| $u_2, \text{м/с}$       |$(r̂1.u₂)  |$(r̂2.u₂)  |$(r̂3.u₂)  |$(r̂4.u₂)  |$(r̂5.u₂)  |
	| $c_1, \text{м/с}$       |$(r̂1.c₁)  |$(r̂2.c₁)  |$(r̂3.c₁)  |$(r̂4.c₁)  |$(r̂5.c₁)  |
	| $w_2, \text{м/с}$       |$(r̂1.w₂)  |$(r̂2.w₂)  |$(r̂3.w₂)  |$(r̂4.w₂)  |$(r̂5.w₂)  |
	"""
end

# ╔═╡ ef9bc959-20a8-44aa-9093-725c4734dd8d
function table_swirl()
	r̂1 = map(x -> round(x; sigdigits=4), R[1])
	r̂2 = map(x -> round(x; sigdigits=4), R[2])
	r̂3 = map(x -> round(x; sigdigits=4), R[3])
	r̂4 = map(x -> round(x; sigdigits=4), R[4])
	r̂5 = map(x -> round(x; sigdigits=4), R[5])

	md"""
	# Обратная закрутка
	| Величина                |Сечение 1 |Сечение 2 |Сечение 3 |Сечение 4 |Сечение 5 |
	|:------------------------|:--------:|:--------:|:--------:|:--------:|:--------:|
	| $r, м$                  |$(r̂1.r₂)  |$(r̂2.r₂)  |$(r̂3.r₂)  |$(r̂4.r₂)  |$(r̂5.r₂)  |
	| $\gamma_1, \degree$     |$(r̂1.γ )  |$(r̂2.γ )  |$(r̂3.γ )  |$(r̂4.γ )  |$(r̂5.γ )  |
	| $c_1, \text{м/с}$       |$(r̂1.c₁)  |$(r̂2.c₁)  |$(r̂3.c₁)  |$(r̂4.c₁)  |$(r̂5.c₁)  |
	| $\alpha_1, \degree$     |$(r̂1.α₁)  |$(r̂2.α₁)  |$(r̂3.α₁)  |$(r̂4.α₁)  |$(r̂5.α₁)  |
	| $c_{1u}, \text{м/с}$    |$(r̂1.c₁u) |$(r̂2.c₁u) |$(r̂3.c₁u) |$(r̂4.c₁u) |$(r̂5.c₁u) |
	| $c_{1z}, \text{м/с}$    |$(r̂1.c₁z) |$(r̂2.c₁z) |$(r̂3.c₁z) |$(r̂4.c₁z) |$(r̂5.c₁z) |
	| $c_{1r}, \text{м/с}$    |$(r̂1.c₁r) |$(r̂2.c₁r) |$(r̂3.c₁r) |$(r̂4.c₁r) |$(r̂5.c₁r) |
	| $u_1, \text{м/с}$       |$(r̂1.u₁)  |$(r̂2.u₁)  |$(r̂3.u₁)  |$(r̂4.u₁)  |$(r̂5.u₁)  |
	| $u_2, \text{м/с}$       |$(r̂1.u₂)  |$(r̂2.u₂)  |$(r̂3.u₂)  |$(r̂4.u₂)  |$(r̂5.u₂)  |
	| $\beta_1, \degree$      |$(r̂1.β₁)  |$(r̂2.β₁)  |$(r̂3.β₁)  |$(r̂4.β₁)  |$(r̂5.β₁)  |
	| $w_1, \text{м/с}$       |$(r̂1.w₁)  |$(r̂2.w₁)  |$(r̂3.w₁)  |$(r̂4.w₁)  |$(r̂5.w₁)  |
	| $w_{1u}, \text{м/с}$    |$(r̂1.w₁u) |$(r̂2.w₁u) |$(r̂3.w₁u) |$(r̂4.w₁u) |$(r̂5.w₁u) |
	| $w_{2u}, \text{м/с}$    |$(r̂1.w₂u) |$(r̂2.w₂u) |$(r̂3.w₂u) |$(r̂4.w₂u) |$(r̂5.w₂u) |
	| $c_{2u}, \text{м/с}$    |$(r̂1.c₂u) |$(r̂2.c₂u) |$(r̂3.c₂u) |$(r̂4.c₂u) |$(r̂5.c₂u) |
	| $c_{2z}, \text{м/с}$    |$(r̂1.c₂z) |$(r̂2.c₂z) |$(r̂3.c₂z) |$(r̂4.c₂z) |$(r̂5.c₂z) |
	| $c_2, \text{м/с}$       |$(r̂1.c₂)  |$(r̂2.c₂)  |$(r̂3.c₂)  |$(r̂4.c₂)  |$(r̂5.c₂)  |
	| $c_{2r}, \text{м/с}$    |$(r̂1.c₂r) |$(r̂2.c₂r) |$(r̂3.c₂r) |$(r̂4.c₂r) |$(r̂5.c₂r) |
	| $\alpha_2, \degree$     |$(r̂1.α₂)  |$(r̂2.α₂)  |$(r̂3.α₂)  |$(r̂4.α₂)  |$(r̂5.α₂)  |
	| $\beta^*_2, \degree$    |$(r̂1.β⃰₂)  |$(r̂2.β⃰₂)  |$(r̂3.β⃰₂)  |$(r̂4.β⃰₂)  |$(r̂5.β⃰₂)  |
	| $w_2, \text{м/с}$       |$(r̂1.w₂)  |$(r̂2.w₂)  |$(r̂3.w₂)  |$(r̂4.w₂)  |$(r̂5.w₂)  |
	| $T_1, \degree C$        |$(r̂1.T₁)  |$(r̂2.T₁)  |$(r̂3.T₁)  |$(r̂4.T₁)  |$(r̂5.T₁)  |
	| $p_1, \text{мПа}$       |$(r̂1.p₁)  |$(r̂2.p₁)  |$(r̂3.p₁)  |$(r̂4.p₁)  |$(r̂5.p₁)  |
	| $\rho_1, \text{кг}/м^3$ |$(r̂1.ρ₁)  |$(r̂2.ρ₁)  |$(r̂3.ρ₁)  |$(r̂4.ρ₁)  |$(r̂5.ρ₁)  |
	| $T^*_{w1}, \degree C$   |$(r̂1.T⃰w₁) |$(r̂2.T⃰w₁) |$(r̂3.T⃰w₁) |$(r̂4.T⃰w₁) |$(r̂5.T⃰w₁) |
	| $T_2, \degree C$        |$(r̂1.T₂)  |$(r̂2.T₂)  |$(r̂3.T₂)  |$(r̂4.T₂)  |$(r̂5.T₂)  |
	| $p_2, \text{мПа}$       |$(r̂1.p₂)  |$(r̂2.p₂)  |$(r̂3.p₂)  |$(r̂4.p₂)  |$(r̂5.p₂)  |
	| $\rho_2, \text{кг}/м^3$ |$(r̂1.ρ₂)  |$(r̂2.ρ₂)  |$(r̂3.ρ₂)  |$(r̂4.ρ₂)  |$(r̂5.ρ₂)  |
	| $2\pi\rho_1 c_{1z}r$    |$(r̂1.πρc₁)|$(r̂2.πρc₁)|$(r̂3.πρc₁)|$(r̂4.πρc₁)|$(r̂5.πρc₁)|
	| $2\pi\rho_2 c_{2z}r$    |$(r̂1.πρc₂)|$(r̂2.πρc₂)|$(r̂3.πρc₂)|$(r̂4.πρc₂)|$(r̂5.πρc₂)|
	| $\rho_T$                |$(r̂1.ρT)  |$(r̂2.ρT)  |$(r̂3.ρT)  |$(r̂4.ρT)  |$(r̂5.ρT)  |
	| $H_p, \text{Дж}$        |$(r̂1.Hₚ)  |$(r̂2.Hₚ)  |$(r̂3.Hₚ)  |$(r̂4.Hₚ)  |$(r̂5.Hₚ)  |
	| $H_u, \text{Дж}$        |$(r̂1.Hᵤ)  |$(r̂2.Hᵤ)  |$(r̂3.Hᵤ)  |$(r̂4.Hᵤ)  |$(r̂5.Hᵤ)  |
	| $\rho_k$                |$(r̂1.ρK)  |$(r̂2.ρK)  |$(r̂3.ρK)  |$(r̂4.ρK)  |$(r̂5.ρK)  |
	| $\rho_\text{k полин}$   |$(r̂1.ρKp) |$(r̂2.ρKp) |$(r̂3.ρKp) |$(r̂4.ρKp) |$(r̂5.ρKp) |
	| $\Delta \rho_k$         |$(r̂1.Δρ)  |$(r̂2.Δρ)  |$(r̂3.Δρ)  |$(r̂4.Δρ)  |$(r̂5.Δρ)  |
	"""
end

# ╔═╡ 3958c916-7eaf-4b0c-9d01-58f218542010
function table_mid()

	ŝ1 = map(x -> round(x; sigdigits=4), S[1])
	ŝ2 = map(x -> round(x; sigdigits=4), S[2])
	ŝ3 = map(x -> round(x; sigdigits=4), S[3])
	ŝ4 = map(x -> round(x; sigdigits=4), S[4])

	md"""
# Газодинамический расчет турбины по среднему диаметру
| Величина                | 1 ступень   | 2 ступень   | 3 ступень   | 4 ступень  |
|:------------------------|:------------|:------------|:------------|:-----------|
| $p_0^*, \text{Па}$      | $(ŝ1.p⃰₀)    | $(ŝ2.p⃰₀)    | $(ŝ3.p⃰₀)    | $(ŝ4.p⃰₀)   |
| $T_0^*, К$              | $(ŝ1.T⃰₀)    | $(ŝ2.T⃰₀)    | $(ŝ3.T⃰₀)    | $(ŝ4.T⃰₀)   |
| $H_0, \text{Дж/кг}$     | $(ŝ1.H₀)    | $(ŝ2.H₀)    | $(ŝ3.H₀)    | $(ŝ4.H₀)   |
| $T_{2tt}, К$            | $(ŝ1.T₂tt)  | $(ŝ2.T₂tt)  | $(ŝ3.T₂tt)  | $(ŝ4.T₂tt) |
| $p_2, \text{Па}$        | $(ŝ1.p₂)    | $(ŝ2.p₂)    | $(ŝ3.p₂)    | $(ŝ4.p₂)   |
| $c_{1t}, \text{м/с}$    | $(ŝ1.c₁t)   | $(ŝ2.c₁t)   | $(ŝ3.c₁t)   | $(ŝ4.c₁t)  |
| $c_1, \text{м/с}$       | $(ŝ1.c₁)    | $(ŝ2.c₁)    | $(ŝ3.c₁)    | $(ŝ4.c₁)   |
| $T_{1t}, К$             | $(ŝ1.T₁t)   | $(ŝ2.T₁t)   | $(ŝ3.T₁t)   | $(ŝ4.T₁t)  |
| $p_1, \text{Па}$        | $(ŝ1.p₁)    | $(ŝ2.p₁)    | $(ŝ3.p₁)    | $(ŝ4.p₁)   |
| $T_1, К$                | $(ŝ1.T₁)    | $(ŝ2.T₁)    | $(ŝ3.T₁)    | $(ŝ4.T₁)   |
| $\rho_1, \text{кг}/м^3$ | $(ŝ1.ρ₁)    | $(ŝ2.ρ₁)    | $(ŝ3.ρ₁)    | $(ŝ4.ρ₁)   |
| $F_{1r}, м^2$           | $(ŝ1.F₁r)   | $(ŝ2.F₁r)   | $(ŝ3.F₁r)   | $(ŝ4.F₁r)  |
| $F_1, м^2$              | $(ŝ1.F₁)    | $(ŝ2.F₁)    | $(ŝ3.F₁)    | $(ŝ4.F₁)   |
| $\alpha_1, ^0$          | $(ŝ1.α₁)    | $(ŝ2.α₁)    | $(ŝ3.α₁)    | $(ŝ4.α₁)   |
| $c_{1u}, \text{м/с}$    | $(ŝ1.c₁u)   | $(ŝ2.c₁u)   | $(ŝ3.c₁u)   | $(ŝ4.c₁u)  |
| $c_{1z}, \text{м/с}$    | $(ŝ1.c₁z)   | $(ŝ2.c₁z)   | $(ŝ3.c₁z)   | $(ŝ4.c₁z)  |
| $u_1, \text{м/с}$       | $(ŝ1.u₁)    | $(ŝ2.u₁)    | $(ŝ3.u₁)    | $(ŝ4.u₁)   |
| $u_2, \text{м/с}$       | $(ŝ1.u₂)    | $(ŝ2.u₂)    | $(ŝ3.u₂)    | $(ŝ4.u₂)   |
| $w_{1u}, \text{м/с}$    | $(ŝ1.w₁u)   | $(ŝ2.w₁u)   | $(ŝ3.w₁u)   | $(ŝ4.w₁u)  |
| $w_1, \text{м/с}$       | $(ŝ1.w₁)    | $(ŝ2.w₁)    | $(ŝ3.w₁)    | $(ŝ4.w₁)   |
| $\beta_1, ^0$           | $(ŝ1.β₁)    | $(ŝ2.β₁)    | $(ŝ3.β₁)    | $(ŝ4.β₁)   |
| $T^*_{w1}, К$           | $(ŝ1.T⃰w₁)   | $(ŝ2.T⃰w₁)   | $(ŝ3.T⃰w₁)   | $(ŝ4.T⃰w₁)  |
| $p^*_{w1}, \text{Па}$   | $(ŝ1.p⃰w₁)   | $(ŝ2.p⃰w₁)   | $(ŝ3.p⃰w₁)   | $(ŝ4.p⃰w₁)  |
| $T^*_{w2}, К$           | $(ŝ1.T⃰w₂)   | $(ŝ2.T⃰w₂)   | $(ŝ3.T⃰w₂)   | $(ŝ4.T⃰w₂)  |
| $p^*_{w2t}, \text{Па}$  | $(ŝ1.p⃰w₂t)  | $(ŝ2.p⃰w₂t)  | $(ŝ3.p⃰w₂t)  | $(ŝ4.p⃰w₂t) |
| $H^*_2, \text{Дж/кг}$   | $(ŝ1.H⃰₂)    | $(ŝ2.H⃰₂)    | $(ŝ3.H⃰₂)    | $(ŝ4.H⃰₂)   |
| $w_{2t}, \text{м/с}$    | $(ŝ1.w₂t)   | $(ŝ2.w₂t)   | $(ŝ3.w₂t)   | $(ŝ4.w₂t)  |
| $w_2, \text{м/с}$       | $(ŝ1.w₂)    | $(ŝ2.w₂)    | $(ŝ3.w₂)    | $(ŝ4.w₂)   |
| $T_2, К$                | $(ŝ1.T₂)    | $(ŝ2.T₂)    | $(ŝ3.T₂)    | $(ŝ4.T₂)   |
| $F_{2r}, м^2$           | $(ŝ1.F₂r)   | $(ŝ2.F₂r)   | $(ŝ3.F₂r)   | $(ŝ4.F₂r)  |
| $F_2, м^2$              | $(ŝ1.F₂)    | $(ŝ2.F₂)    | $(ŝ3.F₂)    | $(ŝ4.F₂)   |
| $\beta^*_2, ^0$         | $(ŝ1.β⃰₂)    | $(ŝ2.β⃰₂)    | $(ŝ3.β⃰₂)    | $(ŝ4.β⃰₂)   |
| $w_{2u}, \text{м/с}$    | $(ŝ1.w₂u)   | $(ŝ2.w₂u)   | $(ŝ3.w₂u)   | $(ŝ4.w₂u)  |
| $c_{2z}=w_{2z}, \text{м/с}$| $(ŝ1.c₂z)| $(ŝ2.c₂z)   | $(ŝ3.c₂z)   | $(ŝ4.c₂z)  |
| $c_{2u}, \text{м/с}$    | $(ŝ1.c₂u)   | $(ŝ2.c₂u)   | $(ŝ3.c₂u)   | $(ŝ4.c₂u)  |
| $\alpha_2, ^0$          | $(ŝ1.α₂)    | $(ŝ2.α₂)    | $(ŝ3.α₂)    | $(ŝ4.α₂)   |
| $c_2, \text{м/с}$       | $(ŝ1.c₂)    | $(ŝ2.c₂)    | $(ŝ3.c₂)    | $(ŝ4.c₂)   |
| $T^*_2, К$              | $(ŝ1.T⃰₂)    | $(ŝ2.T⃰₂)    | $(ŝ3.T⃰₂)    | $(ŝ4.T⃰₂)   |
| $p_2^*, \text{Па}$      | $(ŝ1.p⃰₂)    | $(ŝ2.p⃰₂)    | $(ŝ3.p⃰₂)    | $(ŝ4.p⃰₂)   |
| $M_{c1}$                | $(ŝ1.Mc₁)   | $(ŝ2.Mc₁)   | $(ŝ3.Mc₁)   | $(ŝ4.Mc₁)  |
| $M_{w2}$                | $(ŝ1.Mw₂)   | $(ŝ2.Mw₂)   | $(ŝ3.Mw₂)   | $(ŝ4.Mw₂)  |
| $T^*_{2tt}, K$          | $(ŝ1.T⃰₂tt)  | $(ŝ2.T⃰₂tt)  | $(ŝ3.T⃰₂tt)  | $(ŝ4.T⃰₂tt) |
| $\eta_u$                | $(ŝ1.ηᵤ)    | $(ŝ2.ηᵤ)    | $(ŝ3.ηᵤ)    | $(ŝ4.ηᵤ)   |
| $\eta^*_u$              | $(ŝ1.η⃰ᵤ)    | $(ŝ2.η⃰ᵤ)    | $(ŝ3.η⃰ᵤ)    | $(ŝ4.η⃰ᵤ)   |
"""
end

# ╔═╡ b2981751-027d-4129-b6a4-7967947e4ffa
function table_mid_params()
	p̂1 = map(x -> round(x; sigdigits=4), P[1])
	p̂2 = map(x -> round(x; sigdigits=4), P[2])
	p̂3 = map(x -> round(x; sigdigits=4), P[3])
	p̂4 = map(x -> round(x; sigdigits=4), P[4])

	md"""
	### Параметры для расчета по среднему диаметру
	| Величина    | 1 ступень | 2 ступень | 3 ступень | 4 ступень | Комментарии |
	|:------------|:---------:|:---------:|:---------:|:---------:|:------------|
	| $d_{1c}, м$ | $(p̂1.d₁c) | $(p̂2.d₁c) | $(p̂3.d₁c) | $(p̂4.d₁c) | с.д. направляющей лопатки  |
	| $d_{2c}, м$ | $(p̂1.d₂c) | $(p̂2.d₂c) | $(p̂3.d₂c) | $(p̂4.d₂c) | с.д. рабочей лопатки       |
	| $l_1, м$    | $(p̂1.l₁)  | $(p̂2.l₁)  | $(p̂3.l₁)  | $(p̂4.l₁)  | длина направляющей лопатки |
	| $l_2, м$    | $(p̂1.l₂)  | $(p̂2.l₂)  | $(p̂3.l₂)  | $(p̂4.l₂)  | длина рабочей лопатки      |
	| $p_2, \text{Па}$|$(p̂1.p₂)|$(p̂2.p₂)  | $(p̂3.p₂)  | $(p̂4.p₂)  | давление за ступенью       |
	| $\rho_{Tk}$ | $(p̂1.ρTk) | $(p̂2.ρTk) | $(p̂3.ρTk) | $(p̂4.ρTk) |  |
	| $\rho_{Tc}$ | $(p̂1.ρTc) | $(p̂2.ρTc) | $(p̂3.ρTc) | $(p̂4.ρTc) |  |
	| $n$         | $(p̂1.n)   | $(p̂2.n)   | $(p̂3.n)   | $(p̂4.n)   |  |
	| $\Phi$      | $(p̂1.Φ)   | $(p̂2.Φ)   | $(p̂3.Φ)   | $(p̂4.Φ)   |  |
	| $\Psi$      | $(p̂1.Ψ)   | $(p̂2.Ψ)   | $(p̂3.Ψ)   | $(p̂4.Ψ)   |  |
	| $rk$        | $(p̂1.rk)  | $(p̂2.rk)  | $(p̂3.rk)  | $(p̂4.rk)  |  |
	| $rc$        | $(p̂1.rc)  | $(p̂2.rc)  | $(p̂3.rc)  | $(p̂4.rc)  |  |
	"""
end

# ╔═╡ b0faed30-459f-40f0-b7a8-52fabde15bb7
function table_prime()
	Î = map(x -> round(x; sigdigits=4), I)
	
	md"""
	# Входные условия для _ГТЭ 65_
	| Величина                 | Значения       | Комментарии               |
	|:-------------------------|:--------------:|:--------------------------|
	| $P_0, \text{Па}$         | $(TASK.P⃰₀)     | Давление перед турбиной   |
	| $T_0, С$                 | $(TASK.T⃰₀)     | Температура перед турбиной|
	| $N, Вт$                  | $(TASK.N)      | Мощность (общая)          |
	| $n, \text{мин}^{-1}$     | $(TASK.n)      | Обороты                   |
	| $\alpha, ^0$             | $(TASK.α)      | Угол выхода из 4 ступени  |
	| $m$                      | $(TASK.m)      | Число ступеней            |
	| $G_{A2GTP}, \text{кг/с}$ | $(TASK.G_A2GTP)| Расход из A2GTP           |
	| $Gₒₚₜ,      \text{кг/с}$ | $(Gₒₚₜ)        | Эвристика                 |
	| $d_{mid},   \text{м}$    | $(TASK.d_mid)  | Средний диаметр. У меня был расчет по $u/C_0$ |

	### константы:
	| Величина         | Значения      | Комментарии                      |
	|:-----------------|:-------------:|---------------------------------:|
	| $K_{газ}$        | $(CONST.Kгаз) | Коэффициент политропы газа       |
	| $R, \text{Па}$   | $(CONST.R)    | Универсальная газовая постоянная |
	| $\lambda$        | $(CONST.λ)    | Лямбда?                          |
	| $\eta_{ад}$      | $(CONST.ηад)  | Адиабатный КПД                   |

	# Первичный расчет
	| Величина                   | Значения   | Комментарии                    |
	|:---------------------------|:----------:|:-------------------------------|
	| $C_p, \text{Па}$           | $(Î.Cp)    | Изобарная теплоёмкость газа    |
	| $H_u T, \text{Дж/кг}$      | $(Î.HuT)   | У Аделины есть kN, другой метод|
	| $\Delta T^*_T, К$          | $(Î.ΔtT)   | Температура торможения за р.л. |
	| $T_{2T}, К$                | $(Î.T⃰₂T)   |                                |
	| $a_{кр2}, \text{м/с}$      | $(Î.a_kr)  | Критическая скорость           |
	| $c_{2T}, \text{м/с}$       | $(Î.c₂T)   |                                |
	| $H_{адт}, \text{Дж/кг}$    | $(Î.H_adt) |                                |
	| $H_{0T}, \text{Дж/кг}$     | $(Î.H₀T)   |                                |
	| $T^*_{2T}, К$              | $(Î.T₂tT)  |                                |
	| $p_{2T}, \text{Па}$        | $(Î.p₂T)   |                                |
	| $T_{2T}, К$                | $(Î.T₂T)   |                                |
	| $\rho_{2T}, \text{кг}/м^3$ | $(Î.ρ₂T)   |                                |
	| $F_{2T}, м^2$              | $(Î.F₂T)   | Площадь на выходе из турбины   |
	| $\sigma p, \text{МПа}$     | $(Î.σ_p)   | Напряжение в корневом сечении  |
	| $u_2, \text{м/с}$          | $(Î.u₂)    | Окружная скорость              |
	| $l_2, м$                   | $(Î.l₂)    | Длина рабочей лопатки          |
	| $d_{2T}/l_2$               | $(Î.d₂Tl₂) | Отношение фигней               |
	| $Y$                        | $(Î.Y)     | Это $u/C_0$                    |
	"""
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CairoMakie = "13f3f980-e62b-5c42-98c6-ff1f3baf88f0"
JSON = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[compat]
CairoMakie = "~0.15.6"
JSON = "~0.21.4"
LaTeXStrings = "~1.4.0"
PlutoUI = "~0.7.62"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.12.1"
manifest_format = "2.0"
project_hash = "832f7853c2ec3552ca1b52be9bbe64aacf5ef079"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "d92ad398961a3ed262d8bf04a1a2b8340f915fef"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.5.0"
weakdeps = ["ChainRulesCore", "Test"]

    [deps.AbstractFFTs.extensions]
    AbstractFFTsChainRulesCoreExt = "ChainRulesCore"
    AbstractFFTsTestExt = "Test"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.AbstractTrees]]
git-tree-sha1 = "2d9c9a55f9c93e8887ad391fbae72f8ef55e1177"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.5"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "7e35fca2bdfba44d797c53dfe63a51fabf39bfc0"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.4.0"
weakdeps = ["SparseArrays", "StaticArrays"]

    [deps.Adapt.extensions]
    AdaptSparseArraysExt = "SparseArrays"
    AdaptStaticArraysExt = "StaticArrays"

[[deps.AdaptivePredicates]]
git-tree-sha1 = "7e651ea8d262d2d74ce75fdf47c4d63c07dba7a6"
uuid = "35492f91-a3bd-45ad-95db-fcad7dcfedb7"
version = "1.2.0"

[[deps.AliasTables]]
deps = ["PtrArrays", "Random"]
git-tree-sha1 = "9876e1e164b144ca45e9e3198d0b689cadfed9ff"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.1.3"

[[deps.Animations]]
deps = ["Colors"]
git-tree-sha1 = "e092fa223bf66a3c41f9c022bd074d916dc303e7"
uuid = "27a7e980-b3e6-11e9-2bcd-0b925532e340"
version = "0.4.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Automa]]
deps = ["PrecompileTools", "SIMD", "TranscodingStreams"]
git-tree-sha1 = "a8f503e8e1a5f583fbef15a8440c8c7e32185df2"
uuid = "67c07d97-cdcb-5c2c-af73-a7f9c32a568b"
version = "1.1.0"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "01b8ccb13d68535d73d2b0c23e39bd23155fb712"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.1.0"

[[deps.AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "4126b08903b777c88edf1754288144a0492c05ad"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.8"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.BaseDirs]]
git-tree-sha1 = "bca794632b8a9bbe159d56bf9e31c422671b35e0"
uuid = "18cc8868-cbac-4acf-b575-c8ff214dc66f"
version = "1.3.2"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1b96ea4a01afe0ea4090c5c8039690672dd13f2e"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.9+0"

[[deps.CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[deps.CRC32c]]
uuid = "8bf52ea8-c179-5cab-976a-9e18b702a9bc"
version = "1.11.0"

[[deps.CRlibm]]
deps = ["CRlibm_jll"]
git-tree-sha1 = "66188d9d103b92b6cd705214242e27f5737a1e5e"
uuid = "96374032-68de-5a5b-8d9e-752f78720389"
version = "1.0.2"

[[deps.CRlibm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e329286945d0cfc04456972ea732551869af1cfc"
uuid = "4e9b3aee-d8a1-5a3d-ad8b-7d824db253f0"
version = "1.0.1+0"

[[deps.Cairo]]
deps = ["Cairo_jll", "Colors", "Glib_jll", "Graphics", "Libdl", "Pango_jll"]
git-tree-sha1 = "71aa551c5c33f1a4415867fe06b7844faadb0ae9"
uuid = "159f3aea-2a34-519c-b102-8c37f9878175"
version = "1.1.1"

[[deps.CairoMakie]]
deps = ["CRC32c", "Cairo", "Cairo_jll", "Colors", "FileIO", "FreeType", "GeometryBasics", "LinearAlgebra", "Makie", "PrecompileTools"]
git-tree-sha1 = "f8caabc5a1c1fb88bcbf9bc4078e5656a477afd0"
uuid = "13f3f980-e62b-5c42-98c6-ff1f3baf88f0"
version = "0.15.6"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "fde3bf89aead2e723284a8ff9cdf5b551ed700e8"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.5+0"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "e4c6a16e77171a5f5e25e9646617ab1c276c5607"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.26.0"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.ColorBrewer]]
deps = ["Colors", "JSON"]
git-tree-sha1 = "e771a63cc8b539eca78c85b0cabd9233d6c8f06f"
uuid = "a2cac450-b92f-5266-8821-25eda20663c8"
version = "0.4.1"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "b0fd3f56fa442f81e0a47815c92245acfaaa4e34"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.31.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"
weakdeps = ["SpecialFunctions"]

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "37ea44092930b1811e666c3bc38065d7d87fcc74"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.13.1"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "9d8a54ce4b17aa5bdce0ea5c34bc5e7c340d16ad"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.18.1"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.3.0+1"

[[deps.ComputePipeline]]
deps = ["Observables", "Preferences"]
git-tree-sha1 = "cb1299fee09da21e65ec88c1ff3a259f8d0b5802"
uuid = "95dc2771-c249-4cd0-9c9f-1f3b4330693c"
version = "0.1.4"

[[deps.ConstructionBase]]
git-tree-sha1 = "b4b092499347b18a015186eae3042f72267106cb"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.6.0"
weakdeps = ["IntervalSets", "LinearAlgebra", "StaticArrays"]

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseLinearAlgebraExt = "LinearAlgebra"
    ConstructionBaseStaticArraysExt = "StaticArrays"

[[deps.Contour]]
git-tree-sha1 = "439e35b0b36e2e5881738abc8857bd92ad6ff9a8"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.3"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "4e1fe97fdaed23e9dc21d4d664bea76b65fc50a0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.22"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.DelaunayTriangulation]]
deps = ["AdaptivePredicates", "EnumX", "ExactPredicates", "Random"]
git-tree-sha1 = "5620ff4ee0084a6ab7097a27ba0c19290200b037"
uuid = "927a84f5-c5f4-47a5-9785-b46e178433df"
version = "1.6.4"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"
version = "1.11.0"

[[deps.Distributions]]
deps = ["AliasTables", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns"]
git-tree-sha1 = "3bc002af51045ca3b47d2e1787d6ce02e68b943a"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.122"

    [deps.Distributions.extensions]
    DistributionsChainRulesCoreExt = "ChainRulesCore"
    DistributionsDensityInterfaceExt = "DensityInterface"
    DistributionsTestExt = "Test"

    [deps.Distributions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DensityInterface = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.DocStringExtensions]]
git-tree-sha1 = "7442a5dfe1ebb773c29cc2962a8980f47221d76c"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.5"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e3290f2d49e661fbd94046d7e3726ffcb2d41053"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.4+0"

[[deps.EnumX]]
git-tree-sha1 = "bddad79635af6aec424f53ed8aad5d7555dc6f00"
uuid = "4e289a0a-7415-4d19-859d-a7e5c4648b56"
version = "1.0.5"

[[deps.ExactPredicates]]
deps = ["IntervalArithmetic", "Random", "StaticArrays"]
git-tree-sha1 = "83231673ea4d3d6008ac74dc5079e77ab2209d8f"
uuid = "429591f6-91af-11e9-00e2-59fbe8cec110"
version = "2.2.9"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7bb1361afdb33c7f2b085aa49ea8fe1b0fb14e58"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.7.1+0"

[[deps.Extents]]
git-tree-sha1 = "b309b36a9e02fe7be71270dd8c0fd873625332b4"
uuid = "411431e0-e8b7-467b-b5e0-f676ba4f2910"
version = "0.1.6"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "eaa040768ea663ca695d442be1bc97edfe6824f2"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "6.1.3+0"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "Libdl", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "97f08406df914023af55ade2f843c39e99c5d969"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.10.0"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6d6219a004b8cf1e0b4dbe27a2860b8e04eba0be"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.11+0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "d60eb76f37d7e5a40cc2e7c36974d864b82dc802"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.17.1"

    [deps.FileIO.extensions]
    HTTPExt = "HTTP"

    [deps.FileIO.weakdeps]
    HTTP = "cd3eb016-35fb-5094-929b-558a96fad6f3"

[[deps.FilePaths]]
deps = ["FilePathsBase", "MacroTools", "Reexport", "Requires"]
git-tree-sha1 = "919d9412dbf53a2e6fe74af62a73ceed0bce0629"
uuid = "8fc22ac5-c921-52a6-82fd-178b2807b824"
version = "0.8.3"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates"]
git-tree-sha1 = "3bab2c5aa25e7840a4b065805c0cdfc01f3068d2"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.24"
weakdeps = ["Mmap", "Test"]

    [deps.FilePathsBase.extensions]
    FilePathsBaseMmapExt = "Mmap"
    FilePathsBaseTestExt = "Test"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FillArrays]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "173e4d8f14230a7523ae11b9a3fa9edb3e0efd78"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.14.0"
weakdeps = ["PDMats", "SparseArrays", "Statistics"]

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Zlib_jll"]
git-tree-sha1 = "f85dac9a96a01087df6e3a749840015a0ca3817d"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.17.1+0"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.FreeType]]
deps = ["CEnum", "FreeType2_jll"]
git-tree-sha1 = "907369da0f8e80728ab49c1c7e09327bf0d6d999"
uuid = "b38be410-82b0-50bf-ab77-7b57e271db43"
version = "4.1.1"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "2c5512e11c791d1baed2049c5652441b28fc6a31"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.4+0"

[[deps.FreeTypeAbstraction]]
deps = ["BaseDirs", "ColorVectorSpace", "Colors", "FreeType", "GeometryBasics", "Mmap"]
git-tree-sha1 = "4ebb930ef4a43817991ba35db6317a05e59abd11"
uuid = "663a7486-cb36-511b-a19d-713bb74d65c9"
version = "0.10.8"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7a214fdac5ed5f59a22c2d9a885a16da1c74bbc7"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.17+0"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "Extents", "IterTools", "LinearAlgebra", "PrecompileTools", "Random", "StaticArrays"]
git-tree-sha1 = "1f5a80f4ed9f5a4aada88fc2db456e637676414b"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.5.10"

    [deps.GeometryBasics.extensions]
    GeometryBasicsGeoInterfaceExt = "GeoInterface"

    [deps.GeometryBasics.weakdeps]
    GeoInterface = "cf35fbd7-0cd7-5166-be24-54bfbe79505f"

[[deps.GettextRuntime_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll"]
git-tree-sha1 = "45288942190db7c5f760f59c04495064eedf9340"
uuid = "b0724c58-0f36-5564-988d-3bb0596ebc4a"
version = "0.22.4+0"

[[deps.Giflib_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6570366d757b50fabae9f4315ad74d2e40c0560a"
uuid = "59f7168a-df46-5410-90c8-f2779963d0ec"
version = "5.2.3+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "GettextRuntime_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "50c11ffab2a3d50192a228c313f05b5b5dc5acb2"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.86.0+0"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "a641238db938fff9b2f60d08ed9030387daf428c"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.3"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a6dbda1fd736d60cc477d99f2e7a042acfa46e8"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.15+0"

[[deps.GridLayoutBase]]
deps = ["GeometryBasics", "InteractiveUtils", "Observables"]
git-tree-sha1 = "93d5c27c8de51687a2c70ec0716e6e76f298416f"
uuid = "3955a311-db13-416c-9275-1d80ed98e5e9"
version = "0.11.2"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll"]
git-tree-sha1 = "f923f9a774fcf3f5cb761bfa43aeadd689714813"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "8.5.1+0"

[[deps.HypergeometricFunctions]]
deps = ["LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "68c173f4f449de5b438ee67ed0c9c748dc31a2ec"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.28"

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

[[deps.ImageAxes]]
deps = ["AxisArrays", "ImageBase", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "e12629406c6c4442539436581041d372d69c55ba"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.12"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "eb49b82c172811fd2c86759fa0553a2221feb909"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.7"

[[deps.ImageCore]]
deps = ["ColorVectorSpace", "Colors", "FixedPointNumbers", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "PrecompileTools", "Reexport"]
git-tree-sha1 = "8c193230235bbcee22c8066b0374f63b5683c2d3"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.10.5"

[[deps.ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs", "WebP"]
git-tree-sha1 = "696144904b76e1ca433b886b4e7edd067d76cbf7"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.9"

[[deps.ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "2a81c3897be6fbcde0802a0ebe6796d0562f63ec"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.10"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "0936ba688c6d201805a83da835b55c61a180db52"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.11+0"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "d1b1b796e47d94588b3757fe84fbf65a5ec4a80d"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.5"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl"]
git-tree-sha1 = "ec1debd61c300961f98064cfb21287613ad7f303"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2025.2.0+0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "65d505fa4c0d7072990d659ef3fc086eb6da8208"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.16.2"

    [deps.Interpolations.extensions]
    InterpolationsForwardDiffExt = "ForwardDiff"
    InterpolationsUnitfulExt = "Unitful"

    [deps.Interpolations.weakdeps]
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.IntervalArithmetic]]
deps = ["CRlibm", "MacroTools", "OpenBLASConsistentFPCSR_jll", "Random", "RoundingEmulator"]
git-tree-sha1 = "79342df41c3c24664e5bf29395cfdf2f2a599412"
uuid = "d1acc4aa-44c8-5952-acd4-ba5d80a2a253"
version = "0.22.36"

    [deps.IntervalArithmetic.extensions]
    IntervalArithmeticArblibExt = "Arblib"
    IntervalArithmeticDiffRulesExt = "DiffRules"
    IntervalArithmeticForwardDiffExt = "ForwardDiff"
    IntervalArithmeticIntervalSetsExt = "IntervalSets"
    IntervalArithmeticLinearAlgebraExt = "LinearAlgebra"
    IntervalArithmeticRecipesBaseExt = "RecipesBase"
    IntervalArithmeticSparseArraysExt = "SparseArrays"

    [deps.IntervalArithmetic.weakdeps]
    Arblib = "fb37089c-8514-4489-9461-98f9c8763369"
    DiffRules = "b552c78f-8df3-52c6-915a-8e097449b14b"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
    RecipesBase = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.IntervalSets]]
git-tree-sha1 = "5fbb102dcb8b1a858111ae81d56682376130517d"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.11"

    [deps.IntervalSets.extensions]
    IntervalSetsRandomExt = "Random"
    IntervalSetsRecipesBaseExt = "RecipesBase"
    IntervalSetsStatisticsExt = "Statistics"

    [deps.IntervalSets.weakdeps]
    Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
    RecipesBase = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
    Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.InverseFunctions]]
git-tree-sha1 = "a779299d77cd080bf77b97535acecd73e1c5e5cb"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.17"
weakdeps = ["Dates", "Test"]

    [deps.InverseFunctions.extensions]
    InverseFunctionsDatesExt = "Dates"
    InverseFunctionsTestExt = "Test"

[[deps.IrrationalConstants]]
git-tree-sha1 = "e2222959fbc6c19554dc15174c81bf7bf3aa691c"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.4"

[[deps.Isoband]]
deps = ["isoband_jll"]
git-tree-sha1 = "f9b6d97355599074dc867318950adaa6f9946137"
uuid = "f1662d9f-8043-43de-a69a-05efc1cc6ff4"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "42d5f897009e7ff2cf88db414a389e5ed1bdd023"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.10.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "0533e564aae234aff59ab625543145446d8b6ec2"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.7.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "9496de8fb52c224a2e3f9ff403947674517317d9"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.6"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4255f0032eafd6451d707a51d5f0248b8a165e4d"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.1.3+0"

[[deps.JuliaSyntaxHighlighting]]
deps = ["StyledStrings"]
uuid = "ac6e5ff7-fb65-4e79-a425-ec3bc9c03011"
version = "1.12.0"

[[deps.KernelDensity]]
deps = ["Distributions", "DocStringExtensions", "FFTW", "Interpolations", "StatsBase"]
git-tree-sha1 = "ba51324b894edaf1df3ab16e2cc6bc3280a2f1a7"
uuid = "5ab0869b-81aa-558d-bb23-cbf5423bbe9b"
version = "0.6.10"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "059aabebaa7c82ccb853dd4a0ee9d17796f7e1bc"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.3+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "aaafe88dccbd957a8d82f7d05be9b69172e0cee3"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "4.0.1+0"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "eb62a3deb62fc6d8822c0c4bef73e4412419c5d8"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "18.1.8+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1c602b1127f4751facb671441ca72715cc95938a"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.3+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"
version = "1.11.0"

[[deps.LazyModules]]
git-tree-sha1 = "a560dd966b386ac9ae60bdd3a3d3a326062d3c3e"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "OpenSSL_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.11.1+1"

[[deps.LibGit2]]
deps = ["LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "OpenSSL_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.9.0+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "OpenSSL_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.3+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c8da7e6a91781c41a863611c7e966098d783c57a"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.4.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "d36c21b9e7c172a44a10484125024495e2625ac0"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.7.1+1"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "be484f5c92fad0bd8acfef35fe017900b0b73809"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.18.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3acf07f130a76f87c041cfb2ff7d7284ca67b072"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.41.2+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "f04133fe05eff1667d2054c53d59f9122383fe05"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.7.2+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "2a7a12fc0a4e7fb773450d17975322aa77142106"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.41.2+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.12.0"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "13ca9e2586b89836fd20cccf56e57e2b9ae7f38f"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.29"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.MIMEs]]
git-tree-sha1 = "c64d943587f7187e751162b3b84445bbbd79f691"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.1.0"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "oneTBB_jll"]
git-tree-sha1 = "282cadc186e7b2ae0eeadbd7a4dffed4196ae2aa"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2025.2.0+0"

[[deps.MacroTools]]
git-tree-sha1 = "1e0228a030642014fe5cfe68c2c0a818f9e3f522"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.16"

[[deps.Makie]]
deps = ["Animations", "Base64", "CRC32c", "ColorBrewer", "ColorSchemes", "ColorTypes", "Colors", "ComputePipeline", "Contour", "Dates", "DelaunayTriangulation", "Distributions", "DocStringExtensions", "Downloads", "FFMPEG_jll", "FileIO", "FilePaths", "FixedPointNumbers", "Format", "FreeType", "FreeTypeAbstraction", "GeometryBasics", "GridLayoutBase", "ImageBase", "ImageIO", "InteractiveUtils", "Interpolations", "IntervalSets", "InverseFunctions", "Isoband", "KernelDensity", "LaTeXStrings", "LinearAlgebra", "MacroTools", "Markdown", "MathTeXEngine", "Observables", "OffsetArrays", "PNGFiles", "Packing", "Pkg", "PlotUtils", "PolygonOps", "PrecompileTools", "Printf", "REPL", "Random", "RelocatableFolders", "Scratch", "ShaderAbstractions", "Showoff", "SignedDistanceFields", "SparseArrays", "Statistics", "StatsBase", "StatsFuns", "StructArrays", "TriplotBase", "UnicodeFun", "Unitful"]
git-tree-sha1 = "368542cde25d381e44d84c3c4209764f05f4ef19"
uuid = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a"
version = "0.24.6"

[[deps.MappedArrays]]
git-tree-sha1 = "2dab0221fe2b0f2cb6754eaa743cc266339f527e"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.2"

[[deps.Markdown]]
deps = ["Base64", "JuliaSyntaxHighlighting", "StyledStrings"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MathTeXEngine]]
deps = ["AbstractTrees", "Automa", "DataStructures", "FreeTypeAbstraction", "GeometryBasics", "LaTeXStrings", "REPL", "RelocatableFolders", "UnicodeFun"]
git-tree-sha1 = "a370fef694c109e1950836176ed0d5eabbb65479"
uuid = "0a4f8689-d25c-4efe-a92b-7142dfc1aa53"
version = "0.6.6"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "7b86a5d4d70a9f5cdf2dacb3cbe6d251d1a61dbe"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.4"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2025.5.20"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "9b8215b1ee9e78a293f99797cd31375471b2bcae"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.1.3"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore", "ImageMetadata"]
git-tree-sha1 = "d92b107dbb887293622df7697a2223f9f8176fcd"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.1.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.3.0"

[[deps.Observables]]
git-tree-sha1 = "7438a59546cf62428fc9d1bc94729146d37a7225"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.5.5"

[[deps.OffsetArrays]]
git-tree-sha1 = "117432e406b5c023f665fa73dc26e79ec3630151"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.17.0"
weakdeps = ["Adapt"]

    [deps.OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "b6aa4566bb7ae78498a5e68943863fa8b5231b59"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.6+0"

[[deps.OpenBLASConsistentFPCSR_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "567515ca155d0020a45b05175449b499c63e7015"
uuid = "6cdc7f73-28fd-5e50-80fb-958a8875b1af"
version = "0.3.29+0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.29+0"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "97db9e07fe2091882c765380ef58ec553074e9c7"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.3"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "8292dd5c8a38257111ada2174000a33745b06d4e"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.2.4+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.7+0"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.5.1+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1346c9208249809840c91b26703912dff463d335"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.6+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c392fc5dd032381919e3b22dd32d6443760ce7ea"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.5.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "05868e21324cede2207c6f0f466b4bfef6d5e7ee"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.1"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.44.0+1"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "f07c06228a1c670ae4c87d1276b92c7c597fdda0"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.35"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "cf181f0b1e6a18dfeb0ee8acc4a9d1672499626c"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.4.4"

[[deps.Packing]]
deps = ["GeometryBasics"]
git-tree-sha1 = "bc5bf2ea3d5351edf285a06b0016788a121ce92c"
uuid = "19eb6ba3-879d-56ad-ad62-d5c202156566"
version = "0.5.1"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "0fac6313486baae819364c52b4f483450a9d793f"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.12"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1f7f9bbd5f7a2e5a9f7d96e51c9754454ea7f60b"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.56.4+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "7d2f8f21da5db6a806faf7b9b292296da42b2810"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.3"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "db76b1ecd5e9715f3d043cec13b2ec93ce015d53"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.44.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.12.0"
weakdeps = ["REPL"]

    [deps.Pkg.extensions]
    REPLExt = "REPL"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "f9501cc0430a26bc3d156ae1b5b0c1b47af4d6da"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.3.3"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "StableRNGs", "Statistics"]
git-tree-sha1 = "3ca9a356cd2e113c420f2c13bea19f8d3fb1cb18"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.3"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "d3de2694b52a01ce61a036f18ea9c0f61c4a9230"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.62"

[[deps.PolygonOps]]
git-tree-sha1 = "77b3d3605fc1cd0b42d95eba87dfcd2bf67d5ff6"
uuid = "647866c9-e3ac-4575-94e7-e3d426903924"
version = "0.1.2"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "0f27480397253da18fe2c12a4ba4eb9eb208bf3d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.5.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "fbb92c6c56b34e1a2c4c36058f68f332bec840e7"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.11.0"

[[deps.PtrArrays]]
git-tree-sha1 = "1d36ef11a9aaf1e8b74dacc6a731dd1de8fd493d"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.3.0"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "8b3fc30bc0390abdce15f8822c889f669baed73d"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.1"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "9da16da70037ba9d701192e27befedefb91ec284"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.11.2"

    [deps.QuadGK.extensions]
    QuadGKEnzymeExt = "Enzyme"

    [deps.QuadGK.weakdeps]
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"

[[deps.REPL]]
deps = ["InteractiveUtils", "JuliaSyntaxHighlighting", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "1342a47bf3260ee108163042310d26f2be5ec90b"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.5"
weakdeps = ["FixedPointNumbers"]

    [deps.Ratios.extensions]
    RatiosFixedPointNumbersExt = "FixedPointNumbers"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "62389eeff14780bfe55195b7204c0d8738436d64"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.1"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "852bd0f55565a9e973fcfee83a84413270224dc4"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.8.0"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "58cdd8fb2201a6267e1db87ff148dd6c1dbd8ad8"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.5.1+0"

[[deps.RoundingEmulator]]
git-tree-sha1 = "40b9edad2e5287e05bd413a38f61a8ff55b9557b"
uuid = "5eaf0fd0-dfba-4ccb-bf02-d820a40db705"
version = "0.2.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SIMD]]
deps = ["PrecompileTools"]
git-tree-sha1 = "e24dc23107d426a096d3eae6c165b921e74c18e4"
uuid = "fdea26ae-647d-5447-a871-4b548cad5224"
version = "3.7.2"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "9b81b8393e50b7d4e6d0a9f14e192294d3b7c109"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.3.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.ShaderAbstractions]]
deps = ["ColorTypes", "FixedPointNumbers", "GeometryBasics", "LinearAlgebra", "Observables", "StaticArrays"]
git-tree-sha1 = "818554664a2e01fc3784becb2eb3a82326a604b6"
uuid = "65257c39-d410-5151-9873-9b3e5be5013e"
version = "0.5.0"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"
version = "1.11.0"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SignedDistanceFields]]
deps = ["Random", "Statistics", "Test"]
git-tree-sha1 = "d263a08ec505853a5ff1c1ebde2070419e3f28e9"
uuid = "73760f76-fbc4-59ce-8f25-708e95d2df96"
version = "0.4.0"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "be8eeac05ec97d379347584fa9fe2f5f76795bcb"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.5"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "0494aed9501e7fb65daba895fb7fd57cc38bc743"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.5"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "64d974c2e6fdf07f8155b5b2ca2ffa9069b608d9"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.2"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.12.0"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "f2685b435df2613e25fc10ad8c26dddb8640f547"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.6.1"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.StableRNGs]]
deps = ["Random"]
git-tree-sha1 = "95af145932c2ed859b63329952ce8d633719f091"
uuid = "860ef19b-820b-49d6-a774-d7a799459cd3"
version = "1.0.3"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "be1cf4eb0ac528d96f5115b4ed80c26a8d8ae621"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.2"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "b8693004b385c842357406e3af647701fe783f98"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.15"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "192954ef1208c7019899fbf8049e717f92959682"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.3"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"
weakdeps = ["SparseArrays"]

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "9d72a13a3f4dd3795a195ac5a44d7d6ff5f552ff"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.1"

[[deps.StatsBase]]
deps = ["AliasTables", "DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "2c962245732371acd51700dbb268af311bddd719"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.6"

[[deps.StatsFuns]]
deps = ["HypergeometricFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "8e45cecc66f3b42633b8ce14d431e8e57a3e242e"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.5.0"
weakdeps = ["ChainRulesCore", "InverseFunctions"]

    [deps.StatsFuns.extensions]
    StatsFunsChainRulesCoreExt = "ChainRulesCore"
    StatsFunsInverseFunctionsExt = "InverseFunctions"

[[deps.StructArrays]]
deps = ["ConstructionBase", "DataAPI", "Tables"]
git-tree-sha1 = "8ad2e38cbb812e29348719cc63580ec1dfeb9de4"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.7.1"

    [deps.StructArrays.extensions]
    StructArraysAdaptExt = "Adapt"
    StructArraysGPUArraysCoreExt = ["GPUArraysCore", "KernelAbstractions"]
    StructArraysLinearAlgebraExt = "LinearAlgebra"
    StructArraysSparseArraysExt = "SparseArrays"
    StructArraysStaticArraysExt = "StaticArrays"

    [deps.StructArrays.weakdeps]
    Adapt = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    KernelAbstractions = "63c18a36-062a-441e-b654-da1e3ab1ce7c"
    LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.8.3+2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "f2c1efbc8f3a609aadf318094f8fc5204bdaf344"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.12.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "PrecompileTools", "ProgressMeter", "SIMD", "UUIDs"]
git-tree-sha1 = "98b9352a24cb6a2066f9ababcc6802de9aed8ad8"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.11.6"

[[deps.TranscodingStreams]]
git-tree-sha1 = "0c45878dcfdcfa8480052b6ab162cdd138781742"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.3"

[[deps.Tricks]]
git-tree-sha1 = "372b90fe551c019541fafc6ff034199dc19c8436"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.12"

[[deps.TriplotBase]]
git-tree-sha1 = "4d4ed7f294cda19382ff7de4c137d24d16adc89b"
uuid = "981d1d27-644d-49a2-9326-4793e63143c3"
version = "0.1.0"

[[deps.URIs]]
git-tree-sha1 = "bef26fb046d031353ef97a82e3fdb6afe7f21b1a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.6.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "cec2df8cf14e0844a8c4d770d12347fda5931d72"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.25.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    ForwardDiffExt = "ForwardDiff"
    InverseFunctionsUnitfulExt = "InverseFunctions"
    LatexifyExt = ["Latexify", "LaTeXStrings"]
    PrintfExt = "Printf"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"
    LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
    Latexify = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
    Printf = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.WebP]]
deps = ["CEnum", "ColorTypes", "FileIO", "FixedPointNumbers", "ImageCore", "libwebp_jll"]
git-tree-sha1 = "aa1ca3c47f119fbdae8770c29820e5e6119b83f2"
uuid = "e3aaa7dc-3e4b-44e0-be63-ffb868ccd7c1"
version = "0.1.3"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c1a7aa6219628fcd757dede0ca95e245c5cd9511"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "1.0.0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "fee71455b0aaa3440dfdd54a9a36ccef829be7d4"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.8.1+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "b5899b25d17bf1889d25906fb9deed5da0c15b3b"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.12+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "aa1261ebbac3ccc8d16558ae6799524c450ed16b"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.13+0"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "52858d64353db33a56e13c341d7bf44cd0d7b309"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.6+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "a4c0ee07ad36bf8bbce1c3bb52d21fb1e0b987fb"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.7+0"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "7ed9347888fac59a618302ee38216dd0379c480d"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.12+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXau_jll", "Xorg_libXdmcp_jll"]
git-tree-sha1 = "bfcaf7ec088eaba362093393fe11aa141fa15422"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.17.1+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a63799ff68005991f9d9491b6e95bd3478d783cb"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.6.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.3.1+2"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "446b23e73536f84e8037f5dce465e92275f6a308"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.7+1"

[[deps.isoband_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51b5eeb3f98367157a7a12a1fb0aa5328946c03c"
uuid = "9a68df92-36a6-505f-a73e-abb412b6bfb4"
version = "0.2.3+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "371cc681c00a3ccc3fbc5c0fb91f58ba9bec1ecf"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.13.1+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "125eedcb0a4a0bba65b657251ce1d27c8714e9d6"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.17.4+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.15.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "646634dd19587a56ee2f1199563ec056c5f228df"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.4+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "07b6a107d926093898e82b3b1db657ebe33134ec"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.50+0"

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "libpng_jll"]
git-tree-sha1 = "c1733e347283df07689d71d61e14be986e49e47a"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.10.5+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll"]
git-tree-sha1 = "11e1772e7f3cc987e9d3de991dd4f6b2602663a5"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.8+0"

[[deps.libwebp_jll]]
deps = ["Artifacts", "Giflib_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libglvnd_jll", "Libtiff_jll", "libpng_jll"]
git-tree-sha1 = "4e4282c4d846e11dce56d74fa8040130b7a95cb3"
uuid = "c5f90fcd-3b7e-5836-afba-fc50a0988cb2"
version = "1.6.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.64.0+1"

[[deps.oneTBB_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl"]
git-tree-sha1 = "d5a767a3bb77135a99e433afe0eb14cd7f6914c3"
uuid = "1317d2d5-d96f-522e-a858-c73665f53c3e"
version = "2022.0.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.5.0+2"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "14cc7083fc6dff3cc44f2bc435ee96d06ed79aa7"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "10164.0.1+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e7b67590c14d487e734dcb925924c5dc43ec85f3"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "4.1.0+0"
"""

# ╔═╡ Cell order:
# ╟─89d5d4d4-a5f0-11f0-275d-edfe9355555d
# ╟─4b0d698d-7921-4bf0-b5d4-0bf680d992e5
# ╟─fb7eb31f-8d28-4e05-b994-29a85e359b14
# ╟─b5be0f61-904f-498d-8b4d-3bb84cf62270
# ╟─56a5a75a-20ff-443e-992a-c8a5957b7a90
# ╟─40561c16-193e-4349-bc16-a7d9ceb55f62
# ╟─692ea0cf-2fc9-47fb-9542-930c64ac94bc
# ╟─ec47fa62-62ea-4bf8-a57f-9e6b10b5fa0b
# ╟─65781f50-667a-44c0-beb2-466dfb293d36
# ╟─77bbea27-c0fa-4320-ab84-ff91730410e3
# ╟─7290e07c-eedc-429f-a2fa-7130dae8da37
# ╟─c2b940ae-7013-4184-916f-cc2c6c3bb718
# ╟─23866f8f-bdff-45be-afcd-91d3c87a200e
# ╟─cfbd1033-b649-4ab2-941a-1519bcc28986
# ╟─3e5014a8-e39f-4d3c-bb2f-122dea8482bb
# ╟─e24903de-8706-4d29-aaf0-2005799675e1
# ╠═4e7e1ddb-8a03-4818-be9e-fa31698faf07
# ╟─1f21d0d2-43a3-489b-9b77-d09d0824f799
# ╟─4acc88bf-4bbf-49b5-8006-920901d8ddc9
# ╟─7e4039e8-ed6c-46eb-a079-9df82d4272d6
# ╟─d1889b73-726a-468b-9bb9-e69cd81a796b
# ╟─6316022b-a071-4d6b-be2a-d786c8edad45
# ╟─d51bd461-3106-4b8d-9d3a-66c7fb6c8ab1
# ╟─43b474fc-51fa-4aef-86fa-cba0eb59bcf9
# ╟─9ade3b75-1232-4b47-bd1f-a5ac636d3fc6
# ╠═20f45d03-754e-4d6a-b1ad-431745281c4e
# ╠═ba361882-01ce-426b-8725-90f00d00be4a
# ╟─44ec2743-fcc2-41fd-a7eb-0e86202ccb6b
# ╟─65e1301d-9baa-4c84-9bbf-0a82ed444c29
# ╟─e93e7b4b-069f-44c5-8a0a-d1236ee4b2cc
# ╟─7e3efafc-2d86-4e36-ad67-bbb12de0a0c0
# ╠═e4ead9dc-7b59-4f4c-ae3f-83f4a842dedb
# ╟─a74f6353-4c78-49e3-998f-baec3f10377d
# ╟─2fd068a7-9f7f-49ab-986b-c15593d89eee
# ╟─b0aa65a1-3433-4b48-9196-d47e6e35379e
# ╟─7e82ca6c-5c36-4c0d-ba07-914ff604f107
# ╟─48f45b5a-03af-4b1c-bdb9-16964246e85c
# ╟─8fd74453-354f-4cae-8e46-c310abdc6b5b
# ╟─18159b8a-c05b-4191-9eae-71f7b7646e7d
# ╟─6cf7f12e-cc58-4b08-816b-584e02dbd071
# ╟─0654861a-f4d5-4adb-b929-8e7e6ae78b89
# ╟─bd295267-109a-4c84-bba3-7cdd0d682b18
# ╟─ca7636ed-2d30-4086-bc61-ef31ab371969
# ╟─8845a7bd-f62c-4531-953e-5aabd6b8e708
# ╟─5d979de0-beb0-41df-a5cd-779eec0e611f
# ╟─92eaacb2-756d-4f8e-b9c3-c02353c14417
# ╟─0f7c4d6c-e748-4de0-8166-47d03f4129ec
# ╟─61b7a669-218b-4cc2-a45b-ea70cdda0250
# ╟─9d1db807-3229-4d28-b78b-325f9c82c60d
# ╟─0edf5251-3d74-4f2c-bced-88fdb511d2f8
# ╟─7cb1c106-ccfe-48eb-af87-0eb6812a4000
# ╟─b4612166-cbe9-4b21-b630-e08481294a03
# ╟─4886ddbb-9cc1-483c-8441-bd2b1961d540
# ╟─8047ae16-5263-46a7-8ef9-ee6a82c9f520
# ╟─071cf1e8-2cb9-40d6-8930-90ce150e22fb
# ╟─8e992360-1373-4168-bc59-a7b04792befa
# ╟─08812d58-0a6f-4845-94fe-5c9a965a118c
# ╟─c31c4aba-1cb8-4d45-9e25-634f929b67e6
# ╟─8678ac5d-fea0-4697-b2e6-799e72afda5a
# ╟─1ae0f50a-c021-41cd-a389-cec934e34e26
# ╟─ef9bc959-20a8-44aa-9093-725c4734dd8d
# ╟─3958c916-7eaf-4b0c-9d01-58f218542010
# ╟─b2981751-027d-4129-b6a4-7967947e4ffa
# ╟─b0faed30-459f-40f0-b7a8-52fabde15bb7
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
