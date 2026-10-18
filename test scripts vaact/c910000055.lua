--[VAACT] Magical Dimension
local s,id=GetID()

--ID de la carte officielle (traitée comme elle) : à modifier ici si besoin
s.officiel=28553439

function s.initial_effect(c)
	--Traitée comme Magical Dimension officielle
	local e_add=Effect.CreateEffect(c)
	e_add:SetType(EFFECT_TYPE_SINGLE)
	e_add:SetCode(EFFECT_ADD_CODE)
	e_add:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add:SetValue(s.officiel)
	c:RegisterEffect(e_add)

	--Cibler 1 monstre à vous : le Sacrifier, détruire 1 monstre sur le terrain, et si Magicien, Invoquer 1 Magicien de la main
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.spfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsReleasableByEffect() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsReleasableByEffect,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,Card.IsReleasableByEffect,tp,LOCATION_MZONE,0,1,1,nil)
	local dg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,g)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToEffect(e) and tc:IsControler(tp)) then return end
	local was_spellcaster=tc:IsRace(RACE_SPELLCASTER)
	--1) Sacrifier la cible
	if Duel.Release(tc,REASON_EFFECT)==0 then return end
	--2) Détruire 1 monstre sur le terrain
	local dg=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	if #dg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local des=dg:Select(tp,1,1,nil)
		Duel.HintSelection(des,true)
		Duel.BreakEffect()
		Duel.Destroy(des,REASON_EFFECT)
	end
	--3) Si le monstre Sacrifié était un Magicien : vous pouvez Invoquer 1 Magicien depuis votre main
	if was_spellcaster and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,0,1,nil,e,tp)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
