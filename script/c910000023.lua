--[VAACT] Crépuscule à Cinq Étoiles (Five Star Twilight)
local s,id=GetID()

--ID de la carte officielle (traitée comme elle) : à modifier ici si besoin
s.officiel=6309986

--Monstres invoqués depuis l'Extérieur du Duel : à modifier ici si besoin
s.monstres={
	{nom="Kuribah",    code=44632120},
	{nom="Kuribeille", code=71036835},
	{nom="Kuribou",    code=7021574},
	{nom="Kuribeh",    code=34419588},
	{nom="Kuriboh",    code=CARD_KURIBOH},
}

function s.initial_effect(c)
	--Traitée comme la carte officielle
	local e_add=Effect.CreateEffect(c)
	e_add:SetType(EFFECT_TYPE_SINGLE)
	e_add:SetCode(EFFECT_ADD_CODE)
	e_add:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add:SetValue(s.officiel)
	c:RegisterEffect(e_add)

	--Activation
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL) --1 par Duel
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	--Règle : ne doit pas être dans le Main Deck au début du Duel
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_STARTUP)
		ge1:SetOperation(s.startop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.startop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsOriginalCode,0,LOCATION_DECK,LOCATION_DECK,nil,id)
	if #g>0 then
		Duel.Exile(g,REASON_RULE)
	end
end

function s.cfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(5)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
--Nombre de Zones Monstres libres une fois tous vos monstres Sacrifiés
function s.freezones(tp,g)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)
		+g:FilterCount(function(c) return c:IsControler(tp) and c:GetSequence()<5 end,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if chk==0 then
		return #g>0
			and g:FilterCount(Card.IsReleasableByEffect,nil)==#g
			and s.freezones(tp,g)>=#s.monstres
			and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
	end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,#s.monstres,tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if #g==0 or Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	--Sacrifier tous les monstres que vous contrôlez
	if Duel.Release(g,REASON_EFFECT)==0 then return end
	Duel.AdjustInstantly()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<#s.monstres then return end
	--Invoquer Spécialement les monstres depuis l'Extérieur du Duel
	for _,m in ipairs(s.monstres) do
		local tc=Duel.CreateToken(tp,m.code)
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			--Ne peuvent pas être Sacrifiés pour une Invocation Sacrifice
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			e1:SetValue(1)
			tc:RegisterEffect(e1,true)
		end
	end
	Duel.SpecialSummonComplete()
end