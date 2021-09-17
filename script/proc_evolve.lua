--coded by Lyris
--Not yet finalized values
--Custom constants
EFFECT_EXTRA_EVOLVE_MATERIAL		= 525
EFFECT_CANNOT_BE_EVOLVE_MATERIAL	= 526
TYPE_EVOLVE							= 0x100000000
TYPE_CUSTOM							= TYPE_CUSTOM|TYPE_EVOLVE
CTYPE_EVOLVE						= 0x1000
CTYPE_CUSTOM						= CTYPE_CUSTOM|CTYPE_EVOLVE

SUMMON_TYPE_EVOLVE					= SUMMON_TYPE_SPECIAL+

REASON_EVOLVE						= 0x20000000

--Custom Type Table
Auxiliary.Evolves = {} --number as index = card, card as index = function() is_fusion

--overwrite constants
TYPE_EXTRA	= TYPE_EXTRA|TYPE_EVOLVE

--overwrite functions
local getType, getOrigType, getPrevTypeField, isRankBelow = Card.GetType, Card.GetOriginalType, Card.GetPreviousTypeOnField, Card.IsRankBelow

Card.GetType=function(c, scard, sumtype, p)
	local tpe=scard and get_type(c,scard,sumtype,p) or get_type(c)
	if Auxiliary.Evolves[c] then
		tpe=tpe|TYPE_EVOLVE
		if not Auxiliary.Evolves[c]() then
			tpe=tpe&~TYPE_XYZ
		end
	end
	return tpe
end
Card.GetOriginalType=function(c)
	local tpe=get_orig_type(c)
	if Auxiliary.Evolves[c] then
		tpe=tpe|TYPE_EVOLVE
		if not Auxiliary.Evolves[c]() then
			tpe=tpe&~TYPE_XYZ
		end
	end
	return tpe
end
Card.GetPreviousTypeOnField=function(c)
	local tpe=get_prev_type_field(c)
	if Auxiliary.Evolves[c] then
		tpe=tpe|TYPE_EVOLVE
		if not Auxiliary.Evolves[c]() then
			tpe=tpe&~TYPE_XYZ
		end
	end
	return tpe
end
Card.IsRankBelow=function(c, rk)
	if Auxiliary.Evolves[c] and not Auxiliary.Evolves[c]() then return false end
	return is_rank_below(c,rk)
end

--Custom Functions
function Card.IsCanBeEvolveMaterial(c, ec)
	if not (c:IsControler(ec:GetControler()) and c:IsLocation(LOCATION_MZONE)) then
		local tef1={c:IsHasEffect(EFFECT_EXTRA_EVOLVE_MATERIAL, tp)}
		local tef1alt={ec:IsHasEffect(EFFECT_EXTRA_EVOLVE_MATERIAL, tp)}
		local ValidSubstitute=false
		for _,te1 in ipairs(tef1) do
			local con=te1:GetCondition()
			local val=te1:GetValue()
			if (not con or con(c,ec,1)) and (not val or type(val)=="number" or (type(val)=="function" and val(te1,ec))) then ValidSubstitute=true end
		end
		for _,te1alt in ipairs(tef1alt) do
			local val=te1alt:GetValue()
			if not val or type(val)=="number" or (type(val)=="function" and val(te1alt,c)) then ValidSubstitute=true end
		end
		if not ValidSubstitute then return false end
	else
		if c:IsFacedown() then return false end
	end
	local tef2={c:IsHasEffect(EFFECT_CANNOT_BE_EVOLVE_MATERIAL)}
	for _,te2 in ipairs(tef2) do
		local tev=te2:GetValue()
		if type(tev)=='function' then
			if tev(te2,ec) then return false end
		elseif tev~=0 then return false end
	end
	return true
end
function Auxiliary.AddOrigEvolveType(c,isxyz)
	table.insert(Auxiliary.Evolves,c)
	Auxiliary.Customs[c]=true
	local isxyz=isxyz==nil and false or isxyz
	Auxiliary.Evolves[c]=function() return isxyz end
end
function Auxiliary.AddEvolveProc(c, mname, econ)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local mt=c:GetMetatable()
	mt.material = mname
end
