--coded by Lyris
--Not yet finalized values
--Custom constants
ATTRIBUTE_DREAM	= 0x80

Auxiliary.DreamAttributes = {} --number as index = card, card as index = function() is_fusion

local f1, f2, f3 = Card.GetOriginalAttribute, Card.GetAttribute, Card.IsAttribute
Card.GetOriginalAttribute=function(c)
	if Auxiliary.DreamAttributes[c] then return Auxiliary.DreamAttributes[c]() and f1(c)|ATTRIBUTE_DREAM or ATTRIBUTE_DREAM else return f1(c) end
end
Card.GetAttribute=function(c, sc, st, p)
	if Auxiliary.DreamAttributes[c] then
		if f2(c, sc, st, p)==f1(c, sc, st, p) and (c:IsHasEffect(EFFECT_ADD_ATTRIBUTE) or c:IsHasEffect(EFFECT_CHANGE_ATTRIBUTE)) then
			return f2(c, sc, st, p)|ATTRIBUTE_DREAM
		else
			return c:GetOriginalAttribute(sc, st, p)|ATTRIBUTE_DREAM
		end
	else return f2(c, sc, st, p) end
end
Card.IsAttribute=function(c, catt, sc, st, p)
	if Auxiliary.DreamAttributes[c] then return c:GetAttribute(sc, st, p)&catt==catt else return f3(c, catt, sc, st, p) end
end
function Auxiliary.EnableDreamAttribute(c, add)
	table.insert(Auxiliary.DreamAttributes,c)
	Auxiliary.Customs[c]=true
	local add=add==nil and false or add
	Auxiliary.DreamAttributes[c]=function() return add end
end
