--[VAACT] Spellbinding Circle
local s,id=GetID()

--ID de la carte officielle (traitée comme elle) : à modifier ici si besoin
s.officiel=18807108

function s.initial_effect(c)
	--Traité comme Spellbinding Circle officiel
	local e_add=Effect.CreateEffect(c)
	e_add:SetType(EFFECT_TYPE_SINGLE)
	e_add:SetCode(EFFECT_ADD_CODE)
	e_add:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add:SetValue(s.officiel)
	c:RegisterEffect(e_add)

	--Activer en ciblant 1 monstre de l'adversaire : il ne peut ni attaquer ni changer de position, et perd 700 ATK
	aux.AddPersistentProcedure(c,1,nil,CATEGORY_POSITION,nil,nil,nil,nil,nil,nil,nil,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(aux.PersistentTargetFilter)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(-700)
	c:RegisterEffect(e3)
	--Quand le monstre est détruit, détruire cette carte
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(s.descon)
	e4:SetOperation(s.desop)
	c:RegisterEffect(e4)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_DESTROY_CONFIRMED) then return false end
	local tc=c:GetFirstCardTarget()
	return tc and eg:IsContains(tc) and tc:IsReason(REASON_DESTROY) and c:IsRelateToCard(tc)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
