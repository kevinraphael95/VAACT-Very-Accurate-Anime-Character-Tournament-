--[VAACT] Dark Renewal
local s,id=GetID()

--ID de la carte officielle (traitée comme elle) : à modifier ici si besoin
s.officiel=9287078

function s.initial_effect(c)
	--Traité comme Dark Renewal officiel
	local e_add=Effect.CreateEffect(c)
	e_add:SetType(EFFECT_TYPE_SINGLE)
	e_add:SetCode(EFFECT_ADD_CODE)
	e_add:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add:SetValue(s.officiel)
	c:RegisterEffect(e_add)

	--Quand l'adversaire Invoque : cibler 1 de ces monstres + 1 de vos monstres, les envoyer au Cimetière, puis Invoquer 1 Magicien
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function s.filter1(c,e,tp)
	return c:IsSummonPlayer(1-tp) and c:IsLocation(LOCATION_MZONE) and c:IsCanBeEffectTarget(e) and c:IsAbleToGrave()
		and Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_MZONE,0,1,c)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return eg and eg:IsExists(s.filter1,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=eg:FilterSelect(tp,s.filter1,1,1,nil,e,tp)
	Duel.SetTargetCard(g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,2,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK|LOCATION_GRAVE)
end
function s.spfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g~=2 then return end
	local mc=g:Filter(Card.IsControler,nil,tp):GetFirst()
	if not mc then return end
	local was_spellcaster=mc:IsRace(RACE_SPELLCASTER)
	if Duel.SendtoGrave(g,REASON_EFFECT)==2 and g:IsExists(Card.IsLocation,2,nil,LOCATION_GRAVE) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		--Depuis le Cimetière, ou aussi depuis le Deck si votre monstre ciblé était un Magicien
		local loc=LOCATION_GRAVE
		if was_spellcaster then loc=LOCATION_GRAVE|LOCATION_DECK end
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,loc,0,nil,e,tp)
		if #sg>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=sg:Select(tp,0,1,nil) --"vous pouvez"
			if #tg>0 then
				Duel.BreakEffect()
				Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
