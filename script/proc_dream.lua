--coded by Lyris
--Not yet finalized values
--Custom constants
ATTRIBUTE_DREAM	 = 0x80

Auxiliary.DreamAttributes = {} --number as index = card, card as index = function() is_fusion

local f1, f2, f3 = Card.GetOriginalAttribute, Card.GetAttribute, Card.IsAttribute
Card.GetOriginalAttribute = function(c)
	if Auxiliary.DreamAttributes[c] then return Auxiliary.DreamAttributes[c]() and f1(c) | ATTRIBUTE_DREAM or ATTRIBUTE_DREAM else return f1(c) end
end
Card.GetAttribute = function(c, sc, st, p)
	if Auxiliary.DreamAttributes[c] then
		if f2(c, sc, st, p) == f1(c, sc, st, p) and (c:IsHasEffect(EFFECT_ADD_ATTRIBUTE) or c:IsHasEffect(EFFECT_CHANGE_ATTRIBUTE)) then
			return f2(c, sc, st, p) | ATTRIBUTE_DREAM
		else
			return f1(c) | ATTRIBUTE_DREAM
		end
	else return f2(c, sc, st, p) end
end
Card.IsAttribute = function(c, catt, sc, st, p)
	if Auxiliary.DreamAttributes[c] then return c:GetAttribute(sc, st, p) & catt == catt else return f3(c, catt, sc, st, p) end
end
function Auxiliary.EnableDreamAttribute(c, add)
	table.insert(Auxiliary.DreamAttributes, c)
	Auxiliary.Customs[c] = true
	local add = add == nil and false or add
	Auxiliary.DreamAttributes[c] = function() return add end
end
local xDreamCodes = {1287123, 2134346, 2792265, 2863439, 4035199, 4392470, 4848423, 5257687, 5519829, 7526150, 7572887, 7582066, 7914843, 7969770, 8687195, 8809344, 10992251, 12298909, 12948099, 13193642, 13215230, 13676474, 14812659, 15150371, 15173384, 16768387, 17412721, 20351153, 22200403, 24348204, 25788011, 28450915, 28546905, 30451366, 31242786, 32965616, 34945480, 36107810, 37043180, 39180960, 40200834, 40387124, 42921475, 44913552, 45103815, 45282603, 46247516, 48202661, 49370026, 51838385, 52022648, 54191698, 55623480, 57062206, 58655504, 59290628, 60246171, 65393205, 65953423, 67547370, 68049471, 68870276, 69380702, 69456283, 70307656, 70780151, 70913714, 71625222, 75285069, 75574498, 77827521, 78636495, 79575620, 80532587, 81306586, 81587028, 82065276, 83464209, 84271823, 85684223, 86937530, 89494469, 90590303, 90963488, 92597893, 93889755, 95568112, 97811903}
local xDreamSetCs = {0x150, 0x131, 0x147}
local function filter(c)
	return c:IsSetCard(0) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_PSYCHIC)
end
local e1 = Effect.GlobalEffect()
e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
e1:SetCode(EVENT_STARTUP)
e1:SetOperation(function(e)
	for tc in Auxiliary.Next(Duel.GetMatchingGroup(Card.IsCode, 0, 0xff, 0xff, nil, table.unpack(xDreams))) do
		Auxiliary.EnableDreamAttribute(tc, not tc:IsCode(97811903))
	end
	for tc in Auxiliary.Next(Duel.GetMatchingGroup(Auxiliary.OR(filter, Card.IsSetCard), 0, 0xff, 0xff, nil, table.unpack(xDreamSetCs))) do
		Auxiliary.EnableDreamAttribute(c, true)
	end
end)
Duel.RegisterEffect(e1, 0)
