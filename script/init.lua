TYPE_CUSTOM			= 0
CTYPE_CUSTOM		= 0
--overwrite constants
TYPE_EXTRA			=TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK
REASON_EXTRA		=REASON_FUSION+REASON_SYNCHRO+REASON_XYZ+REASON_LINK
--Custom Type Tables
Auxiliary.Customs={} --check if card uses custom type, indexing card
--Custom Functions
function Card.IsCustomReason(c, rs)
	return (c:GetReason()>>32)&rs>0
end
function Card.IsCustomType(c, tpe, scard, sumtype, p)
	return (c:GetType(scard, sumtype, p)>>32)&tpe>0
end
--overwrite functions
local isReason, getType, isType = Card.IsReason, Card.GetType, Card.IsType
Duel.LoadScript("proc_dream.lua")
Duel.LoadScript("proc_evolve.lua")
Card.IsReason=function(c, rs)
	local cusrs=rs>>32
	local ors=rs&0xffffffff
	if c:GetReason()&ors>0 then return true end
	if cusrs<=0 then return false end
	return c:IsCustomReason(cusrs)
end
Card.GetType=function(c, scard, sumtype, p)
	local tpe=scard and get_type(c, scard, sumtype, p) or get_type(c)
	if is_type(c, TYPE_GEMINI, scard, sumtype, p) and not c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) then
		tpe=(tpe|TYPE_NORMAL)&~TYPE_EFFECT
	end
	return tpe
end
Card.IsType=function Card.IsType(c, tpe, scard, sumtype, p)
	local custpe=tpe>>32
	local otpe=tpe&0xffffffff
	--fix for changing type in deck
	if c:IsLocation(LOCATION_DECK) and c:IsHasEffect(EFFECT_ADD_TYPE) and not scard and not sumtype and not p then
		local egroup={c:IsHasEffect(EFFECT_ADD_TYPE)}
		local typ=0
		for _, ce in ipairs(egroup) do
			if typ&ce:GetValue()==0 then
				typ=typ|ce:GetValue()
			end
		end
		return typ&tpe>0
	end
	if (scard and c:GetType(scard, sumtype, p)&otpe>0) or (not scard and c:GetType()&otpe>0) then return true end
	if custpe<=0 then return false end
	return c:IsCustomType(custpe, scard, sumtype, p)
end
