--憎悪の棘
--Thorn of Malice
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 65079854) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(65079854)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	aux.AddEquipProcedure(c,nil,s.filter)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(600)
	c:RegisterEffect(e2)
	--Pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetTarget(s.indestg)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--battle
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_BATTLED)
	e6:SetCondition(s.adcon)
	e6:SetOperation(s.adop)
	c:RegisterEffect(e6)
end
s.listed_names={CARD_BLACK_ROSE_DRAGON}
function s.filter(c)
	return c:IsCode(CARD_BLACK_ROSE_DRAGON) or c:IsRace(RACE_PLANT)
end
function s.indestg(e,c)
	return e:GetHandler():GetEquipTarget() and c==e:GetHandler():GetEquipTarget():GetBattleTarget()
end
function s.adcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler():GetEquipTarget() and Duel.GetAttackTarget()~=nil
end
function s.adop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local bc=Duel.GetAttackTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-600)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD)
	bc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	bc:RegisterEffect(e2)
end