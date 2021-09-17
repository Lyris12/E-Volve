--coded by Lyris
--Not yet finalized values
--Custom constants
ATTRIBUTE_DREAM	= 0x80

Auxiliary.DreamAttributes = {} --number as index = card, card as index = function() is_fusion

local get_orig_attribute, get_attribute, get_fus_attribute, is_attribute, is_fus_attribute =
	Card.GetOriginalAttribute, Card.GetAttribute, Card.GetFusionAttribute, Card.IsAttribute, Card.IsFusionAttribute

Card.GetOriginalAttribute=function(tc)
	if tc==c then return f1(tc)&0x7f-() else return f1(tc) end
end
Card.GetAttribute=function(tc)
	if tc==c then
		if f2(tc)==f1(tc) and (tc:IsHasEffect(EFFECT_ADD_ATTRIBUTE) or tc:IsHasEffect(EFFECT_CHANGE_ATTRIBUTE)) then
			return f2(tc)
		else
			return f1(tc)
		end
	else return f2(tc) end
end
Card.GetFusionAttribute=function(tc, p)
	if tc==c then
		if f2(tc)==f1(tc) and (tc:IsHasEffect(EFFECT_CHANGE_FUSION_ATTRIBUTE) or tc:IsHasEffect(EFFECT_ADD_FUSION_ATTRIBUTE)) then
			return f3(tc,p)
		else return f2(tc) end
	else return f3(tc,p) end
end
Card.IsAttribute=function(tc, catt)
	if tc==c then return f2(tc)&catt==catt else return f4(tc,catt) end
end
Card.IsFusionAttribute=function(tc, catt, p)
	if tc==c then return f3(tc,p)&catt==catt else return f5(tc,catt,p) end
end
function Auxiliary.EnableDreamAttribute(c, att, add)
end
