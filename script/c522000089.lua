--Dream Team-Up
local s, id = GetID()
function s.initial_effect(c)
	--Reveal 3 DREAM monsters with different Types and Levels in your Deck; your opponent selects 1 at random to add to your hand, then shuffle the rest back into your Deck.
	local e1 = Effect.CreateEffect(c)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetCost(function() e1:SetLabel(1) return true end)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DREAM) and c:IsAbleToHand()
end
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	local rvg = Duel.GetMatchingGroup(aux.AND(s.cfilter, aux.NOT(Card.IsPublic)), tp, LOCATION_DECK, 0, nil)
	if chk == 0 then
		if e:GetLabel() ~= 1 then return false end
		e:SetLabel(0)
		return rvg:GetClassCount(Card.GetRace) > 2 and rvg:GetClassCount(Card.GetLevel) > 2
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, 0, LOCATION_DECK)
	local rg = aux.SelectUnselectGroup(rvg, e, tp, 3, 3, s.diffchk, 1, tp, HINTMSG_CONFIRM)
	Duel.ConfirmCards(1-tp, rg)
	local t = {}
	for tc in aux.Next(rg) do table.insert(t, tc:GetCode()) end
	e:SetLabelObject(t)
end
function s.filter(c, code)
	return s.cfilter(c) and c:IsCode(code)
end
function s.activate(e, tp, eg, ep, ev, re, r, rp)
	local rg = Group.CreateGroup()
	for _, code in ipairs(e:GetLabelObject()) do rg:AddCard(Duel.GetFirstMatchingCard(s.filter, tp, LOCATION_DECK, 0, nil, code)) end
	Duel.SendtoHand(rg:RandomSelect(1-tp, 1), nil, REASON_EFFECT)
end
