--Blessing of the Legendary Dragon
local s, id = GetID()
function s.initial_effect(c)
	--Equip only to an Evolve Monster. The equipped monster's name becomes "Servant of the Legendary Dragon" while equipped with this card, and gains ATK equal to the number of other monsters on the field with the same attribute x100.
	aux.AddEquipProcedure(c, nil, aux.FilterBoolFunction(Card.IsType, TYPE_EVOLVE))
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(function(e, c) return Duel.GetMatchingGroupCount(aux.FilterFaceupFunction(Card.IsAttribute, c:GetAttribute()), e:GetHandlerPlayer(), LOCATION_ONFIELD, LOCATION_ONFIELD, c)*100 end)
	c:RegisterEffect(e1)
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetValue(id//1000)
	c:RegisterEffect(e2)
end
