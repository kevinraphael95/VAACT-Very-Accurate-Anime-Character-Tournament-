--転生炎獣の烈爪
--Salamangreat Claw
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 88540324) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(88540324)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	c:SetUniqueOnField(1,0,id)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsSetCard,SET_SALAMANGREAT))
	aux.EnableCheckReincarnation(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--pierce
	local e3=e1:Clone()
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
	--multiattack
	local e4=e1:Clone()
	e4:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e4:SetCondition(s.macon)
	e4:SetValue(function(e,c) return c:GetLink()-1 end)
	c:RegisterEffect(e4)
end
s.listed_series={SET_SALAMANGREAT}
function s.macon(e)
	local c=e:GetHandler():GetEquipTarget()
	return c:IsSetCard(SET_SALAMANGREAT) and c:IsLinkMonster() and c:IsReincarnationSummoned()
end