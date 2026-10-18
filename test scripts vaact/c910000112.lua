--[VAACT] La Flûte d'Invocation du Dragon (The Flute of Summoning Dragon)
local s,id=GetID()

--ID de la carte officielle (traitée comme elle) : à modifier ici si besoin
s.officiel=43973174
--ID de "Seigneur des D." (Lord of D.) : à modifier ici si besoin
s.seigneur=17985575

s.listed_names={s.seigneur}

function s.initial_effect(c)
	--Traitée comme The Flute of Summoning Dragon officielle
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(s.officiel)
	c:RegisterEffect(e0)

	--Activation
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c,e,sp)
	return c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function s.lord(tp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,s.seigneur),tp,LOCATION_MZONE,0,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	--Vous : 1 Dragon, ou autant que vous voulez si vous contrôlez "Seigneur des D."
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	local max=s.lord(tp) and ft or 1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,max,nil,e,tp)
	if #g==0 then return end
	local ct=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	--Votre adversaire : jusqu'à (nombre invoqué - 1) Dragons depuis sa main
	if ct<=1 then return end
	local oft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(1-tp,CARD_BLUEEYES_SPIRIT) then oft=math.min(oft,1) end
	local omax=math.min(ct-1,oft)
	if omax<=0 then return end
	if not Duel.IsExistingMatchingCard(s.filter,1-tp,LOCATION_HAND,0,1,nil,e,1-tp) then return end
	if not Duel.SelectYesNo(1-tp,aux.Stringid(id,0)) then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
	local og=Duel.SelectMatchingCard(1-tp,s.filter,1-tp,LOCATION_HAND,0,1,omax,nil,e,1-tp)
	if #og>0 then
		Duel.SpecialSummon(og,0,1-tp,1-tp,false,false,POS_FACEUP)
	end
end