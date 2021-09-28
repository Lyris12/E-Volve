--UnLOCK Fusion
local s, id = GetID()
function s.initial_effect(c)
	--Fusion Summon 1 "LOCK" Fusion Monster from your Extra Deck, by shuffling your banished Fusion Materials listed on it into your Deck. You cannot Special Summon other monsters during the turn you activate this card, except "LOCK" monsters.
	local e1 = Fusion.CreateSummonEff(c, aux.FilterBoolFunction(Card.IsSetCard, 0xfa3), aux.FALSE, s.fextra, Fusion.ShuffleMaterial)
	e1:SetCost(s.cost)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id, ACTIVITY_SPSUMMON, s.counterfilter)
end
s.listed_series={0xfa3}
function s.fextra(e, tp, mg)
	return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsFaceup, Card.IsAbleToDeck), tp, LOCATION_REMOVED, 0, nil)
end
function s.counterfilter(c)
	return c:IsSetCard(0xfa3)
end
function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then return Duel.GetCustomActivityCount(id, tp, ACTIVITY_SPSUMMON) == 0 end
	local e1 = Effect.CreateEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabelObject(e)
	e1:SetTargetRange(1, 0)
	e1:SetTarget(s.sumlimit)
	Duel.RegisterEffect(e1, tp)
	aux.RegisterClientHint(c, nil, tp, 1, 0, aux.Stringid(id, 1), nil)
end
function s.sumlimit(e, c, sump, sumtype, sumpos, targetp, se)
	return e:GetLabelObject() ~= se and not c:IsSetCard(0xfa3)
end
