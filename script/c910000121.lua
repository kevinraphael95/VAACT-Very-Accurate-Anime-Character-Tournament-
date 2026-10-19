--[VAACT] Duplication des Clones (Cloning)
local s,id=GetID()

--ID de la carte officielle (traitée comme elle) : à modifier ici si besoin
s.officiel=86871614
--ID du "Jeton Clone" : à modifier ici si besoin
s.jeton=910001149

function s.initial_effect(c)
	--Traitée comme la carte d'origine
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(s.officiel)
	c:RegisterEffect(e0)
	--Quand l'adversaire Invoque exactement 1 monstre : Invoquer 1 "Jeton Clone" copie de ce monstre
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and #eg==1
end
function s.level(ec)
	local lv=ec:GetOriginalLevel()
	if lv<=0 then lv=1 end
	return lv
end
function s.cancreate(tp,ec)
	return Duel.IsPlayerCanSpecialSummonMonster(tp,s.jeton,0,TYPES_TOKEN,ec:GetBaseAttack(),ec:GetBaseDefense(),
		s.level(ec),ec:GetOriginalRace(),ec:GetOriginalAttribute())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=eg:GetFirst()
	if chk==0 then
		return ec and ec:IsMonster() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and s.cancreate(tp,ec)
	end
	ec:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	if not ec or not ec:IsRelateToEffect(e) or ec:IsFacedown() then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not s.cancreate(tp,ec) then return end
	local c=e:GetHandler()
	local token=Duel.CreateToken(tp,s.jeton)
	if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
		--Même Type
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(ec:GetOriginalRace())
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		token:RegisterEffect(e1)
		--Même Attribut
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(ec:GetOriginalAttribute())
		token:RegisterEffect(e2)
		--Même ATK/DEF
		local e3=e1:Clone()
		e3:SetCode(EFFECT_SET_BASE_ATTACK)
		e3:SetValue(ec:GetBaseAttack())
		token:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_DEFENSE)
		e4:SetValue(ec:GetBaseDefense())
		token:RegisterEffect(e4)
		--Mêmes effets (s'il en a)
		token:CopyEffect(ec:GetOriginalCode(),RESET_EVENT|RESETS_STANDARD)
	end
	Duel.SpecialSummonComplete()
end
