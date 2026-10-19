--[VAACT] Le Croc de Critias (The Fang of Critias)
local s,id=GetID()

--ID de la carte officielle (traitée comme elle) : à modifier ici si besoin
s.officiel=11082056
--ID de "Dragon Légendaire Critias" (The Legendary Dragon Critias) : à modifier ici si besoin
s.critias=10000060

function s.initial_effect(c)
	--Traitée comme la carte d'origine
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(s.officiel)
	c:RegisterEffect(e0)
	--Aussi traitée comme "Dragon Légendaire Critias"
	local e0b=e0:Clone()
	e0b:SetValue(s.critias)
	c:RegisterEffect(e0b)
	--Bannir 1 Piège (Terrain ou Cimetière), puis Invoquer le Monstre Fusion correspondant depuis l'Extra Deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.spfilter(c,e,tp,tc)
	return c:IsType(TYPE_FUSION) and c.material_trap and tc:IsCode(c.material_trap)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.tgfilter(c,e,tp)
	return c:IsTrap() and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_ONFIELD|LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD|LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_ONFIELD|LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp):GetFirst()
	if not tc then return end
	if tc:IsOnField() and tc:IsFacedown() then Duel.ConfirmCards(1-tp,tc) end
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc):GetFirst()
	if sc then
		Duel.BreakEffect()
		Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
