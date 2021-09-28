--The Flute of Summoning Kuriboh
local s, id = GetID()
function s.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c, e, tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa4) and (c:IsAbleToHand() or (Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)))
end
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_DECK, 0, 1, nil, e, tp) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK)
end
function s.activate(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local sc = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_DECK, 0, 1, 1, nil):GetFirst()
	aux.ToHandOrElse(sc, tp, function(c)
								return sc:IsCanBeSpecialSummoned(e, 0, tp, false, false, POS_FACEUP, tp) and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
							end,
							function(c)
								return Duel.SpecialSummon(sc, 0, tp, tp, false, false, POS_FACEUP)
							end,
	2)
end
