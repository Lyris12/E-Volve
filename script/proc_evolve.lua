--coded by Lyris
--Not yet finalized values
--Custom constants
EFFECT_EXTRA_EVOLVE_MATERIAL			= 525
EFFECT_CANNOT_BE_EVOLVE_MATERIAL		= 526
TYPE_EVOLVE								= 0x100000000
TYPE_CUSTOM								= TYPE_CUSTOM | TYPE_EVOLVE
CTYPE_EVOLVE							= 0x1000
CTYPE_CUSTOM							= CTYPE_CUSTOM | CTYPE_EVOLVE

SUMMON_TYPE_EVOLVE						= SUMMON_TYPE_SPECIAL+525

REASON_EVOLVE							= 0x20000000

--Custom Type Table
Auxiliary.Evolves						= {} --number as index = card, card as index = function() is_fusion

--overwrite constants
TYPE_EXTRA							= TYPE_EXTRA | TYPE_EVOLVE

--overwrite functions
local getType, getOrigType, getPrevTypeField, isRankBelow = Card.GetType, Card.GetOriginalType, Card.GetPreviousTypeOnField, Card.IsRankBelow

Card.GetType = function(c, scard, sumtype, p)
	local tpe = scard and get_type(c, scard, sumtype, p) or get_type(c)
	if Auxiliary.Evolves[c] then
		tpe = tpe | TYPE_EVOLVE
		if not Auxiliary.Evolves[c]() then
			tpe = tpe &~ TYPE_XYZ
		end
	end
	return tpe
end
Card.GetOriginalType = function(c)
	local tpe = get_orig_type(c)
	if Auxiliary.Evolves[c] then
		tpe = tpe | TYPE_EVOLVE
		if not Auxiliary.Evolves[c]() then
			tpe = tpe &~ TYPE_XYZ
		end
	end
	return tpe
end
Card.GetPreviousTypeOnField = function(c)
	local tpe = get_prev_type_field(c)
	if Auxiliary.Evolves[c] then
		tpe = tpe | TYPE_EVOLVE
		if not Auxiliary.Evolves[c]() then
			tpe = tpe &~ TYPE_XYZ
		end
	end
	return tpe
end
Card.IsRankBelow = function(c, rk)
	if Auxiliary.Evolves[c] and not Auxiliary.Evolves[c]() then return false end
	return is_rank_below(c, rk)
end

--Custom Functions
function Card.IsCanBeEvolveMaterial(c, ec)
	if not (c:IsControler(ec:GetControler()) and c:IsLocation(LOCATION_MZONE)) then
		local tef1 = {c:IsHasEffect(EFFECT_EXTRA_EVOLVE_MATERIAL, tp)}
		local tef1alt = {ec:IsHasEffect(EFFECT_EXTRA_EVOLVE_MATERIAL, tp)}
		local ValidSubstitute = false
		for _, te1 in ipairs(tef1) do
			local con = te1:GetCondition()
			local val = te1:GetValue()
			if (not con or con(c, ec, 1)) and (not val or type(val) == "number" or (type(val) == "function" and val(te1, ec))) then ValidSubstitute = true end
		end
		for _, te1alt in ipairs(tef1alt) do
			local val = te1alt:GetValue()
			if not val or type(val) == "number" or (type(val) == "function" and val(te1alt, c)) then ValidSubstitute = true end
		end
		if not ValidSubstitute then return false end
	else
		if c:IsFacedown() then return false end
	end
	local tef2 = {c:IsHasEffect(EFFECT_CANNOT_BE_EVOLVE_MATERIAL)}
	for _, te2 in ipairs(tef2) do
		local tev = te2:GetValue()
		if type(tev) == 'function' then
			if tev(te2, ec) then return false end
		elseif tev ~= 0 then return false end
	end
	return true
end
function Auxiliary.AddOrigEvolveType(c, isxyz)
	table.insert(Auxiliary.Evolves, c)
	Auxiliary.Customs[c] = true
	local isxyz = isxyz == nil and false or isxyz
	Auxiliary.Evolves[c] = function() return isxyz end
end
function Auxiliary.AddEvolveProc(c, mcode, econ)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local mt = c:GetMetatable()
	mt.material = mcode
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(Auxiliary.EvolveCondition(mcode, econ)
	e2:SetTarget(Auxiliary.EvolveTarget(mcode, econ)
	e2:SetOperation(Auxiliary.EvolveOperation)
	e2:SetValue(SUMMON_TYPE_EVOLVE)
	c:RegisterEffect(e2)
end
function Auxiliary.EvolveMatFilter(c, tp, ec, mcode, econ)
	return c:IsCode(mcode) and econ(tp, ec, c)
end
function Auxiliary.EvoluteCondition(mcode, econ)
	return	function(e, c)
				if c == nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp = c:GetControler()
				local mg = Duel.GetMatchingGroup(Card.IsCanBeEvolveMaterial, tp, 0x11e, 0x11e, nil, c)
				return mg:IsExists(Auxiliary.EvolveMatFilter, 1, nil, tp, c, mcode, econ)
			end
end
function Auxiliary.EvolveTarget(mcode, econ)
	return	function(e, tp, eg, ep, ev, re, r, rp, chk, c)
				local mg = Duel.GetMatchingGroup(Card.IsCanBeEvolveMaterial, tp, 0x11e, 0x11e, nil, c)
				Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
				local tc=mg:Filter(Auxiliary.EvolveMatFilter, nil, tp, c, mcode, econ):SelectUnselect(tp, false, Duel.IsSummonCancelable(), 1. 1)
				if tc then
					e:SetLabelObject(tc)
					return true
				else return false end
			end
end
function Auxiliary.EvolveOperation()
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_EVOLVE)
	g:DeleteGroup()
end
