--Hero Signal
function c22020927.initial_effect(c)
	--When a monster you control is destroyed by battle and sent to the Graveyard: Special Summon 1 Level 4 or lower "HERO" monster from your hand or Deck, except a "Destiny HERO" monster.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c22020927.condition)
	e1:SetTarget(c22020927.target)
	e1:SetOperation(c22020927.operation)
	c:RegisterEffect(e1)
end
c22020927.listed_series={0x8,0xc008}
function c22020927.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE) and c:IsLocation(LOCATION_GRAVE) and c:IsPreviousControler(tp)
end
function c22020927.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c22020927.cfilter,1,nil,tp)
end
function c22020927.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x8) and not c:IsSetCard(0xc008) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22020927.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22020927.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c22020927.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22020927.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
