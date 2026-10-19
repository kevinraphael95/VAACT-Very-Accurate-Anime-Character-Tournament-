--[VAACT] [ANIME] Virus Broyeur de Carte (Crush Card Virus)
local s,id=GetID()

--ID de la carte officielle (traitée comme elle) : à modifier ici si besoin
s.officiel=57728570

function s.initial_effect(c)
	--Traitée comme la carte d'origine
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(s.officiel)
	c:RegisterEffect(e0)
	--Quand un monstre TENEBRES avec 1000 ATK ou moins est détruit sur votre terrain
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
		and (c:GetPreviousAttributeOnField()&ATTRIBUTE_DARK)~=0
		and c:GetPreviousAttackOnField()<=1000
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
--Monstres de l'adversaire avec 1500 ATK ou plus (Terrain, main, Deck)
function s.filter(c)
	return c:IsMonster() and c:IsAttackAbove(1500)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE|LOCATION_HAND|LOCATION_DECK,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,1-tp,LOCATION_MZONE|LOCATION_HAND|LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local conf=Duel.GetFieldGroup(tp,0,LOCATION_MZONE|LOCATION_HAND)
	if #conf>0 then
		Duel.ConfirmCards(tp,conf)
	end
	local dg=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE|LOCATION_HAND|LOCATION_DECK,nil)
	if #dg>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
	Duel.ShuffleHand(1-tp)
end
