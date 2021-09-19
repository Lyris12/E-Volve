--The Flute of Summoning Kuriboh
function c522150002.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,522150002)
	e1:SetTarget(c522150002.target)
	e1:SetOperation(c522150002.activate)
	c:RegisterEffect(e1)
end
function c522150002.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa4) and (c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c522150002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c522150002.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c522150002.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c522150002.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	aux.ToHandOrElse(sc,tp,function(c)
								return sc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
							end,
							function(c)
								return Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
							end,
	2)
end
